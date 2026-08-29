import 'package:flutter/material.dart';

import '../ds_action/ds_action.dart';
import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../status_badge/status_badge.dart';
import 'connection_banner_theme.dart';

enum TournamentConnectionState {
  connected,
  reconnecting,
  stale,
  disconnected,
  incompatible,
  retrying,
}

class ConnectionBanner extends StatelessWidget {
  const ConnectionBanner({
    required this.state,
    this.detail,
    this.synchronizedAtLabel,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final TournamentConnectionState state;
  final String? detail;
  final String? synchronizedAtLabel;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ConnectionBannerTheme>()!;
    final presentation = _presentationFor(state);
    final status = StatusBadge(
      label: presentation.label,
      kind: presentation.kind,
    );
    final effectiveActionLabel = actionLabel ?? presentation.actionLabel;
    final action = onAction == null || effectiveActionLabel == null
        ? null
        : DsAction(
            label: effectiveActionLabel,
            kind: DsActionKind.text,
            status: state == TournamentConnectionState.retrying
                ? DsActionStatus.loading
                : DsActionStatus.idle,
            onPressed: onAction,
          );
    final contextCopy = <Widget>[
      if (detail != null) DsText(detail!, variant: DsTextVariant.secondary),
      if (synchronizedAtLabel != null)
        DsText(
          'Обновлено: $synchronizedAtLabel',
          variant: DsTextVariant.secondary,
        ),
    ];
    return Semantics(
      container: true,
      explicitChildNodes: true,
      liveRegion: state != TournamentConnectionState.connected,
      label: [
        presentation.label,
        ?detail,
        if (synchronizedAtLabel != null) 'Обновлено: $synchronizedAtLabel',
      ].join('. '),
      child: DsSurface(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth <= theme.compactWidth;
            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                status,
                for (final item in contextCopy) ...[
                  SizedBox(height: theme.gap),
                  item,
                ],
              ],
            );
            if (compact || action == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  copy,
                  if (action != null) ...[SizedBox(height: theme.gap), action],
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: copy),
                SizedBox(width: theme.gap),
                action,
              ],
            );
          },
        ),
      ),
    );
  }
}

({String label, StatusKind kind, String? actionLabel}) _presentationFor(
  TournamentConnectionState state,
) => switch (state) {
  TournamentConnectionState.connected => (
    label: 'Подключено',
    kind: StatusKind.success,
    actionLabel: null,
  ),
  TournamentConnectionState.reconnecting => (
    label: 'Восстанавливаем связь',
    kind: StatusKind.info,
    actionLabel: 'Отменить',
  ),
  TournamentConnectionState.stale => (
    label: 'Данные устарели',
    kind: StatusKind.warning,
    actionLabel: 'Переподключиться',
  ),
  TournamentConnectionState.disconnected => (
    label: 'Нет подключения',
    kind: StatusKind.neutral,
    actionLabel: 'Повторить',
  ),
  TournamentConnectionState.incompatible => (
    label: 'Версия приложения несовместима',
    kind: StatusKind.danger,
    actionLabel: 'Проверить снова',
  ),
  TournamentConnectionState.retrying => (
    label: 'Повторяем подключение',
    kind: StatusKind.info,
    actionLabel: 'Подключение',
  ),
};
