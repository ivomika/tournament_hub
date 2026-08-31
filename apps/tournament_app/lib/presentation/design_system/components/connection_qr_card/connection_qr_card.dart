import 'package:flutter/material.dart';

import '../ds_action/ds_action.dart';
import '../ds_flow/ds_flow.dart';
import '../ds_text/ds_text.dart';
import '../qr_code/qr_code.dart';
import '../status_badge/status_badge.dart';
import 'connection_qr_card_theme.dart';

enum ConnectionQrState {
  starting,
  ready,
  reconnecting,
  unavailable,
  expired,
  error,
  stale,
  copied,
}

class ConnectionQrCard extends StatelessWidget {
  const ConnectionQrCard({
    required this.encodedValue,
    required this.displayAddress,
    required this.state,
    this.onCopyAddress,
    this.onShare,
    this.onRetry,
    this.qrSize,
    super.key,
  });

  final String encodedValue;
  final String displayAddress;
  final ConnectionQrState state;
  final VoidCallback? onCopyAddress;
  final VoidCallback? onShare;
  final VoidCallback? onRetry;
  final QrCodeSize? qrSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ConnectionQrCardTheme>()!;
    final presentation = _presentationFor(state, theme);

    return Semantics(
      container: true,
      explicitChildNodes: true,
      liveRegion: state != ConnectionQrState.ready,
      label: 'Подключение spectator в локальной сети. ${presentation.label}.',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.background,
          border: Border.all(color: theme.border),
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(theme.radius),
          child: Stack(
            children: [
              PositionedDirectional(
                start: 0,
                top: 0,
                bottom: 0,
                width: theme.accentWidth,
                child: ColoredBox(color: presentation.accentColor),
              ),
              Padding(
                padding: EdgeInsets.all(theme.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(presentation: presentation),
                    SizedBox(height: theme.gap),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final compact =
                            constraints.maxWidth < theme.compactBreakpoint;
                        final qr = _QrPanel(
                          encodedValue: encodedValue,
                          presentation: presentation,
                          size:
                              qrSize ??
                              (compact
                                  ? QrCodeSize.compact
                                  : QrCodeSize.standard),
                        );
                        final details = _ConnectionDetails(
                          displayAddress: displayAddress,
                          state: state,
                          presentation: presentation,
                          onCopyAddress: onCopyAddress,
                          onShare: onShare,
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
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.presentation});

  final _ConnectionQrPresentation presentation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ConnectionQrCardTheme>()!;
    return Wrap(
      spacing: theme.compactGap,
      runSpacing: theme.compactGap,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceBetween,
      children: [
        const DsText(
          'SPECTATOR · ЛОКАЛЬНАЯ СЕТЬ',
          variant: DsTextVariant.label,
        ),
        StatusBadge(label: presentation.label, kind: presentation.kind),
      ],
    );
  }
}

class _QrPanel extends StatelessWidget {
  const _QrPanel({
    required this.encodedValue,
    required this.presentation,
    required this.size,
  });

  final String encodedValue;
  final _ConnectionQrPresentation presentation;
  final QrCodeSize size;

  @override
  Widget build(BuildContext context) {
    final qrCode = QrCode(
      key: const Key('connection-qr-panel'),
      value: encodedValue,
      semanticLabel: 'QR-код подключения к spectator. Адрес также доступен для ручного ввода.',
      unavailableLabel: '${presentation.label}. QR-код сейчас недоступен.',
      state: presentation.scannable
          ? QrCodeState.scannable
          : QrCodeState.unavailable,
      size: size,
    );

    return qrCode;
  }
}

class _ConnectionDetails extends StatelessWidget {
  const _ConnectionDetails({
    required this.displayAddress,
    required this.state,
    required this.presentation,
    required this.onCopyAddress,
    required this.onShare,
    required this.onRetry,
  });

  final String displayAddress;
  final ConnectionQrState state;
  final _ConnectionQrPresentation presentation;
  final VoidCallback? onCopyAddress;
  final VoidCallback? onShare;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ConnectionQrCardTheme>()!;
    final actions = _actionsForState();

    return Column(
      key: const Key('connection-qr-details'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DsText(
          'Подключите экран зрителя',
          variant: DsTextVariant.heading,
        ),
        SizedBox(height: theme.compactGap),
        DsText(presentation.description, variant: DsTextVariant.secondary),
        SizedBox(height: theme.gap),
        const DsText('Адрес для браузера', variant: DsTextVariant.label),
        SizedBox(height: theme.compactGap),
        Semantics(
          textField: true,
          readOnly: true,
          label: 'Адрес для браузера: $displayAddress',
          child: ExcludeSemantics(
            child: SelectableText(displayAddress, style: theme.addressStyle),
          ),
        ),
        SizedBox(height: theme.gap),
        if (actions.isNotEmpty) DsFlow(children: actions),
        if (actions.isNotEmpty) SizedBox(height: theme.gap),
        const DsText(
          'Откройте адрес на устройстве в той же Wi‑Fi сети.',
          variant: DsTextVariant.secondary,
        ),
      ],
    );
  }

  List<Widget> _actionsForState() => switch (state) {
    ConnectionQrState.starting => const [],
    ConnectionQrState.ready || ConnectionQrState.reconnecting => [
      DsAction(
        label: 'Копировать ссылку Spectator',
        icon: Icons.content_copy_outlined,
        onPressed: onCopyAddress,
      ),
      if (onShare != null)
        DsAction(
          label: 'Поделиться',
          kind: DsActionKind.secondary,
          icon: Icons.ios_share_outlined,
          onPressed: onShare,
        ),
    ],
    ConnectionQrState.copied => [
      DsAction(
        label: 'Ссылка скопирована',
        status: DsActionStatus.success,
        onPressed: onCopyAddress,
      ),
      if (onShare != null)
        DsAction(
          label: 'Поделиться',
          kind: DsActionKind.secondary,
          icon: Icons.ios_share_outlined,
          onPressed: onShare,
        ),
    ],
    ConnectionQrState.stale => [
      DsAction(
        label: 'Обновить адрес',
        icon: Icons.refresh,
        onPressed: onRetry,
      ),
      DsAction(
        label: 'Копировать ссылку Spectator',
        kind: DsActionKind.secondary,
        icon: Icons.content_copy_outlined,
        onPressed: onCopyAddress,
      ),
    ],
    ConnectionQrState.unavailable ||
    ConnectionQrState.expired ||
    ConnectionQrState.error => [
      DsAction(
        label: 'Попробовать снова',
        icon: Icons.refresh,
        onPressed: onRetry,
      ),
    ],
  };
}

class _ConnectionQrPresentation {
  const _ConnectionQrPresentation({
    required this.label,
    required this.description,
    required this.kind,
    required this.icon,
    required this.accentColor,
    required this.scannable,
  });

  final String label;
  final String description;
  final StatusKind kind;
  final IconData icon;
  final Color accentColor;
  final bool scannable;
}

_ConnectionQrPresentation _presentationFor(
  ConnectionQrState state,
  ConnectionQrCardTheme theme,
) => switch (state) {
  ConnectionQrState.starting => _ConnectionQrPresentation(
    label: 'Сервер запускается',
    description: 'Готовим локальный адрес для подключения spectator.',
    kind: StatusKind.info,
    icon: Icons.hourglass_top,
    accentColor: theme.info,
    scannable: false,
  ),
  ConnectionQrState.ready => _ConnectionQrPresentation(
    label: 'Готово к подключению',
    description:
        'Наведите камеру телефона на QR-код или введите адрес вручную.',
    kind: StatusKind.success,
    icon: Icons.qr_code_2,
    accentColor: theme.success,
    scannable: true,
  ),
  ConnectionQrState.reconnecting => _ConnectionQrPresentation(
    label: 'Проверяем адрес',
    description:
        'Текущий адрес доступен, пока Host восстанавливает соединение.',
    kind: StatusKind.info,
    icon: Icons.sync,
    accentColor: theme.info,
    scannable: true,
  ),
  ConnectionQrState.unavailable => _ConnectionQrPresentation(
    label: 'Адрес недоступен',
    description: 'Host пока не нашёл доступный адрес в локальной сети.',
    kind: StatusKind.neutral,
    icon: Icons.wifi_off_outlined,
    accentColor: theme.neutral,
    scannable: false,
  ),
  ConnectionQrState.expired => _ConnectionQrPresentation(
    label: 'Адрес устарел',
    description: 'Обновите адрес перед новым подключением spectator.',
    kind: StatusKind.warning,
    icon: Icons.timer_off_outlined,
    accentColor: theme.warning,
    scannable: false,
  ),
  ConnectionQrState.error => _ConnectionQrPresentation(
    label: 'Ошибка подключения',
    description: 'Не удалось подготовить spectator. Турнир можно продолжать.',
    kind: StatusKind.danger,
    icon: Icons.error_outline,
    accentColor: theme.danger,
    scannable: false,
  ),
  ConnectionQrState.stale => _ConnectionQrPresentation(
    label: 'Адрес мог измениться',
    description: 'Обновите данные перед подключением нового экрана.',
    kind: StatusKind.warning,
    icon: Icons.warning_amber,
    accentColor: theme.warning,
    scannable: true,
  ),
  ConnectionQrState.copied => _ConnectionQrPresentation(
    label: 'Адрес скопирован',
    description: 'Вставьте адрес в браузере устройства в той же сети.',
    kind: StatusKind.success,
    icon: Icons.check_circle_outline,
    accentColor: theme.success,
    scannable: true,
  ),
};
