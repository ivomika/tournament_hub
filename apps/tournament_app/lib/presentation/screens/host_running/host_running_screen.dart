import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostRunningScreenPreview extends StatefulWidget {
  const HostRunningScreenPreview({super.key});

  @override
  State<HostRunningScreenPreview> createState() =>
      _HostRunningScreenPreviewState();
}

class _HostRunningScreenPreviewState extends State<HostRunningScreenPreview> {
  final _currentMatchKey = GlobalKey();
  final _structureKey = GlobalKey();

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир идёт',
    subtitle: 'Double Elimination · Верхняя сетка · Раунд 2',
    sectionLabel: 'FRIDAY FIGHT NIGHT',
    headerVariant: PageHeaderVariant.compact,
    actionDock: ActionDock(
      primary: DsAction(label: 'Ввести результат', onPressed: () {}),
      contextual: ActionDockAction(
        key: const Key('host-running-current-jump'),
        label: 'К текущему бою',
        onSelected: () => _scrollTo(_currentMatchKey),
      ),
      secondary: [
        ActionDockAction(
          label: 'К структуре',
          onSelected: () => _scrollTo(_structureKey),
        ),
      ],
    ),
    child: PageLayout(
      preset: PageLayoutPreset.flow,
      primary: KeyedSubtree(
        key: _currentMatchKey,
        child: TournamentMatchCard(
          title: 'Матч 07 · Верхняя сетка',
          first: previewParticipants.first,
          second: previewParticipants[1],
          isCurrent: true,
        ),
      ),
      secondary: const TournamentStageHeader(
        variant: TournamentStageVariant.strip,
        stage: 'Турнир идёт',
        progress: 'МАТЧ 7 ИЗ 15',
        detail: 'Текущий матч — единственное доступное спортивное действие.',
        kind: StatusKind.warning,
      ),
      supporting: KeyedSubtree(
        key: _structureKey,
        child: const TournamentBracketPreview(completedPreviewCount: 3),
      ),
    ),
  );

  void _scrollTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(target, alignment: 0.04);
  }
}
