import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class SettingsScreenPreview extends StatelessWidget {
  const SettingsScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Настройки',
    subtitle: 'Внешний вид, данные и информация о приложении.',
    sectionLabel: 'СИСТЕМА',
    currentDestination: AppDestination.settings,
    child: AdaptiveSplit(
      primary: DsSection(
        title: 'Приложение',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DsInfoRow(
              title: 'Тема',
              subtitle: 'Тёмная тема Tournament Hub',
              kind: DsInfoKind.settings,
            ),
            const DsGap(DsSpace.md),
            DsAction(
              label: 'Открыть лицензии',
              kind: DsActionKind.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ),
      secondary: DangerZone(
        title: 'Сброс локальных данных',
        message: 'Профиль, активный турнир и история будут удалены с этого устройства. Перед удалением потребуется подтверждение.',
        actionLabel: 'Сбросить данные',
        onAction: () {},
      ),
    ),
  );
}
