import 'package:flutter/material.dart';

import '../ds_text/ds_text.dart';
import 'ds_info_row_theme.dart';

enum DsInfoKind { tournament, history, profile, participant, settings }

class DsInfoRow extends StatelessWidget {
  const DsInfoRow({
    required this.title,
    required this.subtitle,
    this.kind = DsInfoKind.tournament,
    super.key,
  });

  final String title;
  final String subtitle;
  final DsInfoKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsInfoRowTheme>()!;
    return Row(
      children: [
        Icon(switch (kind) {
          DsInfoKind.tournament => Icons.emoji_events_outlined,
          DsInfoKind.history => Icons.history,
          DsInfoKind.profile => Icons.person_outline,
          DsInfoKind.participant => Icons.sports_martial_arts,
          DsInfoKind.settings => Icons.settings_outlined,
        }, color: theme.iconColor),
        SizedBox(width: theme.gap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DsText(title, variant: DsTextVariant.title),
              DsText(subtitle, variant: DsTextVariant.secondary),
            ],
          ),
        ),
      ],
    );
  }
}
