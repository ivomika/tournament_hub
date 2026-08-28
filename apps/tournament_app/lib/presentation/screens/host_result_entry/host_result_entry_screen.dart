import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostResultEntryScreenPreview extends StatelessWidget {
  const HostResultEntryScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Кто победил?',
    subtitle: 'Выбери победителя матча. Счёт для этого режима не требуется.',
    sectionLabel: 'МАТЧ 07 · ВЕРХНЯЯ СЕТКА',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TournamentStageHeader(
          stage: 'Фиксация результата',
          progress: 'МАТЧ 07',
          detail: 'Изменение применится только после выбора победителя.',
          kind: StatusKind.warning,
        ),
        const DsGap(DsSpace.lg),
        TournamentMatchCard(
          title: 'Scorpion против Sub-Zero',
          first: previewParticipants.first,
          second: previewParticipants[1],
          identityVariant: FighterArtworkVariant.matchup,
        ),
        const DsGap(DsSpace.lg),
        OutcomePicker(
          first: previewParticipants.first,
          second: previewParticipants[1],
          onFirstSelected: () {},
          onSecondSelected: () {},
        ),
        const DsGap(DsSpace.md),
        DsAction(
          label: 'Назад без изменений',
          kind: DsActionKind.text,
          onPressed: () {},
        ),
      ],
    ),
  );
}
