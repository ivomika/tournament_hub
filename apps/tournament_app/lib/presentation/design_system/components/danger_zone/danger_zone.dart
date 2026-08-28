import 'package:flutter/material.dart';

import '../ds_action/ds_action.dart';
import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import 'danger_zone_theme.dart';

class DangerZone extends StatelessWidget {
  const DangerZone({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    super.key,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DangerZoneTheme>()!;
    return DsSurface(
      tone: DsSurfaceTone.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: theme.iconColor),
              SizedBox(width: theme.gap),
              Expanded(child: DsText(title, variant: DsTextVariant.title)),
            ],
          ),
          SizedBox(height: theme.gap),
          DsText(message, variant: DsTextVariant.secondary),
          SizedBox(height: theme.gap),
          Align(
            alignment: Alignment.centerLeft,
            child: DsAction(
              label: actionLabel,
              kind: DsActionKind.danger,
              onPressed: onAction,
            ),
          ),
        ],
      ),
    );
  }
}
