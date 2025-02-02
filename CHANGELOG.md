## 4.0.1

* Sponsored by [MyText.ai](https://mytext.ai)

[![](./example/SponsoredByMyTextAi.png)](https://mytext.ai)

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
