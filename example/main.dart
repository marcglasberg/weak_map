import 'package:weak_map/weak_map.dart';

void main() {
  var map = WeakMap<String, int?>();

  print('\nmap["A"] = 1');
  map["A"] = 1;
  print('A = ${map["A"]}'); // A = 1
  print('A exists in map = ${map.contains("A")}'); // A = true

  print('\nDoes not set B');
  print('B = ${map["B"]}'); // B = null
  print('B exists in map = ${map.contains("B")}'); // A = false

  print('\nmap["A"] = null');
  map["A"] = null;
  print('A = ${map["A"]}'); // A = null
  print('A exists in map = ${map.contains("A")}'); // A = true

  print('\nvalue = WeakContainer("X")');
  var value = WeakContainer("X");
  print('Contains X = ${value.contains("X")}'); // Contains X = true
  print('Contains Y = ${value.contains("Y")}'); // Contains Y = false
}
