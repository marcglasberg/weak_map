// ignore_for_file: deprecated_member_use_from_same_package

import 'package:test/test.dart';
import 'package:weak_map/weak_map.dart';

import 'gc_utils.dart';

void main() {
  test("Contains.", () {
    expect(WeakContainer(1).contains(1), true);
    expect(WeakContainer(1).contains(2), false);
    expect(WeakContainer(1).contains("A"), false);
    expect(WeakContainer(true).contains(null), false);

    expect(WeakContainer("A").contains("A"), true);
    expect(WeakContainer("A").contains("B"), false);
    expect(WeakContainer("A").contains(1), false);
    expect(WeakContainer(true).contains(null), false);

    expect(WeakContainer(true).contains(true), true);
    expect(WeakContainer(true).contains(false), false);
    expect(WeakContainer(true).contains("A"), false);
    expect(WeakContainer(true).contains(null), false);

    expect(WeakContainer(null).contains(null), true);
    expect(WeakContainer(null).contains(true), false);
    expect(WeakContainer(null).contains(false), false);
    expect(WeakContainer(null).contains("A"), false);
    expect(WeakContainer(null).contains(1), false);

    var obj1 = Object();
    var obj2 = Object();
    expect(WeakContainer(obj1).contains(obj1), true);
    expect(WeakContainer(obj1).contains(obj2), false);
    expect(WeakContainer(obj1).contains(1), false);
    expect(WeakContainer(obj1).contains("A"), false);
    expect(WeakContainer(obj1).contains(null), false);
    expect(WeakContainer(1).contains(obj1), false);
    expect(WeakContainer("A").contains(obj1), false);
    expect(WeakContainer(true).contains(obj1), false);
    expect(WeakContainer(false).contains(obj1), false);
    expect(WeakContainer(null).contains(obj1), false);
  });

  test("Contains, for values that are false, zero or empty.", () {
    expect(WeakContainer(false).contains(false), true);
    expect(WeakContainer(false).contains(true), false);
    expect(WeakContainer(false).contains(0), false);
    expect(WeakContainer(false).contains(""), false);
    expect(WeakContainer(false).contains(null), false);

    expect(WeakContainer(0).contains(0), true);
    expect(WeakContainer(0).contains(1), false);
    expect(WeakContainer(0).contains(false), false);
    expect(WeakContainer(0).contains(""), false);
    expect(WeakContainer(0).contains(null), false);

    expect(WeakContainer("").contains(""), true);
    expect(WeakContainer("").contains(" "), false);
    expect(WeakContainer("").contains(false), false);
    expect(WeakContainer("").contains(0), false);
    expect(WeakContainer("").contains(null), false);

    expect(WeakContainer(null).contains(0), false);
    expect(WeakContainer(null).contains(""), false);
  });

  test("Contains, for doubles and negative numbers.", () {
    expect(WeakContainer(1.5).contains(1.5), true);
    expect(WeakContainer(1.5).contains(1), false);
    expect(WeakContainer(1.5).contains(2), false);

    expect(WeakContainer(-1).contains(-1), true);
    expect(WeakContainer(-1).contains(1), false);
  });

  test("Strings are compared by equality, even if not identical.", () {
    var str1 = "AB";
    var str2 = ["A", "B"].join();
    // In the VM these Strings are not identical (in JavaScript they are).

    expect(WeakContainer(str1).contains(str2), true);
    expect(WeakContainer(str2).contains(str1), true);
  });

  test("Objects are compared by identity, not by equality.", () {
    var obj1 = _Value(1);
    var obj2 = _Value(1);
    expect(obj1, obj2);
    expect(identical(obj1, obj2), isFalse);

    expect(WeakContainer(obj1).contains(obj1), true);
    expect(WeakContainer(obj1).contains(obj2), false);
    expect(WeakContainer(obj2).contains(obj1), false);
  });

  test("Objects that claim to be equal to everything are not confused with other values.", () {
    var obj = _EqualToEverything();

    expect(WeakContainer(obj).contains(obj), true);
    expect(WeakContainer(obj).contains(_EqualToEverything()), false);
    expect(WeakContainer(obj).contains(1), false);
    expect(WeakContainer(obj).contains("A"), false);
    expect(WeakContainer(obj).contains(true), false);
    expect(WeakContainer(obj).contains(null), false);

    expect(WeakContainer(1).contains(obj), false);
    expect(WeakContainer("A").contains(obj), false);
    expect(WeakContainer(true).contains(obj), false);
    expect(WeakContainer(null).contains(obj), false);
  });

  test("Some other kinds of objects.", () {
    var list = [1, 2];
    var function = () => 1;

    expect(WeakContainer(list).contains(list), true);
    expect(WeakContainer(list).contains([1, 2]), false);

    expect(WeakContainer(function).contains(function), true);
    expect(WeakContainer(function).contains(() => 1), false);

    // Const objects are canonicalized, so they are identical.
    expect(WeakContainer(const _Value(1)).contains(const _Value(1)), true);
    expect(WeakContainer(const _Value(1)).contains(_Value(1)), false);
    expect(WeakContainer(const _Value(1)).contains(const _Value(2)), false);

    expect(WeakContainer(_Enum.a).contains(_Enum.a), true);
    expect(WeakContainer(_Enum.a).contains(_Enum.b), false);

    expect(WeakContainer(#symbol).contains(#symbol), true);
    expect(WeakContainer(Object).contains(Object), true);
    expect(WeakContainer(Object).contains(int), false);
  });

  test("Records are compared by equality.", () {
    expect(WeakContainer((1, 2)).contains((1, 2)), true);
    expect(WeakContainer((1, 2)).contains((2, 1)), false);
    expect(WeakContainer((name: "x", age: 3)).contains((name: "x", age: 3)), true);
    expect(WeakContainer((name: "x", age: 3)).contains((name: "x", age: 4)), false);

    var obj = Object();
    expect(WeakContainer((1, 2)).contains(obj), false);
    expect(WeakContainer((1, 2)).contains(1), false);
    expect(WeakContainer((1, 2)).contains(null), false);
    expect(WeakContainer(obj).contains((1, 2)), false);
    expect(WeakContainer(1).contains((1, 2)), false);
    expect(WeakContainer(null).contains((1, 2)), false);

    var container = WeakContainer((1, 2));
    container.clear();
    expect(container.contains((1, 2)), false);
  });

  test("The same object can be in more than one container.", () {
    var obj = Object();
    var container1 = WeakContainer(obj);
    var container2 = WeakContainer(obj);

    expect(container1.contains(obj), true);
    expect(container2.contains(obj), true);

    container1.clear();
    expect(container1.contains(obj), false);
    expect(container2.contains(obj), true);
  });

  test("Clear.", () {
    var container = WeakContainer(1);
    expect(container.contains(1), true);
    container.clear();
    expect(container.contains(1), false);
  });

  test("Clear, for all kinds of values.", () {
    var obj = Object();
    var container = WeakContainer(obj);
    expect(container.contains(obj), true);
    container.clear();
    expect(container.contains(obj), false);

    container = WeakContainer("A");
    container.clear();
    expect(container.contains("A"), false);

    container = WeakContainer(true);
    container.clear();
    expect(container.contains(true), false);

    container = WeakContainer(false);
    container.clear();
    expect(container.contains(false), false);

    // After clearing, the container does not contain null either.
    container = WeakContainer(null);
    expect(container.contains(null), true);
    container.clear();
    expect(container.contains(null), false);

    // Clearing twice.
    container = WeakContainer(obj);
    container.clear();
    container.clear();
    expect(container.contains(obj), false);
    expect(container.contains(null), false);
  });

  group("Garbage-collection.", () {
    //
    test("The container does not prevent the garbage-collection of its object.", () {
      var containers = <WeakContainer>[];
      var ref = _newObjectInContainer(containers);
      expect(isGarbageCollected(ref), isTrue);
      expect(containers, hasLength(1));
    });

    test("After its object is garbage-collected, the container does not contain null.", () {
      var containers = <WeakContainer>[];
      var ref = _newObjectInContainer(containers);
      expect(isGarbageCollected(ref), isTrue);
      expect(containers.single.contains(null), false);
      expect(containers.single.contains(Object()), false);
    });

    test("While the object is alive, the container still contains it.", () {
      var obj = Object();
      var container = WeakContainer(obj);
      expect(isGarbageCollected(WeakReference(obj), maxRounds: 200), isFalse);
      expect(container.contains(obj), true);
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

class _EqualToEverything {
  @override
  bool operator ==(Object other) => true;

  @override
  int get hashCode => 0;
}

enum _Enum { a, b }

/// Creates a new object, puts it in a new container that is added to
/// [containers], and returns a weak-reference to the object.
WeakReference<Object> _newObjectInContainer(List<WeakContainer> containers) {
  var obj = Object();
  containers.add(WeakContainer(obj));
  return WeakReference(obj);
}
