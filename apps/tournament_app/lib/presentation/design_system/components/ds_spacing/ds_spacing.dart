import 'package:flutter/material.dart';

import 'ds_spacing_theme.dart';

enum DsSpace { xs, sm, md, lg, xl }

extension DsSpaceValue on DsSpace {
  double resolve(DsSpacingTheme theme) => switch (this) {
    DsSpace.xs => theme.xs,
    DsSpace.sm => theme.sm,
    DsSpace.md => theme.md,
    DsSpace.lg => theme.lg,
    DsSpace.xl => theme.xl,
  };
}

class DsGap extends StatelessWidget {
  const DsGap(this.space, {super.key});

  final DsSpace space;

  @override
  Widget build(BuildContext context) {
    final value = space.resolve(Theme.of(context).extension<DsSpacingTheme>()!);
    return SizedBox.square(dimension: value);
  }
}

class DsPagePadding extends StatelessWidget {
  const DsPagePadding({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsSpacingTheme>()!;
    return Padding(padding: EdgeInsets.all(theme.page), child: child);
  }
}
