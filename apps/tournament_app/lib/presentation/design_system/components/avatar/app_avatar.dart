import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_theme.dart';

/// Размер и форма — варианты; инициалы и цвет — presentation данные.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.initials,
    this.size = AppAvatarSize.large,
    this.shape = AppAvatarShape.tile,
    this.foreground,
    this.theme,
    this.semanticsLabel,
    super.key,
  });
  final AppAvatarTheme? theme;
  final String initials;
  final AppAvatarSize size;
  final AppAvatarShape shape;
  final Color? foreground;
  final String? semanticsLabel;
  @override
  Widget build(BuildContext context) {
    final recipe = theme ?? AppAvatarTheme.of(context, size, shape);
    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: recipe.extent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: recipe.background,
            shape: shape == AppAvatarShape.round
                ? BoxShape.circle
                : BoxShape.rectangle,
            borderRadius: shape == AppAvatarShape.tile
                ? recipe.tileRadius
                : null,
          ),
          child: Align(
            alignment: recipe.contentAlignment,
            child: Text(
              initials,
              softWrap: false,
              style: recipe.typography.copyWith(
                color: foreground ?? recipe.foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
