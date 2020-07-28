import 'dart:collection';
import 'package:weak_map/weak_map.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

typedef R1_0<R> = R Function();
typedef F1_0<R, S1> = R1_0<R> Function(S1);

/// Cache for 1 immutable state, and no parameters.
F1_0<R, S1> cache1_0<R, S1>(F1_0<R, S1> f) {
  WeakContainer _s1;
  WeakMap<S1, R> weakMap;

  return (S1 s1) {
    return () {
      if (_s1 == null || !_s1.contains(s1)) {
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

// /////////////////////////////////////////////////////////////////////////////////////////////////

typedef R1_1<R, P1> = R Function(P1);
typedef F1_1<R, S1, P1> = R1_1<R, P1> Function(S1);

/// Cache for 1 immutable state, and 1 parameter.
F1_1<R, S1, P1> cache1_1<R, S1, P1>(F1_1<R, S1, P1> f) {
  WeakContainer _s1;
  WeakMap<S1, Map<P1, R>> weakMap;

  return (S1 s1) {
    return (P1 p1) {
      if (_s1 == null || !_s1.contains(s1)) {
        weakMap = WeakMap();
        Map<P1, R> map = HashMap();
        weakMap[s1] = map;
        _s1 = WeakContainer(s1);
        var result = f(s1)(p1);
        map[p1] = result;
        return result;
      }
      //
      else {
        Map<P1, R> map = weakMap[s1];
        assert(map != null);
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

// /////////////////////////////////////////////////////////////////////////////////////////////////

typedef R1_2<R, P1, P2> = R Function(P1, P2);
typedef F1_2<R, S1, P1, P2> = R1_2<R, P1, P2> Function(S1);

/// Cache for 1 immutable state, and 2 parameters.
F1_2<R, S1, P1, P2> cache1_2<R, S1, P1, P2>(F1_2<R, S1, P1, P2> f) {
  WeakContainer _s1;
  WeakMap<S1, Map<_Pair<P1, P2>, R>> weakMap;

  return (S1 s1) {
    return (P1 p1, P2 p2) {
      var parP = _Pair(p1, p2);
      if (_s1 == null || !_s1.contains(s1)) {
        weakMap = WeakMap();
        Map<_Pair<P1, P2>, R> map = HashMap();
        weakMap[s1] = map;
        _s1 = WeakContainer(s1);
        var result = f(s1)(p1, p2);
        map[parP] = result;
        return result;
      }
      //
      else {
        Map<_Pair<P1, P2>, R> map = weakMap[s1];
        assert(map != null);
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

// /////////////////////////////////////////////////////////////////////////////////////////////////

typedef R2_0<R> = R Function();
typedef F2_0<R, S1, S2> = R2_0<R> Function(S1, S2);

/// Cache for 2 immutable states, and no parameters.
F2_0<R, S1, S2> cache2_0<R, S1, S2>(F2_0<R, S1, S2> f) {
  WeakContainer _s1, _s2;
  WeakMap<S1, WeakMap<S2, R>> weakMap1;
  WeakMap<S2, R> weakMap2;

  return (S1 s1, S2 s2) {
    return () {
      if (_s1 == null ||
          _s2 == null || //
          !_s1.contains(s1) ||
          !_s2.contains(s2)) {
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
        return weakMap1[s1][s2];
      }
    };
  };
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

typedef R2_1<R, P1> = R Function(P1);
typedef F2_1<R, S1, S2, P1> = R2_1<R, P1> Function(S1, S2);

/// Cache for 2 immutable states, and 1 parameter.
F2_1<R, S1, S2, P1> cache2_1<R, S1, S2, P1>(F2_1<R, S1, S2, P1> f) {
  WeakContainer _s1, _s2;
  WeakMap<S1, WeakMap<S2, Map<P1, R>>> weakMap1;
  WeakMap<S2, Map<P1, R>> weakMap2;

  return (S1 s1, S2 s2) {
    return (P1 p1) {
      if (_s1 == null ||
          _s2 == null || //
          !_s1.contains(s1) ||
          !_s2.contains(s2)) {
        _s1 = WeakContainer(s1);
        _s2 = WeakContainer(s2);

        var result = f(s1, s2)(p1);
        weakMap1 = WeakMap();
        weakMap2 = WeakMap();
        Map<P1, R> map = HashMap();
        map[p1] = result;
        weakMap2[s2] = map;
        weakMap1[s1] = weakMap2;
        return result;
      }
      //
      else {
        Map<P1, R> map = weakMap1[s1][s2];
        assert(map != null);
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

// /////////////////////////////////////////////////////////////////////////////////////////////////

typedef R2_2<R, P1, P2> = R Function(P1, P2);
typedef F2_2<R, S1, S2, P1, P2> = R2_2<R, P1, P2> Function(S1, S2);

/// Cache for 2 immutable states, and 2 parameters.
F2_2<R, S1, S2, P1, P2> cache2_2<R, S1, S2, P1, P2>(F2_2<R, S1, S2, P1, P2> f) {
  WeakContainer _s1, _s2;
  WeakMap<S1, WeakMap<S2, Map<_Pair<P1, P2>, R>>> weakMap1;
  WeakMap<S2, Map<_Pair<P1, P2>, R>> weakMap2;

  return (S1 s1, S2 s2) {
    return (P1 p1, P2 p2) {
      var par = _Pair(p1, p2);
      if (_s1 == null || !_s1.contains(s1) || !_s2.contains(s2)) {
        _s1 = WeakContainer(s1);
        _s2 = WeakContainer(s2);

        var result = f(s1, s2)(p1, p2);
        weakMap1 = WeakMap();
        weakMap2 = WeakMap();
        Map<_Pair<P1, P2>, R> map = HashMap();
        map[par] = result;
        weakMap2[s2] = map;
        weakMap1[s1] = weakMap2;
        return result;
      }
      //
      else {
        Map<_Pair<P1, P2>, R> map = weakMap1[s1][s2];
        assert(map != null);
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

// /////////////////////////////////////////////////////////////////////////////////////////////////

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

// /////////////////////////////////////////////////////////////////////////////////////////////////
