import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class JoinScreenPreview extends StatelessWidget {
  const JoinScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Войти в турнир',
    subtitle: 'Подключение к хосту в локальной сети',
    sectionLabel: 'PARTICIPANT',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ConnectionBanner(
          message: 'Подключение не начато',
          kind: StatusKind.neutral,
        ),
        const DsGap(DsSpace.lg),
        AdaptiveSplit(
          primary: DsSection(
            title: 'Код лобби',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const DsTextField(
                  label: 'Код с экрана хоста',
                  helperText: 'Например, FIGHT-24',
                  textInputAction: DsTextInputAction.done,
                ),
                const DsGap(DsSpace.md),
                DsAction(label: 'Присоединиться', onPressed: () {}),
              ],
            ),
          ),
          secondary: const DsSection(
            title: 'Перед подключением',
            child: DsText(
              'Устройство должно быть в той же локальной сети. Хост остаётся единственным источником состояния турнира.',
              variant: DsTextVariant.secondary,
            ),
          ),
        ),
      ],
    ),
  );
}
