import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostOpenScreenPreview extends StatelessWidget {
  const HostOpenScreenPreview({super.key});

  static const _participantInvite = ParticipantInviteViewData(
    endpoint: 'http://192.168.1.42:8080',
    joinCode: 'FIGHT-24',
    state: ParticipantInviteState.ready,
  );
  static const _spectatorAccess = SpectatorAccessViewData(
    endpoint: 'http://192.168.1.42:8080',
    state: ConnectionQrState.ready,
    connectedClients: 0,
  );

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Лобби открыто',
    subtitle: 'Добавь минимум двух игроков и переходи к раздаче персонажей.',
    sectionLabel: 'ЛОББИ ОТКРЫТО · ЭТАП 2 ИЗ 5',
    pageActions: ResponsiveActions(
      primary: DsAction(label: 'Начать раздачу', onPressed: () {}),
      secondary: [
        DsAction(
          key: const Key('open-spectator-access'),
          label: 'Подключить зрителей',
          kind: DsActionKind.secondary,
          onPressed: () => showSpectatorAccessDialog(
            context,
            data: _spectatorAccess,
            onCopyAddress: () {},
            onShare: () {},
            onRetry: () {},
          ),
        ),
        DsAction(
          label: 'Добавить гостя',
          kind: DsActionKind.secondary,
          onPressed: () {},
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TournamentStageHeader(
          stage: 'Сбор участников',
          progress: '4 ИГРОКА',
          detail: 'Настройки турнира зафиксированы. Состав ещё можно менять.',
          kind: StatusKind.success,
        ),
        const DsGap(DsSpace.lg),
        AdaptiveSplit(
          primary: ParticipantInviteCard(
            data: _participantInvite,
            onCopyCode: () {},
            onCopyAddress: () {},
            onRetry: () {},
          ),
          secondary: DsSection(
            title: 'Участники',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final participant in previewParticipants) ...[
                  ParticipantIdentity(participant: participant),
                  const DsGap(DsSpace.sm),
                ],
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
