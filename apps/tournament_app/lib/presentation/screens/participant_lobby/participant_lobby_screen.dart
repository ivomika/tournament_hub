import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ParticipantLobbyScreenPreview extends StatelessWidget {
  const ParticipantLobbyScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Friday Fight Night',
    subtitle: 'Вы подключены как участник',
    sectionLabel: 'УЧАСТНИК · ЛОББИ',
    navigationRole: AppNavigationRole.participant,
    headerVariant: PageHeaderVariant.compact,
    child: PageLayout(
      preset: PageLayoutPreset.flow,
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
      supporting: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConnectionBanner(
            state: TournamentConnectionState.connected,
            detail: 'Данные актуальны',
            synchronizedAtLabel: 'только что',
          ),
          DsGap(DsSpace.md),
          TournamentStageHeader(
            variant: TournamentStageVariant.strip,
            stage: 'Лобби открыто',
            progress: 'ОЖИДАНИЕ ХОСТА',
            detail: '6 участников в лобби · Double Elimination',
          ),
        ],
      ),
    ),
  );
}
