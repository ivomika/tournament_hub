import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class MainScreenPreview extends StatelessWidget {
  const MainScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Твой турнирный центр',
    subtitle: 'Продолжи активную сетку или начни новую игровую ночь.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TournamentSummary(
          tournamentName: 'Friday Fight Night',
          stage: 'Double Elimination · Верхняя сетка · Раунд 2',
          first: previewParticipants.first,
          second: previewParticipants[1],
          onContinue: () {},
        ),
        const DsGap(DsSpace.lg),
        DsSection(
          title: 'Новая игровая ночь',
          child: DsFlow(
            children: [
              DsAction(
                label: 'Создать турнир',
                kind: DsActionKind.secondary,
                onPressed: () {},
              ),
              DsAction(
                label: 'Присоединиться',
                kind: DsActionKind.text,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
