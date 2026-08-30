import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostDraftScreenPreview extends StatelessWidget {
  const HostDraftScreenPreview({
    this.title = 'Новый турнир',
    this.formatLabel = 'Double Elimination',
    this.onOpen,
    this.onCancel,
    super.key,
  });

  final String title;
  final String formatLabel;
  final VoidCallback? onOpen;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) => AppShell(
    title: title,
    subtitle: 'Проверь правила перед открытием лобби.',
    sectionLabel: 'ЧЕРНОВИК · ЭТАП 1 ИЗ 5',
    headerVariant: PageHeaderVariant.compact,
    actionDock: ActionDock(
      primary: DsAction(label: 'Открыть лобби', onPressed: onOpen),
      destructive: ActionDockAction(
        label: 'Отменить турнир',
        kind: ActionDockActionKind.destructive,
        confirmationTitle: 'Отменить турнир?',
        confirmationMessage: 'Факт отмены будет сохранён в истории.',
        onSelected: onCancel ?? () {},
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DsSection(
          title: 'Параметры',
          child: DsInfoRow(
            title: 'Формат',
            subtitle: '$formatLabel · ruleset v1',
          ),
        ),
        const DsGap(DsSpace.lg),
        const TournamentStageHeader(
          variant: TournamentStageVariant.strip,
          stage: 'Черновик',
          progress: 'НАСТРОЙК',
          detail: 'Правила будут зафиксированы после открытия лобби.',
        ),
      ],
    ),
  );
}
