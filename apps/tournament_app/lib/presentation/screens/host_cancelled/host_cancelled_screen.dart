import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostCancelledScreenPreview extends StatelessWidget {
  const HostCancelledScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир отменён',
    child: TournamentEmptyState(
      title: 'Турнир не состоялся',
      message: 'Результаты не были сохранены.',
      actionLabel: 'На главную',
      onAction: () {},
    ),
  );
}
