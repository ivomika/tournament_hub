import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ProfileScreenPreview extends StatelessWidget {
  const ProfileScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => const AppShell(
    title: 'Профиль',
    child: DsSection(
      title: 'Данные игрока',
      child: DsInfoRow(
        title: 'Иван',
        subtitle: '12 турниров · 4 победы',
        kind: DsInfoKind.profile,
      ),
    ),
  );
}
