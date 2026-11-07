import 'package:flutter/widgets.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';

/// Одни presentation данные для Widgetbook, native golden и web сравнения.
class AvatarFixture extends StatelessWidget {
  const AvatarFixture({
    required this.size,
    required this.shape,
    this.initials = 'И',
    this.foreground,
    super.key,
  });
  final AppAvatarSize size;
  final AppAvatarShape shape;
  final String initials;
  final Color? foreground;
  @override
  Widget build(BuildContext context) => AppAvatar(
    initials: initials,
    size: size,
    shape: shape,
    foreground: foreground,
  );
}
