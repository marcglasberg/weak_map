/// Applies memory pressure until the [ref] target is garbage-collected,
/// or until it gives up. Returns true if the target was collected.
///
/// Dart can't force a garbage-collection directly, but allocating lots of
/// short-lived objects reliably triggers it in the VM. If the target is
/// still strongly reachable it will never be collected, and this returns
/// false after all rounds have been tried.
bool isGarbageCollected(WeakReference<Object> ref, {int maxRounds = 2000}) {
  for (var round = 0; round < maxRounds; round++) {
    if (ref.target == null) return true;
    var garbage = List<List<int>?>.filled(100, null);
    for (var i = 0; i < garbage.length; i++) {
      garbage[i] = List<int>.filled(1000, i);
    }
  }
  return ref.target == null;
}
