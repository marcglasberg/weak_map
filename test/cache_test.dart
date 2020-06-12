import 'package:test/test.dart';
import 'package:weak_map/src/cache.dart';

void main() {
  var stateNames = ["Juan", "Anna", "Bill", "Zack", "Arnold", "Amanda"];

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test 1 state with 0 parameters.', () {
    //
    var selector = cache1_0((int limit) => () {
          return stateNames.take(limit).toList();
        });

    var memoA1 = selector(1)();
    var memoA2 = selector(1)();
    expect(memoA1, ["Juan"]);
    expect(identical(memoA1, memoA2), isTrue);

    var memoB1 = selector(2)();
    var memoB2 = selector(2)();
    expect(memoB1, ["Juan", "Anna"]);
    expect(identical(memoB1, memoB2), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test results are forgotten when the state changes (1 state with 0 parameters).', () {
    //
    var selector = cache1_0((int limit) => () {
          return stateNames.take(limit).toList();
        });

    var memoA1 = selector(1)();
    var memoA2 = selector(1)();
    expect(memoA1, ["Juan"]);
    expect(identical(memoA1, memoA2), isTrue);

    // Another state with another parameter.
    selector(2)();

    // Try reading the previous state, with the same parameter as before.
    var memoA5 = selector(1)();
    expect(memoA5, ["Juan"]);
    expect(identical(memoA5, memoA1), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test 1 state with 1 parameter.', () {
    //
    var selector = cache1_1((List<String> state) => (String startString) {
          return state.where((str) => str.startsWith(startString)).toList();
        });

    var memoA1 = selector(stateNames)("A");
    var memoA2 = selector(stateNames)("A");
    expect(memoA1, ["Anna", "Arnold", "Amanda"]);
    expect(identical(memoA1, memoA2), isTrue);

    selector(stateNames)("B");

    var memoA3 = selector(stateNames)("A");
    expect(memoA3, ["Anna", "Arnold", "Amanda"]);
    expect(identical(memoA1, memoA3), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test results are forgotten when the state changes (1 state with 1 parameter).', () {
    //
    var selector = cache1_1((List<String> state) => (String startString) {
          return state.where((str) => str.startsWith(startString)).toList();
        });

    var memoA1 = selector(stateNames)("A");
    var memoA2 = selector(stateNames)("A");
    expect(memoA1, ["Anna", "Arnold", "Amanda"]);
    expect(identical(memoA1, memoA2), isTrue);

    // Another state with another parameter.
    selector(List.of(stateNames))("B");
    selector(stateNames)("B");

    // Try reading the previous state, with the same parameter as before.
    var memoA5 = selector(stateNames)("A");
    expect(memoA5, ["Anna", "Arnold", "Amanda"]);
    expect(identical(memoA5, memoA1), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test 1 state with 2 parameters.', () {
    //
    var selector = cache1_2((List<String> state) => (String startString, String endString) {
          return state
              .where((str) => str.startsWith(startString) && str.endsWith(endString))
              .toList();
        });

    String otherA = "a" ""; // Concatenate.
    expect(identical("a", otherA), isFalse);

    var memoA1 = selector(stateNames)("A", "a");
    var memoA2 = selector(stateNames)("A", otherA);
    expect(memoA1, ["Anna", "Amanda"]);
    expect(identical(memoA1, memoA2), isTrue);

    var memoB1 = selector(stateNames)("A", "d");
    var memoB2 = selector(stateNames)("A", "d");
    expect(memoB1, ["Arnold"]);
    expect(identical(memoB1, memoB2), isTrue);

    var memoA3 = selector(stateNames)("A", "a");
    expect(memoA1, ["Anna", "Amanda"]);
    expect(identical(memoA1, memoA3), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test results are forgotten when the state changes (1 state with 2 parameters).', () {
    //
    var selector = cache1_2((List<String> state) => (String startString, String endString) {
          return state
              .where((str) => str.startsWith(startString) && str.endsWith(endString))
              .toList();
        });

    var memoA1 = selector(stateNames)("A", "a");
    var memoA2 = selector(stateNames)("A", "a");
    expect(memoA1, ["Anna", "Amanda"]);
    expect(identical(memoA1, memoA2), isTrue);

    // Another state with another parameter.
    selector(List.of(stateNames))("B", "l");
    selector(stateNames)("B", "l");

    // Try reading the previous state, with the same parameter as before.
    var memoA5 = selector(stateNames)("A", "a");
    expect(memoA5, ["Anna", "Amanda"]);
    expect(identical(memoA5, memoA1), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test 2 states with 0 parameters.', () {
    //
    var selector = cache2_0((List<String> names, int limit) => () {
          return names.where((str) => str.startsWith("A")).take(limit).toList();
        });

    var memoA1 = selector(stateNames, 1)();
    var memoA2 = selector(stateNames, 1)();
    expect(memoA1, ["Anna"]);
    expect(identical(memoA1, memoA2), isTrue);

    var memoB1 = selector(stateNames, 2)();
    var memoB2 = selector(stateNames, 2)();
    expect(memoB1, ["Anna", "Arnold"]);
    expect(identical(memoB1, memoB2), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test results are forgotten when the state changes (2 states with 0 parameters).', () {
    //
    var selector = cache2_0((List<String> names, int limit) => () {
          return names.where((str) => str.startsWith("A")).take(limit).toList();
        });

    var memoA1 = selector(stateNames, 1)();
    var memoA2 = selector(stateNames, 1)();
    expect(memoA1, ["Anna"]);
    expect(identical(memoA1, memoA2), isTrue);

    // Another state with another parameter.
    selector(stateNames, 2)();

    // Try reading the previous state, with the same parameter as before.
    var memoA5 = selector(stateNames, 1)();
    expect(memoA5, ["Anna"]);
    expect(identical(memoA5, memoA1), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test 2 states with 1 parameter.', () {
    //
    var selector = cache2_1((List<String> names, int limit) => (String searchString) {
          return names.where((str) => str.startsWith(searchString)).take(limit).toList();
        });

    var memoA1 = selector(stateNames, 1)("A");
    var memoA2 = selector(stateNames, 1)("A");
    expect(memoA1, ["Anna"]);
    expect(identical(memoA1, memoA2), isTrue);

    var memoB1 = selector(stateNames, 2)("A");
    var memoB2 = selector(stateNames, 2)("A");
    expect(memoB1, ["Anna", "Arnold"]);
    expect(identical(memoB1, memoB2), isTrue);

    var memoC = selector(stateNames, 2)("B");
    expect(memoC, ["Bill"]);

    var memoD = selector(stateNames, 2)("A");
    expect(identical(memoD, memoB1), isTrue);

    // Has to forget, because the state changed.
    selector(stateNames, 1)("A");
    expect(identical(memoA1, memoC), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test results are forgotten when the state changes (2 states with 1 parameter).', () {
    //
    var selector = cache2_1((List<String> names, int limit) => (String searchString) {
          return names.where((str) => str.startsWith(searchString)).take(limit).toList();
        });

    var memoA1 = selector(stateNames, 1)("A");
    var memoA2 = selector(stateNames, 1)("A");
    expect(memoA1, ["Anna"]);
    expect(identical(memoA1, memoA2), isTrue);

    // Another state with another parameter.
    selector(stateNames, 2)("B");
    selector(stateNames, 1)("B");

    // Try reading the previous state, with the same parameter as before.
    var memoA5 = selector(stateNames, 1)("A");
    expect(memoA5, ["Anna"]);
    expect(identical(memoA5, memoA1), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test 2 states with 2 parameters.', () {
    //
    var selector =
        cache2_2((List<String> names, int limit) => (String startString, String endString) {
              return names
                  .where((str) => str.startsWith(startString) && str.endsWith(endString))
                  .take(limit)
                  .toList();
            });

    var memoA1 = selector(stateNames, 1)("A", "a");
    var memoA2 = selector(stateNames, 1)("A", "a");
    expect(memoA1, ["Anna"]);
    expect(identical(memoA1, memoA2), isTrue);

    var memoB1 = selector(stateNames, 2)("A", "a");
    var memoB2 = selector(stateNames, 2)("A", "a");
    expect(memoB1, ["Anna", "Amanda"]);
    expect(identical(memoB1, memoB2), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test results are forgotten when the state changes (2 states with 2 parameters).', () {
    //
    var selector =
        cache2_2((List<String> names, int limit) => (String startString, String endString) {
              return names
                  .where((str) => str.startsWith(startString) && str.endsWith(endString))
                  .take(limit)
                  .toList();
            });

    var memoA1 = selector(stateNames, 1)("A", "a");
    var memoA2 = selector(stateNames, 1)("A", "a");
    expect(memoA1, ["Anna"]);
    expect(identical(memoA1, memoA2), isTrue);

    // Another state with another parameter.
    selector(stateNames, 2)("B", "l");
    selector(stateNames, 1)("B", "l");

    // Try reading the previous state, with the same parameter as before.
    var memoA5 = selector(stateNames, 1)("A", "a");
    expect(memoA5, ["Anna"]);
    expect(identical(memoA5, memoA1), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////
}