import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/share_link/app_share_link.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class ShareFixture extends StatelessWidget {
  const ShareFixture({this.long = false, this.disabled = false, super.key});
  final bool long, disabled;
  void _copy() {}
  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context);
    return AppShareLink(
      role: localizations.shareRole,
      address: long
          ? 'http://host.local/spectator/tournament-with-a-long-session-address'
          : 'http://host.local/spectator',
      copyLabel: localizations.shareCopy,
      onCopy: disabled ? null : _copy,
    );
  }
}
