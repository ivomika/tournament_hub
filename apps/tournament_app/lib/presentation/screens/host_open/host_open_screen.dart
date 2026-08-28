import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostOpenScreenPreview extends StatelessWidget {
  const HostOpenScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Лобби открыто',
    child: Column(
      children: [
        ConnectionBanner(
          message: 'Код: FIGHT-24',
          kind: StatusKind.success,
          actionLabel: 'Копировать',
          onAction: () {},
        ),
        const DsGap(DsSpace.lg),
        DsSection(
          title: 'Участники',
          child: DsFlow(
            children: [
              for (final participant in previewParticipants)
                ParticipantIdentity(participant: participant),
            ],
          ),
        ),
        const DsGap(DsSpace.lg),
        DsAction(label: 'Начать раздачу', onPressed: () {}),
      ],
    ),
  );
}
