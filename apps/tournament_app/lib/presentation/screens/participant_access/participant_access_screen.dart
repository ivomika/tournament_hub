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
    final t = ParticipantAccessScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final intro = Column(
      mainAxisSize: t.min,
      crossAxisAlignment: t.start,
      mainAxisAlignment: t.startMain,
      children: [
        Text(l.screenJoinTitle, style: t.heroHeading),
        SizedBox(height: t.gap),
        Text(l.screenScan, style: t.caption),
      ],
    );
    final code = AppQrCode(
      data: state.qrPayload,
      semanticLabel: l.screenQrParticipantLabel,
      code: state.code,
    );

    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: l.screenConnection,
            backLabel: l.screenBack,
            onBack: onBack,
          ),
          SizedBox(height: t.gap),
          Expanded(
            child: t.desktop
                ? Row(
                    crossAxisAlignment: t.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: t.stretch,
                          children: [
                            Expanded(child: AppScreenTile(child: intro)),
                          ],
                        ),
                      ),
                      SizedBox(width: t.gap),
                      Expanded(
                        child: AppScreenTile(child: Center(child: code)),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: t.stretch,
                      children: [
                        intro,
                        SizedBox(height: t.gap),
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
