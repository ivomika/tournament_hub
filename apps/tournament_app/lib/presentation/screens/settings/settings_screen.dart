import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class SettingsScreenPreview extends StatelessWidget {
  const SettingsScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Настройки',
    child: DsSection(
      title: 'Приложение',
      child: Column(
        children: [
          const DsInfoRow(
            title: 'Тема',
            subtitle: 'Тёмная',
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
  );
}
