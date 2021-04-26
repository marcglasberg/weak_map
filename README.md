[![pub package](https://img.shields.io/pub/v/weak_map.svg)](https://pub.dartlang.org/packages/weak_map)

# weak_map

This package contains the classes:
 * **WeakMap**  
 * **WeakContainer**
 
And also the functions:
 * **cache1state**
 * **cache1state_1param**
 * **cache1state_2params**
 * **cache2states**
 * **cache2states_1param**
 * **cache2states_2params**
 * **cache3states**
 * **cache1state_0params_x**
 * **cache2states_0params_x**
 * **cache3states_0params_x**

### Why is this package useful?

1. Dart doesn't allow for real <a href="https://en.wikipedia.org/wiki/Weak_reference">weak-references</a>, 
but this package allows you to go as close as possible 
(internally it uses the <a href="https://api.flutter.dev/flutter/dart-core/Expando-class.html">Expando</a> class).
The Dart engine stores a value in memory while it is reachable (and can potentially be used).
Usually, keys in a map are considered reachable and kept in memory while the map itself is in memory.
This means if we put an object into a map or into a variable, 
then while the map is alive, the object will be alive as well, 
even if there are no other references to it. 
It occupies memory and may not be garbage collected.
WeakMap and WeakContainer are fundamentally different in this aspect. 
They don't prevent garbage-collection of key objects.

2. Caches that keep the result of expensive processes calculated over immutable data 
can also benefit from weak-maps.
I here provide functions similar to the ones of the 
<a href="https://pub.dev/packages/reselect">reselect</a> package, but better.
This can be used with Redux or with any other calculations over immutable data.    

<br>

## WeakMap

A WeakMap lets you garbage-collect its keys. 
Please note the **keys** can be garbage-collected, not their corresponding values.


This means if you use some object as a key to a map-entry, this alone
will not prevent Dart to garbage-collect this object. 

In other words,
after all other references to that object have been destroyed, its entry
(key and value) may be removed automatically from the map at any moment.
To create a map:

```dart
var map = WeakMap();
```    

To add and retrieve a value:

```dart
map["John"] = 42;
var age = map["John"];
```
The following map methods work as expected:

```dart
map.remove("John")
map.clear()
map.contains("John"))
```

However, adding some `null` value to the map is the same as removing the key:

```dart
map["John"] = null; // Same as map.remove("John")
```

**Notes:**

1. If you use null, a number, a boolean, a String, or a const type as the map key,
it will act like a regular map, because these types are never
garbage-collected. All other types of object may be garbage-collected.

2. To retrieve a value added to the map, you can use the equivalent
syntaxes `var y = map[x]` or `var y = map.get(x)`.

3. Doing `map[x] = y` is equivalent to `map.add(key: x, value: y)`,
but the object is later retrieved by **identity**.

<br>

## WeakContainer

As previously explained, Dart doesn't have real weak-references.
But you can check that some object is the same you had before.

To create a weak-container:

```
var obj = Object();
var ref = WeakContainer(obj);
var someObj = Random().nextBool() ? obj : Object();
print(ref.contains(someObj)); // True or false.
```

This will print `true` if `someObj` is the same as the original `obj`,
and will print `false` if it's a different object, compared by identity.
If all references to the original `obj` have been destroyed,
the weak-container will **not** prevent `obj` to be garbage-collected.

<br>

### Why doesn't Dart allow for real weak-references, anyway?

Because the creators of Dart don't want the GC (garbage-collector) to be "visible".

Expandos are not equivalent to weak-references (meaning the Java `WeakReference` behavior).
A weak reference is one that doesn't keep the referenced object alive, 
so the weak reference value may change to `null` at any time in the program. 
This makes the GC visible in the program.

Expandos are maps (from key to value) which won't keep the key alive. 
There is no way to distinguish an Expando that garbage collects the entry when the key dies, 
and one that doesn't, because you don't have the key to do the lookup anymore.

Basically, it means that an expando keeps a value alive 
as long as you have a reference to both the expando and the key, 
and after that, you can't check if the entry is there or not.
With expandos, the GC need not be part of the language specification. 
It's just an optimization that implementations (are expected to) do to release memory that isn't needed anymore. 
Disabling the GC will not change the behavior of programs unless they run out of memory.

<br>

## Cache

Suppose you have some **immutable** information, which we call "state", and some parameters.
We want to perform some expensive process (calculation, selection filtering etc) over the state,
and we want to cache the result. 
  
For example, suppose you want to filter an **immutable list of millions of users**, 
to create a new list with only the names that start with some text. 
You could filter the users list to remove all other names, like this:

```dart     
List<User> filter(String text) => users.where((user)=>user.name.startsWith(text)).toList();
```                                                                                           

This is an expensive process, so you may want to cache the filtered list. 

In this example, we have a single state and a single parameter, 
so we're going to use the `cache1state_1param` method:

```dart                                                    
static List<User> filter(Users users, String text)
   => _filter(users)(text);

static final _filter = cache1state_1param(
        (Users users) 
           => (String text) 
              => users.where((user)=>user.name.startsWith(text)).toList());
```  

The above code will calculate the filtered list only once, 
and then return it when the `filter` function is called again with the same `users` and `text`.

If the function is called with a **different** `users` and/or `text`, 
it will recalculate and cache the new result.

However, it treats the state and the parameter differently. 
If you call the function while keeping the **same state** and changing only the parameter, 
it will cache all the results, one for each parameter.

However, as soon as you call the function with a **changed state**, 
it will delete all of its previous cached information,
since it understands that they are no longer useful.

And even if you don't call that function ever again, it will delete the cached information if it detects
that the state is no longer used in other parts of the program.
In other words, it keeps the cached information in a weak-map, 
so that the cache will not hold to old information and have a negative impact in memory usage.

Some functions, marked with an "x", also let you pass some extra information which 
is not used in any way to decide whether the cache should be used/recalculated/evicted.
    
For the moment, the following 10 methods are provided, 
which combine 1, 2 or 3 states with 0, 1 or 2 parameters, 
and possibly some extra information:

```dart
cache1state((state) => () => ...);
cache1state_1param((state) => (parameter) => ...);
cache1state_2params((state) => (parameter1, parameter2) => ...);
cache2states((state1, state2) => () => ...);
cache2states_1param((state1, state2) => (parameter) => ...);
cache2states_2params((state1, state2) => (parameter1, parameter2) => ...);
cache3states((state1, state2, state3) => () => ...);
cache1state_0params_x((state1, extra) => () => ...);
cache2states_0params_x((state1, state2, extra) => () => ...);
cache3states_0params_x((state1, state2, state3, extra) => () => ...);
```    

I have created only those above, because for my own usage I never required more than that. 
Please, open an <a href="https://github.com/marcglasberg/weak_map/issues">issue</a> 
to ask for more variations in case you feel the need.

**Note:** These cache functions are similar to the "createSelector" functions found in the
<a href="https://pub.dev/packages/reselect">reselect</a> package.
The differences are: First, here you can keep any number of cached results for each function,
one for each time the function is called with the same state and different parameters.
Meanwhile, the reselect package only keeps a single cached result per function.
Second, here it discards the cached information when the state changes 
or is no longer used in other parts of the program.
Meanwhile, the reselect package will always keep the states and cached results in memory.

<br>

***

*The Flutter packages I've authored:* 
* <a href="https://pub.dev/packages/async_redux">async_redux</a>
* <a href="https://pub.dev/packages/provider_for_redux">provider_for_redux</a>
* <a href="https://pub.dev/packages/i18n_extension">i18n_extension</a>
* <a href="https://pub.dev/packages/align_positioned">align_positioned</a>
* <a href="https://pub.dev/packages/network_to_file_image">network_to_file_image</a>
* <a href="https://pub.dev/packages/matrix4_transform">matrix4_transform</a> 
* <a href="https://pub.dev/packages/back_button_interceptor">back_button_interceptor</a>
* <a href="https://pub.dev/packages/indexed_list_view">indexed_list_view</a> 
* <a href="https://pub.dev/packages/animated_size_and_fade">animated_size_and_fade</a>
* <a href="https://pub.dev/packages/assorted_layout_widgets">assorted_layout_widgets</a>

*My Medium Articles:*
* <a href="https://medium.com/flutter-community/https-medium-com-marcglasberg-async-redux-33ac5e27d5f6">Async Redux: Flutter’s non-boilerplate version of Redux</a> (versions: <a href="https://medium.com/flutterando/async-redux-pt-brasil-e783ceb13c43">Português</a>)
* <a href="https://medium.com/flutter-community/i18n-extension-flutter-b966f4c65df9">i18n_extension</a> (versions: <a href="https://medium.com/flutterando/qual-a-forma-f%C3%A1cil-de-traduzir-seu-app-flutter-para-outros-idiomas-ab5178cf0336">Português</a>)
* <a href="https://medium.com/flutter-community/flutter-the-advanced-layout-rule-even-beginners-must-know-edc9516d1a2">Flutter: The Advanced Layout Rule Even Beginners Must Know</a> (versions: <a href="https://habr.com/ru/post/500210/">русский</a>)

*My article in the official Flutter documentation*:
* <a href="https://flutter.dev/docs/development/ui/layout/constraints">Understanding constraints</a>

<br>_Marcelo Glasberg:_<br>
_https://github.com/marcglasberg_<br>
_https://twitter.com/glasbergmarcelo_<br>
_https://stackoverflow.com/users/3411681/marcg_<br>
_https://medium.com/@marcglasberg_<br>
