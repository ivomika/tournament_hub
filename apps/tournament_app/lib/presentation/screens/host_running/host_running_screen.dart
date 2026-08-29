import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostRunningScreenPreview extends StatelessWidget {
  const HostRunningScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир идёт',
    subtitle: 'Double Elimination · Верхняя сетка · Раунд 2',
    sectionLabel: 'FRIDAY FIGHT NIGHT',
    headerVariant: PageHeaderVariant.compact,
    pageActions: ResponsiveActions(
      primary: DsAction(label: 'Определить победителя', onPressed: () {}),
    ),
    actionDock: ActionDock(
      primary: DsAction(label: 'Ввести результат', onPressed: () {}),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdaptiveSplit(
          primary: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TournamentMatchCard(
                title: 'Матч 07 · Верхняя сетка',
                first: previewParticipants.first,
                second: previewParticipants[1],
                isCurrent: true,
              ),
            ],
          ),
          secondary: const TournamentBracketPreview(),
        ),
        const DsGap(DsSpace.lg),
        const TournamentStageHeader(
          stage: 'Турнир идёт',
          progress: 'МАТЧ 7 ИЗ 15',
          detail: 'Текущий матч — единственное доступное спортивное действие.',
          kind: StatusKind.warning,
        ),
      ],
    ),
  );
}
