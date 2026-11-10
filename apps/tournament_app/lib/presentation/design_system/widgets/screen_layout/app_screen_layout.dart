import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

/// Responsive layout only. Receives complete content; no product state or routing.
class AppScreenLayout extends StatelessWidget {
  const AppScreenLayout({
    required this.primary,
    this.header,
    this.secondary,
    this.footer,
    this.brand = true,
    this.centerPrimary = false,
    this.primarySurface = true,
    super.key,
  });
  final Widget primary;
  final Widget? header, secondary, footer;
  final bool brand, centerPrimary, primarySurface;
  @override
  Widget build(BuildContext context) {
    final appearance = AppScreenLayoutTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final Widget? responsiveContent;
    if (appearance.desktop) {
      responsiveContent = Row(
        crossAxisAlignment: appearance.stretch,
        children: [
          Expanded(
            flex: appearance.primaryFlex,
            child: AppScreenTile(transparent: !primarySurface, child: primary),
          ),
          if (secondary != null || footer != null) ...[
            SizedBox(width: appearance.gap),
            Expanded(
              flex: appearance.secondaryFlex,
              child: AppScreenTile(
                child: Column(
                  crossAxisAlignment: appearance.stretch,
                  children: [
                    if (secondary != null)
                      Expanded(child: secondary!)
                    else
                      const Spacer(),
                    if (footer != null) ...[
                      SizedBox(height: appearance.gap),
                      footer!,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      );
    } else {
      responsiveContent = Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          Expanded(
            child: centerPrimary
                ? Column(
                    crossAxisAlignment: appearance.stretch,
                    children: [
                      Expanded(child: primary),
                      if (secondary != null) ...[
                        SizedBox(height: appearance.gap),
                        secondary!,
                      ],
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: appearance.stretch,
                      children: [
                        primary,
                        if (secondary != null) ...[
                          SizedBox(height: appearance.gap),
                          secondary!,
                        ],
                      ],
                    ),
                  ),
          ),
          if (footer != null) ...[SizedBox(height: appearance.gap), footer!],
        ],
      );
    }
    return Scaffold(
      backgroundColor: appearance.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: appearance.stretch,
          children: [
            if (appearance.desktop && brand)
              SizedBox(
                height: appearance.brandHeight,
                child: Padding(
                  padding: appearance.brandInset,
                  child: RichText(
                    text: TextSpan(
                      style: appearance.brand,
                      children: [
                        TextSpan(text: localizations.screenBrand),
                        TextSpan(
                          text: localizations.screenBrandAccent,
                          style: appearance.accentBrand,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: appearance.inset,
                child: Column(
                  crossAxisAlignment: appearance.stretch,
                  children: [
                    if (header != null) ...[
                      header!,
                      SizedBox(height: appearance.gap),
                    ],
                    Expanded(child: responsiveContent),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppScreenTile extends StatelessWidget {
  const AppScreenTile({
    required this.child,
    this.transparent = false,
    this.padding,
    this.raised = false,
    super.key,
  });
  final bool transparent, raised;
  Color _resolveBackground(AppScreenLayoutTheme theme) {
    if (!theme.desktop || transparent) return theme.background;
    if (raised) return theme.raised;
    return theme.surface;
  }

  final EdgeInsets? padding;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final appearance = AppScreenLayoutTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _resolveBackground(appearance),
        borderRadius: appearance.radius,
      ),
      child: Padding(padding: padding ?? appearance.tileInset, child: child),
    );
  }
}
