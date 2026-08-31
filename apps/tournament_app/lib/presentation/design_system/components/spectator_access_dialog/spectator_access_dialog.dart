import 'dart:async';

import 'package:flutter/material.dart';

import '../connection_qr_card/connection_qr_card.dart';
import '../ds_action/ds_action.dart';
import '../ds_spacing/ds_spacing.dart';
import '../ds_text/ds_text.dart';
import '../page_header/page_header.dart';
import '../qr_code/qr_code.dart';
import '../status_badge/status_badge.dart';
import 'spectator_access_dialog_theme.dart';
import 'spectator_access_view_data.dart';

class SpectatorAccessDialog extends StatefulWidget {
  const SpectatorAccessDialog({
    required this.data,
    required this.onClose,
    this.onCopyAddress,
    this.onShare,
    this.onRetry,
    super.key,
  });

  final SpectatorAccessViewData data;
  final VoidCallback onClose;
  final FutureOr<void> Function()? onCopyAddress;
  final VoidCallback? onShare;
  final VoidCallback? onRetry;

  @override
  State<SpectatorAccessDialog> createState() => _SpectatorAccessDialogState();
}

class _SpectatorAccessDialogState extends State<SpectatorAccessDialog> {
  var _copied = false;
  var _copyFailed = false;

  @override
  void didUpdateWidget(covariant SpectatorAccessDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.endpoint != widget.data.endpoint ||
        oldWidget.data.state != widget.data.state) {
      _copied = false;
      _copyFailed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<SpectatorAccessDialogTheme>()!;
    final endpoint = widget.data.endpoint;
    final effectiveState =
        _copied && widget.data.state == ConnectionQrState.ready
        ? ConnectionQrState.copied
        : widget.data.state;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Полноэкранное подключение зрителей',
      child: ColoredBox(
        color: theme.background,
        child: SafeArea(
          child: SingleChildScrollView(
            child: DsPagePadding(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: theme.maxContentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PageHeader(
                        sectionLabel: 'SPECTATOR · ЭКРАН ДЛЯ ТВ',
                        title: 'Подключить зрителей',
                        subtitle: 'Откройте адрес в браузере телевизора или другого устройства в этой локальной сети.',
                        trailing: StatusBadge(
                          label: '${widget.data.connectedClients} ПОДКЛЮЧЕНО',
                          kind: widget.data.connectedClients > 0
                              ? StatusKind.success
                              : StatusKind.neutral,
                        ),
                      ),
                      SizedBox(height: theme.gap),
                      ConnectionQrCard(
                        encodedValue: endpoint ?? '',
                        displayAddress: endpoint ?? 'Адрес ещё недоступен',
                        state: effectiveState,
                        qrSize: QrCodeSize.large,
                        onCopyAddress: widget.onCopyAddress == null
                            ? null
                            : _copyAddress,
                        onShare: widget.onShare,
                        onRetry: widget.onRetry,
                      ),
                      if (_copyFailed) ...[
                        SizedBox(height: theme.gap),
                        const DsText(
                          'Не удалось скопировать ссылку. Выделите адрес вручную.',
                          variant: DsTextVariant.secondary,
                          textAlign: TextAlign.center,
                        ),
                      ],
                      SizedBox(height: theme.gap),
                      const DsText(
                        'Spectator получает только read-only представление турнира. Закрытие этого окна не останавливает турнир.',
                        variant: DsTextVariant.secondary,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: theme.gap),
                      DsAction(
                        label: 'Вернуться к лобби',
                        kind: DsActionKind.secondary,
                        onPressed: widget.onClose,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _copyAddress() async {
    try {
      await widget.onCopyAddress!();
      if (!mounted) return;
      setState(() {
        _copied = true;
        _copyFailed = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _copied = false;
        _copyFailed = true;
      });
    }
  }
}
