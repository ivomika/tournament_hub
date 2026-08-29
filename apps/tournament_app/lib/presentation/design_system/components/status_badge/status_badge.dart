import 'package:flutter/material.dart';

import '../ds_text/ds_text.dart';
import 'status_badge_theme.dart';

enum StatusKind { success, danger, warning, info, neutral }

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.label, required this.kind, super.key});

  final String label;
  final StatusKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<StatusBadgeTheme>()!;
    final (color, icon) = switch (kind) {
      StatusKind.success => (theme.success, Icons.check_circle_outline),
      StatusKind.danger => (theme.danger, Icons.error_outline),
      StatusKind.warning => (theme.warning, Icons.warning_amber),
      StatusKind.info => (theme.info, Icons.info_outline),
      StatusKind.neutral => (theme.neutral, Icons.circle_outlined),
    };
    final badge = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.horizontalPadding,
          vertical: theme.verticalPadding,
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: theme.gap,
          children: [
            Icon(icon, color: color, size: theme.iconSize),
            DsText(label, variant: DsTextVariant.label),
          ],
        ),
      ),
    );
    return Semantics(
      container: true,
      label: 'Статус: $label',
      child: ExcludeSemantics(child: badge),
    );
  }
}
