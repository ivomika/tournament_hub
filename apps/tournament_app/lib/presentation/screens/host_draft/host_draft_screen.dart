import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostDraftScreenPreview extends StatelessWidget {
  const HostDraftScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Новый турнир',
    subtitle: 'Настрой правила до открытия лобби — после этого они неизменны.',
    sectionLabel: 'ЧЕРНОВИК · ЭТАП 1 ИЗ 5',
    pageActions: ResponsiveActions(
      primary: DsAction(label: 'Открыть лобби', onPressed: () {}),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TournamentStageHeader(
          stage: 'Черновик',
          progress: 'НАСТРОЙКА',
          detail: 'Название, формат и правила ещё можно изменить.',
        ),
        const DsGap(DsSpace.lg),
        AdaptiveSplit(
          primary: DsSection(
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
                const DsInfoRow(
                  title: 'Формат',
                  subtitle: 'Double Elimination',
                ),
              ],
            ),
          ),
          secondary: DangerZone(
            title: 'Отменить создание',
            message: 'Черновик будет удалён после подтверждения.',
            actionLabel: 'Удалить черновик',
            onAction: () {},
          ),
        ),
      ],
    ),
  );
}
