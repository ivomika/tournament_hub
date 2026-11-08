import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';

/// A viewport is an environment, not the intrinsic size of a control.
/// Screens keep their own full-size layout; standalone controls get loose constraints.
class ComponentPreview extends StatelessWidget {
  const ComponentPreview({required this.child, this.padded = false, super.key});
  final Widget child;
  final bool padded;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Theme.of(context).extension<AppControlMetrics>()!.topLeft,
    child: Padding(
      padding: EdgeInsets.all(
        padded
            ? Theme.of(context).extension<AppSpacing>()!.space16
            : Theme.of(context).extension<AppSpacing>()!.space0,
      ),
      child: child,
    ),
  );
}
