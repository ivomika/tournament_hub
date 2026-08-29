import 'package:flutter/material.dart';

import '../ds_action/ds_action.dart';
import '../ds_flow/ds_flow.dart';
import '../ds_text/ds_text.dart';
import '../qr_code/qr_code.dart';
import '../status_badge/status_badge.dart';
import 'participant_invite_card_theme.dart';
import 'participant_invite_view_data.dart';

class ParticipantInviteCard extends StatelessWidget {
  const ParticipantInviteCard({
    required this.data,
    this.onCopyCode,
    this.onCopyAddress,
    this.onRetry,
    super.key,
  });

  final ParticipantInviteViewData data;
  final VoidCallback? onCopyCode;
  final VoidCallback? onCopyAddress;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ParticipantInviteCardTheme>()!;
    final presentation = _presentation(data.state);

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Приглашение участника. ${presentation.label}.',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.background,
          border: Border.all(color: theme.border),
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: Padding(
          padding: EdgeInsets.all(theme.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: theme.compactGap,
                runSpacing: theme.compactGap,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const DsText(
                    'УЧАСТНИК · ВХОД В ЛОББИ',
                    variant: DsTextVariant.label,
                  ),
                  StatusBadge(
                    label: presentation.label,
                    kind: presentation.kind,
                  ),
                ],
              ),
              SizedBox(height: theme.gap),
              LayoutBuilder(
                builder: (context, constraints) {
                  final compact =
                      constraints.maxWidth < theme.compactBreakpoint;
                  final qr = QrCode(
                    key: const Key('participant-invite-qr'),
                    value: data.endpoint,
                    semanticLabel: 'QR-код для входа участника. Код и адрес доступны рядом.',
                    unavailableLabel:
                        '${presentation.label}. QR-код участника недоступен.',
                    state: presentation.scannable
                        ? QrCodeState.scannable
                        : QrCodeState.unavailable,
                    size: compact ? QrCodeSize.compact : QrCodeSize.standard,
                  );
                  final details = _InviteDetails(
                    data: data,
                    presentation: presentation,
                    onCopyCode: onCopyCode,
                    onCopyAddress: onCopyAddress,
                    onRetry: onRetry,
                  );

                  if (compact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(child: qr),
                        SizedBox(height: theme.gap),
                        details,
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      qr,
                      SizedBox(width: theme.gap),
                      Expanded(child: details),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InviteDetails extends StatelessWidget {
  const _InviteDetails({
    required this.data,
    required this.presentation,
    required this.onCopyCode,
    required this.onCopyAddress,
    required this.onRetry,
  });

  final ParticipantInviteViewData data;
  final _ParticipantInvitePresentation presentation;
  final VoidCallback? onCopyCode;
  final VoidCallback? onCopyAddress;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ParticipantInviteCardTheme>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DsText('Пригласите игроков', variant: DsTextVariant.heading),
        SizedBox(height: theme.compactGap),
        DsText(presentation.description, variant: DsTextVariant.secondary),
        SizedBox(height: theme.gap),
        const DsText('Код входа', variant: DsTextVariant.label),
        SizedBox(height: theme.compactGap),
        Semantics(
          label: 'Код входа: ${data.joinCode}',
          child: ExcludeSemantics(
            child: SelectableText(data.joinCode, style: theme.codeStyle),
          ),
        ),
        SizedBox(height: theme.compactGap),
        const DsText('Адрес для ручного ввода', variant: DsTextVariant.label),
        SizedBox(height: theme.compactGap),
        Semantics(
          label: 'Адрес для входа участника: ${data.endpoint}',
          child: ExcludeSemantics(child: SelectableText(data.endpoint)),
        ),
        SizedBox(height: theme.gap),
        DsFlow(children: _actions()),
      ],
    );
  }

  List<Widget> _actions() => switch (data.state) {
    ParticipantInviteState.ready || ParticipantInviteState.stale => [
      DsAction(label: 'Копировать код', onPressed: onCopyCode),
      DsAction(
        label: 'Копировать адрес',
        kind: DsActionKind.secondary,
        onPressed: onCopyAddress,
      ),
    ],
    ParticipantInviteState.starting => const [
      DsAction(label: 'Готовим приглашение', status: DsActionStatus.loading),
    ],
    ParticipantInviteState.unavailable || ParticipantInviteState.error => [
      DsAction(label: 'Попробовать снова', onPressed: onRetry),
    ],
  };
}

class _ParticipantInvitePresentation {
  const _ParticipantInvitePresentation({
    required this.label,
    required this.description,
    required this.kind,
    required this.scannable,
  });

  final String label;
  final String description;
  final StatusKind kind;
  final bool scannable;
}

_ParticipantInvitePresentation _presentation(
  ParticipantInviteState state,
) => switch (state) {
  ParticipantInviteState.starting => const _ParticipantInvitePresentation(
    label: 'Готовим вход',
    description: 'Локальный адрес появится после запуска приглашения.',
    kind: StatusKind.info,
    scannable: false,
  ),
  ParticipantInviteState.ready => const _ParticipantInvitePresentation(
    label: 'Можно подключаться',
    description: 'Игрок сканирует QR или вводит тот же адрес вручную.',
    kind: StatusKind.success,
    scannable: true,
  ),
  ParticipantInviteState.stale => const _ParticipantInvitePresentation(
    label: 'Адрес мог измениться',
    description: 'Перед новым входом проверьте адрес локальной сети.',
    kind: StatusKind.warning,
    scannable: false,
  ),
  ParticipantInviteState.unavailable => const _ParticipantInvitePresentation(
    label: 'Вход недоступен',
    description: 'Host пока не подготовил локальный адрес.',
    kind: StatusKind.neutral,
    scannable: false,
  ),
  ParticipantInviteState.error => const _ParticipantInvitePresentation(
    label: 'Не удалось открыть вход',
    description: 'Турнир сохранён. Попробуйте подготовить приглашение снова.',
    kind: StatusKind.danger,
    scannable: false,
  ),
};
