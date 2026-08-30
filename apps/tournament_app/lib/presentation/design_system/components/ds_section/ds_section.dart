import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import 'ds_section_theme.dart';

class DsSection extends StatelessWidget {
  const DsSection({
    required this.title,
    required this.child,
    this.density = DsDensity.comfortable,
    super.key,
  });

  final String title;
  final Widget child;
  final DsDensity density;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsSectionTheme>()!;
    final gap = switch (density) {
      DsDensity.compact => theme.compactGap,
      DsDensity.comfortable => theme.gap,
      DsDensity.presentation => theme.presentationGap,
    };
    return DsSurface(
      density: density,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DsText(title, variant: DsTextVariant.title),
          SizedBox(height: gap),
          child,
        ],
      ),
    );
  }
}
