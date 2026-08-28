import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class RegistrationScreenPreview extends StatelessWidget {
  const RegistrationScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Registration',
    child: DsSection(
      title: 'Создание профиля',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DsTextField(label: 'Никнейм'),
          const DsGap(DsSpace.md),
          DsAction(label: 'Продолжить', onPressed: () {}),
        ],
      ),
    ),
  );
}
