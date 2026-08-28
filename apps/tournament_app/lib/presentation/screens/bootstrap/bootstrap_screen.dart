import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class BootstrapScreenPreview extends StatelessWidget {
  const BootstrapScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => const AppShell(
    title: 'Tournament Hub',
    subtitle: 'Подготавливаем локальный профиль и турнирное состояние.',
    sectionLabel: 'WELCOME TO THE ARENA',
    child: DsSurface(
      tone: DsSurfaceTone.accent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DsProgress(),
          DsGap(DsSpace.md),
          DsText(
            'Собираем твою арену',
            variant: DsTextVariant.title,
            textAlign: TextAlign.center,
          ),
          DsGap(DsSpace.sm),
          DsText(
            'Все данные остаются на этом устройстве.',
            variant: DsTextVariant.secondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
