import 'package:flutter/material.dart';

enum ActionDockActionKind { secondary, destructive }

class ActionDockAction {
  const ActionDockAction({
    required this.label,
    required this.onSelected,
    this.icon,
    this.kind = ActionDockActionKind.secondary,
    this.confirmationTitle,
    this.confirmationMessage,
    this.enabled = true,
    this.key,
  });

  final String label;
  final VoidCallback onSelected;
  final IconData? icon;
  final ActionDockActionKind kind;
  final String? confirmationTitle;
  final String? confirmationMessage;
  final bool enabled;
  final Key? key;
}
