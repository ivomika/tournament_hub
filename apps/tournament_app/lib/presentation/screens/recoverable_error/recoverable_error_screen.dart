import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class RecoverableErrorScreenPreview extends StatelessWidget {
  const RecoverableErrorScreenPreview({
    this.isFatal = false,
    this.onRetry,
    super.key,
  });

  final bool isFatal;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => AppShell(
    title: isFatal ? 'Не удалось запустить приложение' : 'Подключение прервано',
    subtitle: isFatal
        ? 'Безопасное продолжение невозможно'
        : 'Локальные данные в безопасности',
    sectionLabel: 'ВОССТАНОВЛЕНИЕ',
    navigationRole: AppNavigationRole.focused,
    headerVariant: PageHeaderVariant.compact,
    pageActions: isFatal
        ? null
        : ResponsiveActions(
            primary: DsAction(
              label: 'Проверить снова',
              onPressed: onRetry ?? () {},
            ),
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
          title: isFatal
              ? 'Локальное состояние недоступно'
              : 'Не удалось загрузить турнир',
          message: isFatal
              ? 'Закройте приложение и проверьте локальное хранилище перед повторным запуском.'
              : 'Обновите приложение или вернитесь на главную. Технические данные подключения не публикуются.',
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
