import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/screens/result_locked/result_locked_screen_state.dart';
import 'package:tournament_app/presentation/screens/result_locked/result_locked_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface_theme.dart';

class ResultLockedScreen extends StatelessWidget {
  const ResultLockedScreen({
    required this.state,
    required this.onBack,
    required this.onShare,
    required this.onCorrect,
    super.key,
  });
  final ResultLockedScreenState state;
  final VoidCallback? onBack, onShare, onCorrect;
  @override
  Widget build(BuildContext context) {
    final appearance = ResultLockedScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: state.title,
            backLabel: localizations.screenBack,
            onBack: onBack,
            action: AppHeaderAction(
              kind: AppHeaderActionKind.share,
              label: localizations.screenSpectators,
              onPressed: onShare,
            ),
          ),
          SizedBox(height: appearance.gap),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: appearance.simpleWidth),
                  child: AppSurface(
                    tone: AppSurfaceTone.surface,
                    child: Column(
                      mainAxisSize: appearance.min,
                      crossAxisAlignment: appearance.stretch,
                      children: [
                        Text(
                          localizations.screenMatchResults,
                          style: appearance.heading,
                        ),
                        SizedBox(height: appearance.small),
                        Text(state.matchLabel, style: appearance.caption),
                        SizedBox(height: appearance.small),
                        Text(state.pairingLabel, style: appearance.body),
                        SizedBox(height: appearance.small),
                        AppButton(
                          label: localizations.screenResultCorrect,
                          kind: AppButtonKind.secondary,
                          onPressed: onCorrect,
                        ),
                        SizedBox(height: appearance.small),
                        Text(state.reason, style: appearance.caption),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
