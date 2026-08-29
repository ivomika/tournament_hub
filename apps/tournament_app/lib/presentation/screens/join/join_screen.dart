import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class JoinScreenPreview extends StatelessWidget {
  const JoinScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Войти в турнир',
    subtitle: 'Подключение к хосту в локальной сети',
    sectionLabel: 'УЧАСТНИК',
    navigationRole: AppNavigationRole.participant,
    headerVariant: PageHeaderVariant.compact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdaptiveSplit(
          primary: ParticipantJoinPanel(
            data: const ParticipantJoinViewData(
              state: ParticipantJoinState.idle,
            ),
            onScan: () {},
            onSubmit: (_) {},
            onRetry: () {},
          ),
          secondary: const DsSection(
            title: 'Перед подключением',
            child: DsText(
              'Устройство должно быть в той же локальной сети. Хост остаётся единственным источником состояния турнира.',
              variant: DsTextVariant.secondary,
            ),
          ),
        ),
        const DsGap(DsSpace.lg),
        const ConnectionBanner(
          state: TournamentConnectionState.disconnected,
          detail: 'Подключение ещё не начато',
        ),
      ],
    ),
  );
}
