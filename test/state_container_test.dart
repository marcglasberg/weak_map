import 'package:test/test.dart';
import 'package:weak_map/src/state_container.dart';

import 'gc_utils.dart';

// StateContainer is internal, used by the cache functions. It's tested
// directly here, so that it remains tested after the deprecated
// WeakContainer (which uses it) is removed.

void main() {
  test("Values that a WeakReference rejects can be used.", () {
    // WeakReference throws for these values, but StateContainer accepts them.
    // (In the VM it throws an ArgumentError, and in JavaScript a JS error.)
    expect(() => WeakReference<Object>("A"), throwsA(anything));

    for (var value in <Object?>[null, "A", "", 1, 0, -1, 1.5, true, false, (1, 2), (a: 1)]) {
      var container = StateContainer(value);
      expect(container.contains(value), true, reason: "Value: $value");
    }
  });

  test("Null.", () {
    expect(StateContainer(null).contains(null), true);
    expect(StateContainer(null).contains(false), false);
    expect(StateContainer(null).contains(0), false);
    expect(StateContainer(null).contains(""), false);
    expect(StateContainer(null).contains(()), false); // The empty record.
    expect(StateContainer(null).contains(Object()), false);

    expect(StateContainer(false).contains(null), false);
    expect(StateContainer(0).contains(null), false);
    expect(StateContainer("").contains(null), false);
    expect(StateContainer(()).contains(null), false);
    expect(StateContainer(Object()).contains(null), false);
  });

  test("Numbers, Strings and booleans are compared by equality.", () {
    expect(StateContainer(1).contains(1), true);
    expect(StateContainer(1).contains(2), false);
    expect(StateContainer(1).contains("1"), false);
    expect(StateContainer(1).contains(true), false);

    // Like in a regular Dart map, 1 and 1.0 are equal.
    expect(StateContainer(1).contains(1.0), true);

    expect(StateContainer(1.5).contains(double.parse("1.5")), true);
    expect(StateContainer(-1).contains(1), false);

    var str1 = "AB";
    var str2 = ["A", "B"].join();
    expect(StateContainer(str1).contains(str2), true);
    expect(StateContainer(str1).contains("ab"), false);

    expect(StateContainer(true).contains(true), true);
    expect(StateContainer(true).contains(false), false);
    expect(StateContainer(false).contains(false), true);
    expect(StateContainer(false).contains(0), false);
  });

  test("Records are compared by equality, including the objects inside them.", () {
    var obj = Object();
    expect(StateContainer((1, 2)).contains((1, 2)), true);
    expect(StateContainer((1, 2)).contains((2, 1)), false);
    expect(StateContainer((a: 1)).contains((a: 1)), true);
    expect(StateContainer((a: 1)).contains((b: 1)), false);
    expect(StateContainer((_Value(1), 2)).contains((_Value(1), 2)), true);
    expect(StateContainer((obj, 2)).contains((obj, 2)), true);
    expect(StateContainer((obj, 2)).contains((Object(), 2)), false);
  });

  test("Objects are compared by identity, not by equality.", () {
    var obj1 = _Value(1);
    var obj2 = _Value(1);
    expect(obj1, obj2);

    expect(StateContainer(obj1).contains(obj1), true);
    expect(StateContainer(obj1).contains(obj2), false);

    var list = [1, 2];
    expect(StateContainer(list).contains(list), true);
    expect(StateContainer(list).contains([1, 2]), false);

    var weird = _EqualToEverything();
    expect(StateContainer(weird).contains(weird), true);
    expect(StateContainer(weird).contains(_EqualToEverything()), false);
    expect(StateContainer(weird).contains(1), false);
    expect(StateContainer(weird).contains(null), false);
    expect(StateContainer(1).contains(weird), false);
    expect(StateContainer(null).contains(weird), false);
  });

  test("Other kinds of objects.", () {
    var function = () => 1;
    expect(StateContainer(function).contains(function), true);
    expect(StateContainer(function).contains(() => 1), false);

    // Const objects are canonicalized, so they are identical.
    expect(StateContainer(const _Value(1)).contains(const _Value(1)), true);
    expect(StateContainer(const _Value(1)).contains(_Value(1)), false);

    expect(StateContainer(_Enum.a).contains(_Enum.a), true);
    expect(StateContainer(_Enum.a).contains(_Enum.b), false);
    expect(StateContainer(#symbol).contains(#symbol), true);
    expect(StateContainer(Object).contains(Object), true);
    expect(StateContainer(Object).contains(int), false);
  });

  test("Clear.", () {
    var obj = Object();
    for (var value in <Object?>[obj, null, "A", 1, true, false, (1, 2)]) {
      var container = StateContainer(value);
      container.clear();
      expect(container.contains(value), false, reason: "Value: $value");
      expect(container.contains(null), false, reason: "Value: $value");

      // Clearing twice.
      container.clear();
      expect(container.contains(value), false, reason: "Value: $value");
    }
  });

  test("The same object can be in more than one container.", () {
    var obj = Object();
    var container1 = StateContainer(obj);
    var container2 = StateContainer(obj);
    container1.clear();
    expect(container1.contains(obj), false);
    expect(container2.contains(obj), true);
  });

  group("Garbage-collection.", () {
    //
    test("The container does not prevent the garbage-collection of its object.", () {
      var containers = <StateContainer>[];
      var ref = _newObjectInContainer(containers);
      expect(isGarbageCollected(ref), isTrue);
      expect(containers, hasLength(1));
    });

    test("While the object is alive, the container still contains it.", () {
      var obj = Object();
      var container = StateContainer(obj);
      expect(isGarbageCollected(WeakReference(obj), maxRounds: 200), isFalse);
      expect(container.contains(obj), true);
    });

    test("After its object is garbage-collected, the container does not contain null.", () {
      var containers = <StateContainer>[];
      var ref = _newObjectInContainer(containers);
      expect(isGarbageCollected(ref), isTrue);
      expect(containers.single.contains(null), false);
      expect(containers.single.contains(Object()), false);
      expect(containers.single.contains("A"), false);
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
WeakReference<Object> _newObjectInContainer(List<StateContainer> containers) {
  var obj = Object();
  containers.add(StateContainer(obj));
  return WeakReference(obj);
}
