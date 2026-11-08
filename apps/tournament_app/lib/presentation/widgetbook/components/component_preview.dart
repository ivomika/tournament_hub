import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';

/// A viewport is an environment, not the intrinsic size of a control.
/// Screens keep their own full-size layout; standalone controls get loose constraints.
class ComponentPreview extends StatelessWidget {
  const ComponentPreview({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Theme.of(context).extension<AppControlMetrics>()!.topLeft,
    child: child,
  );
}
