import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class RecoverableErrorScreenPreview extends StatelessWidget {
  const RecoverableErrorScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Подключение прервано',
    subtitle: 'Локальные данные в безопасности',
    sectionLabel: 'ВОССТАНОВЛЕНИЕ',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConnectionBanner(
          state: TournamentConnectionState.incompatible,
          detail: 'Обновите приложение на обоих устройствах',
          onAction: () {},
        ),
        const DsGap(DsSpace.lg),
        TournamentEmptyState(
          title: 'Не удалось загрузить турнир',
          message: 'Обновите приложение или вернитесь на главную. Технические данные подключения не публикуются.',
          actionLabel: 'Повторить подключение',
          onAction: () {},
          isError: true,
        ),
        const DsGap(DsSpace.md),
        DsFlow(
          children: [
            DsAction(
              label: 'На главную',
              kind: DsActionKind.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ],
    ),
  );
}
