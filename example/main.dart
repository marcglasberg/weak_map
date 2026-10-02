import 'package:weak_map/weak_map.dart';

void main() {
  var map = WeakMap<String, int?>();

  // 1)
  print('\nmap["A"] = 1');
  map["A"] = 1;
  print('A = ${map["A"]}'); // A = 1
  print('A exists in map = ${map.contains("A")}'); // A = true

  // 2)
  print('\nDoes not set B');
  print('B = ${map["B"]}'); // B = null
  print('B exists in map = ${map.contains("B")}'); // A = false

  // 3)
  print('\nmap["A"] = null');
  map["A"] = null;
  print('A = ${map["A"]}'); // A = null
  // Adding some null value to the map is the same as removing the key.
  print('A exists in map = ${map.contains("A")}'); // A = false

  // 4)
  // Object keys are compared by identity, and are held weakly.
  print('\nObject keys');
  var objMap = WeakMap<Object, String>();
  var key1 = Object();
  var key2 = Object();
  objMap[key1] = "metadata";
  print('key1 = ${objMap[key1]}'); // key1 = metadata
  print('key2 = ${objMap[key2]}'); // key2 = null
  // When there are no other references to key1, it may be garbage-collected,
  // together with its "metadata" value. The map does not keep it alive.
}
