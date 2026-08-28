import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostDraftScreenPreview extends StatelessWidget {
  const HostDraftScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Новый турнир',
    child: DsSection(
      title: 'Параметры',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DsTextField(label: 'Название'),
          const DsGap(DsSpace.md),
          const DsInfoRow(title: 'Формат', subtitle: 'Каждый с каждым'),
          const DsGap(DsSpace.md),
          DsAction(label: 'Открыть лобби', onPressed: () {}),
        ],
      ),
    ),
  );
}
