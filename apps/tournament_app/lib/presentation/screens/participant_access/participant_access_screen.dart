import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/screens/participant_access/participant_access_screen_state.dart';
import 'package:tournament_app/presentation/screens/participant_access/participant_access_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/app_qr_code.dart';

class ParticipantAccessScreen extends StatelessWidget {
  const ParticipantAccessScreen({
    required this.state,
    required this.onBack,
    super.key,
  });
  final ParticipantAccessScreenState state;
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) {
    final appearance = ParticipantAccessScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final intro = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.start,
      mainAxisAlignment: appearance.startMain,
      children: [
        Text(localizations.screenJoinTitle, style: appearance.heroHeading),
        SizedBox(height: appearance.gap),
        Text(localizations.screenScan, style: appearance.caption),
      ],
    );
    final code = AppQrCode(
      data: state.qrPayload,
      semanticLabel: localizations.screenQrParticipantLabel,
      code: state.code,
    );

    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: localizations.screenConnection,
            backLabel: localizations.screenBack,
            onBack: onBack,
          ),
          SizedBox(height: appearance.gap),
          Expanded(
            child: appearance.desktop
                ? Row(
                    crossAxisAlignment: appearance.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: appearance.stretch,
                          children: [
                            Expanded(child: AppScreenTile(child: intro)),
                          ],
                        ),
                      ),
                      SizedBox(width: appearance.gap),
                      Expanded(
                        child: AppScreenTile(child: Center(child: code)),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: appearance.stretch,
                      children: [
                        intro,
                        SizedBox(height: appearance.gap),
                        Center(child: code),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
