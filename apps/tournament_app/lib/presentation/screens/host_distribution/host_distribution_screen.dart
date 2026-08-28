import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostDistributionScreenPreview extends StatelessWidget {
  const HostDistributionScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Раздача персонажей',
    child: Column(
      children: [
        DsSection(
          title: 'Назначения',
          child: DsFlow(
            children: [
              for (final participant in previewParticipants)
                ParticipantIdentity(participant: participant),
            ],
          ),
        ),
        const DsGap(DsSpace.lg),
        DsAction(label: 'Создать раунды', onPressed: () {}),
      ],
    ),
  );
}
