import 'state_container.dart';

/// **Deprecated:** Use Dart's native [WeakReference] instead.
///
/// When this package was created, Dart had no weak-references, and this class
/// was the closest thing to one: it lets you check if some object is the same
/// you had before, without keeping that object alive. Since Dart 2.17, a
/// [WeakReference] does the same, and more, because it also lets you get the
/// object back while it's still alive:
///
/// ```
/// // Before:
/// var container = WeakContainer(obj);
/// print(container.contains(someObj));
///
/// // Now:
/// var ref = WeakReference(obj);
/// print(identical(ref.target, someObj));
/// ```
///
/// Note a [WeakReference] can't hold null, numbers, booleans, Strings or records
/// (it throws an [ArgumentError]). Those are never garbage-collected anyway, so
/// you can keep them in a regular variable and compare them with `==`.
///
@Deprecated("Use Dart's native WeakReference instead. "
    "Replace `WeakContainer(obj).contains(x)` with `identical(WeakReference(obj).target, x)`. "
    "This class will be removed in a future version.")
class WeakContainer {
  final StateContainer _container;

  WeakContainer(Object? value) : _container = StateContainer(value);

  /// Returns true if [value] is the same object this container was created
  /// with (compared by identity), or an equal value if the container was
  /// created with null, a number, a boolean, a String or a record.
  bool contains(Object? value) => _container.contains(value);

  /// After calling this method, [contains] always returns false.
  void clear() => _container.clear();
}
