# weak_map

This package contains the classes:
 * **WeakMap**  
 * **WeakContainer**

### Why is this package useful?

Dart doesn't allow for real <a href="https://en.wikipedia.org/wiki/Weak_reference">weak-references</a>, 
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

However, adding some null value to the map is the same as removing the key:

```dart
map["John"] = null; // Same as map.remove("John")
```

**Notes:**

1. If you add a number, a boolean, a String, or a const type to the map,
it will act like a regular map, because these types are never
garbage-collected. All other types of object may be garbage-collected.

2. To retrieve a value added to the map, you can use the equivalent
syntaxes `var y = map[x]` or `var y = map.get(x)`.

3. Doing `map[x] = y` is equivalent to `map.add(key: obj, value: 42)`,
and will mean the object is later retrieved by **equality**.
However, you can also add the object so that it is later returned by **identity**.
To that end, use the syntax `map.addByIdentity(key: obj, value: 42)`.

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

<br>_Marcelo Glasberg:_<br>
_https://github.com/marcglasberg_<br>
_https://twitter.com/glasbergmarcelo_<br>
_https://stackoverflow.com/users/3411681/marcg_<br>
_https://medium.com/@marcglasberg_<br>
