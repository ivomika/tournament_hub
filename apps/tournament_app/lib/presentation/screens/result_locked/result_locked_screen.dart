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
    final t = ResultLockedScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: state.title,
            backLabel: l.screenBack,
            onBack: onBack,
            action: AppHeaderAction(
              kind: AppHeaderActionKind.share,
              label: l.screenSpectators,
              onPressed: onShare,
            ),
          ),
          SizedBox(height: t.gap),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: t.simpleWidth),
                  child: AppSurface(
                    tone: AppSurfaceTone.surface,
                    child: Column(
                      mainAxisSize: t.min,
                      crossAxisAlignment: t.stretch,
                      children: [
                        Text(l.screenMatchResults, style: t.heading),
                        SizedBox(height: t.small),
                        Text(state.matchLabel, style: t.caption),
                        SizedBox(height: t.small),
                        Text(state.pairingLabel, style: t.body),
                        SizedBox(height: t.small),
                        AppButton(
                          label: l.screenResultCorrect,
                          kind: AppButtonKind.secondary,
                          onPressed: onCorrect,
                        ),
                        SizedBox(height: t.small),
                        Text(state.reason, style: t.caption),
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
