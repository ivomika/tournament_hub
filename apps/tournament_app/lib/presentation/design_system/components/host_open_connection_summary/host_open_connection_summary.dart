import 'package:flutter/material.dart';

import '../ds_info_row/ds_info_row.dart';
import '../ds_section/ds_section.dart';
import '../status_badge/status_badge.dart';
import 'host_open_connection_summary_theme.dart';
import 'host_open_connection_view_data.dart';

class HostOpenConnectionSummary extends StatelessWidget {
  const HostOpenConnectionSummary({required this.data, super.key});

  final HostOpenConnectionViewData data;

  @override
  Widget build(BuildContext context) {
    // dart format off
    final theme = Theme.of(context).extension<HostOpenConnectionSummaryTheme>()!;
    // dart format on
    return DsSection(
      title: 'Зрительский экран',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DsInfoRow(title: data.statusLabel, subtitle: data.detail),
          SizedBox(height: theme.gap),
          StatusBadge(
            label: '${data.connectedSpectators} ПОДКЛЮЧЕНО',
            kind: data.kind,
          ),
        ],
      ),
    );
  }
}
