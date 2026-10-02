import 'package:test/test.dart';
import 'package:weak_map/weak_map.dart';

import 'gc_utils.dart';

void main() {
  var stateNames = List<String>.unmodifiable(["Juan", "Anna", "Bill", "Zack", "Arnold", "Amanda"]);

  test('Test 1 state with 0 parameters.', () {
    //

    // This is some function we want to cache, for some specific `limit`.
    List<String> func(int? limit) {
      return (limit == null) ? [] : stateNames.take(limit).toList();
    }

    // This is the cache.
    var _funcCached = cache1state<List<String>, int?>((int? limit) => () => func(limit));

    // And this is the cached func.
    List<String> funcCached(int? limit) => _funcCached(limit)();

    List<String> memoA1 = funcCached(1);
    List<String> memoA2 = funcCached(1);
    expect(memoA1, ["Juan"]);
    expect(memoA2, ["Juan"]);
    expect(identical(memoA1, memoA2), isTrue);

    var memoB1 = _funcCached(2)();
    var memoB2 = _funcCached(2)();
    expect(memoB1, ["Juan", "Anna"]);
    expect(memoB2, ["Juan", "Anna"]);
    expect(identical(memoB1, memoB2), isTrue);

    var memoC1 = _funcCached(null)();
    var memoC2 = _funcCached(null)();
    expect(memoC1, []);
    expect(memoC2, []);
    expect(identical(memoC1, memoC2), isTrue);
  });

  test('Test 1 state with 0 parameters, caching null parameter.', () {
    //

    // This is some function we want to cache, for some specific `limit`.
    List<String>? func(int? limit) {
      return (limit == null) ? null : stateNames.take(limit).toList();
    }

    // This is the cache.
    var _funcCached = cache1state<List<String>?, int?>((int? limit) => () => func(limit));

    // And this is the cached func.
    List<String>? funcCached(int? limit) => _funcCached(limit)();

    List<String>? memoA1 = funcCached(1);
    List<String>? memoA2 = funcCached(1);
    expect(memoA1, ["Juan"]);
    expect(memoA2, ["Juan"]);
    expect(identical(memoA1, memoA2), isTrue);

    var memoB1 = _funcCached(2)();
    var memoB2 = _funcCached(2)();
    expect(memoB1, ["Juan", "Anna"]);
    expect(memoB2, ["Juan", "Anna"]);
    expect(identical(memoB1, memoB2), isTrue);

    var memoC1 = _funcCached(null)();
    var memoC2 = _funcCached(null)();
    expect(memoC1, isNull);
    expect(memoC2, isNull);
    expect(identical(memoC1, memoC2), isTrue);
  });

  test('Test results are forgotten when the state changes (1 state with 0 parameters).', () {
    //
    var selector = cache1state((int? limit) => () {
          return limit == null ? [] : stateNames.take(limit).toList();
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

  test('Also works when changing to null (1 state with 0 parameters).', () {
    //
    var selector = cache1state((int? limit) => () {
          return limit == null ? [] : stateNames.take(limit).toList();
        });

    var memoA1 = selector(1)();
    var memoA2 = selector(1)();
    expect(memoA1, ["Juan"]);
    expect(identical(memoA1, memoA2), isTrue);

    // Another state with another parameter.
    selector(null)();

    // Try reading the previous state, with the same parameter as before.
    var memoA5 = selector(1)();
    expect(memoA5, ["Juan"]);
    expect(identical(memoA5, memoA1), isFalse);
  });

  test('Also works when changing from null (1 state with 0 parameters).', () {
    //
    var selector = cache1state((int? limit) => () {
          return limit == null ? [] : stateNames.take(limit).toList();
        });

    var memoA1 = selector(null)();
    var memoA2 = selector(null)();
    expect(memoA1, []);
    expect(identical(memoA1, memoA2), isTrue);

    // Another state with another parameter.
    selector(1)();

    // Try reading the previous state, with the same parameter as before.
    var memoA5 = selector(null)();
    expect(memoA5, []);
    expect(identical(memoA5, memoA1), isFalse);
  });

  test('Test 1 state with 1 parameter.', () {
    //
    var selector = cache1state_1param((List<String> state) => (String startString) {
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

  test('Test results are forgotten when the state changes (1 state with 1 parameter).', () {
    //
    var selector = cache1state_1param((List<String> state) => (String startString) {
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

  test('Test 1 state with 2 parameters.', () {
    //
    var selector =
        cache1state_2params((List<String> state) => (String startString, String endString) {
              return state
                  .where((str) => str.startsWith(startString) && str.endsWith(endString))
                  .toList();
            });

    String otherA = "a" ""; // Concatenate.
    expect(identical("a", otherA), isTrue);

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

  test('Test results are forgotten when the state changes (1 state with 2 parameters).', () {
    //
    var selector =
        cache1state_2params((List<String> state) => (String startString, String endString) {
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

  test('Test 2 states with 0 parameters.', () {
    //
    var selector = cache2states((List<String> names, int limit) => () {
          return names.where((str) => str.startsWith("A")).take(limit).toList();
        });

    var memoA1 = selector(stateNames, 1)();
    var memoA2 = selector(stateNames, 1)();
    expect(memoA1, ["Anna"]);
    expect(memoA2, ["Anna"]);
    expect(identical(memoA1, memoA2), isTrue);

    var memoB1 = selector(stateNames, 2)();
    var memoB2 = selector(stateNames, 2)();
    expect(memoB1, ["Anna", "Arnold"]);
    expect(identical(memoB1, memoB2), isTrue);
  });

  test('Test results are forgotten when the state changes (2 states with 0 parameters).', () {
    //
    var selector = cache2states((List<String> names, int limit) => () {
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

  test('Test 2 states with 1 parameter.', () {
    //
    var selector = cache2states_1param((List<String> names, int limit) => (String searchString) {
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

  test('Test results are forgotten when the state changes (2 states with 1 parameter).', () {
    //
    var selector = cache2states_1param((List<String> names, int limit) => (String searchString) {
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

  test('Test 2 states with 2 parameters.', () {
    //
    var selector = cache2states_2params(
        (List<String> names, int limit) => (String startString, String endString) {
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

  test('Test results are forgotten when the state changes (2 states with 2 parameters).', () {
    //
    var selector = cache2states_2params(
        (List<String> names, int limit) => (String startString, String endString) {
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

  test(
      'Changing the second or the first state, it should forget the cached value. '
      '(2 states with 2 parameters)', () {
    //
    var stateNames1 = List<String>.unmodifiable(["A1a", "A2a", "A3x", "B4a", "B5a", "B6x"]);

    var selector = cache2states_2params(
        (List<String> names, int limit) => (String startString, String endString) {
              return names
                  .where((str) => str.startsWith(startString) && str.endsWith(endString))
                  .take(limit)
                  .toList();
            });

    var memo1 = selector(stateNames1, 1)("A", "a");
    expect(memo1, ["A1a"]);

    var memo2 = selector(stateNames1, 2)("A", "a");
    expect(memo2, ["A1a", "A2a"]);

    var memo3 = selector(stateNames1, 1)("A", "a");
    expect(memo3, ["A1a"]);

    var memo4 = selector(stateNames1, 2)("A", "a");
    expect(memo4, ["A1a", "A2a"]);

    expect(identical(memo1, memo3), isFalse);
    expect(identical(memo2, memo4), isFalse);

    // ---

    var stateNames2 = List<String>.unmodifiable(["A1a", "A2a", "A3x", "B4a", "B5a", "B6x"]);

    var memo5 = selector(stateNames1, 1)("A", "a");
    expect(memo5, ["A1a"]);

    var memo6 = selector(stateNames2, 1)("A", "a");
    expect(memo6, ["A1a"]);

    var memo7 = selector(stateNames1, 1)("A", "a");
    expect(memo7, ["A1a"]);

    var memo8 = selector(stateNames2, 1)("A", "a");
    expect(memo8, ["A1a"]);

    expect(identical(memo5, memo7), isFalse);
    expect(identical(memo6, memo8), isFalse);
  });

  test('Test 2 states with 3 parameters.', () {
    //
    var selector = cache2states_3params((List<String> names, int limit) =>
        (String startString, String endString, String containsString) {
          return names
              .where((str) =>
                  str.startsWith(startString) &&
                  str.endsWith(endString) &&
                  str.contains(containsString))
              .take(limit)
              .toList();
        });

    expect(selector(stateNames, 1)("A", "a", "x"), []);

    var memoA1 = selector(stateNames, 1)("A", "a", "n");
    var memoA2 = selector(stateNames, 1)("A", "a", "n");
    expect(memoA1, ["Anna"]);
    expect(identical(memoA1, memoA2), isTrue);

    var memoB1 = selector(stateNames, 2)("A", "a", "n");
    var memoB2 = selector(stateNames, 2)("A", "a", "n");
    expect(memoB1, ["Anna", "Amanda"]);
    expect(identical(memoB1, memoB2), isTrue);
  });

  test('Test results are forgotten when the state changes (2 states with 3 parameters).', () {
    //
    var selector = cache2states_3params((List<String> names, int limit) =>
        (String startString, String endString, String containsString) {
          return names
              .where((str) =>
                  str.startsWith(startString) &&
                  str.endsWith(endString) &&
                  str.contains(containsString))
              .take(limit)
              .toList();
        });

    var memoA1 = selector(stateNames, 1)("A", "a", "n");
    var memoA2 = selector(stateNames, 1)("A", "a", "n");
    expect(memoA1, ["Anna"]);
    expect(identical(memoA1, memoA2), isTrue);

    // Same state with another parameter.
    // Then try reading the previous state, with the same parameter as before.
    // Result is the same instance.
    var memoA3 = selector(stateNames, 1)("A", "a", "x");
    var memoA4 = selector(stateNames, 1)("A", "a", "n");
    var memoA5 = selector(stateNames, 1)("A", "a", "n");
    var memoA6 = selector(stateNames, 1)("A", "a", "x");
    expect(memoA3, []);
    expect(memoA4, ["Anna"]);
    expect(memoA5, ["Anna"]);
    expect(memoA6, []);
    expect(identical(memoA4, memoA5), isTrue);
    expect(identical(memoA3, memoA6), isTrue);

    // ---

    // Another state with the same parameter.
    selector(stateNames, 2)("A", "a", "n");

    // Try reading the previous state, with the same parameter as before.
    var memoA7 = selector(stateNames, 1)("A", "a", "x");
    var memoA8 = selector(stateNames, 1)("A", "a", "n");
    expect(memoA7, []);
    expect(memoA8, ["Anna"]);
    expect(identical(memoA7, memoA3), isFalse);
    expect(identical(memoA8, memoA4), isFalse);
  });

  test(
      'Changing the second or the first state, it should forget the cached value. '
      '(2 states with 3 parameters)', () {
    //
    var stateNames1 = List<String>.unmodifiable(["A1na", "A2na", "A3nx", "B4na", "B5na", "B6nx"]);

    var selector = cache2states_3params((List<String> names, int limit) =>
        (String startString, String endString, String containsString) {
          return names
              .where((str) =>
                  str.startsWith(startString) &&
                  str.endsWith(endString) &&
                  str.contains(containsString))
              .take(limit)
              .toList();
        });

    var memo1 = selector(stateNames1, 1)("A", "a", "n");
    expect(memo1, ["A1na"]);

    var memo2 = selector(stateNames1, 2)("A", "a", "n");
    expect(memo2, ["A1na", "A2na"]);

    var memo3 = selector(stateNames1, 1)("A", "a", "n");
    expect(memo3, ["A1na"]);

    var memo4 = selector(stateNames1, 2)("A", "a", "n");
    expect(memo4, ["A1na", "A2na"]);

    expect(identical(memo1, memo3), isFalse);
    expect(identical(memo2, memo4), isFalse);

    // ---

    var stateNames2 = List<String>.unmodifiable(["A1na", "A2na", "A3nx", "B4na", "B5na", "B6nx"]);

    var memo5 = selector(stateNames1, 1)("A", "a", "n");
    expect(memo5, ["A1na"]);

    var memo6 = selector(stateNames2, 1)("A", "a", "n");
    expect(memo6, ["A1na"]);

    var memo7 = selector(stateNames1, 1)("A", "a", "n");
    expect(memo7, ["A1na"]);

    var memo8 = selector(stateNames2, 1)("A", "a", "n");
    expect(memo8, ["A1na"]);

    expect(identical(memo5, memo7), isFalse);
    expect(identical(memo6, memo8), isFalse);
  });

  test('Test 3 states with 0 parameters.', () {
    //
    var selector = cache3states((
      List<String> names,
      int limit,
      String startsWith,
    ) =>
        () {
          return names.where((str) => str.startsWith(startsWith)).take(limit).toList();
        });

    // Same states return the same object as the result.
    var memoA1 = selector(stateNames, 1, "A")();
    var memoA2 = selector(stateNames, 1, "A")();
    expect(memoA1, ["Anna"]);
    expect(memoA2, ["Anna"]);
    expect(identical(memoA1, memoA2), isTrue);

    // ---

    // Change first state (even if it's equal), deletes the cache.
    var memoA = selector(stateNames, 1, "A")();
    var memoB = selector(stateNames.toList(), 1, "A")();
    expect(memoB, ["Anna"]);
    expect(identical(memoA, memoB), isFalse);

    // ---

    // Change first state, deletes the cache.
    memoA = selector(stateNames, 1, "A")();
    selector(stateNames.toList(), 1, "A")();
    memoB = selector(stateNames, 1, "A")();
    expect(memoB, ["Anna"]);
    expect(identical(memoA, memoB), isFalse);

    // Change second state, deletes the cache.
    memoA = selector(stateNames, 1, "A")();
    selector(stateNames, 2, "A")();
    memoB = selector(stateNames, 1, "A")();
    expect(memoB, ["Anna"]);
    expect(identical(memoA, memoB), isFalse);

    // Change third state, deletes the cache.
    memoA = selector(stateNames, 1, "A")();
    selector(stateNames, 1, "B")();
    memoB = selector(stateNames, 1, "A")();
    expect(memoB, ["Anna"]);
    expect(identical(memoA, memoB), isFalse);
  });

  // The tests below count how many times the cached function is called, which
  // is the only way to be sure the cache is used when the results are values
  // like numbers or Strings (for which `identical` is not meaningful).

  test('cache1state: Calls the function only once per state.', () {
    //
    var calls = 0;
    var selector = cache1state((int state) => () {
          calls++;
          return state * 10;
        });

    expect(selector(1)(), 10);
    expect(selector(1)(), 10);
    expect(calls, 1);

    expect(selector(2)(), 20);
    expect(selector(2)(), 20);
    expect(calls, 2);

    // Only the last state is remembered.
    expect(selector(1)(), 10);
    expect(calls, 3);
  });

  test('cache1state: Null results are cached too.', () {
    //
    var calls = 0;
    var selector = cache1state((Object? state) => () {
          calls++;
          return null;
        });

    var obj = Object();
    expect(selector(obj)(), isNull);
    expect(selector(obj)(), isNull);
    expect(calls, 1);

    expect(selector("A")(), isNull);
    expect(selector("A")(), isNull);
    expect(calls, 2);

    expect(selector(null)(), isNull);
    expect(selector(null)(), isNull);
    expect(calls, 3);
  });

  test(
      'cache1state: Object states are compared by identity, '
      'while Strings, numbers and booleans are compared by equality.', () {
    //
    var calls = 0;
    var selector = cache1state((Object state) => () {
          calls++;
          return [state];
        });

    // Equal, but not identical, objects are different states.
    var state1 = _Value(1);
    var state2 = _Value(1);
    expect(state1, state2);
    selector(state1)();
    selector(state2)();
    expect(calls, 2);
    selector(state2)();
    expect(calls, 2);

    // Equal Strings are the same state, even if not identical.
    var str1 = "AB";
    var str2 = ["A", "B"].join();
    // In the VM these Strings are not identical (in JavaScript they are).
    selector(str1)();
    selector(str2)();
    expect(calls, 3);

    selector(1)();
    selector(1)();
    expect(calls, 4);

    selector(true)();
    selector(true)();
    expect(calls, 5);

    selector(1.5)();
    selector(1.5)();
    expect(calls, 6);
  });

  test('cache1state: Records are compared by equality.', () {
    //
    var calls = 0;
    var selector = cache1state(((int, int) state) => () {
          calls++;
          return state.$1 + state.$2;
        });

    expect(selector((1, 2))(), 3);
    expect(selector((1, 2))(), 3);
    expect(calls, 1);

    expect(selector((2, 2))(), 4);
    expect(calls, 2);
  });

  test('cache1state_1param: Calls the function only once per state and parameter.', () {
    //
    var calls = 0;
    var selector = cache1state_1param((String state) => (int param) {
          calls++;
          return "$state$param";
        });

    expect(selector("A")(1), "A1");
    expect(selector("A")(1), "A1");
    expect(calls, 1);

    expect(selector("A")(2), "A2");
    expect(selector("A")(2), "A2");
    expect(calls, 2);

    // While the state is the same, it keeps the results for all parameters.
    expect(selector("A")(1), "A1");
    expect(selector("A")(2), "A2");
    expect(calls, 2);

    // A new state forgets the results for all parameters.
    expect(selector("B")(1), "B1");
    expect(calls, 3);
    expect(selector("A")(1), "A1");
    expect(selector("A")(2), "A2");
    expect(calls, 5);
  });

  test('cache1state_1param: Null states, parameters and results.', () {
    //
    var calls = 0;
    var selector = cache1state_1param((String? state) => (int? param) {
          calls++;
          return (state == null || param == null) ? null : "$state$param";
        });

    expect(selector(null)(1), isNull);
    expect(selector(null)(1), isNull);
    expect(calls, 1);

    expect(selector(null)(null), isNull);
    expect(selector(null)(null), isNull);
    expect(calls, 2);

    expect(selector("A")(null), isNull);
    expect(selector("A")(null), isNull);
    expect(calls, 3);

    expect(selector("A")(1), "A1");
    expect(selector("A")(null), isNull);
    expect(calls, 4);
  });

  test('cache1state_1param: Parameters are compared by equality.', () {
    //
    var calls = 0;
    var selector = cache1state_1param((Object state) => (_Value param) {
          calls++;
          return [param.value];
        });

    var state = Object();
    var result1 = selector(state)(_Value(1));
    var result2 = selector(state)(_Value(1));
    expect(identical(result1, result2), isTrue);
    expect(calls, 1);

    selector(state)(_Value(2));
    expect(calls, 2);
  });

  test('cache1state_2params: Calls the function only once per state and parameters.', () {
    //
    var calls = 0;
    var selector = cache1state_2params((String state) => (String? p1, String? p2) {
          calls++;
          return "$state-$p1-$p2";
        });

    expect(selector("S")("a", "b"), "S-a-b");
    expect(selector("S")("a", "b"), "S-a-b");
    expect(calls, 1);

    // The order of the parameters matters.
    expect(selector("S")("b", "a"), "S-b-a");
    expect(calls, 2);

    // Null parameters.
    expect(selector("S")("a", null), "S-a-null");
    expect(selector("S")(null, "a"), "S-null-a");
    expect(selector("S")(null, null), "S-null-null");
    expect(calls, 5);

    // While the state is the same, it keeps the results for all parameters.
    selector("S")("a", "b");
    selector("S")("b", "a");
    selector("S")("a", null);
    selector("S")(null, "a");
    selector("S")(null, null);
    expect(calls, 5);

    // A new state forgets the results for all parameters.
    expect(selector("T")("a", "b"), "T-a-b");
    expect(calls, 6);
    expect(selector("S")("a", "b"), "S-a-b");
    expect(calls, 7);
  });

  test('cache1state_2params: Null states and results.', () {
    //
    var calls = 0;
    var selector = cache1state_2params((String? state) => (int p1, int p2) {
          calls++;
          return null;
        });

    expect(selector(null)(1, 2), isNull);
    expect(selector(null)(1, 2), isNull);
    expect(calls, 1);

    expect(selector("A")(1, 2), isNull);
    expect(selector("A")(1, 2), isNull);
    expect(calls, 2);
  });

  test('cache2states: Calls the function only once per states, and forgets when any state changes.',
      () {
    //
    var calls = 0;
    var selector = cache2states((String? s1, int? s2) => () {
          calls++;
          return "$s1-$s2";
        });

    expect(selector("A", 1)(), "A-1");
    expect(selector("A", 1)(), "A-1");
    expect(calls, 1);

    // Change only the first state.
    expect(selector("B", 1)(), "B-1");
    expect(selector("B", 1)(), "B-1");
    expect(calls, 2);

    // Change only the second state.
    expect(selector("B", 2)(), "B-2");
    expect(selector("B", 2)(), "B-2");
    expect(calls, 3);

    // Only the last states are remembered.
    expect(selector("A", 1)(), "A-1");
    expect(calls, 4);

    // Null states.
    expect(selector(null, 1)(), "null-1");
    expect(selector(null, 1)(), "null-1");
    expect(calls, 5);

    expect(selector(null, null)(), "null-null");
    expect(selector(null, null)(), "null-null");
    expect(calls, 6);

    expect(selector("A", null)(), "A-null");
    expect(selector("A", null)(), "A-null");
    expect(calls, 7);
  });

  test('cache2states: Object states, null results, and the same object as both states.', () {
    //
    var calls = 0;
    var selector = cache2states((Object s1, Object s2) => () {
          calls++;
          return null;
        });

    var obj1 = Object();
    var obj2 = Object();

    expect(selector(obj1, obj2)(), isNull);
    expect(selector(obj1, obj2)(), isNull);
    expect(calls, 1);

    // Swapping the states is a change.
    expect(selector(obj2, obj1)(), isNull);
    expect(calls, 2);

    expect(selector(obj1, obj1)(), isNull);
    expect(selector(obj1, obj1)(), isNull);
    expect(calls, 3);
  });

  test('cache2states_1param: Calls the function only once per states and parameter.', () {
    //
    var calls = 0;
    var selector = cache2states_1param((String? s1, int? s2) => (String? p) {
          calls++;
          return (p == null) ? null : "$s1-$s2-$p";
        });

    expect(selector("A", 1)("x"), "A-1-x");
    expect(selector("A", 1)("x"), "A-1-x");
    expect(calls, 1);

    expect(selector("A", 1)("y"), "A-1-y");
    expect(selector("A", 1)(null), isNull);
    expect(calls, 3);

    // While the states are the same, it keeps the results for all parameters.
    selector("A", 1)("x");
    selector("A", 1)("y");
    selector("A", 1)(null);
    expect(calls, 3);

    // Changing only the first state forgets the results for all parameters.
    expect(selector("B", 1)("x"), "B-1-x");
    expect(calls, 4);
    expect(selector("A", 1)("x"), "A-1-x");
    expect(calls, 5);

    // Changing only the second state forgets the results for all parameters.
    expect(selector("A", 2)("x"), "A-2-x");
    expect(calls, 6);
    expect(selector("A", 1)("x"), "A-1-x");
    expect(calls, 7);

    // Null states.
    expect(selector(null, null)("x"), "null-null-x");
    expect(selector(null, null)("x"), "null-null-x");
    expect(calls, 8);
  });

  test('cache2states_2params: Calls the function only once per states and parameters.', () {
    //
    var calls = 0;
    var selector = cache2states_2params((String? s1, int? s2) => (String? p1, String? p2) {
          calls++;
          return (p1 == null) ? null : "$s1-$s2-$p1-$p2";
        });

    expect(selector("A", 1)("x", "y"), "A-1-x-y");
    expect(selector("A", 1)("x", "y"), "A-1-x-y");
    expect(calls, 1);

    // The order of the parameters matters.
    expect(selector("A", 1)("y", "x"), "A-1-y-x");
    expect(calls, 2);

    // Null parameters and results.
    expect(selector("A", 1)(null, "x"), isNull);
    expect(selector("A", 1)("x", null), "A-1-x-null");
    expect(calls, 4);

    // While the states are the same, it keeps the results for all parameters.
    selector("A", 1)("x", "y");
    selector("A", 1)("y", "x");
    selector("A", 1)(null, "x");
    selector("A", 1)("x", null);
    expect(calls, 4);

    // Changing only the first state forgets the results.
    expect(selector("B", 1)("x", "y"), "B-1-x-y");
    expect(calls, 5);

    // Changing only the second state forgets the results.
    expect(selector("B", 2)("x", "y"), "B-2-x-y");
    expect(calls, 6);

    // Null states.
    expect(selector(null, null)("x", "y"), "null-null-x-y");
    expect(selector(null, null)("x", "y"), "null-null-x-y");
    expect(calls, 7);
  });

  test('cache2states_3params: Calls the function only once per states and parameters.', () {
    //
    var calls = 0;
    var selector =
        cache2states_3params((String? s1, int? s2) => (String? p1, String? p2, String? p3) {
              calls++;
              return (p1 == null) ? null : "$s1-$s2-$p1-$p2-$p3";
            });

    expect(selector("A", 1)("x", "y", "z"), "A-1-x-y-z");
    expect(selector("A", 1)("x", "y", "z"), "A-1-x-y-z");
    expect(calls, 1);

    // The order of the parameters matters.
    expect(selector("A", 1)("z", "y", "x"), "A-1-z-y-x");
    expect(selector("A", 1)("x", "z", "y"), "A-1-x-z-y");
    expect(calls, 3);

    // Null parameters and results.
    expect(selector("A", 1)(null, "y", "z"), isNull);
    expect(selector("A", 1)("x", null, null), "A-1-x-null-null");
    expect(calls, 5);

    // While the states are the same, it keeps the results for all parameters.
    selector("A", 1)("x", "y", "z");
    selector("A", 1)("z", "y", "x");
    selector("A", 1)("x", "z", "y");
    selector("A", 1)(null, "y", "z");
    selector("A", 1)("x", null, null);
    expect(calls, 5);

    // Changing only the first state forgets the results.
    expect(selector("B", 1)("x", "y", "z"), "B-1-x-y-z");
    expect(calls, 6);

    // Changing only the second state forgets the results.
    expect(selector("B", 2)("x", "y", "z"), "B-2-x-y-z");
    expect(calls, 7);

    // Null states.
    expect(selector(null, null)("x", "y", "z"), "null-null-x-y-z");
    expect(selector(null, null)("x", "y", "z"), "null-null-x-y-z");
    expect(calls, 8);
  });

  test('cache3states: Calls the function only once per states, and forgets when any state changes.',
      () {
    //
    var calls = 0;
    var selector = cache3states((String? s1, int? s2, bool? s3) => () {
          calls++;
          return (s3 == null) ? null : "$s1-$s2-$s3";
        });

    expect(selector("A", 1, true)(), "A-1-true");
    expect(selector("A", 1, true)(), "A-1-true");
    expect(calls, 1);

    expect(selector("B", 1, true)(), "B-1-true");
    expect(calls, 2);

    expect(selector("B", 2, true)(), "B-2-true");
    expect(calls, 3);

    expect(selector("B", 2, false)(), "B-2-false");
    expect(selector("B", 2, false)(), "B-2-false");
    expect(calls, 4);

    // Only the last states are remembered.
    expect(selector("A", 1, true)(), "A-1-true");
    expect(calls, 5);

    // Null states and null results.
    expect(selector(null, null, null)(), isNull);
    expect(selector(null, null, null)(), isNull);
    expect(calls, 6);

    expect(selector("A", null, true)(), "A-null-true");
    expect(selector("A", null, true)(), "A-null-true");
    expect(calls, 7);
  });

  test(
      'cache1state_0params_x: The extra information is passed to the function, '
      'but does not affect the cache.', () {
    //
    var calls = 0;
    var selector = cache1state_0params_x((String? state, String? extra) => () {
          calls++;
          return "$state-$extra";
        });

    expect(selector("A", "x")(), "A-x");
    expect(selector("A", "x")(), "A-x");
    expect(calls, 1);

    // Changing only the extra information returns the cached result,
    // which was calculated with the original extra information.
    expect(selector("A", "y")(), "A-x");
    expect(selector("A", null)(), "A-x");
    expect(calls, 1);

    // Changing the state recalculates, using the current extra information.
    expect(selector("B", "y")(), "B-y");
    expect(calls, 2);
    expect(selector("A", "z")(), "A-z");
    expect(calls, 3);

    // Null states.
    expect(selector(null, null)(), "null-null");
    expect(selector(null, "x")(), "null-null");
    expect(calls, 4);
  });

  test(
      'cache1state_0params_x: Object states are compared by identity, and null results are cached.',
      () {
    //
    var calls = 0;
    var selector = cache1state_0params_x((List<int> state, Object extra) => () {
          calls++;
          return state.isEmpty ? null : List.of(state);
        });

    var state1 = [1];
    var result1 = selector(state1, "x")();
    var result2 = selector(state1, Object())();
    expect(result1, [1]);
    expect(identical(result1, result2), isTrue);
    expect(calls, 1);

    // Equal, but not identical, states are different states.
    var result3 = selector([1], "x")();
    expect(result3, [1]);
    expect(identical(result1, result3), isFalse);
    expect(calls, 2);

    var state2 = <int>[];
    expect(selector(state2, "x")(), isNull);
    expect(selector(state2, "x")(), isNull);
    expect(calls, 3);
  });

  test(
      'cache2states_0params_x: The extra information is passed to the function, '
      'but does not affect the cache.', () {
    //
    var calls = 0;
    var selector = cache2states_0params_x((String? s1, int? s2, String? extra) => () {
          calls++;
          return (extra == null) ? null : "$s1-$s2-$extra";
        });

    expect(selector("A", 1, "x")(), "A-1-x");
    expect(selector("A", 1, "x")(), "A-1-x");
    expect(calls, 1);

    // Changing only the extra information returns the cached result.
    expect(selector("A", 1, "y")(), "A-1-x");
    expect(selector("A", 1, null)(), "A-1-x");
    expect(calls, 1);

    // Changing only the first state recalculates, using the current extra.
    expect(selector("B", 1, "y")(), "B-1-y");
    expect(calls, 2);

    // Changing only the second state recalculates, using the current extra.
    expect(selector("B", 2, "z")(), "B-2-z");
    expect(calls, 3);

    // Only the last states are remembered.
    expect(selector("A", 1, "x")(), "A-1-x");
    expect(calls, 4);

    // Null states and null results.
    expect(selector(null, null, null)(), isNull);
    expect(selector(null, null, "x")(), isNull);
    expect(calls, 5);
  });

  test(
      'cache3states_0params_x: The extra information is passed to the function, '
      'but does not affect the cache.', () {
    //
    var calls = 0;
    var selector = cache3states_0params_x((String? s1, int? s2, bool? s3, String? extra) => () {
          calls++;
          return (extra == null) ? null : "$s1-$s2-$s3-$extra";
        });

    expect(selector("A", 1, true, "x")(), "A-1-true-x");
    expect(selector("A", 1, true, "x")(), "A-1-true-x");
    expect(calls, 1);

    // Changing only the extra information returns the cached result.
    expect(selector("A", 1, true, "y")(), "A-1-true-x");
    expect(selector("A", 1, true, null)(), "A-1-true-x");
    expect(calls, 1);

    // Changing only the first state recalculates, using the current extra.
    expect(selector("B", 1, true, "y")(), "B-1-true-y");
    expect(calls, 2);

    // Changing only the second state recalculates, using the current extra.
    expect(selector("B", 2, true, "z")(), "B-2-true-z");
    expect(calls, 3);

    // Changing only the third state recalculates, using the current extra.
    expect(selector("B", 2, false, "w")(), "B-2-false-w");
    expect(selector("B", 2, false, "x")(), "B-2-false-w");
    expect(calls, 4);

    // Only the last states are remembered.
    expect(selector("A", 1, true, "x")(), "A-1-true-x");
    expect(calls, 5);

    // Null states and null results.
    expect(selector(null, null, null, null)(), isNull);
    expect(selector(null, null, null, "x")(), isNull);
    expect(calls, 6);
  });

  test('The states are passed to the function in the correct order.', () {
    //
    expect(cache2states((String a, String b) => () => "$a$b")("A", "B")(), "AB");
    expect(
        cache2states_1param((String a, String b) => (String p) => "$a$b$p")("A", "B")("p"), "ABp");
    expect(
        cache2states_2params((String a, String b) => (String p, String q) => "$a$b$p$q")("A", "B")(
            "p", "q"),
        "ABpq");
    expect(
        cache2states_3params((String a, String b) =>
            (String p, String q, String r) => "$a$b$p$q$r")("A", "B")("p", "q", "r"),
        "ABpqr");
    expect(cache3states((String a, String b, String c) => () => "$a$b$c")("A", "B", "C")(), "ABC");
    expect(
        cache2states_0params_x((String a, String b, String x) => () => "$a$b$x")("A", "B", "x")(),
        "ABx");
    expect(
        cache3states_0params_x((String a, String b, String c, String x) => () => "$a$b$c$x")(
            "A", "B", "C", "x")(),
        "ABCx");
  });

  test('Different caches are independent from each other.', () {
    //
    var calls1 = 0;
    var calls2 = 0;
    var selector1 = cache1state((String state) => () => ++calls1);
    var selector2 = cache1state((String state) => () => ++calls2);

    expect(selector1("A")(), 1);
    expect(selector2("A")(), 1);
    expect(selector1("B")(), 2);
    expect(selector2("A")(), 1);
    expect(calls1, 2);
    expect(calls2, 1);
  });

  test('cache1state_2params: Parameters are compared by equality, not identity.', () {
    //
    var calls = 0;
    var selector = cache1state_2params((Object state) => (Object p1, Object p2) {
          calls++;
          return [p1, p2];
        });

    var state = Object();
    var result1 = selector(state)(_Value(1), (1, ["x"].join()));
    var result2 = selector(state)(_Value(1), (1, ["x"].join()));
    expect(identical(result1, result2), isTrue);
    expect(calls, 1);

    selector(state)(_Value(2), (1, "x"));
    selector(state)(_Value(1), (2, "x"));
    expect(calls, 3);
  });

  test('cache2states_2params: Parameters are compared by equality, not identity.', () {
    //
    var calls = 0;
    var selector = cache2states_2params((Object s1, Object s2) => (Object p1, Object p2) {
          calls++;
          return [p1, p2];
        });

    var s1 = Object();
    var s2 = Object();
    var result1 = selector(s1, s2)(_Value(1), (1, ["x"].join()));
    var result2 = selector(s1, s2)(_Value(1), (1, ["x"].join()));
    expect(identical(result1, result2), isTrue);
    expect(calls, 1);

    selector(s1, s2)(_Value(2), (1, "x"));
    selector(s1, s2)(_Value(1), (2, "x"));
    expect(calls, 3);
  });

  test('cache2states_3params: Parameters are compared by equality, not identity.', () {
    //
    var calls = 0;
    var selector =
        cache2states_3params((Object s1, Object s2) => (Object p1, Object p2, Object? p3) {
              calls++;
              return [p1, p2, p3];
            });

    var s1 = Object();
    var s2 = Object();
    var result1 = selector(s1, s2)(_Value(1), (1, ["x"].join()), null);
    var result2 = selector(s1, s2)(_Value(1), (1, ["x"].join()), null);
    expect(identical(result1, result2), isTrue);
    expect(calls, 1);

    selector(s1, s2)(_Value(2), (1, "x"), null);
    selector(s1, s2)(_Value(1), (2, "x"), null);
    selector(s1, s2)(_Value(1), (1, "x"), _Value(1));
    expect(calls, 4);
  });

  test('Parameters that are equal but of different types (1 and 1.0) are the same parameter.', () {
    // This is the same behavior as a regular Dart map.
    var calls = 0;
    var selector = cache1state_1param((Object state) => (num param) {
          calls++;
          return [param];
        });

    var state = Object();
    var result1 = selector(state)(1);
    var result2 = selector(state)(1.0);
    expect(identical(result1, result2), isTrue);
    expect(calls, 1);
  });

  test('A cached function can call itself with other parameters (re-entrancy).', () {
    //
    // Each cache calculates Fibonacci numbers recursively, by calling itself.
    var calls = 0;
    late int Function(int) fib;
    int calc(int n) {
      calls++;
      return (n < 2) ? n : fib(n - 1) + fib(n - 2);
    }

    var state1 = Object();
    var state2 = "state";

    var c1 = cache1state_1param((Object s) => (int n) => calc(n));
    var c2 = cache1state_2params((Object s) => (int n, int unused) => calc(n));
    var c3 = cache2states_1param((Object s1, String s2) => (int n) => calc(n));
    var c4 = cache2states_2params((Object s1, String s2) => (int n, int unused) => calc(n));
    var c5 = cache2states_3params(
        (Object s1, String s2) => (int n, int unused1, int unused2) => calc(n));

    var fibs = <String, int Function(int)>{
      'cache1state_1param': (n) => c1(state1)(n),
      'cache1state_2params': (n) => c2(state1)(n, 0),
      'cache2states_1param': (n) => c3(state1, state2)(n),
      'cache2states_2params': (n) => c4(state1, state2)(n, 0),
      'cache2states_3params': (n) => c5(state1, state2)(n, 0, 0),
    };

    for (var entry in fibs.entries) {
      calls = 0;
      fib = entry.value;
      expect(fib(30), 832040, reason: entry.key);
      // Each value of n is calculated only once.
      expect(calls, 31, reason: entry.key);

      // And all of them stay cached.
      expect(fib(30), 832040, reason: entry.key);
      expect(fib(15), 610, reason: entry.key);
      expect(calls, 31, reason: entry.key);
    }
  });

  test('The cached function is not called until the returned function is called.', () {
    //
    var calls = 0;
    var selector = cache2states_1param((String s1, String s2) {
      calls++;
      return (int p) => "$s1$s2$p";
    });

    var function = selector("A", "B");
    expect(calls, 0);
    expect(function(1), "AB1");
    expect(calls, 1);
  });

  group('All cache functions.', () {
    //
    for (var cacheCase in _cacheCases) {
      var name = cacheCase.name;
      var n = cacheCase.numberOfStates;

      test('$name: With the same states, calculates only once and returns the same result.', () {
        var calls = 0;
        var call = cacheCase.create(onCall: () => calls++);
        var states = [for (var i = 0; i < n; i++) Object()];

        var result1 = call(states);
        var result2 = call(states);
        var result3 = call(List.of(states)); // Another list, with the same states.
        expect(result1, _expectedResult(cacheCase, states));
        expect(identical(result1, result2), isTrue);
        expect(identical(result1, result3), isTrue);
        expect(calls, 1);
      });

      for (var index = 0; index < n; index++) {
        //
        test(
            '$name: Changing state ${index + 1} recalculates, '
            'and only the last states are remembered.', () {
          var calls = 0;
          var call = cacheCase.create(onCall: () => calls++);
          var states = [for (var i = 0; i < n; i++) Object()];
          var otherStates = _replace(states, index, Object());

          var result1 = call(states);
          var result2 = call(otherStates);
          expect(result2, _expectedResult(cacheCase, otherStates));
          expect(calls, 2);

          // Going back to the previous states recalculates.
          var result3 = call(states);
          expect(result3, _expectedResult(cacheCase, states));
          expect(identical(result1, result3), isFalse);
          expect(calls, 3);
        });

        test('$name: State ${index + 1} is compared by identity, if it is an object.', () {
          var calls = 0;
          var call = cacheCase.create(onCall: () => calls++);
          var states = _replace([for (var i = 0; i < n; i++) Object()], index, _Value(1));
          var equalStates = _replace(states, index, _Value(1));
          expect(equalStates, states);

          call(states);
          call(equalStates);
          expect(calls, 2);
          call(equalStates);
          expect(calls, 2);
        });

        test(
            '$name: State ${index + 1} is compared by equality, '
            'if it is a String, number, boolean, record or null.', () {
          var calls = 0;
          var call = cacheCase.create(onCall: () => calls++);
          var objects = [for (var i = 0; i < n; i++) Object()];

          // Each value is created again for each call, so that it's equal,
          // but not necessarily identical.
          var values = <Object? Function()>[
            () => ["A", "B"].join(),
            () => int.parse("123"),
            () => double.parse("1.5"),
            () => bool.parse("true"),
            () => (int.parse("1"), ["x"].join()),
            () => (name: ["x"].join(), age: int.parse("3")),
            () => null,
          ];

          var expectedCalls = 0;
          for (var value in values) {
            var result1 = call(_replace(objects, index, value()));
            var result2 = call(_replace(objects, index, value()));
            expectedCalls++;
            expect(calls, expectedCalls, reason: "Value: ${value()}");
            expect(identical(result1, result2), isTrue);
            expect(result1, _expectedResult(cacheCase, _replace(objects, index, value())));
          }
        });

        test('$name: State ${index + 1} can change between objects and values.', () {
          var calls = 0;
          var call = cacheCase.create(onCall: () => calls++);
          var objects = [for (var i = 0; i < n; i++) Object()];
          var obj = Object();

          var sequence = <Object?>[obj, "A", null, obj, 1, obj, (1, 2), null, "A"];
          for (var i = 0; i < sequence.length; i++) {
            var states = _replace(objects, index, sequence[i]);
            expect(call(states), _expectedResult(cacheCase, states));
            expect(call(states), _expectedResult(cacheCase, states));
            expect(calls, i + 1);
          }
        });
      }

      if (n > 1) {
        test('$name: The same object can be used as more than one state.', () {
          var calls = 0;
          var call = cacheCase.create(onCall: () => calls++);
          var obj = Object();
          var states = [for (var i = 0; i < n; i++) obj];

          expect(call(states), _expectedResult(cacheCase, states));
          expect(call(states), _expectedResult(cacheCase, states));
          expect(calls, 1);

          // Using another object in one of the positions is a change.
          var otherStates = _replace(states, n - 1, Object());
          expect(call(otherStates), _expectedResult(cacheCase, otherStates));
          expect(calls, 2);
        });
      }

      if (cacheCase.hasParams) {
        test('$name: While the states are the same, the results for all parameters are kept.',
            () {
          var calls = 0;
          var call = cacheCase.create(onCall: () => calls++);
          var states = [for (var i = 0; i < n; i++) Object()];

          var results = [for (var p = 0; p < 5; p++) call(states, p)];
          expect(calls, 5);
          for (var p = 0; p < 5; p++) {
            expect(results[p], _expectedResult(cacheCase, states, p));
            expect(identical(call(states, p), results[p]), isTrue);
          }
          expect(calls, 5);

          // Changing the states forgets the results for all parameters.
          var otherStates = [for (var i = 0; i < n; i++) Object()];
          call(otherStates, 0);
          expect(calls, 6);
          for (var p = 0; p < 5; p++) {
            expect(identical(call(states, p), results[p]), isFalse);
          }
        });
      }

      test(
          '$name: If the function throws, the error is propagated, '
          'and the next call recalculates.', () {
        var calls = 0;
        var shouldThrow = true;
        var call = cacheCase.create(onCall: () {
          calls++;
          if (shouldThrow) throw StateError("Failed");
        });
        var states = [for (var i = 0; i < n; i++) Object()];

        // Throws on the first call.
        expect(() => call(states), throwsStateError);
        expect(calls, 1);

        // The next call with the same states recalculates, and then caches.
        shouldThrow = false;
        expect(call(states), _expectedResult(cacheCase, states));
        expect(call(states), _expectedResult(cacheCase, states));
        expect(calls, 2);
      });

      for (var index = 0; index < n; index++) {
        //
        test(
            '$name: If the function throws after state ${index + 1} changes, '
            'the next call recalculates with the new states.', () {
          var calls = 0;
          var shouldThrow = false;
          var call = cacheCase.create(onCall: () {
            calls++;
            if (shouldThrow) throw StateError("Failed");
          });

          // The new state may be an object or a value.
          for (var value in <Object? Function()>[() => Object(), () => "A", () => null]) {
            calls = 0;
            var states = [for (var i = 0; i < n; i++) Object()];
            var otherStates = _replace(states, index, value());

            shouldThrow = false;
            expect(call(states), _expectedResult(cacheCase, states));

            // Fails with the new states.
            shouldThrow = true;
            expect(() => call(otherStates), throwsStateError);

            // The next call with the new states recalculates, and then caches.
            shouldThrow = false;
            expect(call(otherStates), _expectedResult(cacheCase, otherStates));
            expect(call(otherStates), _expectedResult(cacheCase, otherStates));
            expect(calls, 3);

            // The previous states work too.
            expect(call(states), _expectedResult(cacheCase, states));
          }
        });
      }
    }
  });

  group('Garbage-collection.', () {
    //
    for (var cacheCase in _cacheCases) {
      var name = cacheCase.name;
      var n = cacheCase.numberOfStates;

      test(
          '$name: The cache does not prevent the garbage-collection '
          'of the states, nor of the cached result.', () {
        var call = cacheCase.create();
        var refs = _callWithNewStates(call, n, keep: {});
        for (var ref in refs) {
          expect(isGarbageCollected(ref), isTrue);
        }

        // The cache still works afterwards.
        expect(call(["A", "B", "C"]), isNotNull);
      });

      for (var dropped = 0; dropped < n; dropped++) {
        //
        test(
            '$name: When state ${dropped + 1} is no longer used, it and the cached result '
            'are garbage-collected, even if the other states are objects still in use.', () {
          var call = cacheCase.create();
          var keep = {
            for (var i = 0; i < n; i++)
              if (i != dropped) i: Object()
          };
          var refs = _callWithNewStates(call, n, keep: keep);
          for (var ref in refs) {
            expect(isGarbageCollected(ref), isTrue);
          }
          expect(keep, hasLength(n - 1));
        });

        test(
            '$name: When state ${dropped + 1} is no longer used, it and the cached result '
            'are garbage-collected, even if the other states are numbers or Strings.', () {
          var call = cacheCase.create();
          var keep = <int, Object>{
            for (var i = 0; i < n; i++)
              if (i != dropped) i: (i.isEven ? 42 : "A")
          };
          var refs = _callWithNewStates(call, n, keep: keep);
          for (var ref in refs) {
            expect(isGarbageCollected(ref), isTrue);
          }
        });
      }

      test(
          '$name: When the states change, the previous cached result is garbage-collected, '
          'even if the previous states are still in use.', () {
        var call = cacheCase.create();
        var states = [for (var i = 0; i < n; i++) Object()];
        var resultRef = _callAndGetWeakResult(call, states);

        call([for (var i = 0; i < n; i++) Object()]);
        expect(isGarbageCollected(resultRef), isTrue);
        expect(states, hasLength(n));
      });

      test(
          '$name: When the cache itself is no longer used, the cached result is '
          'garbage-collected, even if the states are still in use.', () {
        var states = [for (var i = 0; i < n; i++) Object()];
        var resultRef = _callDroppedCache(cacheCase, states);
        expect(isGarbageCollected(resultRef), isTrue);
        expect(states, hasLength(n));
      });

      if (cacheCase.hasParams) {
        test(
            '$name: While the states are in use, the results for all parameters '
            'are not garbage-collected.', () {
          var call = cacheCase.create();
          var states = [for (var i = 0; i < n; i++) Object()];
          var refs = [for (var p = 0; p < 3; p++) _callAndGetWeakResult(call, states, p)];
          for (var p = 0; p < 3; p++) {
            expect(isGarbageCollected(refs[p], maxRounds: 200), isFalse);
            expect(identical(call(states, p), refs[p].target), isTrue);
          }
        });

        test(
            '$name: When the states change, the results for all parameters are '
            'garbage-collected, even if the previous states are still in use.', () {
          var call = cacheCase.create();
          var states = [for (var i = 0; i < n; i++) Object()];
          var refs = [for (var p = 0; p < 3; p++) _callAndGetWeakResult(call, states, p)];

          call([for (var i = 0; i < n; i++) Object()]);
          for (var ref in refs) {
            expect(isGarbageCollected(ref), isTrue);
          }
          expect(states, hasLength(n));
        });
      }

      test('$name: While the states are in use, the cached result is not garbage-collected.', () {
        var call = cacheCase.create();
        var states = [for (var i = 0; i < n; i++) Object()];
        var resultRef = _callAndGetWeakResult(call, states);
        expect(isGarbageCollected(resultRef, maxRounds: 200), isFalse);
        expect(identical(call(states), resultRef.target), isTrue);
      });
    }

    test('The extra information is not kept alive by the cache.', () {
      var state1 = Object();
      var state2 = Object();
      var state3 = Object();

      var cache1 = cache1state_0params_x((Object s1, Object x) => () => [s1]);
      var cache2 = cache2states_0params_x((Object s1, Object s2, Object x) => () => [s1, s2]);
      var cache3 = cache3states_0params_x(
          (Object s1, Object s2, Object s3, Object x) => () => [s1, s2, s3]);

      // The extra information used to calculate the result.
      var ref1 = _callWithNewExtra((x) => cache1(state1, x)());
      var ref2 = _callWithNewExtra((x) => cache2(state1, state2, x)());
      var ref3 = _callWithNewExtra((x) => cache3(state1, state2, state3, x)());

      // The extra information used when the result was read from the cache.
      var ref4 = _callWithNewExtra((x) => cache1(state1, x)());
      var ref5 = _callWithNewExtra((x) => cache2(state1, state2, x)());
      var ref6 = _callWithNewExtra((x) => cache3(state1, state2, state3, x)());

      for (var ref in [ref1, ref2, ref3, ref4, ref5, ref6]) {
        expect(isGarbageCollected(ref), isTrue);
      }
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

/// Calls a cached function with the given states (and with the given [param],
/// for the cache functions that have parameters), and returns its result.
typedef _CachedCall = Object Function(List<Object?> states, [int param]);

class _CacheCase {
  final String name;
  final int numberOfStates;
  final bool hasParams;

  /// Creates a new cache. The cached result is a new list that contains all the
  /// states, followed by all the parameters (if any). The optional [onCall] is
  /// called each time the result is actually calculated (not read from the cache).
  final _CachedCall Function({void Function()? onCall}) create;

  _CacheCase(this.name, this.numberOfStates, this.create, {this.hasParams = false});
}

final _cacheCases = [
  _CacheCase('cache1state', 1, ({onCall}) {
    var cache = cache1state((Object? s1) => () {
          onCall?.call();
          return [s1];
        });
    return (s, [p = 1]) => cache(s[0])();
  }),
  _CacheCase('cache1state_1param', 1, hasParams: true, ({onCall}) {
    var cache = cache1state_1param((Object? s1) => (int p1) {
          onCall?.call();
          return [s1, p1];
        });
    return (s, [p = 1]) => cache(s[0])(p);
  }),
  _CacheCase('cache1state_2params', 1, hasParams: true, ({onCall}) {
    var cache = cache1state_2params((Object? s1) => (int p1, int p2) {
          onCall?.call();
          return [s1, p1, p2];
        });
    return (s, [p = 1]) => cache(s[0])(p, p + 1);
  }),
  _CacheCase('cache2states', 2, ({onCall}) {
    var cache = cache2states((Object? s1, Object? s2) => () {
          onCall?.call();
          return [s1, s2];
        });
    return (s, [p = 1]) => cache(s[0], s[1])();
  }),
  _CacheCase('cache2states_1param', 2, hasParams: true, ({onCall}) {
    var cache = cache2states_1param((Object? s1, Object? s2) => (int p1) {
          onCall?.call();
          return [s1, s2, p1];
        });
    return (s, [p = 1]) => cache(s[0], s[1])(p);
  }),
  _CacheCase('cache2states_2params', 2, hasParams: true, ({onCall}) {
    var cache = cache2states_2params((Object? s1, Object? s2) => (int p1, int p2) {
          onCall?.call();
          return [s1, s2, p1, p2];
        });
    return (s, [p = 1]) => cache(s[0], s[1])(p, p + 1);
  }),
  _CacheCase('cache2states_3params', 2, hasParams: true, ({onCall}) {
    var cache = cache2states_3params((Object? s1, Object? s2) => (int p1, int p2, int p3) {
          onCall?.call();
          return [s1, s2, p1, p2, p3];
        });
    return (s, [p = 1]) => cache(s[0], s[1])(p, p + 1, p + 2);
  }),
  _CacheCase('cache3states', 3, ({onCall}) {
    var cache = cache3states((Object? s1, Object? s2, Object? s3) => () {
          onCall?.call();
          return [s1, s2, s3];
        });
    return (s, [p = 1]) => cache(s[0], s[1], s[2])();
  }),
  _CacheCase('cache1state_0params_x', 1, ({onCall}) {
    var cache = cache1state_0params_x((Object? s1, String x) => () {
          onCall?.call();
          return [s1];
        });
    return (s, [p = 1]) => cache(s[0], "x")();
  }),
  _CacheCase('cache2states_0params_x', 2, ({onCall}) {
    var cache = cache2states_0params_x((Object? s1, Object? s2, String x) => () {
          onCall?.call();
          return [s1, s2];
        });
    return (s, [p = 1]) => cache(s[0], s[1], "x")();
  }),
  _CacheCase('cache3states_0params_x', 3, ({onCall}) {
    var cache = cache3states_0params_x((Object? s1, Object? s2, Object? s3, String x) => () {
          onCall?.call();
          return [s1, s2, s3];
        });
    return (s, [p = 1]) => cache(s[0], s[1], s[2], "x")();
  }),
];

/// The result the cache functions in [_cacheCases] are expected to return.
List<Object?> _expectedResult(_CacheCase cacheCase, List<Object?> states, [int param = 1]) {
  var numberOfParams = switch (cacheCase.name) {
    'cache1state_1param' || 'cache2states_1param' => 1,
    'cache1state_2params' || 'cache2states_2params' => 2,
    'cache2states_3params' => 3,
    _ => 0,
  };
  return [...states, for (var i = 0; i < numberOfParams; i++) param + i];
}

/// Returns a copy of [states], where the state at [index] is replaced by [value].
List<Object?> _replace(List<Object?> states, int index, Object? value) =>
    [for (var i = 0; i < states.length; i++) (i == index) ? value : states[i]];

/// Calls the cached function with [numberOfStates] states. The states in [keep]
/// (indexed by their position) are used as given, while the others are new
/// objects which are not referenced anywhere else. Returns weak-references to
/// those new states and to the cached result.
List<WeakReference<Object>> _callWithNewStates(
  _CachedCall call,
  int numberOfStates, {
  required Map<int, Object> keep,
}) {
  var states = <Object?>[for (var i = 0; i < numberOfStates; i++) keep[i] ?? Object()];
  var result = call(states);

  // Make sure the result is cached.
  expect(identical(call(states), result), isTrue);

  return [
    for (var i = 0; i < numberOfStates; i++)
      if (!keep.containsKey(i)) WeakReference(states[i]!),
    WeakReference(result),
  ];
}

/// Calls the cached function with the given states (and [param]),
/// and returns a weak-reference to the cached result.
WeakReference<Object> _callAndGetWeakResult(_CachedCall call, List<Object?> states,
    [int param = 1]) {
  var result = call(states, param);
  expect(identical(call(states, param), result), isTrue);
  return WeakReference(result);
}

/// Creates a new cache, calls it with the given states, and then drops the
/// cache. Returns a weak-reference to the result.
WeakReference<Object> _callDroppedCache(_CacheCase cacheCase, List<Object?> states) {
  var call = cacheCase.create();
  return _callAndGetWeakResult(call, states);
}

/// Calls [call] with some new extra information which is not referenced
/// anywhere else, and returns a weak-reference to that extra information.
WeakReference<Object> _callWithNewExtra(void Function(Object extra) call) {
  var extra = Object();
  call(extra);
  return WeakReference(extra);
}
