import 'package:flutter/foundation.dart';

/// A WeakMap lets you garbage-collect its keys.
/// Please note: The **[key]** can be garbage-collected, not the [value].
///
/// This means if you use some object as a key to a map-entry, this alone
/// will not prevent Dart to garbage-collect this object. In other words,
/// after all other references to that object have been destroyed, its entry
/// (key and value) may be removed automatically from the map at any moment.
///
/// To create a map:
/// ```
/// var map = WeakMap();
/// ```
///
/// To add and retrieve a value:
/// ```
/// map["John"] = 42;
/// var age = map["John"];
/// ```
///
/// The following map methods work as expected:
/// ```
/// map.remove("John")
/// map.clear()
/// map.contains("John"))
/// ```
///
/// However, adding some null value to the map is the same as removing the key:
/// ```
/// map["John"] = null; // Same as map.remove("John")
/// ```
///
/// Notes:
///
/// 1. If you add a number, a boolean, a String, or a const type to the map,
/// it will act like a regular map, because these types are never
/// garbage-collected. All other types of object may be garbage-collected.
///
/// 2. To retrieve a value added to the map, you can use the equivalent
/// syntaxes `var y = map[x]` or `var y = map.get(x)`.
///
/// 3. Doing `map[x] = y` is equivalent to `map.add(key: obj, value: 42)`,
/// and will mean the object is later retrieved by **equality**.
/// However, you can also add the object so that it is later returned by **identity**.
/// To that end, use the syntax `map.addByIdentity(key: obj, value: 42)`.
///
class WeakMap<K, V> {
  final Map<K, V> _map;
  final Map<K, Object> _equalsMap;
  Expando<V> _expando;

  WeakMap()
      : _map = {},
        _equalsMap = {},
        _expando = Expando();

  static bool _allowedInExpando(Object value) =>
      value is! String && value is! num && value is! bool && value != null;

  void operator []=(K key, V value) => add(key: key, value: value);

  V operator [](K key) => get(key);

  void addByIdentity({@required K key, @required V value}) {
    if (_allowedInExpando(key)) {
      _expando[key] = value;
    } else
      _map[key] = value;
  }

  void add({@required K key, @required V value}) {
    if (_allowedInExpando(key)) {
      var obj = Object();
      _equalsMap[key] = obj;
      _expando[obj] = value;
    } else
      _map[key] = value;
  }

  bool contains(K key) => get(key) != null;

  V get(K key) {
    if (_map.containsKey(key))
      return _map[key];
    else {
      var obj = _equalsMap[key];
      if (obj != null)
        return _expando[obj];
      else if (!_allowedInExpando(key))
        return null;
      else
        return _expando[key];
    }
  }

  void remove(K key) {
    _map.remove(key);

    var obj = _equalsMap[key];
    if (obj != null) _expando[obj] = null;

    if (_allowedInExpando(key)) _expando[key] = null;
  }

  void clear() {
    _map.clear();
    _equalsMap.clear();
    _expando = Expando();
  }
}
