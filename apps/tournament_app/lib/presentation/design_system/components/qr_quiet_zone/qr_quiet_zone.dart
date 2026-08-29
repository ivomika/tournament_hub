import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'qr_quiet_zone_theme.dart';

class QrQuietZone extends StatelessWidget {
  const QrQuietZone({required this.moduleCount, required this.child, super.key})
    : assert(moduleCount > 0);

  final int moduleCount;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<QrQuietZoneTheme>()!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final dimension = math.min(constraints.maxWidth, constraints.maxHeight);
        final moduleExtent = dimension / (moduleCount + theme.modules * 2);
        final quietZoneExtent = moduleExtent * theme.modules;

        return SizedBox.square(
          dimension: dimension,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(theme.radius),
            child: ColoredBox(
              color: theme.background,
              child: Padding(
                padding: EdgeInsets.all(quietZoneExtent),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
