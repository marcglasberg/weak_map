import 'package:test/test.dart';
import 'package:weak_map/src/weak_container.dart';

import 'package:weak_map/weak_map.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Clear.", () {
    var container = WeakContainer(1);
    expect(container.contains(1), true);
    container.clear();
    expect(container.contains(1), false);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Using null in the map.", () {
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
