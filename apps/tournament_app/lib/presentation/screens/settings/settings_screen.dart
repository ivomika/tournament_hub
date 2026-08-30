import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class SettingsScreenPreview extends StatefulWidget {
  const SettingsScreenPreview({this.onClearHistory, this.onReset, super.key});

  final Future<void> Function()? onClearHistory;
  final Future<void> Function()? onReset;

  @override
  State<SettingsScreenPreview> createState() => _SettingsScreenPreviewState();
}

class _SettingsScreenPreviewState extends State<SettingsScreenPreview> {
  bool _resetting = false;
  bool _clearingHistory = false;

  Future<void> _showClearHistory() async {
    await showTournamentConfirmationDialog<void>(
      context: context,
      builder: (dialogContext) => DsConfirmationDialog(
        title: 'Очистить историю?',
        message: 'Все завершённые и отменённые турниры будут удалены. Действие нельзя отменить.',
        confirmLabel: 'Очистить историю',
        loading: _clearingHistory,
        onConfirm: () => _clearHistory(dialogContext),
      ),
    );
  }

  Future<void> _clearHistory(BuildContext dialogContext) async {
    final clear = widget.onClearHistory;
    if (clear == null) {
      Navigator.of(dialogContext).pop();
      return;
    }
    setState(() => _clearingHistory = true);
    try {
      await clear();
      if (dialogContext.mounted) Navigator.of(dialogContext).pop();
    } finally {
      if (mounted) setState(() => _clearingHistory = false);
    }
  }

  Future<void> _showReset() async {
    await showTournamentConfirmationDialog<void>(
      context: context,
      builder: (dialogContext) => DsConfirmationDialog(
        title: 'Сбросить локальные данные?',
        message: 'Профиль, активный турнир и история будут удалены с этого устройства. Действие нельзя отменить.',
        confirmLabel: 'Сбросить данные',
        loading: _resetting,
        onConfirm: () => _reset(dialogContext),
      ),
    );
  }

  Future<void> _reset(BuildContext dialogContext) async {
    final reset = widget.onReset;
    if (reset == null) {
      Navigator.of(dialogContext).pop();
      return;
    }
    setState(() => _resetting = true);
    try {
      await reset();
      if (dialogContext.mounted) Navigator.of(dialogContext).pop();
    } finally {
      if (mounted) setState(() => _resetting = false);
    }
  }

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Настройки',
    subtitle: 'Внешний вид, данные и информация о приложении.',
    sectionLabel: 'СИСТЕМА',
    currentDestination: AppDestination.settings,
    child: PageLayout(
      preset: PageLayoutPreset.split,
      primary: DsSection(
        title: 'Приложение',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DsInfoRow(
              title: 'Тема',
              subtitle: 'Тёмная тема Tournament Hub',
              kind: DsInfoKind.settings,
            ),
            const DsGap(DsSpace.md),
            DsAction(
              label: 'Открыть лицензии',
              kind: DsActionKind.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ),
      secondary: DangerZone(
        title: 'Сброс локальных данных',
        message: 'Удаляет profile и все owned records после подтверждения.',
        actionLabel: 'Сбросить данные',
        onAction: _resetting ? null : _showReset,
      ),
      supporting: DangerZone(
        title: 'История турниров',
        message: 'Удаляет все immutable snapshots одной операцией. Активный турнир не затрагивается.',
        actionLabel: 'Очистить историю',
        onAction: _clearingHistory ? null : _showClearHistory,
      ),
    ),
  );
}
