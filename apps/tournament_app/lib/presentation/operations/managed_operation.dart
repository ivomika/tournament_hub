import 'package:tournament_app/presentation/operations/operation_outcome.dart';

/// Индивидуальная отмена не закрывает другие операции того же владельца.
abstract interface class ManagedOperation<Result> {
  Future<OperationOutcome<Result>> get result;

  /// Возвращает завершение cleanup; result получает отмену раньше cleanup.
  Future<void> cancel();
}
