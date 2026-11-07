import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';

class AppIdentity extends StatelessWidget {
  const AppIdentity({
    required this.primary,
    required this.initials,
    this.secondary,
    this.kind = AppIdentityKind.character,
    this.layout = AppIdentityLayout.inline,
    this.avatarForeground,
    super.key,
  });
  final String primary, initials;
  final String? secondary;
  final AppIdentityKind kind;
  final AppIdentityLayout layout;
  final Color? avatarForeground;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: _buildLayout);
  Widget _buildLayout(BuildContext context, BoxConstraints constraints) {
    final theme = AppIdentityTheme.of(
      context,
      kind,
      layout,
      constraints.maxWidth,
    );
    return MergeSemantics(
      child: SizedBox(
        width: constraints.maxWidth,
        child: layout == AppIdentityLayout.inline
            ? Row(
                crossAxisAlignment: theme.center,
                children: [
                  AppAvatar(
                    initials: initials,
                    size: theme.size,
                    shape: theme.shape,
                    theme: theme.avatar,
                    foreground: avatarForeground,
                  ),
                  SizedBox(width: theme.gap),
                  Flexible(
                    child: IntrinsicWidth(
                      child: _IdentityText(
                        primary: primary,
                        secondary: secondary,
                        theme: theme,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: theme.leading,
                children: [
                  AppAvatar(
                    initials: initials,
                    size: theme.size,
                    shape: theme.shape,
                    theme: theme.avatar,
                    foreground: avatarForeground,
                  ),
                  SizedBox(height: theme.gap),
                  Text(
                    primary,
                    style: theme.primary,
                    textAlign: theme.textAlign,
                  ),
                  if (secondary != null) ...[
                    SizedBox(height: theme.textGap),
                    Text(
                      secondary!,
                      style: theme.secondary,
                      textAlign: theme.textAlign,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _IdentityText extends StatelessWidget {
  const _IdentityText({
    required this.primary,
    required this.secondary,
    required this.theme,
  });
  final String primary;
  final String? secondary;
  final AppIdentityTheme theme;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: theme.stretch,
    children: [
      Text(primary, style: theme.primary, textAlign: theme.textAlign),
      if (secondary != null) ...[
        SizedBox(height: theme.textGap),
        Text(secondary!, style: theme.secondary, textAlign: theme.textAlign),
      ],
    ],
  );
}
