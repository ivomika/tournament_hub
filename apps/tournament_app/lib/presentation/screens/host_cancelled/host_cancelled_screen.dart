import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostCancelledScreenPreview extends StatelessWidget {
  const HostCancelledScreenPreview({
    this.title = 'Турнир',
    this.reason = 'Отменено организатором',
    this.onMain,
    super.key,
  });

  final String title;
  final String reason;
  final VoidCallback? onMain;

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир отменён',
    subtitle: '$title · $reason',
    sectionLabel: 'ЗАВЕРШЁН · ТОЛЬКО ЧТЕНИЕ',
    headerVariant: PageHeaderVariant.compact,
    actionDock: ActionDock(
      primary: DsAction(label: 'На главную', onPressed: onMain),
    ),
    child: const PageLayout(
      preset: PageLayoutPreset.split,
      primary: TournamentEmptyState(
        title: 'Турнир не состоялся',
        message: 'Факт отмены сохранён без итоговых мест и чемпиона.',
      ),
      secondary: TournamentStageHeader(
        variant: TournamentStageVariant.strip,
        stage: 'Отменён',
        progress: 'БЕЗ ЧЕМПИОНА',
        detail: 'Спортивный результат не определён.',
        kind: StatusKind.danger,
      ),
    ),
  );
}
