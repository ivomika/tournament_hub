import 'package:flutter/material.dart';

import '../confirmation/confirmation.dart';
import '../ds_action/ds_action.dart';
import '../ds_text/ds_text.dart';
import 'action_dock_action.dart';
import 'action_dock_theme.dart';

class ActionDock extends StatefulWidget {
  const ActionDock({
    required this.primary,
    this.secondary = const [],
    this.destructive,
    super.key,
  });

  final Widget primary;
  final List<ActionDockAction> secondary;
  final ActionDockAction? destructive;

  @override
  State<ActionDock> createState() => _ActionDockState();
}

class _ActionDockState extends State<ActionDock> {
  final FocusNode _overflowFocusNode = FocusNode(
    debugLabel: 'ActionDock overflow',
  );

  List<ActionDockAction> get _overflowActions => [
    ...widget.secondary,
    ?widget.destructive,
  ];

  @override
  void dispose() {
    _overflowFocusNode.dispose();
    super.dispose();
  }

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
                  child: widget.primary,
                ),
              ),
              if (_overflowActions.isNotEmpty) ...[
                SizedBox(width: theme.gap),
                MenuAnchor(
                  menuChildren: [
                    for (final action in _overflowActions)
                      MenuItemButton(
                        key: action.key,
                        onPressed: action.enabled
                            ? () => _select(action)
                            : null,
                        leadingIcon: action.icon == null
                            ? null
                            : Icon(
                                action.icon,
                                color:
                                    action.kind ==
                                        ActionDockActionKind.destructive
                                    ? theme.danger
                                    : theme.foreground,
                              ),
                        child: DsText(
                          action.label,
                          variant: DsTextVariant.secondary,
                        ),
                      ),
                  ],
                  builder: (context, controller, child) => SizedBox.square(
                    dimension: theme.overflowSize,
                    child: IconButton(
                      focusNode: _overflowFocusNode,
                      tooltip: 'Дополнительные действия',
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () => controller.isOpen
                          ? controller.close()
                          : controller.open(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _select(ActionDockAction action) async {
    if (!action.enabled) return;
    if (action.kind != ActionDockActionKind.destructive) {
      action.onSelected();
      _restoreOverflowFocus();
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
    _restoreOverflowFocus();
  }

  void _restoreOverflowFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _overflowFocusNode.canRequestFocus) {
        _overflowFocusNode.requestFocus();
      }
    });
  }
}
