import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';

class AppSimpleFormLayout extends StatelessWidget {
  const AppSimpleFormLayout({
    required this.header,
    required this.form,
    this.intro,
    this.footer,
    super.key,
  });
  final Widget header, form;
  final Widget? intro, footer;
  double _resolveMaxWidth(AppScreenLayoutTheme theme) {
    if (!theme.desktop) return theme.formWidth;
    if (intro == null) return theme.utilityWidth;
    return theme.simpleWidth;
  }

  @override
  Widget build(BuildContext context) {
    final appearance = AppScreenLayoutTheme.of(context);
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          header,
          SizedBox(height: appearance.gap),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (appearance.desktop)
                    SizedBox(height: appearance.utilityTop),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: _resolveMaxWidth(appearance),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: appearance.desktop
                            ? appearance.surface
                            : appearance.background,
                        borderRadius: appearance.radius,
                      ),
                      child: Padding(
                        padding: appearance.desktop
                            ? EdgeInsets.all(appearance.simplePadding)
                            : EdgeInsets.all(appearance.zero),
                        child: appearance.desktop && intro != null
                            ? Row(
                                crossAxisAlignment: appearance.start,
                                children: [
                                  Expanded(
                                    flex: appearance.simpleIntroFlex,
                                    child: intro!,
                                  ),
                                  SizedBox(width: appearance.gap),
                                  Expanded(
                                    flex: appearance.simpleFormFlex,
                                    child: Column(
                                      crossAxisAlignment: appearance.stretch,
                                      children: [
                                        form,
                                        if (footer != null) ...[
                                          SizedBox(height: appearance.gap),
                                          footer!,
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: appearance.stretch,
                                children: [
                                  if (intro != null) ...[
                                    intro!,
                                    SizedBox(height: appearance.gap),
                                  ],
                                  form,
                                  if (appearance.desktop && footer != null) ...[
                                    SizedBox(height: appearance.gap),
                                    footer!,
                                  ],
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!appearance.desktop && footer != null) ...[
            SizedBox(height: appearance.gap),
            footer!,
          ],
        ],
      ),
    );
  }
}
