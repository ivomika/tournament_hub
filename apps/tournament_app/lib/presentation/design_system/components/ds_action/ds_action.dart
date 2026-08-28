import 'package:flutter/material.dart';

import 'ds_action_theme.dart';

enum DsActionKind { primary, secondary, text }

class DsAction extends StatelessWidget {
  const DsAction({
    required this.label,
    this.onPressed,
    this.kind = DsActionKind.primary,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final DsActionKind kind;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsActionTheme>()!;
    final style = switch (kind) {
      DsActionKind.primary => theme.primary,
      DsActionKind.secondary => theme.secondary,
      DsActionKind.text => theme.text,
    };
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon), Text(label)],
          );
    return switch (kind) {
      DsActionKind.primary => ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      DsActionKind.secondary => OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      DsActionKind.text => TextButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    };
  }
}
