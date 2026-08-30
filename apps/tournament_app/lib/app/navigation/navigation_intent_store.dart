import 'dart:async';

import 'models/navigation_intent.dart';
import 'ports/navigation_intent_sink.dart';
import 'ports/navigation_intent_source.dart';

final class NavigationIntentStore
    implements NavigationIntentSink, NavigationIntentSource {
  NavigationIntentStore({
    NavigationIntent initialIntent = const NavigationIntent.main(),
  }) : _current = initialIntent;

  final StreamController<NavigationIntent> _changes =
      StreamController.broadcast(sync: true);
  final List<NavigationIntent> _history = [];
  NavigationIntent _current;
  bool _isDisposed = false;

  @override
  NavigationIntent get current => _current;

  @override
  Stream<NavigationIntent> get changes => _changes.stream;

  @override
  void go(NavigationIntent intent) {
    if (_isDisposed || intent == _current) return;
    _history.add(_current);
    _current = intent;
    _changes.add(intent);
  }

  @override
  void back() {
    if (_isDisposed) return;
    final previous = _history.isEmpty
        ? const NavigationIntent.main()
        : _history.removeLast();
    if (previous == _current) return;
    _current = previous;
    _changes.add(previous);
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    await _changes.close();
  }
}
