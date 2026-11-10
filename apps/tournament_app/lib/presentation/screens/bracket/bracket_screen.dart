import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/screens/bracket/bracket_screen_state.dart';
import 'package:tournament_app/presentation/screens/bracket/bracket_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_map/app_bracket_map.dart';

class BracketScreen extends StatelessWidget {
  const BracketScreen({
    required this.state,
    required this.controller,
    required this.onBack,
    required this.onControls,
    required this.onZoomOut,
    required this.onZoomIn,
    required this.onFit,
    required this.onCurrent,
    super.key,
  });
  final BracketScreenState state;
  final TransformationController controller;
  final VoidCallback? onBack, onControls, onZoomOut, onZoomIn, onFit, onCurrent;
  @override
  Widget build(BuildContext context) {
    final appearance = BracketScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    return AppScreenCanvas(
      padded: false,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppBracketMap(
              diagram: state.diagram,
              controller: controller,
            ),
          ),
          Padding(
            padding: appearance.inset,
            child: AppSectionHeader(
              title: localizations.screenBracket,
              backLabel: localizations.screenBack,
              onBack: onBack,
            ),
          ),
          Padding(
            padding: appearance.inset,
            child: Align(
              alignment: appearance.bottomRight,
              child: Column(
                mainAxisSize: appearance.min,
                crossAxisAlignment: appearance.start,
                children: [
                  if (state.controlsExpanded)
                    AppScreenTile(
                      child: Column(
                        mainAxisSize: appearance.min,
                        children: [
                          Row(
                            mainAxisSize: appearance.min,
                            children: [
                              AppButton(
                                kind: AppButtonKind.icon,
                                fill: false,
                                glyph: AppGlyph.minus,
                                label: localizations.screenZoomOut,
                                onPressed: onZoomOut,
                              ),
                              Text(state.zoomLabel, style: appearance.body),
                              AppButton(
                                kind: AppButtonKind.icon,
                                fill: false,
                                glyph: AppGlyph.plus,
                                label: localizations.screenZoomIn,
                                onPressed: onZoomIn,
                              ),
                            ],
                          ),
                          AppButton(
                            label: localizations.screenMapFit,
                            kind: AppButtonKind.textLink,
                            onPressed: onFit,
                          ),
                          AppButton(
                            label: localizations.screenMapCurrent,
                            kind: AppButtonKind.textLink,
                            onPressed: onCurrent,
                          ),
                        ],
                      ),
                    ),
                  AppButton(
                    kind: AppButtonKind.icon,
                    fill: false,
                    glyph: AppGlyph.settings,
                    label: localizations.screenMapControls,
                    onPressed: onControls,
                  ),
                  if (state.detail.isNotEmpty)
                    Text(state.detail, style: appearance.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
