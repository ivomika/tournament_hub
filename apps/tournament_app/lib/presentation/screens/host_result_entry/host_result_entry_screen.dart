import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostResultEntryScreenPreview extends StatelessWidget {
  const HostResultEntryScreenPreview({
    this.first = previewIvan,
    this.second = previewMira,
    this.matchLabel = 'ТЕКУЩИЙ МАТЧ',
    this.firstTo = 1,
    this.onFirstSelected,
    this.onSecondSelected,
    this.onFirstScoreSelected,
    this.onSecondScoreSelected,
    this.onBack,
    super.key,
  });

  final PreviewParticipant first;
  final PreviewParticipant second;
  final String matchLabel;
  final int firstTo;
  final VoidCallback? onFirstSelected;
  final VoidCallback? onSecondSelected;
  final ValueChanged<int>? onFirstScoreSelected;
  final ValueChanged<int>? onSecondScoreSelected;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Кто победил?',
    subtitle:
        'Каждая битва имеет собственный счёт. Выбери победителя и фактический результат серии FT$firstTo.',
    sectionLabel: matchLabel,
    headerVariant: PageHeaderVariant.compact,
    actionDock: ActionDock(
      primary: const DsAction(label: 'Выбери победителя'),
      secondary: [
        ActionDockAction(
          label: 'Назад без изменений',
          onSelected: onBack ?? () {},
        ),
      ],
    ),
    child: PageLayout(
      preset: PageLayoutPreset.flow,
      primary: OutcomePicker(
        first: first,
        second: second,
        firstTo: firstTo,
        onFirstSelected: onFirstSelected,
        onSecondSelected: onSecondSelected,
        onFirstScoreSelected: onFirstScoreSelected,
        onSecondScoreSelected: onSecondScoreSelected,
      ),
      secondary: const TournamentStageHeader(
        stage: 'Ввод результата',
        progress: 'МАТЧ ИДЁТ',
        detail: 'Результат сохраняется до перехода к следующей схватке.',
        variant: TournamentStageVariant.strip,
      ),
    ),
  );
}
