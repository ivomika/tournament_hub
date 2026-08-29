import 'package:flutter/material.dart';

import '../confirmation/confirmation.dart';
import '../ds_action/ds_action.dart';
import '../ds_text/ds_text.dart';
import 'action_dock_action.dart';
import 'action_dock_theme.dart';

class ActionDock extends StatelessWidget {
  const ActionDock({
    required this.primary,
    this.secondary = const [],
    this.destructive,
    super.key,
  });

  final Widget primary;
  final List<ActionDockAction> secondary;
  final ActionDockAction? destructive;

  List<ActionDockAction> get _overflowActions => [...secondary, ?destructive];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ActionDockTheme>()!;
    final media = MediaQuery.of(context);
    final maxFraction = media.orientation == Orientation.landscape
        ? theme.landscapeMaxFraction
        : theme.portraitMaxFraction;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: media.size.height * maxFraction),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.background,
          border: Border(top: BorderSide(color: theme.divider)),
        ),
        child: Padding(
          padding: EdgeInsets.all(theme.padding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: theme.minimumHeight),
                  child: primary,
                ),
              ),
              if (_overflowActions.isNotEmpty) ...[
                SizedBox(width: theme.gap),
                SizedBox.square(
                  dimension: theme.overflowSize,
                  child: PopupMenuButton<ActionDockAction>(
                    tooltip: 'Дополнительные действия',
                    icon: const Icon(Icons.more_horiz),
                    onSelected: (action) => _select(context, action),
                    itemBuilder: (context) => [
                      for (final action in _overflowActions)
                        PopupMenuItem(
                          key: action.key,
                          value: action,
                          enabled: action.enabled,
                          child: Row(
                            children: [
                              if (action.icon case final icon?) ...[
                                Icon(
                                  icon,
                                  color:
                                      action.kind ==
                                          ActionDockActionKind.destructive
                                      ? theme.danger
                                      : theme.foreground,
                                ),
                                SizedBox(width: theme.gap),
                              ],
                              Expanded(
                                child: DsText(
                                  action.label,
                                  variant: DsTextVariant.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _select(BuildContext context, ActionDockAction action) async {
    if (!action.enabled) return;
    if (action.kind != ActionDockActionKind.destructive) {
      action.onSelected();
      return;
    }
    final confirmed = await showTournamentConfirmationDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: DsText(
          action.confirmationTitle ?? action.label,
          variant: DsTextVariant.title,
        ),
        content: DsText(
          action.confirmationMessage ?? 'Это действие нельзя отменить.',
          variant: DsTextVariant.secondary,
        ),
        actions: [
          DsAction(
            label: 'Назад',
            kind: DsActionKind.text,
            autofocus: true,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          DsAction(
            label: action.label,
            kind: DsActionKind.danger,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    if (confirmed ?? false) action.onSelected();
  }
}
