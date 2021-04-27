import 'package:test/test.dart';
import 'package:weak_map/weak_map.dart';

void main() {
  var stateNames = List<String>.unmodifiable(["Juan", "Anna", "Bill", "Zack", "Arnold", "Amanda"]);

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  ////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  ////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test 1 state with 2 parameters.', () {
    //
    var selector =
        cache1state_2params((List<String> state) => (String startString, String endString) {
              return state
                  .where((str) => str.startsWith(startString) && str.endsWith(endString))
                  .toList();
            });

    // TODO: MARCELO: Refazer este teste.
    // Originalmente era: expect(identical("a", otherA), isFalse);
    // With no other changes except
    // flutter channel stable 1.22.5 => flutter channel beta  1.24.0-10.2.pre
    // (Dart version 2.10.4)         => (Dart version 2.12.0 (build 2.12.0-29.10.beta))
    // suddenly this isTrue
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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Changing the second or the first state, it should forget the cached value.', () {
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

  //////////////////////////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////////////////////////
}
