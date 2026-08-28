import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HistoryScreenPreview extends StatelessWidget {
  const HistoryScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => const AppShell(
    title: 'История',
    child: DsSection(
      title: 'Завершённые турниры',
      child: Column(
        children: [
          DsInfoRow(
            title: 'Friday Fight Night',
            subtitle: '8 участников · завершён',
            kind: DsInfoKind.history,
          ),
          DsGap(DsSpace.md),
          DsInfoRow(
            title: 'Weekend Cup',
            subtitle: '6 участников · завершён',
            kind: DsInfoKind.history,
          ),
        ],
      ),
    ),
  );
}
