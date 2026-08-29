import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ParticipantDistributionScreenPreview extends StatelessWidget {
  const ParticipantDistributionScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Персонаж определён',
    subtitle: 'Friday Fight Night · случайная раздача завершена',
    sectionLabel: 'УЧАСТНИК · РАЗДАЧА',
    navigationRole: AppNavigationRole.participant,
    headerVariant: PageHeaderVariant.compact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DsSurface(
          tone: DsSurfaceTone.accent,
          child: ParticipantIdentity(
            participant: previewParticipants.first,
            artworkVariant: FighterArtworkVariant.hero,
          ),
        ),
        const DsGap(DsSpace.lg),
        const ConnectionBanner(
          state: TournamentConnectionState.connected,
          detail: 'Данные актуальны',
          synchronizedAtLabel: 'только что',
        ),
        const DsGap(DsSpace.md),
        const TournamentStageHeader(
          stage: 'Распределение',
          progress: 'ОЖИДАЕМ СЕТКУ',
          detail: 'Хост формирует случайный seeding и запускает турнир.',
        ),
      ],
    ),
  );
}
