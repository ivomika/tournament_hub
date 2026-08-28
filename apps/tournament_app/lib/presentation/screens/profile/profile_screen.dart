import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ProfileScreenPreview extends StatelessWidget {
  const ProfileScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Профиль',
    subtitle: 'Локальная identity для турниров на этом устройстве.',
    sectionLabel: 'ИГРОК',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ProfileSummary(nickname: 'Иван', tournaments: 12, victories: 4),
        const DsGap(DsSpace.lg),
        DsSection(
          title: 'Изменить никнейм',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DsTextField(label: 'Новый никнейм'),
              const DsGap(DsSpace.md),
              DsAction(label: 'Сохранить изменения', onPressed: () {}),
            ],
          ),
        ),
      ],
    ),
  );
}
