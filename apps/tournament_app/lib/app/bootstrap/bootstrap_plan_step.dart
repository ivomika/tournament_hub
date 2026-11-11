import 'package:tournament_app/app/bootstrap/bootstrap_step.dart';
import 'package:tournament_app/presentation/operations/operation_request.dart';

/// Scheduler не извлекает Output по ключу: typed узел сам фиксирует свой lease.
abstract interface class BootstrapAcquisition {
  void commit();

  Future<void> close();
}

abstract interface class BootstrapPlanStep {
  Type get stepType;

  BootstrapPlacement get placement;

  bool get isComplete;

  bool get isValid;

  void claim(Object owner);

  OperationRequest<BootstrapAcquisition> start();

  Future<void> release();
}
