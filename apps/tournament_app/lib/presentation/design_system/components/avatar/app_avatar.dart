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
    this.semanticsLabel,
    super.key,
  });
  final String initials;
  final AppAvatarSize size;
  final AppAvatarShape shape;
  final Color? foreground;
  final String? semanticsLabel;
  @override
  Widget build(BuildContext context) {
    final theme = AppAvatarTheme.of(context, size, shape);
    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: theme.extent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.background,
            shape: shape == AppAvatarShape.round
                ? BoxShape.circle
                : BoxShape.rectangle,
            borderRadius: shape == AppAvatarShape.tile
                ? theme.tileRadius
                : null,
          ),
          child: Align(
            alignment: theme.contentAlignment,
            child: Text(
              initials,
              softWrap: false,
              style: theme.typography.copyWith(
                color: foreground ?? theme.foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
