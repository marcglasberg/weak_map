/// Internal. Remembers some state without keeping it alive, so that we can
/// later check if some other state is the same one.
///
/// Objects are compared by identity, and held weakly (in a [WeakReference]),
/// so that the container doesn't prevent them from being garbage-collected.
/// Values that a [WeakReference] rejects (null, numbers, booleans, Strings and
/// records) are never garbage-collected anyway, so they are held normally and
/// compared by equality.
///
/// This is used by the cache functions.
///
class StateContainer {
  WeakReference<Object>? _ref;
  Object? _value;
  bool _isNull;

  StateContainer(Object? value)
      : _ref = _allowedInWeakReference(value) ? WeakReference(value!) : null,
        _value = _allowedInWeakReference(value) ? null : value,
        _isNull = (value == null);

  bool contains(Object? value) {
    // Must come first: After the object is garbage-collected, the target is
    // null, which must not match a null value.
    if (value == null) {
      return _isNull;
    } else {
      if (_value == value) {
        return true;
      } else {
        return (_ref != null && identical(_ref!.target, value));
      }
    }
  }

  void clear() {
    _value = null;
    _ref = null;
    _isNull = false;
  }

  static bool _allowedInWeakReference(Object? value) =>
      value is! String && value is! num && value is! bool && value is! Record && value != null;
}
