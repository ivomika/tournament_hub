import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostFinishedScreenPreview extends StatefulWidget {
  const HostFinishedScreenPreview({super.key});

  @override
  State<HostFinishedScreenPreview> createState() =>
      _HostFinishedScreenPreviewState();
}

class _HostFinishedScreenPreviewState extends State<HostFinishedScreenPreview> {
  final _resultsKey = GlobalKey();
  final _structureKey = GlobalKey();

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир завершён',
    subtitle: 'Friday Fight Night · Double Elimination',
    sectionLabel: 'ФИНАЛ',
    headerVariant: PageHeaderVariant.compact,
    actionDock: ActionDock(
      primary: DsAction(label: 'На главную', onPressed: () {}),
      contextual: ActionDockAction(
        key: const Key('host-finished-results-jump'),
        label: 'К итогам',
        onSelected: () => _scrollTo(_resultsKey),
      ),
      secondary: [
        ActionDockAction(label: 'Открыть историю', onSelected: () {}),
        ActionDockAction(
          label: 'К структуре',
          onSelected: () => _scrollTo(_structureKey),
        ),
      ],
    ),
    child: PageLayout(
      preset: PageLayoutPreset.flow,
      primary: ChampionHero(champion: previewParticipants.first),
      secondary: const TournamentStageHeader(
        variant: TournamentStageVariant.strip,
        stage: 'Результат зафиксирован',
        progress: 'ЗАВЕРШЁН',
        detail: 'Турнир доступен только для чтения и сохранён в истории.',
        kind: StatusKind.success,
      ),
      supporting: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KeyedSubtree(key: _resultsKey, child: const TournamentStandings()),
          const DsGap(DsSpace.lg),
          KeyedSubtree(
            key: _structureKey,
            child: const TournamentBracketPreview(completedPreviewCount: 3),
          ),
        ],
      ),
    ),
  );

  void _scrollTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(target, alignment: 0.04);
  }
}
