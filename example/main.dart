import 'package:weak_map/weak_map.dart';

void main() {
  var map = WeakMap();
  map["A"] = 1;
  print('A = ${map["A"]}'); // A = 1
  print('B = ${map["B"]}'); // B = null

  var value = WeakContainer("X");
  print('Contains X = ${value.contains("X")}'); // Contains X = true
  print('Contains Y = ${value.contains("Y")}'); // Contains Y = false
}
