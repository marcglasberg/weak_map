/// A weak-container is similar, but not exactly, a weak-reference to some object.
/// Dart doesn't have real weak-references, so the best you can do here is to check
/// that some object is the same you had before.
///
/// To create a weak-container:
/// ```
/// var obj = Object();
/// var ref = WeakContainer(obj);
/// var someObj = Random().nextBool() ? obj : Object();
/// print(ref.contains(someObj)); // True or false.
/// ```
/// This will print `true` if `someObj` is the same as the original `obj`,
/// and will print `false` if it's a different object, compared by identity.
///
/// If all references to the original `obj` have been destroyed,
/// the weak-container will NOT prevent `obj` to be garbage-collected.
///
class WeakContainer {
  Expando? _expando;
  Object? _value;
  bool _isNull;

  WeakContainer(Object? value)
      : _expando = _allowedInExpando(value) ? _createExpando(value!) : null,
        _value = _allowedInExpando(value) ? null : value,
        _isNull = (value == null);

  bool contains(Object? value) {
    if (value == null) {
      return _isNull;
    } else {
      if (_value == value) {
        return true;
      } else {
        return (_expando != null && //
            _allowedInExpando(value) &&
            _expando![value] == true);
      }
    }
  }

  void clear() {
    _value = null;
    _expando = null;
    _isNull = false;
  }

  static Expando _createExpando(Object value) {
    assert(_allowedInExpando(value));
    var expando = Expando();
    expando[value] = true;
    return expando;
  }

  static bool _allowedInExpando(Object? value) =>
      value is! String && value is! num && value is! bool && value != null;
}
