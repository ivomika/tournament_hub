import 'package:tournament_app/app/bootstrap/bootstrap_resource.dart';
import 'package:tournament_app/presentation/operations/operation_request.dart';

enum BootstrapPlacement { beforeApplication, afterApplication }

abstract interface class BootstrapStep<Input, Output> {
  BootstrapPlacement get placement;

  /// onCancel обязан также уметь очистить незавершённую/неуспешную попытку.
  OperationRequest<BootstrapResource<Output>> start(Input input);
}
