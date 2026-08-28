import 'package:flutter/material.dart';

import '../ds_action/ds_action.dart';
import '../ds_surface/ds_surface.dart';
import '../status_badge/status_badge.dart';
import 'connection_banner_theme.dart';

class ConnectionBanner extends StatelessWidget {
  const ConnectionBanner({
    required this.message,
    required this.kind,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String message;
  final StatusKind kind;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ConnectionBannerTheme>()!;
    return DsSurface(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final status = StatusBadge(label: message, kind: kind);
          final action = actionLabel == null
              ? null
              : DsAction(
                  label: actionLabel!,
                  kind: DsActionKind.text,
                  onPressed: onAction,
                );
          if (constraints.maxWidth <= theme.compactWidth) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                status,
                if (action != null) ...[SizedBox(height: theme.gap), action],
              ],
            );
          }
          return Row(children: [status, const Spacer(), ?action]);
        },
      ),
    );
  }
}
