import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostFinishedScreenPreview extends StatelessWidget {
  const HostFinishedScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир завершён',
    subtitle: 'Friday Fight Night · Double Elimination',
    sectionLabel: 'ФИНАЛ',
    headerVariant: PageHeaderVariant.compact,
    actionDock: ActionDock(
      primary: DsAction(label: 'На главную', onPressed: () {}),
      secondary: [
        ActionDockAction(label: 'Открыть историю', onSelected: () {}),
      ],
    ),
    child: PageLayout(
      preset: PageLayoutPreset.hero,
      primary: ChampionHero(champion: previewParticipants.first),
      secondary: const TournamentStandings(),
      supporting: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TournamentStageHeader(
            stage: 'Результат зафиксирован',
            progress: 'ЗАВЕРШЁН',
            detail: 'Турнир доступен только для чтения и сохранён в истории.',
            kind: StatusKind.success,
          ),
          DsGap(DsSpace.lg),
          TournamentBracketPreview(),
        ],
      ),
    ),
  );
}
