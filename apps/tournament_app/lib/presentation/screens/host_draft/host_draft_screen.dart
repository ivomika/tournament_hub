import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostDraftScreenPreview extends StatelessWidget {
  const HostDraftScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Новый турнир',
    subtitle: 'Настрой правила до открытия лобби — после этого они неизменны.',
    sectionLabel: 'ЧЕРНОВИК · ЭТАП 1 ИЗ 5',
    headerVariant: PageHeaderVariant.compact,
    actionDock: ActionDock(
      primary: DsAction(label: 'Открыть лобби', onPressed: () {}),
      destructive: ActionDockAction(
        label: 'Удалить черновик',
        kind: ActionDockActionKind.destructive,
        confirmationTitle: 'Удалить черновик?',
        confirmationMessage:
            'Настройки турнира будут удалены без возможности восстановления.',
        onSelected: () {},
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DsSection(
          title: 'Параметры',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DsTextField(
                label: 'Название',
                helperText: 'Его увидят все участники',
                textInputAction: DsTextInputAction.done,
              ),
              const DsGap(DsSpace.md),
              const DsInfoRow(title: 'Формат', subtitle: 'Double Elimination'),
            ],
          ),
        ),
        const DsGap(DsSpace.lg),
        const TournamentStageHeader(
          variant: TournamentStageVariant.strip,
          stage: 'Черновик',
          progress: 'НАСТРОЙКА',
          detail: 'Название, формат и правила ещё можно изменить.',
        ),
      ],
    ),
  );
}
