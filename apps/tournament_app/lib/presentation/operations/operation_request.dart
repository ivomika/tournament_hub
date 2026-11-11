/// Источник результата и фактическая отмена принадлежащей ему работы.
///
/// Если остановка источника невозможна, onCancel освобождает доступные ресурсы;
/// подавление позднего результата остаётся ответственностью OperationScope.
final class OperationRequest<Result> {
  const OperationRequest({required this.result, required this.onCancel});

  final Future<Result> result;
  final Future<void> Function() onCancel;
}
