import 'package:flutter/material.dart';

import 'adaptive_split_theme.dart';

class AdaptiveSplit extends StatelessWidget {
  const AdaptiveSplit({
    required this.primary,
    required this.secondary,
    super.key,
  });

  final Widget primary;
  final Widget secondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AdaptiveSplitTheme>()!;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < theme.breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              primary,
              SizedBox(height: theme.gap),
              secondary,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: theme.primaryFlex, child: primary),
            SizedBox(width: theme.gap),
            Expanded(flex: theme.secondaryFlex, child: secondary),
          ],
        );
      },
    );
  }
}
