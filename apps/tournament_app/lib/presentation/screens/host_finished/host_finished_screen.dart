import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostFinishedScreenPreview extends StatelessWidget {
  const HostFinishedScreenPreview({
    this.title = 'Турнир завершён',
    this.champion = previewIvan,
    this.standings = previewStandingsRows,
    this.onMain,
    super.key,
  });

  final String title;
  final PreviewParticipant champion;
  final List<StandingRowViewData> standings;
  final VoidCallback? onMain;

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир завершён',
    subtitle: title,
    sectionLabel: 'ФИНАЛ · ЭТАП 5 ИЗ 5',
    headerVariant: PageHeaderVariant.compact,
    actionDock: ActionDock(
      primary: DsAction(label: 'На главную', onPressed: onMain),
    ),
    child: PageLayout(
      preset: PageLayoutPreset.flow,
      primary: ChampionHero(champion: champion),
      secondary: const TournamentStageHeader(
        variant: TournamentStageVariant.strip,
        stage: 'Результат зафиксирован',
        progress: 'ЗАВЕРШЁН',
        detail: 'Чемпион и полный ranking сохранены в immutable history.',
        kind: StatusKind.success,
      ),
      supporting: TournamentStandings(rows: standings),
    ),
  );
}
