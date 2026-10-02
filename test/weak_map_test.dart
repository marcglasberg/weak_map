import 'package:test/test.dart';
import 'package:weak_map/weak_map.dart';

import 'gc_utils.dart';

void main() {
  test("Add number/String/boolean to map.", () {
    var map = WeakMap();

    var obj1 = Object();
    var obj2 = Object();
    var obj3 = Object();
    var obj4 = Object();
    var obj5 = Object();
    expect(obj1, isNot(obj2));
    expect(obj2, isNot(obj3));
    expect(obj3, isNot(obj4));
    expect(obj4, isNot(obj5));

    map[1] = obj1;
    map["A"] = obj2;
    map[true] = obj3;
    map[false] = obj4;
    map[null] = obj5;

    expect(map[1], obj1);
    expect(map["A"], obj2);
    expect(map[true], obj3);
    expect(map[false], obj4);
    expect(map[null], obj5);
  });

  test("Using null as the map value.", () {
    var map = WeakMap();

    map["A"] = null;
    expect(map.contains("A"), false);

    map["A"] = Object();
    expect(map.contains("A"), true);

    map["A"] = null;
    expect(map.contains("A"), false);

    map["A"] = Object();
    map.remove("A");
    expect(map.contains("A"), false);
  });

  test("Using null as the map key.", () {
    var map = WeakMap();

    var obj1 = Object();
    expect(map[null], null);
    expect(map.contains(null), false);

    map[null] = obj1;
    expect(map[null], obj1);
    expect(map.contains(null), true);

    map[null] = null;
    expect(map[null], null);
    expect(map.contains(null), false);
  });

  test("getOrThrow", () async {
    //
    var map = WeakMap();
    map[1] = 1;
    map["A"] = 2;
    map[true] = 3;
    var obj1 = Object();
    map[obj1] = 4;
    var obj2 = Object();
    map[obj2] = 5;

    expect(map[1], 1);
    expect(map.get(1), 1);
    expect(map.getOrThrow(1), 1);

    expect(map["A"], 2);
    expect(map.get("A"), 2);
    expect(map.getOrThrow("A"), 2);

    expect(map[true], 3);
    expect(map.get(true), 3);
    expect(map.getOrThrow(true), 3);

    expect(map[obj1], 4);
    expect(map.get(obj1), 4);
    expect(map.getOrThrow(obj1), 4);

    expect(map[obj2], 5);
    expect(map.get(obj2), 5);
    expect(map.getOrThrow(obj2), 5);

    expect(map[123], null);
    expect(map.get(123), null);
    expect(() => map.getOrThrow(123), throwsStateError);
  });

  test("getOrThrow throws a StateError for any missing key.", () {
    //
    var map = WeakMap();
    expect(() => map.getOrThrow(123), throwsStateError);
    expect(() => map.getOrThrow("A"), throwsStateError);
    expect(() => map.getOrThrow(true), throwsStateError);
    expect(() => map.getOrThrow(null), throwsStateError);
    expect(() => map.getOrThrow(Object()), throwsStateError);

    // Typed maps, with nullable and non-nullable values.
    expect(() => WeakMap<Object, int>().getOrThrow(Object()), throwsStateError);
    expect(() => WeakMap<Object, int?>().getOrThrow(Object()), throwsStateError);
    expect(() => WeakMap<String, int>().getOrThrow("A"), throwsStateError);

    // Keys that were added and then removed.
    var obj = Object();
    map[obj] = 1;
    map["A"] = 2;
    map[null] = 3;
    expect(map.getOrThrow(obj), 1);
    expect(map.getOrThrow("A"), 2);
    expect(map.getOrThrow(null), 3);

    map.remove(obj);
    map.remove("A");
    map.remove(null);
    expect(() => map.getOrThrow(obj), throwsStateError);
    expect(() => map.getOrThrow("A"), throwsStateError);
    expect(() => map.getOrThrow(null), throwsStateError);

    // Keys that were cleared.
    map[obj] = 1;
    map["A"] = 2;
    map.clear();
    expect(() => map.getOrThrow(obj), throwsStateError);
    expect(() => map.getOrThrow("A"), throwsStateError);
  });

  test("getOrThrow with keys explicitly set to null.", () {
    //
    var map = WeakMap<Object?, int?>();
    var obj = Object();

    // Keys that act like a regular map return null.
    map["A"] = null;
    map[1] = null;
    map[true] = null;
    map[null] = null;
    map[(1, 2)] = null;
    expect(map.getOrThrow("A"), isNull);
    expect(map.getOrThrow(1), isNull);
    expect(map.getOrThrow(true), isNull);
    expect(map.getOrThrow(null), isNull);
    expect(map.getOrThrow((1, 2)), isNull);

    // Other keys throw.
    map[obj] = null;
    expect(() => map.getOrThrow(obj), throwsStateError);
  });

  test("Typed map.", () {
    //
    var map = WeakMap<Object, int>();
    var obj = Object();

    map["A"] = 1;
    map[obj] = 2;

    int? a = map["A"];
    int? b = map.get(obj);
    int c = map.getOrThrow(obj);

    expect(a, 1);
    expect(b, 2);
    expect(c, 2);
    expect(map["B"], isNull);
    expect(map[Object()], isNull);
  });

  test("The add method is the same as the [] operator.", () {
    //
    var map = WeakMap();
    var obj = Object();

    map.add(key: "A", value: 1);
    map.add(key: 2, value: 2);
    map.add(key: true, value: 3);
    map.add(key: null, value: 4);
    map.add(key: obj, value: 5);

    expect(map["A"], 1);
    expect(map[2], 2);
    expect(map[true], 3);
    expect(map[null], 4);
    expect(map[obj], 5);

    // Adding a null value is the same as removing the key.
    map.add(key: "A", value: null);
    map.add(key: obj, value: null);
    expect(map.contains("A"), false);
    expect(map.contains(obj), false);
  });

  test("Using objects as keys.", () {
    //
    var map = WeakMap();
    var obj1 = Object();
    var obj2 = Object();
    var obj3 = Object();

    expect(map[obj1], null);
    expect(map.contains(obj1), false);

    map[obj1] = "A";
    map[obj2] = "B";

    expect(map[obj1], "A");
    expect(map.get(obj1), "A");
    expect(map.contains(obj1), true);

    expect(map[obj2], "B");
    expect(map.get(obj2), "B");
    expect(map.contains(obj2), true);

    expect(map[obj3], null);
    expect(map.get(obj3), null);
    expect(map.contains(obj3), false);
  });

  test("Some other kinds of objects as keys.", () {
    //
    var map = WeakMap();

    var list = [1, 2];
    var function = () => 1;
    const constObj = _Value(1);

    map[list] = 1;
    map[function] = 2;
    map[constObj] = 3;
    map[_Enum.a] = 4;
    map[#symbol] = 5;
    map[Object] = 6;

    expect(map[list], 1);
    expect(map[function], 2);
    expect(map[constObj], 3);
    expect(map[const _Value(1)], 3); // Const objects are canonicalized.
    expect(map[_Enum.a], 4);
    expect(map[_Enum.b], null);
    expect(map[#symbol], 5);
    expect(map[Object], 6);
  });

  test("Numbers, Strings and booleans as keys, in a single map.", () {
    //
    var map = WeakMap();

    map[1] = "int";
    map[1.5] = "double";
    map[-1] = "negative";
    map["1"] = "String";
    map[""] = "empty String";
    map[true] = "true";
    map[false] = "false";

    expect(map[1], "int");
    expect(map[1.5], "double");
    expect(map[-1], "negative");
    expect(map["1"], "String");
    expect(map[""], "empty String");
    expect(map[true], "true");
    expect(map[false], "false");
    expect(map[2], null);
    expect(map["2"], null);
  });

  test("Overwriting values.", () {
    //
    var map = WeakMap();
    var obj = Object();

    map["A"] = 1;
    map[obj] = 1;
    map[null] = 1;

    map["A"] = 2;
    map[obj] = 2;
    map[null] = 2;

    expect(map["A"], 2);
    expect(map[obj], 2);
    expect(map[null], 2);
  });

  test("Values that are not null, but are false, zero or empty, are kept in the map.", () {
    //
    var map = WeakMap();
    var obj1 = Object();
    var obj2 = Object();
    var obj3 = Object();

    map["A"] = false;
    map["B"] = 0;
    map["C"] = "";
    map[obj1] = false;
    map[obj2] = 0;
    map[obj3] = "";

    expect(map.contains("A"), true);
    expect(map.contains("B"), true);
    expect(map.contains("C"), true);
    expect(map.contains(obj1), true);
    expect(map.contains(obj2), true);
    expect(map.contains(obj3), true);

    expect(map["A"], false);
    expect(map["B"], 0);
    expect(map["C"], "");
    expect(map[obj1], false);
    expect(map[obj2], 0);
    expect(map[obj3], "");

    expect(map.getOrThrow("A"), false);
    expect(map.getOrThrow(obj1), false);
  });

  test("Object keys are compared by identity, not by equality.", () {
    //
    var map = WeakMap();
    var obj1 = _Value(1);
    var obj2 = _Value(1);
    expect(obj1, obj2);
    expect(identical(obj1, obj2), isFalse);

    map[obj1] = "A";
    expect(map[obj1], "A");
    expect(map[obj2], null);
    expect(map.contains(obj2), false);

    map[obj2] = "B";
    expect(map[obj1], "A");
    expect(map[obj2], "B");

    map.remove(obj2);
    expect(map[obj1], "A");
    expect(map[obj2], null);
  });

  test("Strings are compared by equality, even if not identical.", () {
    //
    var map = WeakMap();
    var str1 = "AB";
    var str2 = ["A", "B"].join();
    // In the VM these Strings are not identical (in JavaScript they are).

    map[str1] = 1;
    expect(map[str2], 1);
    expect(map.contains(str2), true);

    map.remove(str2);
    expect(map.contains(str1), false);
  });

  test("Using objects as map keys, with null as the value.", () {
    //
    var map = WeakMap();
    var obj = Object();

    map[obj] = null;
    expect(map.contains(obj), false);
    expect(map[obj], null);

    map[obj] = 1;
    expect(map.contains(obj), true);

    // Adding a null value is the same as removing the key.
    map[obj] = null;
    expect(map.contains(obj), false);
    expect(map[obj], null);
  });

  test("Remove.", () {
    //
    var map = WeakMap();
    var obj1 = Object();
    var obj2 = Object();

    map[1] = 1;
    map["A"] = 2;
    map[true] = 3;
    map[null] = 4;
    map[obj1] = 5;
    map[obj2] = 6;

    map.remove(1);
    expect(map.contains(1), false);
    expect(map[1], null);

    map.remove("A");
    expect(map.contains("A"), false);
    expect(map["A"], null);

    map.remove(true);
    expect(map.contains(true), false);
    expect(map[true], null);

    map.remove(null);
    expect(map.contains(null), false);
    expect(map[null], null);

    map.remove(obj1);
    expect(map.contains(obj1), false);
    expect(map[obj1], null);

    // The other keys are not affected.
    expect(map[obj2], 6);
  });

  test("Removing keys that don't exist does nothing.", () {
    //
    var map = WeakMap();
    var obj = Object();
    map["A"] = 1;
    map[obj] = 2;

    map.remove("B");
    map.remove(2);
    map.remove(false);
    map.remove(null);
    map.remove(Object());

    expect(map["A"], 1);
    expect(map[obj], 2);

    // Removing twice.
    map.remove("A");
    map.remove("A");
    map.remove(obj);
    map.remove(obj);
    expect(map.contains("A"), false);
    expect(map.contains(obj), false);
  });

  test("Keys can be added again after being removed.", () {
    //
    var map = WeakMap();
    var obj = Object();

    map["A"] = 1;
    map[obj] = 2;
    map.remove("A");
    map.remove(obj);

    map["A"] = 3;
    map[obj] = 4;
    expect(map["A"], 3);
    expect(map[obj], 4);
  });

  test("Clear.", () {
    //
    var map = WeakMap();
    var obj1 = Object();
    var obj2 = Object();

    map[1] = 1;
    map["A"] = 2;
    map[true] = 3;
    map[null] = 4;
    map[obj1] = 5;
    map[obj2] = 6;

    map.clear();

    expect(map.contains(1), false);
    expect(map.contains("A"), false);
    expect(map.contains(true), false);
    expect(map.contains(null), false);
    expect(map.contains(obj1), false);
    expect(map.contains(obj2), false);

    expect(map[1], null);
    expect(map["A"], null);
    expect(map[true], null);
    expect(map[null], null);
    expect(map[obj1], null);
    expect(map[obj2], null);
  });

  test("The map can be used after being cleared.", () {
    //
    var map = WeakMap();
    var obj = Object();

    // Clearing an empty map.
    map.clear();
    expect(map.contains("A"), false);

    map["A"] = 1;
    map[obj] = 2;
    map.clear();

    map["A"] = 3;
    map[obj] = 4;
    expect(map["A"], 3);
    expect(map[obj], 4);

    // Clearing twice.
    map.clear();
    map.clear();
    expect(map.contains("A"), false);
    expect(map.contains(obj), false);
  });

  test("Different maps are independent from each other.", () {
    //
    var map1 = WeakMap();
    var map2 = WeakMap();
    var obj = Object();

    map1["A"] = 1;
    map1[obj] = 2;
    expect(map2["A"], null);
    expect(map2[obj], null);

    map2["A"] = 3;
    map2[obj] = 4;
    expect(map1["A"], 1);
    expect(map1[obj], 2);
    expect(map2["A"], 3);
    expect(map2[obj], 4);

    map1.remove("A");
    map1.remove(obj);
    expect(map2["A"], 3);
    expect(map2[obj], 4);

    map1["A"] = 1;
    map1[obj] = 2;
    map2.clear();
    expect(map1["A"], 1);
    expect(map1[obj], 2);
  });

  test("Records as keys act like a regular map (records are compared by equality).", () {
    //
    var map = WeakMap();

    map[(1, 2)] = "A";
    map[(name: "x", age: 3)] = "B";

    expect(map[(1, 2)], "A");
    expect(map.get((1, 2)), "A");
    expect(map.getOrThrow((1, 2)), "A");
    expect(map.contains((1, 2)), true);

    expect(map[(name: "x", age: 3)], "B");

    expect(map[(2, 1)], null);
    expect(map.contains((2, 1)), false);
    expect(() => map.getOrThrow((2, 1)), throwsStateError);

    map[(1, 2)] = "C";
    expect(map[(1, 2)], "C");

    map.remove((1, 2));
    expect(map.contains((1, 2)), false);

    map.clear();
    expect(map.contains((name: "x", age: 3)), false);
  });

  test("Records with objects inside are compared by the equality of their fields.", () {
    //
    var map = WeakMap();
    var obj = Object();

    map[(_Value(1), 2)] = "A";
    map[(obj, 1)] = "B";

    // Equal fields (even if not identical) make equal records.
    expect(map[(_Value(1), 2)], "A");
    expect(map[(_Value(2), 2)], null);

    expect(map[(obj, 1)], "B");
    expect(map[(Object(), 1)], null);
  });

  test("Numbers that are equal but of different types (1 and 1.0) are the same key.", () {
    // This is the same behavior as a regular Dart map.
    var map = WeakMap();
    map[1] = "A";
    expect(map[1.0], "A");
    map[2.0] = "B";
    expect(map[2], "B");
  });

  test("The same object can be a key in more than one map.", () {
    //
    var map1 = WeakMap();
    var map2 = WeakMap();
    var obj = Object();

    map1[obj] = 1;
    map2[obj] = 2;
    expect(map1[obj], 1);
    expect(map2[obj], 2);

    map1.clear();
    expect(map1[obj], null);
    expect(map2[obj], 2);
  });

  test("Weak-maps can be nested (a weak-map as the value of another weak-map).", () {
    //
    var outer = WeakMap<Object, WeakMap<Object, String>>();
    var key1 = Object();
    var key2 = Object();

    outer[key1] = WeakMap()..[key2] = "A";
    expect(outer[key1]![key2], "A");
    expect(outer[key2], null);
    expect(outer[key1]![key1], null);
  });

  test("A map can be used as its own key, or as its own value.", () {
    //
    var map = WeakMap();
    map[map] = map;
    expect(map[map], same(map));
    map.remove(map);
    expect(map.contains(map), false);
  });

  test("Many keys of all kinds.", () {
    //
    var map = WeakMap<Object, int>();
    var objects = [for (var i = 0; i < 10000; i++) Object()];

    for (var i = 0; i < objects.length; i++) {
      map[objects[i]] = i;
      map[i] = -i;
      map["$i"] = i * 2;
    }

    for (var i = 0; i < objects.length; i++) {
      expect(map[objects[i]], i);
      expect(map[i], -i);
      expect(map["$i"], i * 2);
    }

    // Removes half of them.
    for (var i = 0; i < objects.length; i += 2) {
      map.remove(objects[i]);
      map.remove(i);
      map.remove("$i");
    }

    for (var i = 0; i < objects.length; i++) {
      var removed = i.isEven;
      expect(map.contains(objects[i]), !removed);
      expect(map.contains(i), !removed);
      expect(map.contains("$i"), !removed);
    }
  });

  test("The value can be of any type.", () {
    //
    var map = WeakMap();
    var obj = Object();
    var value = Object();

    map[obj] = (1, 2);
    expect(map[obj], (1, 2));

    map[obj] = [1, 2];
    expect(map[obj], [1, 2]);

    map[obj] = value;
    expect(map[obj], same(value));

    map[obj] = obj; // The key itself.
    expect(map[obj], same(obj));
  });

  group("Garbage-collection.", () {
    //
    test("Sanity check: An object which is still referenced is not garbage-collected.", () {
      var keepAlive = <Object>[];
      var ref = _newObjectKeptIn(keepAlive);
      expect(isGarbageCollected(ref, maxRounds: 200), isFalse);
      expect(keepAlive, hasLength(1));
    });

    test("Sanity check: An object which is not referenced is garbage-collected.", () {
      var ref = _newObjectKeptIn(null);
      expect(isGarbageCollected(ref), isTrue);
    });

    test("An object key does not prevent its own garbage-collection.", () {
      var map = WeakMap();
      var refs = _addNewKeyAndValue(map);
      expect(isGarbageCollected(refs.key), isTrue);
      expect(map, isNotNull);
    });

    test("The value is garbage-collected after its key is garbage-collected.", () {
      var map = WeakMap();
      var refs = _addNewKeyAndValue(map);
      expect(isGarbageCollected(refs.key), isTrue);
      expect(isGarbageCollected(refs.value), isTrue);
      expect(map, isNotNull);
    });

    test("A value that references its own key does not prevent the key garbage-collection.", () {
      var map = WeakMap();
      var refs = _addNewKeyAndValue(map, valueReferencesKey: true);
      expect(isGarbageCollected(refs.key), isTrue);
      expect(isGarbageCollected(refs.value), isTrue);
      expect(map, isNotNull);
    });

    test("Removing an object key lets its value be garbage-collected.", () {
      var map = WeakMap();
      var key = Object();
      var valueRef = _addNewValue(map, key);
      map.remove(key);
      expect(isGarbageCollected(valueRef), isTrue);
      expect(key, isNotNull);
    });

    test("Setting a null value lets the previous value be garbage-collected.", () {
      var map = WeakMap();
      var key = Object();
      var valueRef = _addNewValue(map, key);
      map[key] = null;
      expect(isGarbageCollected(valueRef), isTrue);
      expect(key, isNotNull);
    });

    test("Clearing the map lets the values of object keys be garbage-collected.", () {
      var map = WeakMap();
      var key = Object();
      var valueRef = _addNewValue(map, key);
      map.clear();
      expect(isGarbageCollected(valueRef), isTrue);
      expect(key, isNotNull);
    });

    test("While the key is alive, the value is not garbage-collected.", () {
      var map = WeakMap();
      var key = Object();
      var valueRef = _addNewValue(map, key);
      expect(isGarbageCollected(valueRef, maxRounds: 200), isFalse);
      expect(map[key], same(valueRef.target));
    });

    test(
        "When the map is no longer used, its values are garbage-collected, "
        "even if their keys are still in use.", () {
      var key = Object();
      var valueRef = _addNewValueToDroppedMap(key);
      expect(isGarbageCollected(valueRef), isTrue);
      expect(key, isNotNull);
    });

    test(
        "When an object key is garbage-collected, "
        "the entries of the other keys are not affected.", () {
      var map = WeakMap();
      var keptKey = Object();
      var keptValueRef = _addNewValue(map, keptKey);
      var refs = _addNewKeyAndValue(map);

      expect(isGarbageCollected(refs.key), isTrue);
      expect(isGarbageCollected(refs.value), isTrue);
      expect(isGarbageCollected(keptValueRef, maxRounds: 200), isFalse);
      expect(map[keptKey], same(keptValueRef.target));
    });

    test("Many object keys are all garbage-collected.", () {
      var map = WeakMap();
      var refs = _addManyNewKeysAndValues(map, 1000);
      for (var ref in refs) {
        expect(isGarbageCollected(ref), isTrue);
      }
    });

    test(
        "Values of String, number, boolean, null and record keys are not "
        "garbage-collected while the map is in use (like a regular map).", () {
      var map = WeakMap();
      var refs = [
        _addNewValue(map, "A"),
        _addNewValue(map, 1),
        _addNewValue(map, 1.5),
        _addNewValue(map, true),
        _addNewValue(map, null),
        _addNewValue(map, (1, 2)),
      ];
      for (var ref in refs) {
        expect(isGarbageCollected(ref, maxRounds: 200), isFalse);
      }
      expect(map["A"], same(refs[0].target));
      expect(map[(1, 2)], same(refs[5].target));
    });

    test(
        "A record key keeps the objects inside it alive, "
        "because records act like a regular map.", () {
      var map = WeakMap();
      var objRef = _addRecordKeyWithNewObject(map);
      expect(isGarbageCollected(objRef, maxRounds: 200), isFalse);
      expect(map, isNotNull);
    });

    // Note: This can't be checked in the same test as the one above, because
    // after the test reads the object (to check it's alive), the VM may keep
    // it alive until the end of the test. A regular Dart map behaves the same.
    test("Clearing the map lets the objects inside record keys be garbage-collected.", () {
      var map = WeakMap();
      var objRef = _addRecordKeyWithNewObject(map);
      map.clear();
      expect(isGarbageCollected(objRef), isTrue);
    });

    test("Removing a record key lets the objects inside it be garbage-collected.", () {
      var map = WeakMap();
      var objRef = _addRecordKeyWithNewObject(map);
      map.remove(_recordKeyFor(objRef));
      expect(isGarbageCollected(objRef), isTrue);
    });

    test("A const object key is never garbage-collected, so its value is kept.", () {
      var map = WeakMap();
      var valueRef = _addNewValue(map, const _Value(42));
      expect(isGarbageCollected(valueRef, maxRounds: 200), isFalse);
      expect(map[const _Value(42)], same(valueRef.target));
    });
  },
      // Garbage-collection can't be observed synchronously in JavaScript.
      testOn: 'vm');
}

class _Value {
  final int value;

  const _Value(this.value);

  @override
  bool operator ==(Object other) => other is _Value && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

enum _Enum { a, b }

/// Creates a new object, optionally keeping it in the [keepAlive] list,
/// and returns a weak-reference to it.
WeakReference<Object> _newObjectKeptIn(List<Object>? keepAlive) {
  var obj = Object();
  keepAlive?.add(obj);
  return WeakReference(obj);
}

/// Adds a new key and a new value to the [map], without keeping them anywhere
/// else, and returns weak-references to the key and the value.
MapEntry<WeakReference<Object>, WeakReference<Object>> _addNewKeyAndValue(
  WeakMap map, {
  bool valueReferencesKey = false,
}) {
  var key = Object();
  var value = valueReferencesKey ? [key] : Object();
  map[key] = value;
  return MapEntry(WeakReference(key), WeakReference(value));
}

/// Adds a new value to the [map], for the given [key], without keeping it
/// anywhere else, and returns a weak-reference to the value.
WeakReference<Object> _addNewValue(WeakMap map, Object? key) {
  var value = Object();
  map[key] = value;
  return WeakReference(value);
}

/// Creates a new map, adds a new value to it for the given [key], and then
/// drops the map. Returns a weak-reference to the value.
WeakReference<Object> _addNewValueToDroppedMap(Object key) {
  var map = WeakMap();
  return _addNewValue(map, key);
}

/// Adds [count] new keys and values to the [map], without keeping them anywhere
/// else, and returns weak-references to all of them.
List<WeakReference<Object>> _addManyNewKeysAndValues(WeakMap map, int count) {
  var refs = <WeakReference<Object>>[];
  for (var i = 0; i < count; i++) {
    var entry = _addNewKeyAndValue(map);
    refs
      ..add(entry.key)
      ..add(entry.value);
  }
  return refs;
}

/// Adds a record key that contains a new object to the [map],
/// and returns a weak-reference to that object.
WeakReference<Object> _addRecordKeyWithNewObject(WeakMap map) {
  var obj = Object();
  map[(obj, 1)] = "A";
  return WeakReference(obj);
}

/// Returns a record equal to the one added by [_addRecordKeyWithNewObject].
(Object, int) _recordKeyFor(WeakReference<Object> objRef) => (objRef.target!, 1);
