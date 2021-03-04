## [2.0.0]

* Cache functions with extra parameters.
* Rename of cache functions to make them easier to use.

Now, cache functions are:

```dart
cache1state((state) => () => ...);
cache1state_1param((state) => (parameter) => ...);
cache1state_2params((state) => (parameter1, parameter2) => ...);
cache2states((state1, state2) => () => ...);
cache2states_1param((state1, state2) => (parameter) => ...);
cache2states_2params((state1, state2) => (parameter1, parameter2) => ...);
cache3states((state1, state2, state3) => () => ...);
cache1state_0params_x((state1, extra) => () => ...);
cache2states_0params_x((state1, state2, extra) => () => ...);
cache3states_0params_x((state1, state2, state3, extra) => () => ...);
```    

## [1.4.0-nullsafety.0]

* Migrating to null safety

## [1.3.2] - 2020/08/13

* Type parameters rename (clean-code).

## [1.3.1] - 2020/08/11

* cache3_0.

## [1.2.2] - 2020/07/28

* Dependency bump.

## [1.2.1] - 2020/06/12

* Cache functions.

## [1.1.2] - 2020/05/26

* Add is by identity.
* Docs improvement.

## [1.0.6] - 2020/05/19

* Removed dependency on Flutter (it's now pure Dart).

## [1.0.2] - 2020/05/18

* Example.

## [1.0.0] - 2020/05/18

* WeakMap and WeakContainer.
