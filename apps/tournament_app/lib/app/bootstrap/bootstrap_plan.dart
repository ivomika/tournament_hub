import 'package:tournament_app/app/bootstrap/bootstrap_failure.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_plan_step.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_resource.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_step.dart';
import 'package:tournament_app/presentation/operations/operation_request.dart';

final class BootstrapPlan<Output> {
  BootstrapPlan._(this._tail, Iterable<BootstrapPlanStep> steps)
    : steps = List.unmodifiable(steps);

  factory BootstrapPlan.seed(Output value) =>
      BootstrapPlan._(_SeedNode(value), const []);

  final _PlanNode<Output> _tail;
  final List<BootstrapPlanStep> steps;

  Output get value => _tail.value;

  BootstrapPlan<Next> then<Next>(BootstrapStep<Output, Next> step) {
    final node = _StepNode(_tail, step);
    return BootstrapPlan._(node, [...steps, node]);
  }

  void claim(Object owner) {
    var placement = BootstrapPlacement.beforeApplication;
    for (final step in steps) {
      if (placement == BootstrapPlacement.afterApplication &&
          step.placement == BootstrapPlacement.beforeApplication) {
        throw const BootstrapPlanException(BootstrapPlanIssue.phaseOrder);
      }
      placement = step.placement;
    }
    for (final step in steps) {
      step.claim(owner);
    }
  }
}

abstract interface class _PlanNode<Value> {
  Value get value;
}

final class _SeedNode<Value> implements _PlanNode<Value> {
  const _SeedNode(this.value);

  @override
  final Value value;
}

final class _StepNode<Input, Output>
    implements _PlanNode<Output>, BootstrapPlanStep {
  _StepNode(this.previous, this.step);

  final _PlanNode<Input> previous;
  final BootstrapStep<Input, Output> step;
  BootstrapResource<Output>? _resource;
  Object? _owner;

  @override
  Output get value => _resource!.value;

  @override
  Type get stepType => step.runtimeType;

  @override
  BootstrapPlacement get placement => step.placement;

  @override
  bool get isComplete => _resource != null;

  @override
  bool get isValid => _resource?.isValid ?? false;

  @override
  void claim(Object owner) {
    if (_owner != null && !identical(_owner, owner)) {
      throw const BootstrapPlanException(BootstrapPlanIssue.alreadyOwned);
    }
    _owner = owner;
  }

  @override
  OperationRequest<BootstrapAcquisition> start() {
    final request = step.start(previous.value);
    return OperationRequest(
      result: request.result.then(_acquire),
      onCancel: request.onCancel,
    );
  }

  BootstrapAcquisition _acquire(BootstrapResource<Output> resource) =>
      _Acquisition(resource, _cache);

  void _cache(BootstrapResource<Output> resource) => _resource = resource;

  @override
  Future<void> release() {
    final resource = _resource;
    _resource = null;
    return resource?.close() ?? Future<void>.value();
  }
}

final class _Acquisition<Output> implements BootstrapAcquisition {
  const _Acquisition(this.resource, this.cache);

  final BootstrapResource<Output> resource;
  final void Function(BootstrapResource<Output>) cache;

  @override
  void commit() => cache(resource);

  @override
  Future<void> close() => resource.close();
}
