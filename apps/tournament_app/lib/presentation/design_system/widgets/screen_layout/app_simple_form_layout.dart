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
  @override
  Widget build(BuildContext context) {
    final t = AppScreenLayoutTheme.of(context);
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          header,
          SizedBox(height: t.gap),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (t.desktop) SizedBox(height: t.utilityTop),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: t.desktop
                          ? (intro == null ? t.utilityWidth : t.simpleWidth)
                          : t.formWidth,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: t.desktop ? t.surface : t.background,
                        borderRadius: t.radius,
                      ),
                      child: Padding(
                        padding: t.desktop
                            ? EdgeInsets.all(t.simplePadding)
                            : EdgeInsets.all(t.zero),
                        child: t.desktop && intro != null
                            ? Row(
                                crossAxisAlignment: t.start,
                                children: [
                                  Expanded(
                                    flex: t.simpleIntroFlex,
                                    child: intro!,
                                  ),
                                  SizedBox(width: t.gap),
                                  Expanded(
                                    flex: t.simpleFormFlex,
                                    child: Column(
                                      crossAxisAlignment: t.stretch,
                                      children: [
                                        form,
                                        if (footer != null) ...[
                                          SizedBox(height: t.gap),
                                          footer!,
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: t.stretch,
                                children: [
                                  if (intro != null) ...[
                                    intro!,
                                    SizedBox(height: t.gap),
                                  ],
                                  form,
                                  if (t.desktop && footer != null) ...[
                                    SizedBox(height: t.gap),
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
          if (!t.desktop && footer != null) ...[
            SizedBox(height: t.gap),
            footer!,
          ],
        ],
      ),
    );
  }
}
