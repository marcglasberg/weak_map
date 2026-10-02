* Sponsored by [MyText.ai](https://mytext.ai)

[![](./example/SponsoredByMyTextAi.png)](https://mytext.ai)

## 4.1.1

* `WeakContainer` is now deprecated. It was created when Dart had no weak
  references. Use Dart's native `WeakReference` instead: replace
  `WeakContainer(obj).contains(x)` with `identical(WeakReference(obj).target, x)`.
  It will be removed in a future version.

* The cache functions now use a `WeakReference` internally to remember the
  states, instead of creating one `Expando` per state. Same behavior, but faster.

* Fixed the cache functions when the cached function throws an error. Before the fix,
  the next call after an error with the same states could return `null`, or throw a
  `LateInitializationError` or a null-check error, instead of recalculating.
  Now the error is propagated, and the next call recalculates.

* Fixed `cache2states_1param`, `cache2states_2params` and `cache2states_3params`
  crashing when the cached function calls itself with other parameters (for example, a
  memoized recursive function).

## 4.0.2

* Fixed unsafe cast.

* Fixed `getOrThrow` not throwing a `StateError` for missing object keys.

* Fixed Dart records crashing `WeakMap`, `WeakContainer` and the cache functions.
  Records are now treated like Strings and numbers (compared by equality).
  Requires Dart 3.0.0.

* Fixed a memory leak in the cache functions with 2 or 3 states, which could
  keep the first state and the cached result in memory after they were no
  longer used.

* Many more tests, including garbage-collection tests.

## 3.0.1

* Flutter 3.10.0 and Dart 3.0.0

## 2.1.0

* `cache2states_3params((state1, state2) => (param1, param2, param3) => ...);`

## 2.0.4

* Docs improvement.

## 2.0.2

* NNBD improvement.

## 2.0.0

* Cache functions with extra parameters.
* Rename of cache functions to make them easier to use.

Now, cache functions are:

```
cache1state((state) => () => ...);
cache1state_1param((state) => (parameter) => ...);
cache1state_2params((state) => (param1, param2) => ...);
cache2states((state1, state2) => () => ...);
cache2states_1param((state1, state2) => (parameter) => ...);
cache2states_2params((state1, state2) => (param1, param2) => ...);
cache3states((state1, state2, state3) => () => ...);
cache1state_0params_x((state1, extra) => () => ...);
cache2states_0params_x((state1, state2, extra) => () => ...);
cache3states_0params_x((state1, state2, state3, extra) => () => ...);
```    

## 1.4.0-nullsafety.0

* Migrating to null safety

## 1.3.2

* Type parameters rename (clean-code).

## 1.3.1

* cache3_0.

## 1.2.2

* Dependency bump.

## 1.2.1

* Cache functions.

## 1.1.2

* Add is by identity.
* Docs improvement.

## 1.0.6

* Removed dependency on Flutter (it's now pure Dart).

## 1.0.2

* Example.

## 1.0.0

* WeakMap and WeakContainer.
