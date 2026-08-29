import 'package:flutter/material.dart';

import '../ds_action/ds_action.dart';
import '../ds_field/ds_field.dart';
import '../ds_flow/ds_flow.dart';
import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../status_badge/status_badge.dart';
import 'participant_join_panel_theme.dart';
import 'participant_join_view_data.dart';

class ParticipantJoinPanel extends StatelessWidget {
  const ParticipantJoinPanel({
    required this.data,
    this.onScan,
    this.onSubmit,
    this.onRetry,
    super.key,
  });

  final ParticipantJoinViewData data;
  final VoidCallback? onScan;
  final ValueChanged<String>? onSubmit;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ParticipantJoinPanelTheme>()!;
    final presentation = _presentation(data.state);

    return Semantics(
      container: true,
      explicitChildNodes: true,
      liveRegion: data.state != ParticipantJoinState.idle,
      label: 'Вход участника. ${presentation.label}.',
      child: DsSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: theme.gap,
              runSpacing: theme.gap,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const DsText('СКАНЕР ИЛИ КОД', variant: DsTextVariant.label),
                StatusBadge(label: presentation.label, kind: presentation.kind),
              ],
            ),
            SizedBox(height: theme.gap),
            _ScannerSurface(data: data, onScan: onScan),
            SizedBox(height: theme.gap),
            DsText(presentation.description, variant: DsTextVariant.secondary),
            SizedBox(height: theme.gap),
            DsTextField(
              key: const Key('participant-join-value'),
              label: 'Адрес или код с экрана Host',
              helperText: 'Например, http://192.168.1.42:8080 или FIGHT-24',
              enabled: !presentation.busy,
              textInputAction: DsTextInputAction.done,
              errorText: presentation.errorText,
              onSubmitted: onSubmit,
            ),
            SizedBox(height: theme.gap),
            DsFlow(children: _actions(presentation)),
          ],
        ),
      ),
    );
  }

  List<Widget> _actions(_ParticipantJoinPresentation presentation) => [
    DsAction(
      label: presentation.primaryLabel,
      status: presentation.busy
          ? DsActionStatus.loading
          : presentation.success
          ? DsActionStatus.success
          : DsActionStatus.idle,
      onPressed: presentation.busy || presentation.success
          ? null
          : presentation.retry
          ? onRetry
          : () => onSubmit?.call(data.enteredValue),
    ),
    if (!presentation.busy)
      DsAction(
        label: 'Сканировать QR',
        kind: DsActionKind.secondary,
        onPressed: onScan,
      ),
  ];
}

class _ScannerSurface extends StatelessWidget {
  const _ScannerSurface({required this.data, required this.onScan});

  final ParticipantJoinViewData data;
  final VoidCallback? onScan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ParticipantJoinPanelTheme>()!;
    final scanning = data.state == ParticipantJoinState.scanning;
    return Semantics(
      button: !scanning,
      label: scanning
          ? 'Камера ищет QR-код участника'
          : 'Открыть камеру для сканирования QR-кода участника',
      child: GestureDetector(
        onTap: scanning ? null : onScan,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.scannerBackground,
            border: Border.all(color: theme.scannerBorder),
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          child: SizedBox(
            height: theme.scannerHeight,
            child: Padding(
              padding: EdgeInsets.all(theme.padding),
              child: Center(
                child: DsText(
                  scanning
                      ? 'Наведите камеру на QR-код Host'
                      : 'Камера откроется здесь',
                  variant: scanning
                      ? DsTextVariant.title
                      : DsTextVariant.secondary,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ParticipantJoinPresentation {
  const _ParticipantJoinPresentation({
    required this.label,
    required this.description,
    required this.primaryLabel,
    required this.kind,
    this.errorText,
    this.busy = false,
    this.success = false,
    this.retry = false,
  });

  final String label;
  final String description;
  final String primaryLabel;
  final StatusKind kind;
  final String? errorText;
  final bool busy;
  final bool success;
  final bool retry;
}

_ParticipantJoinPresentation _presentation(ParticipantJoinState state) =>
    switch (state) {
      ParticipantJoinState.idle => const _ParticipantJoinPresentation(
        label: 'Готово к вводу',
        description: 'Сканируйте QR или введите адрес с экрана организатора.',
        primaryLabel: 'Присоединиться',
        kind: StatusKind.neutral,
      ),
      ParticipantJoinState.scanning => const _ParticipantJoinPresentation(
        label: 'Сканируем',
        description: 'QR будет проверен перед подключением к лобби.',
        primaryLabel: 'Сканирование',
        kind: StatusKind.info,
        busy: true,
      ),
      ParticipantJoinState.connecting => const _ParticipantJoinPresentation(
        label: 'Подключаемся',
        description: 'Проверяем локальный адрес и ожидаем ответ Host.',
        primaryLabel: 'Подключение',
        kind: StatusKind.info,
        busy: true,
      ),
      ParticipantJoinState.accepted => const _ParticipantJoinPresentation(
        label: 'Вход подтверждён',
        description: 'Host принял подключение. Открываем лобби.',
        primaryLabel: 'Подключено',
        kind: StatusKind.success,
        success: true,
      ),
      ParticipantJoinState.denied => const _ParticipantJoinPresentation(
        label: 'Вход отклонён',
        description: 'Host не разрешил присоединение. Проверьте код.',
        primaryLabel: 'Попробовать снова',
        kind: StatusKind.danger,
        errorText: 'Доступ к этому лобби не подтверждён',
        retry: true,
      ),
      ParticipantJoinState.notFound => const _ParticipantJoinPresentation(
        label: 'Лобби не найдено',
        description: 'Проверьте сеть и адрес на экране Host.',
        primaryLabel: 'Попробовать снова',
        kind: StatusKind.warning,
        errorText: 'Локальное лобби не найдено',
        retry: true,
      ),
      ParticipantJoinState.error => const _ParticipantJoinPresentation(
        label: 'Ошибка подключения',
        description: 'Не удалось проверить адрес. Данные турнира не изменены.',
        primaryLabel: 'Повторить',
        kind: StatusKind.danger,
        errorText: 'Проверьте адрес и попробуйте ещё раз',
        retry: true,
      ),
    };
