import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import 'profile_summary_theme.dart';

class ProfileSummary extends StatelessWidget {
  const ProfileSummary({
    required this.nickname,
    required this.tournaments,
    required this.victories,
    super.key,
  });

  final String nickname;
  final int tournaments;
  final int victories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ProfileSummaryTheme>()!;
    final avatar = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.iconBackground,
        shape: BoxShape.circle,
      ),
      child: SizedBox.square(
        dimension: theme.iconSize,
        child: Icon(Icons.person, color: theme.iconColor),
      ),
    );
    final identity = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DsText('ЛОКАЛЬНЫЙ ПРОФИЛЬ', variant: DsTextVariant.label),
        SizedBox(height: theme.gap),
        DsText(nickname, variant: DsTextVariant.heading, maxLines: 2),
      ],
    );
    final stats = Wrap(
      spacing: theme.gap,
      runSpacing: theme.gap,
      children: [
        _ProfileMetric(value: '$tournaments', label: 'турниров'),
        _ProfileMetric(value: '$victories', label: 'победы'),
      ],
    );
    return DsSurface(
      tone: DsSurfaceTone.accent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < theme.compactBreakpoint) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatar,
                SizedBox(height: theme.gap),
                identity,
                SizedBox(height: theme.gap),
                stats,
              ],
            );
          }
          return Row(
            children: [
              avatar,
              SizedBox(width: theme.gap),
              Expanded(child: identity),
              SizedBox(width: theme.gap),
              stats,
            ],
          );
        },
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DsText(value, variant: DsTextVariant.title),
      DsText(label, variant: DsTextVariant.secondary),
    ],
  );
}
