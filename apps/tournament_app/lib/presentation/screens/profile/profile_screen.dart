import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ProfileStatisticsViewData {
  const ProfileStatisticsViewData({
    required this.tournaments,
    required this.victories,
    required this.tournamentWinRate,
    required this.normalMatches,
    required this.normalMatchWins,
    required this.normalMatchWinRate,
    this.bestPlace,
  });

  final int tournaments;
  final int victories;
  final double tournamentWinRate;
  final int normalMatches;
  final int normalMatchWins;
  final double normalMatchWinRate;
  final int? bestPlace;
}

class ProfileScreenPreview extends StatefulWidget {
  const ProfileScreenPreview({
    this.nickname = 'Иван',
    this.statistics,
    this.onSave,
    super.key,
  });

  final String nickname;
  final ProfileStatisticsViewData? statistics;
  final Future<void> Function(String nickname)? onSave;

  @override
  State<ProfileScreenPreview> createState() => _ProfileScreenPreviewState();
}

class _ProfileScreenPreviewState extends State<ProfileScreenPreview> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.nickname,
  );
  bool _editing = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nickname = _controller.text.trim();
    if (nickname.isEmpty) {
      setState(() => _error = 'Введите никнейм');
      return;
    }
    final save = widget.onSave;
    if (save == null) {
      setState(() => _editing = false);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await save(nickname);
      if (mounted) setState(() => _editing = false);
    } on Object {
      if (mounted) setState(() => _error = 'Не удалось изменить профиль');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statistics = widget.statistics;
    return AppShell(
      title: 'Профиль',
      subtitle: 'Локальная identity для турниров на этом устройстве.',
      sectionLabel: 'ИГРОК',
      headerVariant: PageHeaderVariant.compact,
      currentDestination: AppDestination.profile,
      child: PageLayout(
        preset: PageLayoutPreset.focused,
        primary: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileSummary(
              nickname: widget.nickname,
              tournaments: statistics?.tournaments ?? 0,
              victories: statistics?.victories ?? 0,
            ),
            if (statistics != null) ...[
              const DsGap(DsSpace.sm),
              DsSection(
                title: 'Статистика',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DsInfoRow(
                      title: 'Победы в турнирах',
                      subtitle:
                          '${statistics.victories} из ${statistics.tournaments} · ${_percent(statistics.tournamentWinRate)}',
                    ),
                    const DsGap(DsSpace.sm),
                    DsInfoRow(
                      title: 'Победы в обычных матчах',
                      subtitle:
                          '${statistics.normalMatchWins} из ${statistics.normalMatches} · ${_percent(statistics.normalMatchWinRate)}',
                    ),
                    const DsGap(DsSpace.sm),
                    DsInfoRow(
                      title: 'Лучшее место',
                      subtitle:
                          statistics.bestPlace?.toString() ?? 'Нет данных',
                    ),
                  ],
                ),
              ),
            ],
            const DsGap(DsSpace.sm),
            if (_editing) ...[
              DsTextField(
                label: 'Новый никнейм',
                controller: _controller,
                errorText: _error,
                enabled: !_loading,
                textInputAction: DsTextInputAction.done,
                onSubmitted: (_) => _save(),
              ),
              const DsGap(DsSpace.sm),
              DsFlow(
                children: [
                  DsAction(
                    label: 'Сохранить',
                    status: _loading
                        ? DsActionStatus.loading
                        : DsActionStatus.idle,
                    onPressed: _loading ? null : _save,
                  ),
                  DsAction(
                    label: 'Отмена',
                    kind: DsActionKind.text,
                    onPressed: _loading
                        ? null
                        : () => setState(() => _editing = false),
                  ),
                ],
              ),
            ] else
              DsFlow(
                children: [
                  DsAction(
                    label: 'Редактировать профиль',
                    kind: DsActionKind.text,
                    onPressed: () => setState(() => _editing = true),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _percent(double value) => '${(value * 100).round()}%';
}
