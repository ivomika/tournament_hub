import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class RegistrationScreenPreview extends StatelessWidget {
  const RegistrationScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Как тебя представить?',
    subtitle: 'Никнейм будет виден участникам турнира на этом устройстве.',
    sectionLabel: 'ПЕРВЫЙ ВХОД',
    navigationRole: AppNavigationRole.focused,
    child: PageLayout(
      preset: PageLayoutPreset.workspace,
      primary: const DsSurface(
        tone: DsSurfaceTone.accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DsText('ТВОЯ ЛОКАЛЬНАЯ АРЕНА', variant: DsTextVariant.label),
            DsGap(DsSpace.md),
            DsText(
              'Создавай турниры. Добавляй гостей. Играй офлайн.',
              variant: DsTextVariant.heading,
            ),
            DsGap(DsSpace.md),
            DsText(
              'Профиль хранится локально и не требует регистрации в интернете.',
              variant: DsTextVariant.secondary,
            ),
          ],
        ),
      ),
      secondary: DsSection(
        title: 'Создание профиля',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DsTextField(
              label: 'Никнейм',
              helperText: 'Так тебя увидят участники',
              textInputAction: DsTextInputAction.done,
            ),
            const DsGap(DsSpace.md),
            DsAction(label: 'Войти в арену', onPressed: () {}),
          ],
        ),
      ),
    ),
  );
}
