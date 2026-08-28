import 'package:flutter/material.dart';

import 'ds_flow_theme.dart';

class DsFlow extends StatelessWidget {
  const DsFlow({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsFlowTheme>()!;
    return Wrap(spacing: theme.gap, runSpacing: theme.gap, children: children);
  }
}
