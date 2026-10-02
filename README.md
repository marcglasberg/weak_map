[![Pub popularity](https://badgen.net/pub/popularity/weak_map)](https://pub.dev/packages/weak_map)
[![Pub Version](https://img.shields.io/pub/v/weak_map?style=flat-square&logo=dart)](https://pub.dev/packages/weak_map)
[![GitHub stars](https://img.shields.io/github/stars/marcglasberg/weak_map?style=social)](https://github.com/marcglasberg/weak_map)
![GitHub repo size](https://img.shields.io/github/repo-size/marcglasberg/weak_map?style=flat-square)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)
[![Developed by Marcelo Glasberg](https://img.shields.io/badge/Developed%20by%20Marcelo%20Glasberg-blue.svg)](https://glasberg.dev/)
[![Glasberg.dev on pub.dev](https://img.shields.io/pub/publisher/weak_map.svg)](https://pub.dev/publishers/glasberg.dev/packages)
[![Platforms](https://badgen.net/pub/flutter-platform/weak_map)](https://pub.dev/packages/weak_map)

#### Sponsor

[![](./example/SponsoredByMyTextAi.png)](https://mytext.ai)

# weak_map

This package gives you:

* **WeakMap**: A map whose keys are weakly held. You use it to attach values to objects
  without keeping those objects alive.


* **Cache functions**: Memoization of expensive calculations over immutable state, with
  the cached results discarded when the state changes or is no longer used. They are
  similar to the selectors of the <a href="https://pub.dev/packages/reselect">reselect</a>
  package, but better:

  `cache1state`, `cache1state_1param`, `cache1state_2params`,
  `cache2states`, `cache2states_1param`, `cache2states_2params`, `cache2states_3params`,
  `cache3states`,
  `cache1state_0params_x`, `cache2states_0params_x`, `cache3states_0params_x`.

<br>

## First, Dart's own WeakReference

When this package was created, Dart had no
<a href="https://en.wikipedia.org/wiki/Weak_reference">weak references</a>.
Since Dart 2.17, it has one built in:
<a href="https://api.dart.dev/stable/dart-core/WeakReference-class.html">
WeakReference</a>.

A `WeakReference` points to a **single object** without keeping that object alive. While
other
parts of your program use the object, `target` returns it. After the object is
garbage-collected, `target` returns `null`:

```
var user = User("John");
var ref = WeakReference(user);

// User("John"), while the user is still in use.
print(ref.target); 

// Later, if nothing else uses the user, it may be garbage-collected:
print(ref.target); // null
```

Use it when **one** object needs to point to **another** object, but shouldn't be the
reason that object stays in memory. Examples are a child pointing back to its parent, a
listener registry that shouldn't keep the listeners alive, or a "last seen" object you'll
reuse if it's still around.

Things to know:

* You must check `target` for `null` every time you use it, since the garbage-collector
  can run at any moment.

* `WeakReference` throws an `ArgumentError` for numbers, Strings, booleans, records and
  `null`.

* `WeakReference` compares by identity, so two references to the same object are **not**
  equal (`WeakReference(a) != WeakReference(a)`).

* If you need to run some code when the object is collected, use Dart's
  <a href="https://api.dart.dev/stable/dart-core/Finalizer-class.html">Finalizer</a>.

<br>

## WeakMap

A `WeakMap` is a map whose **keys** are held weakly. If you use some object as a key, the
map alone won't keep that object alive. After all other references to the key are gone,
the key may be garbage-collected, and its whole entry (key **and** value) disappears from
the map.

```
var map = WeakMap<User, Avatar>();

map[user] = avatar; // Add.
var a = map[user]; // Read. Same as map.get(user).
map.contains(user); // true
map.remove(user); // Remove.
map.clear(); // Remove everything.
```

Note only the **keys** are weak. The values are kept alive for as long as their keys are
alive.

### Why it's useful

A `WeakMap` lets you **associate data with objects you don't control**, without having to
remember to clean it up. For example:

* **Metadata.** You want to attach some extra information to objects that belong to
  another library, or to classes you can't change. With a regular `Map`, you'd have to
  remove the entry when the object is no longer used, or the map would grow forever. With
  a `WeakMap`, the entry goes away by itself.

* **Caching results per object.** You calculate something expensive from an immutable
  object (a layout, a parsed version, a filtered list), and want to reuse it while that
  object is still around. The cache functions of this package are built on this idea.

* **Tracking objects.** You want to mark objects as "already processed", "visited" or
  "seen", without keeping them in memory after everyone else stopped using them.

### WeakMap vs. WeakReference

Neither of them keeps objects alive, but they solve different problems:

* A `WeakReference` is a **pointer** to one object. It answers: _"Is this object still
  alive, and if so, give it to me."_

* A `WeakMap` is a **lookup table** from objects to values. It answers: _"I have this
  object here. What value did I attach to it?"_

You could try to build a weak map yourself with `Map<WeakReference<User>, Avatar>`, but it
doesn't work well:

1. **You can't look things up.** `WeakReference` uses identity for `==`, so
   `map[WeakReference(user)]` creates a new reference that never matches the one in the
   map. You'd have to key the map by `identityHashCode(user)` and then handle hash
   collisions yourself.

2. **Dead entries pile up.** When a key is collected, its entry stays in the map, with a
   `WeakReference` whose `target` is now `null`, and a value that is still taking up
   memory. You'd need a `Finalizer`, or periodic sweeps, to remove them.

3. **Values can keep their own keys alive.** If the value references its key (which is
   common, for example `map[user] = Avatar(owner: user)`), then the regular map keeps the
   value alive, the value keeps the key alive, and the key is **never** collected. That's
   a memory leak. `WeakMap` doesn't have this problem: a value only stays alive because of
   its key, and never keeps that key alive.

`WeakMap` takes care of all of this for you. Internally it uses Dart's
<a href="https://api.dart.dev/stable/dart-core/Expando-class.html">Expando</a>, which is
supported by the garbage-collector itself.

### When to use which

| You want to                                                                   | Use                                                |
|-------------------------------------------------------------------------------|----------------------------------------------------|
| Point to one object without keeping it alive, and get it back later           | `WeakReference`                                    |
| Check if some object is the same one you had before, without keeping it alive | `WeakReference`, with `identical(ref.target, obj)` |
| Run some code when an object is garbage-collected                             | `Finalizer`                                        |
| Attach values to objects, and have those values go away with the objects      | `WeakMap`                                          |
| Cache expensive calculations over immutable state                             | The cache functions (see below)                    |
| Iterate over the entries, or know how many there are                          | A regular `Map` (see note 6 below)                 |

### Notes

1. Object keys are compared by **identity**, not by `operator ==`. Two different objects
   that are equal are two different keys.

2. If you use `null`, a number, a boolean, a String or a record as a key, the `WeakMap`
   acts like a regular map for that key: these values are never garbage-collected, and
   they are compared by equality (`==`). Constant objects (`const`) are compared by
   identity, and are never garbage-collected either.

   Note, a Dart record key keeps the objects inside it alive, until you remove it or clear
   the map. Records can't be weak keys, because they have no identity. If you need a weak
   composite key, nest the maps instead. The entry then goes away when **either** object
   is garbage-collected:

   ```dart
   // Instead of WeakMap<(User, Doc), Result>
   var map = WeakMap<User, WeakMap<Doc, Result>>();
   ```

3. Setting a key to `null` is the same as removing it: `map[user] = null` is the same as
   `map.remove(user)`. For the same reason, `contains` returns `false` for keys set to
   `null`.

4. `map[key]` and `map.get(key)` return `null` if the key doesn't exist. Use
   `map.getOrThrow(key)` to throw a `StateError` instead.

5. `map[key] = value` is the same as `map.add(key: key, value: value)`.

6. A `WeakMap` has no `length`, `keys`, `values` or iteration, on purpose. Whether an
   entry is still there depends on when the garbage-collector runs, which is
   unpredictable. And since you can only look up an entry while you still have its key,
   which means the key is alive, you can never observe an entry disappearing. This keeps
   your program's behavior the same, no matter when (or if) the garbage-collector runs.

<br>

## Cache

Suppose you have some **immutable** information, which we call "state", and some
parameters. We want to perform some expensive process (calculation, selection filtering
etc) over the state, and we want to cache the result.

For example, suppose you want to filter an **immutable list of millions of users**, to
create a new list with only the names that start with some text. You could filter the
users list to remove all other names, like this:

```dart
List<User> filter(String text) =>
    users.where((user) => user.name.startsWith(text)).toList();
```

This is an expensive process, so you may want to cache the filtered list.

In this example, we have a single state and a single parameter, so we're going to use
the `cache1state_1param` method:

```
static List<User> filter(Users users, String text)
  => _filter(users)(text);

static final _filter = cache1state_1param((Users users) => (String text)
  => users.where((user)=>user.name.startsWith(text)).toList());
```

The above code will calculate the filtered list only once, and then return it when the
`filter` function is called again with the same `users` and `text`.

If the function is called with a **different** `users` and/or `text`, it will recalculate
and cache the new result.

However, it treats the state and the parameter differently. If you call the function while
keeping the **same state** and changing only the parameter, it will cache all the results,
one for each parameter.

However, as soon as you call the function with a **changed state**, it will delete all of
its previous cached information, since it understands that they are no longer useful.

And even if you don't call that function ever again, it will delete the cached information
if it detects that the state is no longer used in other parts of the program. In other
words, it keeps the cached information in a weak-map, so that the cache will not hold to
old information and have a negative impact in memory usage.

States are compared by **identity** if they are objects, and by equality if they are
numbers, Strings, booleans, records or `null`. Parameters are compared by equality (`==`).
This is why the state must be immutable: if you change the contents of the state object,
the cache can't notice it, and will keep returning the old result.
If a state is a record with objects inside, those objects are kept alive until the state
changes.

Some functions, marked with an "x", also let you pass some extra information which is not
used in any way to decide whether the cache should be used/recalculated/evicted.

For the moment, the following 11 methods are provided, which combine 1, 2 or 3 states with
0, 1, 2 or 3 parameters, and possibly some extra information:

```
cache1state((state) => () => ...);
cache1state_1param((state) => (parameter) => ...);
cache1state_2params((state) => (parameter1, parameter2) => ...);
cache2states((state1, state2) => () => ...);
cache2states_1param((state1, state2) => (parameter) => ...);
cache2states_2params((state1, state2) => (parameter1, parameter2) => ...);
cache2states_3params((state1, state2) => (parameter1, parameter2, parameter3) => ...);
cache3states((state1, state2, state3) => () => ...);
cache1state_0params_x((state1, extra) => () => ...);
cache2states_0params_x((state1, state2, extra) => () => ...);
cache3states_0params_x((state1, state2, state3, extra) => () => ...);
```

I have created only those above, because for my own usage I never required more than that.
Please, open an <a href="https://github.com/marcglasberg/weak_map/issues">issue</a>
to ask for more variations in case you feel the need.

**Note:** These cache functions are similar to the "createSelector" functions found in the
<a href="https://pub.dev/packages/reselect">reselect</a> package. The differences are:
First, here you can keep any number of cached results for each function, one for each time
the function is called with the same state and different parameters. Meanwhile, the
reselect package only keeps a single cached result per function. Second, here it discards
the cached information when the state changes or is no longer used in other parts of the
program. Meanwhile, the reselect package will always keep the states and cached results in
memory.

<br>

***

## By Marcelo Glasberg

<a href="https://glasberg.dev">_glasberg.dev_</a>
<br>
<a href="https://github.com/marcglasberg">_github.com/marcglasberg_</a>
<br>
<a href="https://www.linkedin.com/in/marcglasberg/">_linkedin.com/in/marcglasberg/_</a>
<br>
<a href="https://twitter.com/glasbergmarcelo">_twitter.com/glasbergmarcelo_</a>
<br>
<a href="https://stackoverflow.com/users/3411681/marcg">
_stackoverflow.com/users/3411681/marcg_</a>
<br>
<a href="https://medium.com/@marcglasberg">_medium.com/@marcglasberg_</a>
<br>

*My article in the official Flutter documentation*:

* <a href="https://flutter.dev/docs/development/ui/layout/constraints">Understanding
  constraints</a>

*The Flutter packages I've authored:*

* <a href="https://pub.dev/packages/async_redux">async_redux</a>
* <a href="https://pub.dev/packages/provider_for_redux">provider_for_redux</a>
* <a href="https://pub.dev/packages/i18n_extension">i18n_extension</a>
* <a href="https://pub.dev/packages/align_positioned">align_positioned</a>
* <a href="https://pub.dev/packages/network_to_file_image">network_to_file_image</a>
* <a href="https://pub.dev/packages/image_pixels">image_pixels</a>
* <a href="https://pub.dev/packages/matrix4_transform">matrix4_transform</a>
* <a href="https://pub.dev/packages/back_button_interceptor">back_button_interceptor</a>
* <a href="https://pub.dev/packages/indexed_list_view">indexed_list_view</a>
* <a href="https://pub.dev/packages/animated_size_and_fade">animated_size_and_fade</a>
* <a href="https://pub.dev/packages/assorted_layout_widgets">assorted_layout_widgets</a>
* <a href="https://pub.dev/packages/weak_map">weak_map</a>
* <a href="https://pub.dev/packages/themed">themed</a>
* <a href="https://pub.dev/packages/bdd_framework">bdd_framework</a>
* <a href="https://pub.dev/packages/tiktoken_tokenizer_gpt4o_o1">
  tiktoken_tokenizer_gpt4o_o1</a>

*My Medium Articles:*

* <a href="https://medium.com/flutter-community/https-medium-com-marcglasberg-async-redux-33ac5e27d5f6">
  Async Redux: Flutter’s non-boilerplate version of Redux</a> 
  (versions: <a href="https://medium.com/flutterando/async-redux-pt-brasil-e783ceb13c43">
  Português</a>)
* <a href="https://medium.com/flutter-community/i18n-extension-flutter-b966f4c65df9">
  i18n_extension</a> 
  (versions: <a href="https://medium.com/flutterando/qual-a-forma-f%C3%A1cil-de-traduzir-seu-app-flutter-para-outros-idiomas-ab5178cf0336">
  Português</a>)
* <a href="https://medium.com/flutter-community/flutter-the-advanced-layout-rule-even-beginners-must-know-edc9516d1a2">
  Flutter: The Advanced Layout Rule Even Beginners Must Know</a> 
  (versions: <a href="https://habr.com/ru/post/500210/">русский</a>)
* <a href="https://medium.com/flutter-community/the-new-way-to-create-themes-in-your-flutter-app-7fdfc4f3df5f">
  The New Way to create Themes in your Flutter App</a> 

[![](./example/SponsoredByMyTextAi.png)](https://mytext.ai)
