import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostResultEntryScreenPreview extends StatelessWidget {
  const HostResultEntryScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Кто победил?',
    subtitle: 'Выбери победителя матча. Счёт для этого режима не требуется.',
    sectionLabel: 'МАТЧ 07 · ВЕРХНЯЯ СЕТКА',
    headerVariant: PageHeaderVariant.compact,
    pageActions: ResponsiveActions(
      primary: DsAction(label: 'Подтвердить победителя', onPressed: () {}),
    ),
    actionDock: ActionDock(
      primary: DsAction(label: 'Подтвердить победителя', onPressed: () {}),
      secondary: [
        ActionDockAction(label: 'Назад без изменений', onSelected: () {}),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutcomePicker(
          first: previewParticipants.first,
          second: previewParticipants[1],
          onFirstSelected: () {},
          onSecondSelected: () {},
        ),
        const DsGap(DsSpace.lg),
        const TournamentStageHeader(
          stage: 'Фиксация результата',
          progress: 'МАТЧ 07',
          detail: 'Изменение применится только после выбора победителя.',
          kind: StatusKind.warning,
        ),
      ],
    ),
  );
}
