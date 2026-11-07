import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

final iconSlotsUseCase = WidgetbookUseCase(
  name: 'Slots / colors / RTL',
  builder: IconSlotsUseCase.build,
);

abstract final class IconSlotsUseCase {
  static Widget build(BuildContext context) => const IconSlotsFixture();
}

class IconSlotsFixture extends StatelessWidget {
  const IconSlotsFixture({super.key});
  @override
  Widget build(BuildContext context) {
    final gap = Theme.of(context).extension<AppSpacing>()!.space16;
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (final size in AppIconSize.values)
          AppIcon(AppGlyph.trash, size: size),
        for (final tone in AppIconTone.values)
          AppIcon(AppGlyph.check, tone: tone),
        const Directionality(
          textDirection: TextDirection.rtl,
          child: AppIcon(AppGlyph.arrow),
        ),
      ],
    );
  }
}
