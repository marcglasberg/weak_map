import 'dart:collection';
import 'package:weak_map/weak_map.dart';

// /////////////////////////////////////////////////////////////////////////////

typedef R1_0<Result> = Result Function();
typedef F1_0<Result, State1> = R1_0<Result> Function(State1);

/// Cache for 1 immutable state, and no parameters.
F1_0<Result?, State1> cache1_0<Result, State1>(F1_0<Result, State1> f) {
  WeakContainer? _s1;
  late WeakMap<State1, Result> weakMap;

  return (State1 s1) {
    return () {
      if (_s1 == null || !_s1!.contains(s1)) {
        weakMap = WeakMap();
        _s1 = WeakContainer(s1);
        var result = f(s1)();
        weakMap[s1] = result;
        return result;
      }
      //
      else {
        return weakMap[s1];
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

typedef R1_1<Result, Param1> = Result Function(Param1);
typedef F1_1<Result, State1, Param1> = R1_1<Result, Param1> Function(State1);

/// Cache for 1 immutable state, and 1 parameter.
F1_1<Result?, State1, Param1> cache1_1<Result, State1, Param1>(
  F1_1<Result, State1, Param1> f,
) {
  WeakContainer? _s1;
  late WeakMap<State1, Map<Param1, Result>> weakMap;

  return (State1 s1) {
    return (Param1 p1) {
      if (_s1 == null || !_s1!.contains(s1)) {
        weakMap = WeakMap();
        Map<Param1, Result> map = HashMap();
        weakMap[s1] = map;
        _s1 = WeakContainer(s1);
        var result = f(s1)(p1);
        map[p1] = result;
        return result;
      }
      //
      else {
        Map<Param1, Result> map = weakMap[s1]!;
        if (!map.containsKey(p1)) {
          var result = f(s1)(p1);
          map[p1] = result;
          return result;
        }
        //
        else
          return map[p1];
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

typedef R1_2<Result, Param1, Param2> = //
    Result Function(Param1, Param2);

typedef F1_2<Result, State1, Param1, Param2> = //
    R1_2<Result, Param1, Param2> Function(State1);

/// Cache for 1 immutable state, and 2 parameters.
F1_2<Result?, State1, Param1, Param2> cache1_2<Result, State1, Param1, Param2>(
    F1_2<Result, State1, Param1, Param2> f) {
  WeakContainer? _s1;
  late WeakMap<State1, Map<_Pair<Param1, Param2>, Result>> weakMap;

  return (State1 s1) {
    return (Param1 p1, Param2 p2) {
      var parP = _Pair(p1, p2);
      if (_s1 == null || !_s1!.contains(s1)) {
        weakMap = WeakMap();
        Map<_Pair<Param1, Param2>, Result> map = HashMap();
        weakMap[s1] = map;
        _s1 = WeakContainer(s1);
        var result = f(s1)(p1, p2);
        map[parP] = result;
        return result;
      }
      //
      else {
        Map<_Pair<Param1, Param2>, Result> map = weakMap[s1]!;
        if (!map.containsKey(parP)) {
          var result = f(s1)(p1, p2);
          map[parP] = result;
          return result;
        }
        return map[parP];
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

typedef R2_0<Result> = Result Function();
typedef F2_0<Result, State1, State2> = R2_0<Result> Function(State1, State2);

/// Cache for 2 immutable states, and no parameters.
F2_0<Result?, State1, State2> cache2_0<Result, State1, State2>(
  F2_0<Result, State1, State2> f,
) {
  WeakContainer? _s1, _s2;
  late WeakMap<State1, WeakMap<State2, Result>> weakMap1;
  WeakMap<State2, Result> weakMap2;

  return (State1 s1, State2 s2) {
    return () {
      if (_s1 == null ||
          _s2 == null || //
          !_s1!.contains(s1) ||
          !_s2!.contains(s2)) {
        _s1 = WeakContainer(s1);
        _s2 = WeakContainer(s2);

        var result = f(s1, s2)();
        weakMap1 = WeakMap();
        weakMap2 = WeakMap();
        weakMap2[s2] = result;
        weakMap1[s1] = weakMap2;
        return result;
      }
      //
      else {
        return weakMap1[s1]![s2];
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

typedef R2_1<Result, Param1> = Result Function(Param1);
typedef F2_1<Result, State1, State2, Param1> = R2_1<Result, Param1> Function(
  State1,
  State2,
);

/// Cache for 2 immutable states, and 1 parameter.
F2_1<Result?, State1, State2, Param1> cache2_1<Result, State1, State2, Param1>(
    F2_1<Result, State1, State2, Param1> f) {
  WeakContainer? _s1, _s2;
  late WeakMap<State1, WeakMap<State2, Map<Param1, Result>>> weakMap1;
  WeakMap<State2, Map<Param1, Result>> weakMap2;

  return (State1 s1, State2 s2) {
    return (Param1 p1) {
      if (_s1 == null ||
          _s2 == null || //
          !_s1!.contains(s1) ||
          !_s2!.contains(s2)) {
        _s1 = WeakContainer(s1);
        _s2 = WeakContainer(s2);

        var result = f(s1, s2)(p1);
        weakMap1 = WeakMap();
        weakMap2 = WeakMap();
        Map<Param1, Result> map = HashMap();
        map[p1] = result;
        weakMap2[s2] = map;
        weakMap1[s1] = weakMap2;
        return result;
      }
      //
      else {
        Map<Param1, Result> map = weakMap1[s1]![s2]!;
        if (!map.containsKey(p1)) {
          var result = f(s1, s2)(p1);
          map[p1] = result;
          return result;
        }

        return map[p1];
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

typedef R2_2<Result, Param1, Param2> = //
    Result Function(Param1, Param2);

typedef F2_2<Result, State1, State2, Param1, Param2> = //
    R2_2<Result, Param1, Param2> Function(State1, State2);

/// Cache for 2 immutable states, and 2 parameters.
F2_2<Result?, State1, State2, Param1, Param2> //
    cache2_2<Result, State1, State2, Param1, Param2>(
        F2_2<Result, State1, State2, Param1, Param2> f) {
  WeakContainer? _s1, _s2;
  late WeakMap<State1, WeakMap<State2, Map<_Pair<Param1, Param2>, Result>>> weakMap1;
  WeakMap<State2, Map<_Pair<Param1, Param2>, Result>> weakMap2;

  return (State1 s1, State2 s2) {
    return (Param1 p1, Param2 p2) {
      var par = _Pair(p1, p2);
      if (_s1 == null || !_s1!.contains(s1) || !_s2!.contains(s2)) {
        _s1 = WeakContainer(s1);
        _s2 = WeakContainer(s2);

        var result = f(s1, s2)(p1, p2);
        weakMap1 = WeakMap();
        weakMap2 = WeakMap();
        Map<_Pair<Param1, Param2>, Result> map = HashMap();
        map[par] = result;
        weakMap2[s2] = map;
        weakMap1[s1] = weakMap2;
        return result;
      }
      //
      else {
        Map<_Pair<Param1, Param2>, Result> map = weakMap1[s1]![s2]!;
        if (!map.containsKey(par)) {
          var result = f(s1, s2)(p1, p2);
          map[par] = result;
          return result;
        }

        return map[par];
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

typedef R3_0<Result> = //
    Result Function();

typedef F3_0<Result, State1, State2, State3> = //
    R3_0<Result> Function(State1, State2, State3);

/// Cache for 3 immutable states, and no parameters.
F3_0<Result?, State1, State2, State3> cache3_0<Result, State1, State2, State3>(
    F3_0<Result, State1, State2, State3> f) {
  WeakContainer? _s1, _s2, _s3;
  late WeakMap<State1, WeakMap<State2, WeakMap<State3, Result>>> weakMap1;
  WeakMap<State2, WeakMap<State3, Result>> weakMap2;
  WeakMap<State3, Result> weakMap3;

  return (State1 s1, State2 s2, State3 s3) {
    return () {
      if (_s1 == null ||
          _s2 == null ||
          _s3 == null || //
          !_s1!.contains(s1) ||
          !_s2!.contains(s2) ||
          !_s3!.contains(s3)) {
        _s1 = WeakContainer(s1);
        _s2 = WeakContainer(s2);
        _s3 = WeakContainer(s3);

        var result = f(s1, s2, s3)();
        weakMap1 = WeakMap();
        weakMap2 = WeakMap();
        weakMap3 = WeakMap();
        weakMap3[s3] = result;
        weakMap2[s2] = weakMap3;
        weakMap1[s1] = weakMap2;
        return result;
      }
      //
      else {
        return weakMap1[s1]![s2]![s3];
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

class _Pair<X, Y> {
  final X x;
  final Y y;

  _Pair(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Pair &&
          runtimeType == other.runtimeType //
          &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

// /////////////////////////////////////////////////////////////////////////////
