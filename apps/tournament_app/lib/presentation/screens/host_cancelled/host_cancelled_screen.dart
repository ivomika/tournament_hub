import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostCancelledScreenPreview extends StatelessWidget {
  const HostCancelledScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир отменён',
    subtitle: 'Friday Fight Night · отменён организатором',
    sectionLabel: 'ЗАВЕРШЁН · ТОЛЬКО ЧТЕНИЕ',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TournamentStageHeader(
          stage: 'Отменён',
          progress: 'БЕЗ ЧЕМПИОНА',
          detail: 'Состояние неизменяемо. Спортивный результат не определён.',
          kind: StatusKind.danger,
        ),
        const DsGap(DsSpace.lg),
        TournamentEmptyState(
          title: 'Турнир не состоялся',
          message:
              'Факт отмены сохранён в истории без итоговых мест и чемпиона.',
          actionLabel: 'На главную',
          onAction: () {},
        ),
      ],
    ),
  );
}
