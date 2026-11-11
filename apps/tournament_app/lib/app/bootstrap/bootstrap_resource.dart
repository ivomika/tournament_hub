import 'dart:async';

/// Владение успешным результатом; отмена pending start — отдельный контракт.
final class BootstrapResource<Value> {
  BootstrapResource({required this.value, this._onClose, this._isValid});

  final Value value;
  final Future<void> Function()? _onClose;
  final bool Function()? _isValid;
  Future<void>? _closing;

  bool get isValid => _closing == null && (_isValid?.call() ?? true);

  Future<void> close() {
    final closing = _closing;
    if (closing != null) return closing;

    final completion = Completer<void>();
    _closing = completion.future;
    final cleanup = _onClose;
    if (cleanup == null) {
      completion.complete();
    } else {
      completion.complete(Future<void>.sync(cleanup));
    }
    return completion.future;
  }
}
