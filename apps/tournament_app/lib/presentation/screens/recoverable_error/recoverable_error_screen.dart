import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class RecoverableErrorScreenPreview extends StatelessWidget {
  const RecoverableErrorScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Ошибка',
    child: TournamentEmptyState(
      title: 'Не удалось загрузить турнир',
      message: 'Данные сохранены. Повторите попытку.',
      actionLabel: 'Повторить',
      onAction: () {},
      isError: true,
    ),
  );
}
