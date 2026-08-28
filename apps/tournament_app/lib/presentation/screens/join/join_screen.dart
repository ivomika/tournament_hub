import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class JoinScreenPreview extends StatelessWidget {
  const JoinScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Войти в турнир',
    child: DsSection(
      title: 'Код лобби',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DsTextField(label: 'Код'),
          const DsGap(DsSpace.md),
          DsAction(label: 'Присоединиться', onPressed: () {}),
        ],
      ),
    ),
  );
}
