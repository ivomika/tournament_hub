import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostOpenScreenPreview extends StatelessWidget {
  const HostOpenScreenPreview({
    this.spectatorProjection = previewHostOpenConnectionViewData,
    this.onCopySpectatorAddress,
    this.onShareSpectatorAddress,
    this.onRetrySpectator,
    super.key,
  });

  final HostOpenConnectionViewData spectatorProjection;
  final VoidCallback? onCopySpectatorAddress;
  final VoidCallback? onShareSpectatorAddress;
  final VoidCallback? onRetrySpectator;

  static const _participantInvite = ParticipantInviteViewData(
    endpoint: 'http://192.168.1.42:8080',
    joinCode: 'FIGHT-24',
    state: ParticipantInviteState.ready,
  );
  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Лобби открыто',
      subtitle: 'Добавь минимум двух игроков и переходи к раздаче персонажей.',
      sectionLabel: 'ЛОББИ ОТКРЫТО · ЭТАП 2 ИЗ 5',
      headerVariant: PageHeaderVariant.compact,
      actionDock: ActionDock(
        primary: DsAction(label: 'Начать раздачу', onPressed: () {}),
        secondary: [
          ActionDockAction(
            key: const Key('open-spectator-access'),
            label: 'Подключить зрителей',
            onSelected: () => showSpectatorAccessDialog(
              context,
              data: spectatorProjection.spectatorAccess,
              onCopyAddress: () => onCopySpectatorAddress?.call(),
              onShare: () => onShareSpectatorAddress?.call(),
              onRetry: () => onRetrySpectator?.call(),
            ),
          ),
          ActionDockAction(label: 'Добавить гостя', onSelected: () {}),
        ],
        destructive: ActionDockAction(
          label: 'Отменить турнир',
          kind: ActionDockActionKind.destructive,
          confirmationTitle: 'Отменить турнир?',
          confirmationMessage: 'Лобби будет закрыто, а турнир сохранится в истории как отменённый.',
          onSelected: () {},
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdaptiveSplit(
            primary: DsSection(
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
            secondary: ParticipantInviteCard(
              data: _participantInvite,
              onCopyCode: () {},
              onCopyAddress: () {},
              onRetry: () {},
            ),
          ),
          const DsGap(DsSpace.lg),
          const TournamentStageHeader(
            stage: 'Сбор участников',
            progress: '4 ИГРОКА',
            detail: 'Настройки турнира зафиксированы. Состав ещё можно менять.',
            kind: StatusKind.success,
          ),
          const DsGap(DsSpace.lg),
          HostOpenConnectionSummary(data: spectatorProjection),
        ],
      ),
    );
  }
}
