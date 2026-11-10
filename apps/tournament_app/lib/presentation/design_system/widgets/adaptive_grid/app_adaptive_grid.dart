import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/adaptive_grid/app_adaptive_grid_theme.dart';

class AppAdaptiveGrid extends StatelessWidget {
  const AppAdaptiveGrid({
    required this.columns,
    required this.children,
    super.key,
  });
  final int columns;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: _layout);
  Widget _layout(BuildContext context, BoxConstraints constraints) {
    final appearance = AppAdaptiveGridTheme.of(
      context,
      columns,
      constraints.maxWidth,
    );
    return Wrap(
      spacing: appearance.gap,
      runSpacing: appearance.gap,
      children: [
        for (final child in children)
          SizedBox(width: appearance.width, child: child),
      ],
    );
  }
}
