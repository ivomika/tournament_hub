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
  @override
  Widget build(BuildContext context) {
    final t = AppSectionHeaderTheme.of(context);
    return Row(
      children: [
        SizedBox.square(
          dimension: t.slot,
          child: AppButton(
            label: backLabel,
            kind: AppButtonKind.icon,
            glyph: leadingGlyph ?? AppGlyph.back,
            onPressed: onBack,
          ),
        ),
        SizedBox(width: t.gap),
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: t.style, textAlign: t.textAlign),
          ),
        ),
        SizedBox(width: t.gap),
        SizedBox.square(
          dimension: t.slot,
          child: action == null
              ? null
              : AppButton(
                  label: action!.label,
                  kind: action!.kind == AppHeaderActionKind.save
                      ? AppButtonKind.accentIcon
                      : AppButtonKind.icon,
                  glyph: action!.kind.glyph,
                  onPressed: action!.onPressed,
                ),
        ),
      ],
    );
  }
}
