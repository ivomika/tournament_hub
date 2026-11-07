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
    this.theme,
    super.key,
  });
  final String primary, initials;
  final String? secondary;
  final AppIdentityKind kind;
  final AppIdentityLayout layout;
  final Color? avatarForeground;
  final AppIdentityTheme? theme;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: _buildLayout);
  Widget _buildLayout(BuildContext context, BoxConstraints constraints) {
    final theme =
        this.theme ??
        AppIdentityTheme.of(context, kind, layout, constraints.maxWidth);
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
                  if (theme.fillText)
                    Expanded(
                      child: _IdentityText(
                        primary: primary,
                        secondary: secondary,
                        theme: theme,
                      ),
                    )
                  else
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
      _IdentityLine(text: primary, style: theme.primary, theme: theme),
      if (secondary != null) ...[
        SizedBox(height: theme.textGap),
        _IdentityLine(text: secondary!, style: theme.secondary, theme: theme),
      ],
    ],
  );
}

class _IdentityLine extends StatelessWidget {
  const _IdentityLine({
    required this.text,
    required this.style,
    required this.theme,
  });
  final String text;
  final TextStyle style;
  final AppIdentityTheme theme;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: theme.exactLineBoxes
        ? MediaQuery.textScalerOf(context).scale(style.fontSize!) *
              style.height!
        : null,
    child: Text(text, style: style, textAlign: theme.textAlign),
  );
}
