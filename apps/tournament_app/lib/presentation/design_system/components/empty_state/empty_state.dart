import 'package:flutter/material.dart';

import '../ds_action/ds_action.dart';
import '../ds_text/ds_text.dart';
import 'empty_state_theme.dart';

class TournamentEmptyState extends StatelessWidget {
  const TournamentEmptyState({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.isError = false,
    super.key,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<EmptyStateTheme>()!;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: theme.maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.inbox_outlined,
              size: theme.iconSize,
              color: isError ? theme.error : theme.foreground,
            ),
            SizedBox(height: theme.gap),
            DsText(
              title,
              variant: DsTextVariant.heading,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: theme.gap),
            DsText(
              message,
              variant: DsTextVariant.secondary,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              SizedBox(height: theme.gap),
              DsAction(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
