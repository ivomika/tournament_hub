import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostLobbyParticipantViewData {
  const HostLobbyParticipantViewData({
    required this.id,
    required this.nickname,
    required this.isGuest,
  });

  final String id;
  final String nickname;
  final bool isGuest;
}

class HostOpenScreenPreview extends StatefulWidget {
  const HostOpenScreenPreview({
    this.participantNicknames = const ['Организатор', 'Гость 1'],
    this.participants,
    this.onAddGuest,
    this.onRemoveParticipant,
    this.onStartDistribution,
    this.onCancel,
    this.spectatorProjection = previewHostOpenConnectionViewData,
    this.onCopySpectatorAddress,
    this.onShareSpectatorAddress,
    this.onRetrySpectator,
    super.key,
  });

  final List<String> participantNicknames;
  final List<HostLobbyParticipantViewData>? participants;
  final ValueChanged<String>? onAddGuest;
  final ValueChanged<String>? onRemoveParticipant;
  final VoidCallback? onStartDistribution;
  final VoidCallback? onCancel;
  final HostOpenConnectionViewData spectatorProjection;
  final VoidCallback? onCopySpectatorAddress;
  final VoidCallback? onShareSpectatorAddress;
  final VoidCallback? onRetrySpectator;

  static const participantInvite = ParticipantInviteViewData(
    endpoint: 'http://192.168.1.42:8080',
    joinCode: 'FIGHT-24',
    state: ParticipantInviteState.ready,
  );

  @override
  State<HostOpenScreenPreview> createState() => _HostOpenScreenPreviewState();
}

class _HostOpenScreenPreviewState extends State<HostOpenScreenPreview> {
  final _nickname = TextEditingController();

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roster =
        widget.participants ??
        [
          for (final (index, nickname) in widget.participantNicknames.indexed)
            HostLobbyParticipantViewData(
              id: 'preview-$index',
              nickname: nickname,
              isGuest: index != 0,
            ),
        ];
    return AppShell(
      title: 'Лобби открыто',
      subtitle: 'Добавь минимум двух игроков и переходи к раздаче.',
      sectionLabel: 'ЛОББИ · ЭТАП 2 ИЗ 5',
      headerVariant: PageHeaderVariant.compact,
      actionDock: ActionDock(
        primary: DsAction(
          label: 'Начать раздачу',
          onPressed: roster.length >= 2 ? widget.onStartDistribution : null,
        ),
        secondary: [
          ActionDockAction(
            key: const Key('open-spectator-access'),
            label: 'Подключить зрителей',
            onSelected: () => showSpectatorAccessDialog(
              context,
              data: widget.spectatorProjection.spectatorAccess,
              onCopyAddress: () => widget.onCopySpectatorAddress?.call(),
              onShare: () => widget.onShareSpectatorAddress?.call(),
              onRetry: () => widget.onRetrySpectator?.call(),
            ),
          ),
        ],
        destructive: ActionDockAction(
          label: 'Отменить турнир',
          kind: ActionDockActionKind.destructive,
          confirmationTitle: 'Отменить турнир?',
          confirmationMessage: 'Турнир будет сохранён без чемпиона.',
          onSelected: widget.onCancel ?? () {},
        ),
      ),
      child: PageLayout(
        preset: PageLayoutPreset.flow,
        primary: DsSection(
          title: 'Участники',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final participant in roster) ...[
                DsInfoRow(
                  title: participant.nickname,
                  subtitle: participant.isGuest
                      ? 'Локальный гость'
                      : 'Локальный Host',
                ),
                if (participant.isGuest)
                  DsAction(
                    label: 'Удалить гостя',
                    kind: DsActionKind.secondary,
                    onPressed: widget.onRemoveParticipant == null
                        ? null
                        : () => widget.onRemoveParticipant!(participant.id),
                  ),
                const DsGap(DsSpace.sm),
              ],
            ],
          ),
        ),
        secondary: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ParticipantInviteCard(
              data: HostOpenScreenPreview.participantInvite,
              onCopyCode: () {},
              onCopyAddress: () {},
              onRetry: () {},
            ),
            const DsGap(DsSpace.lg),
            DsSection(
              title: 'Добавить гостя',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DsTextField(
                    label: 'Имя гостя',
                    controller: _nickname,
                    textInputAction: DsTextInputAction.done,
                    onSubmitted: (_) => _add(),
                  ),
                  const DsGap(DsSpace.md),
                  DsAction(label: 'Добавить', onPressed: _add),
                ],
              ),
            ),
          ],
        ),
        supporting: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HostOpenConnectionSummary(data: widget.spectatorProjection),
            const DsGap(DsSpace.lg),
            TournamentStageHeader(
              variant: TournamentStageVariant.strip,
              stage: 'Сбор участников',
              progress: '${roster.length} ИГРОКА',
              detail: 'Состав можно менять только до раздачи бойцов.',
              kind: roster.length >= 2
                  ? StatusKind.success
                  : StatusKind.warning,
            ),
          ],
        ),
      ),
    );
  }

  void _add() {
    final value = _nickname.text.trim();
    if (value.isEmpty) return;
    widget.onAddGuest?.call(value);
    _nickname.clear();
  }
}
