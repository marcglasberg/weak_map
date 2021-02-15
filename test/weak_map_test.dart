import 'package:test/test.dart';
import 'package:weak_map/weak_map.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Using null in the map.", () async {
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

  //////////////////////////////////////////////////////////////////////////////////////////////////
}
