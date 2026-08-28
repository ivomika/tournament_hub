import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import 'ds_section_theme.dart';

class DsSection extends StatelessWidget {
  const DsSection({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsSectionTheme>()!;
    return DsSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DsText(title, variant: DsTextVariant.title),
          SizedBox(height: theme.gap),
          child,
        ],
      ),
    );
  }
}
