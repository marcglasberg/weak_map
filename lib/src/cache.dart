import 'dart:collection';

import 'package:weak_map/weak_map.dart';

// /////////////////////////////////////////////////////////////////////////////

typedef R1_0<Result> = Result Function();
typedef F1_0<Result, State1> = R1_0<Result> Function(State1);

/// Cache for 1 immutable state, and no parameters.
F1_0<Result, State1> cache1state<Result, State1>(F1_0<Result, State1> f) {
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
        return weakMap[s1] as Result;
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

typedef R1_1<Result, Param1> = Result Function(Param1);
typedef F1_1<Result, State1, Param1> = R1_1<Result, Param1> Function(State1);

/// Cache for 1 immutable state, and 1 parameter.
F1_1<Result, State1, Param1> cache1state_1param<Result, State1, Param1>(
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
          return map[p1] as Result;
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
F1_2<Result, State1, Param1, Param2> cache1state_2params<Result, State1, Param1, Param2>(
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
        return map[parP] as Result;
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

typedef R2_0<Result> = Result Function();
typedef F2_0<Result, State1, State2> = R2_0<Result> Function(State1, State2);

/// Cache for 2 immutable states, and no parameters.
F2_0<Result, State1, State2> cache2states<Result, State1, State2>(
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
        return weakMap1[s1]![s2] as Result;
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
F2_1<Result, State1, State2, Param1> cache2states_1param<Result, State1, State2, Param1>(
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

        return map[p1] as Result;
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
F2_2<Result, State1, State2, Param1, Param2> //
    cache2states_2params<Result, State1, State2, Param1, Param2>(
        F2_2<Result, State1, State2, Param1, Param2> f) {
  WeakContainer? _s1, _s2;
  late WeakMap<State1, WeakMap<State2, Map<_Pair<Param1, Param2>, Result>>> weakMap1;
  WeakMap<State2, Map<_Pair<Param1, Param2>, Result>> weakMap2;

  return (State1 s1, State2 s2) {
    return (Param1 p1, Param2 p2) {
      var pair = _Pair(p1, p2);
      if (_s1 == null || !_s1!.contains(s1) || !_s2!.contains(s2)) {
        _s1 = WeakContainer(s1);
        _s2 = WeakContainer(s2);

        var result = f(s1, s2)(p1, p2);
        weakMap1 = WeakMap();
        weakMap2 = WeakMap();
        Map<_Pair<Param1, Param2>, Result> map = HashMap();
        map[pair] = result;
        weakMap2[s2] = map;
        weakMap1[s1] = weakMap2;
        return result;
      }
      //
      else {
        Map<_Pair<Param1, Param2>, Result> map = weakMap1[s1]![s2]!;
        if (!map.containsKey(pair)) {
          var result = f(s1, s2)(p1, p2);
          map[pair] = result;
          return result;
        }

        return map[pair] as Result;
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

typedef R2_3<Result, Param1, Param2, Param3> = //
    Result Function(Param1, Param2, Param3);

typedef F2_3<Result, State1, State2, Param1, Param2, Param3> = //
    R2_3<Result, Param1, Param2, Param3> Function(State1, State2);

/// Cache for 2 immutable states, and 3 parameters.
F2_3<Result, State1, State2, Param1, Param2, Param3> //
    cache2states_3params<Result, State1, State2, Param1, Param2, Param3>(
        F2_3<Result, State1, State2, Param1, Param2, Param3> f) {
  WeakContainer? _s1, _s2;
  late WeakMap<State1, WeakMap<State2, Map<_Triad<Param1, Param2, Param3>, Result>>> weakMap1;
  WeakMap<State2, Map<_Triad<Param1, Param2, Param3>, Result>> weakMap2;

  return (State1 s1, State2 s2) {
    return (Param1 p1, Param2 p2, Param3 p3) {
      var triad = _Triad(p1, p2, p3);
      if (_s1 == null || !_s1!.contains(s1) || !_s2!.contains(s2)) {
        _s1 = WeakContainer(s1);
        _s2 = WeakContainer(s2);

        var result = f(s1, s2)(p1, p2, p3);
        weakMap1 = WeakMap();
        weakMap2 = WeakMap();
        Map<_Triad<Param1, Param2, Param3>, Result> map = HashMap();
        map[triad] = result;
        weakMap2[s2] = map;
        weakMap1[s1] = weakMap2;
        return result;
      }
      //
      else {
        Map<_Triad<Param1, Param2, Param3>, Result> map = weakMap1[s1]![s2]!;
        if (!map.containsKey(triad)) {
          var result = f(s1, s2)(p1, p2, p3);
          map[triad] = result;
          return result;
        }

        return map[triad] as Result;
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
F3_0<Result, State1, State2, State3> cache3states<Result, State1, State2, State3>(
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
        return weakMap1[s1]![s2]![s3] as Result;
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

typedef F1_0_x<Result, State1, Extra> = R1_0<Result> Function(State1, Extra);

/// Cache for 1 immutable state, no parameters, and some extra information.
/// Note: The extra information is not used in any way to decide whether
/// the cache should be used/recalculated/evicted.
F1_0_x<Result, State1, Extra> cache1state_0params_x<Result, State1, Extra>(
  F1_0_x<Result, State1, Extra> f,
) {
  WeakContainer? _s1;
  late WeakMap<State1, Result> weakMap;

  return (State1 state1, Extra extra) {
    return () {
      if (_s1 == null || !_s1!.contains(state1)) {
        weakMap = WeakMap();
        _s1 = WeakContainer(state1);
        var result = f(state1, extra)();
        weakMap[state1] = result;
        return result;
      }
      //
      else {
        return weakMap[state1] as Result;
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

typedef F2_0_x<Result, State1, State2, Extra> = R2_0<Result> Function(State1, State2, Extra);

/// Cache for 2 immutable states, no parameters, and some extra information.
/// Note: The extra information is not used in any way to decide whether
/// the cache should be used/recalculated/evicted.
F2_0_x<Result, State1, State2, Extra> cache2states_0params_x<Result, State1, State2, Extra>(
  F2_0_x<Result, State1, State2, Extra> f,
) {
  WeakContainer? _s1, _s2;
  late WeakMap<State1, WeakMap<State2, Result>> weakMap1;
  late WeakMap<State2, Result> weakMap2;

  return (State1 state1, State2 state2, Extra extra) {
    return () {
      if (_s1 == null ||
          _s2 == null || //
          !_s1!.contains(state1) ||
          !_s2!.contains(state2)) {
        _s1 = WeakContainer(state1);
        _s2 = WeakContainer(state2);

        var result = f(state1, state2, extra)();
        weakMap1 = WeakMap();
        weakMap2 = WeakMap();
        weakMap2[state2] = result;
        weakMap1[state1] = weakMap2;
        return result;
      }
      //
      else {
        return weakMap1[state1]![state2] as Result;
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////

typedef F3_0_x<Result, State1, State2, State3, Extra> = R3_0<Result> Function(
    State1, State2, State3, Extra);

/// Cache for 3 immutable states, no parameters, and some extra information.
/// Note: The extra information is not used in any way to decide whether
/// the cache should be used/recalculated/evicted.
F3_0_x<Result, State1, State2, State3, Extra>
    cache3states_0params_x<Result, State1, State2, State3, Extra>(
  F3_0_x<Result, State1, State2, State3, Extra> f,
) {
  WeakContainer? _s1, _s2, _s3;
  late WeakMap<State1, WeakMap<State2, WeakMap<State3, Result>>> weakMap1;
  late WeakMap<State2, WeakMap<State3, Result>> weakMap2;
  late WeakMap<State3, Result> weakMap3;

  return (State1 state1, State2 state2, State3 state3, Extra extra) {
    return () {
      if (_s1 == null ||
          _s2 == null ||
          _s3 == null || //
          !_s1!.contains(state1) ||
          !_s2!.contains(state2) ||
          !_s3!.contains(state3)) {
        _s1 = WeakContainer(state1);
        _s2 = WeakContainer(state2);
        _s3 = WeakContainer(state3);

        var result = f(state1, state2, state3, extra)();
        weakMap1 = WeakMap();
        weakMap2 = WeakMap();
        weakMap3 = WeakMap();
        weakMap3[state3] = result;
        weakMap2[state2] = weakMap3;
        weakMap1[state1] = weakMap2;
        return result;
      }
      //
      else {
        return weakMap1[state1]![state2]![state3] as Result;
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
  int get hashCode => Object.hash(x, y);
}

// /////////////////////////////////////////////////////////////////////////////

class _Triad<X, Y, Z> {
  final X x;
  final Y y;
  final Z z;

  _Triad(this.x, this.y, this.z);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Triad &&
          runtimeType == other.runtimeType //
          &&
          x == other.x &&
          y == other.y &&
          z == other.z;

  @override
  int get hashCode => Object.hash(x, y, z);
}

// /////////////////////////////////////////////////////////////////////////////
