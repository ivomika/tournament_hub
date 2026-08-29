import 'package:flutter/material.dart';

import 'ds_action_theme.dart';

enum DsActionKind { primary, secondary, text, danger }

enum DsActionStatus { idle, loading, success }

class DsAction extends StatelessWidget {
  const DsAction({
    required this.label,
    this.onPressed,
    this.kind = DsActionKind.primary,
    this.icon,
    this.status = DsActionStatus.idle,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final DsActionKind kind;
  final IconData? icon;
  final DsActionStatus status;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsActionTheme>()!;
    final style = switch (kind) {
      DsActionKind.primary => theme.primary,
      DsActionKind.secondary => theme.secondary,
      DsActionKind.text => theme.text,
      DsActionKind.danger => theme.danger,
    };
    final stateIcon = switch (status) {
      DsActionStatus.idle => icon == null ? null : Icon(icon),
      DsActionStatus.loading => SizedBox.square(
        dimension: theme.indicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: theme.indicatorStrokeWidth,
        ),
      ),
      DsActionStatus.success => Icon(Icons.check, color: theme.success),
    };
    final child = stateIcon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              stateIcon,
              SizedBox(width: theme.contentGap),
              Flexible(child: Text(label)),
            ],
          );
    final effectiveOnPressed = status == DsActionStatus.loading
        ? null
        : onPressed;
    final button = switch (kind) {
      DsActionKind.primary => ElevatedButton(
        onPressed: effectiveOnPressed,
        focusNode: focusNode,
        autofocus: autofocus,
        style: style,
        child: child,
      ),
      DsActionKind.secondary => OutlinedButton(
        onPressed: effectiveOnPressed,
        focusNode: focusNode,
        autofocus: autofocus,
        style: style,
        child: child,
      ),
      DsActionKind.text => TextButton(
        onPressed: effectiveOnPressed,
        focusNode: focusNode,
        autofocus: autofocus,
        style: style,
        child: child,
      ),
      DsActionKind.danger => OutlinedButton(
        onPressed: effectiveOnPressed,
        focusNode: focusNode,
        autofocus: autofocus,
        style: style,
        child: child,
      ),
    };
    return Semantics(
      button: true,
      enabled: effectiveOnPressed != null,
      onTap: effectiveOnPressed,
      liveRegion: status != DsActionStatus.idle,
      label: switch (status) {
        DsActionStatus.idle => label,
        DsActionStatus.loading => '$label. Выполняется',
        DsActionStatus.success => '$label. Выполнено',
      },
      child: ExcludeSemantics(child: button),
    );
  }
}
