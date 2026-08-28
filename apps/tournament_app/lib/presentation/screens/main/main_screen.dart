import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class MainScreenPreview extends StatelessWidget {
  const MainScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Main',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DsSection(
          title: 'Активный турнир',
          child: DsInfoRow(
            title: 'Friday Fight Night',
            subtitle: 'Running · следующий шаг доступен',
          ),
        ),
        const DsGap(DsSpace.md),
        DsFlow(
          children: [
            DsAction(label: 'Продолжить', onPressed: () {}),
            DsAction(
              label: 'Присоединиться',
              kind: DsActionKind.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ],
    ),
  );
}
