import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostDistributionScreenPreview extends StatefulWidget {
  const HostDistributionScreenPreview({
    this.participants = previewParticipants,
    this.onReroll,
    this.onBackToOpen,
    this.onStart,
    super.key,
  });

  final List<PreviewParticipant> participants;
  final Future<void> Function()? onReroll;
  final VoidCallback? onBackToOpen;
  final VoidCallback? onStart;

  @override
  State<HostDistributionScreenPreview> createState() =>
      _HostDistributionScreenPreviewState();
}

class _HostDistributionScreenPreviewState
    extends State<HostDistributionScreenPreview> {
  bool _isRerolling = false;
  bool _rerolled = false;
  String? _error;

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Раздача персонажей',
    subtitle: 'Аватар бойца — главный идентификатор участника.',
    sectionLabel: 'РАЗДАЧА · ЭТАП 3 ИЗ 5',
    headerVariant: PageHeaderVariant.compact,
    actionDock: ActionDock(
      primary: DsAction(
        label: 'Создать сетку и начать',
        onPressed: _isRerolling ? null : widget.onStart,
      ),
      secondary: [
        ActionDockAction(
          key: const Key('reroll-all-fighters'),
          label: _isRerolling ? 'Перераспределяем…' : 'Перераздать всех',
          enabled: !_isRerolling && widget.onReroll != null,
          onSelected: _rerollAll,
        ),
        ActionDockAction(
          label: 'Вернуться в лобби',
          enabled: !_isRerolling,
          onSelected: widget.onBackToOpen ?? () {},
        ),
      ],
    ),
    child: PageLayout(
      preset: PageLayoutPreset.split,
      primary: DsSection(
        title: 'Назначения',
        child: DsFlow(
          children: [
            for (final participant in widget.participants)
              DsSurface(
                tone: DsSurfaceTone.elevated,
                child: ParticipantIdentity(participant: participant),
              ),
          ],
        ),
      ),
      secondary: TournamentStageHeader(
        variant: TournamentStageVariant.strip,
        stage: _error == null ? 'Случайное назначение' : 'Ошибка раздачи',
        progress:
            '${widget.participants.length} ИЗ ${widget.participants.length}',
        detail:
            _error ??
            (_rerolled
                ? 'Персонажи перераспределены и сохранены.'
                : 'Все участники получили уникальных бойцов.'),
        kind: _error == null ? StatusKind.success : StatusKind.danger,
      ),
    ),
  );

  Future<void> _rerollAll() async {
    if (_isRerolling || widget.onReroll == null) return;
    setState(() {
      _isRerolling = true;
      _error = null;
    });
    try {
      await widget.onReroll!();
      if (!mounted) return;
      setState(() => _rerolled = true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _rerolled = false;
        _error = 'Не удалось перераспределить персонажей. Повторите попытку.';
      });
    } finally {
      if (mounted) setState(() => _isRerolling = false);
    }
  }
}
