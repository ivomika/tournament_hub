import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class RecoverableErrorScreenPreview extends StatelessWidget {
  const RecoverableErrorScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Подключение прервано',
    subtitle: 'Локальные данные в безопасности',
    sectionLabel: 'ВОССТАНОВЛЕНИЕ',
    headerVariant: PageHeaderVariant.compact,
    pageActions: ResponsiveActions(
      primary: DsAction(label: 'Проверить снова', onPressed: () {}),
      secondary: [
        DsAction(
          label: 'На главную',
          kind: DsActionKind.secondary,
          onPressed: () {},
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TournamentEmptyState(
          title: 'Не удалось загрузить турнир',
          message: 'Обновите приложение или вернитесь на главную. Технические данные подключения не публикуются.',
          isError: true,
        ),
        const DsGap(DsSpace.lg),
        ConnectionBanner(
          state: TournamentConnectionState.incompatible,
          detail: 'Обновите приложение на обоих устройствах',
        ),
      ],
    ),
  );
}
