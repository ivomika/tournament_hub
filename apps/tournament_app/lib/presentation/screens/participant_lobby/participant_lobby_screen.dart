import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ParticipantLobbyScreenPreview extends StatelessWidget {
  const ParticipantLobbyScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => const AppShell(
    title: 'Лобби',
    child: Column(
      children: [
        ConnectionBanner(message: 'Подключено', kind: StatusKind.success),
        DsGap(DsSpace.lg),
        DsSection(
          title: 'Ожидание хоста',
          child: DsText(
            'Хост скоро начнёт раздачу персонажей.',
            variant: DsTextVariant.secondary,
          ),
        ),
      ],
    ),
  );
}
