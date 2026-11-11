import 'package:tournament_app/app/bootstrap/bootstrap_plan_step.dart';
import 'package:tournament_app/presentation/operations/operation_scope.dart';

abstract final class BootstrapResources {
  static Future<void> close(Iterable<BootstrapPlanStep> resources) async {
    final errors = <Object>[];
    for (final resource in resources.toList().reversed) {
      try {
        await resource.release();
      } catch (error) {
        collect(errors, error);
      }
    }
    if (errors.isNotEmpty) throw OperationCleanupException(errors);
  }

  static void collect(List<Object> errors, Object error) {
    if (error is OperationCleanupException) {
      errors.addAll(error.errors);
    } else {
      errors.add(error);
    }
  }
}
