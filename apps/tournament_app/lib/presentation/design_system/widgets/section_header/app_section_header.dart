import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header_theme.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';

enum AppHeaderActionKind {
  save(AppGlyph.check),
  edit(AppGlyph.edit),
  add(AppGlyph.plus),
  share(AppGlyph.qr);

  const AppHeaderActionKind(this.glyph);
  final AppGlyph glyph;
}

class AppHeaderAction {
  const AppHeaderAction({
    required this.kind,
    required this.label,
    required this.onPressed,
  });
  final AppHeaderActionKind kind;
  final String label;
  final VoidCallback? onPressed;
}

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    required this.backLabel,
    required this.onBack,
    this.action,
    this.leadingGlyph,
    super.key,
  });
  final String title, backLabel;
  final VoidCallback? onBack;
  final AppHeaderAction? action;
  final AppGlyph? leadingGlyph;
  AppButtonKind _resolveActionKind() {
    if (action?.kind == AppHeaderActionKind.save) {
      return AppButtonKind.accentIcon;
    }
    return AppButtonKind.icon;
  }

  @override
  Widget build(BuildContext context) {
    final appearance = AppSectionHeaderTheme.of(context);
    return Row(
      children: [
        SizedBox.square(
          dimension: appearance.slot,
          child: AppButton(
            label: backLabel,
            kind: AppButtonKind.icon,
            glyph: leadingGlyph ?? AppGlyph.back,
            onPressed: onBack,
          ),
        ),
        SizedBox(width: appearance.gap),
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: appearance.style,
              textAlign: appearance.textAlign,
            ),
          ),
        ),
        SizedBox(width: appearance.gap),
        SizedBox.square(
          dimension: appearance.slot,
          child: action == null
              ? null
              : AppButton(
                  label: action!.label,
                  kind: _resolveActionKind(),
                  glyph: action!.kind.glyph,
                  onPressed: action!.onPressed,
                ),
        ),
      ],
    );
  }
}
