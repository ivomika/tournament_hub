import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ParticipantLobbyScreenPreview extends StatelessWidget {
  const ParticipantLobbyScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Friday Fight Night',
    subtitle: 'Вы подключены как участник',
    sectionLabel: 'PARTICIPANT · ЛОББИ',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ConnectionBanner(
          message: 'Подключено · данные актуальны',
          kind: StatusKind.success,
        ),
        const DsGap(DsSpace.lg),
        const TournamentStageHeader(
          stage: 'Лобби открыто',
          progress: 'ОЖИДАНИЕ ХОСТА',
          detail: '6 участников в лобби · Double Elimination',
        ),
        const DsGap(DsSpace.lg),
        AdaptiveSplit(
          primary: DsSection(
            title: 'Вы в турнире',
            child: ParticipantIdentity(participant: previewParticipants.first),
          ),
          secondary: const DsSection(
            title: 'Что дальше',
            child: DsText(
              'Хост закроет набор и запустит случайную раздачу персонажей. Здесь не требуется никаких действий.',
              variant: DsTextVariant.secondary,
            ),
          ),
        ),
      ],
    ),
  );
}
