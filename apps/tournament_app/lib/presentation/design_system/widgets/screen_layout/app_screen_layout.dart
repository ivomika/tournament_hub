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
    final t = AppScreenLayoutTheme.of(context),
        l = FoundationLocalizations.of(context);
    return Scaffold(
      backgroundColor: t.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: t.stretch,
          children: [
            if (t.desktop && brand)
              SizedBox(
                height: t.brandHeight,
                child: Padding(
                  padding: t.brandInset,
                  child: RichText(
                    text: TextSpan(
                      style: t.brand,
                      children: [
                        TextSpan(text: l.screenBrand),
                        TextSpan(
                          text: l.screenBrandAccent,
                          style: t.accentBrand,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: t.inset,
                child: Column(
                  crossAxisAlignment: t.stretch,
                  children: [
                    if (header != null) ...[header!, SizedBox(height: t.gap)],
                    Expanded(
                      child: t.desktop
                          ? Row(
                              crossAxisAlignment: t.stretch,
                              children: [
                                Expanded(
                                  flex: t.primaryFlex,
                                  child: AppScreenTile(
                                    transparent: !primarySurface,
                                    child: primary,
                                  ),
                                ),
                                if (secondary != null || footer != null) ...[
                                  SizedBox(width: t.gap),
                                  Expanded(
                                    flex: t.secondaryFlex,
                                    child: AppScreenTile(
                                      child: Column(
                                        crossAxisAlignment: t.stretch,
                                        children: [
                                          if (secondary != null)
                                            Expanded(child: secondary!)
                                          else
                                            const Spacer(),
                                          if (footer != null) ...[
                                            SizedBox(height: t.gap),
                                            footer!,
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            )
                          : Column(
                              crossAxisAlignment: t.stretch,
                              children: [
                                Expanded(
                                  child: centerPrimary
                                      ? Column(
                                          crossAxisAlignment: t.stretch,
                                          children: [
                                            Expanded(child: primary),
                                            if (secondary != null) ...[
                                              SizedBox(height: t.gap),
                                              secondary!,
                                            ],
                                          ],
                                        )
                                      : SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: t.stretch,
                                            children: [
                                              primary,
                                              if (secondary != null) ...[
                                                SizedBox(height: t.gap),
                                                secondary!,
                                              ],
                                            ],
                                          ),
                                        ),
                                ),
                                if (footer != null) ...[
                                  SizedBox(height: t.gap),
                                  footer!,
                                ],
                              ],
                            ),
                    ),
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
    super.key,
  });
  final bool transparent;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final t = AppScreenLayoutTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.desktop && !transparent ? t.surface : t.background,
        borderRadius: t.radius,
      ),
      child: Padding(padding: t.tileInset, child: child),
    );
  }
}
