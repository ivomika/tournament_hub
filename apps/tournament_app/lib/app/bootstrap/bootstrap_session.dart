import 'dart:async';

import 'package:tournament_app/app/bootstrap/bootstrap_plan_step.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_resources.dart';

final class BootstrapSession<Value> {
  BootstrapSession(this.value, Iterable<BootstrapPlanStep> resources)
    : _resources = List.unmodifiable(resources);

  final Value value;
  final List<BootstrapPlanStep> _resources;
  Future<void>? _closing;

  Future<void> close() {
    final closing = _closing;
    if (closing != null) return closing;

    final completion = Completer<void>();
    _closing = completion.future;
    completion.complete(BootstrapResources.close(_resources));
    return completion.future;
  }
}
