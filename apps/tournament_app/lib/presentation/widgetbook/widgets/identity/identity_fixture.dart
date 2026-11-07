import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class IdentityFixture extends StatelessWidget {
  const IdentityFixture({
    this.layout = AppIdentityLayout.inline,
    this.participant = false,
    this.long = false,
    super.key,
  });
  final AppIdentityLayout layout;
  final bool participant, long;
  @override
  Widget build(BuildContext context) => AppIdentity(
    primary: long ? 'Александр Константинопольский' : 'Иван',
    initials: 'И',
    secondary: participant
        ? null
        : FoundationLocalizations.of(context).participantDescription,
    layout: layout,
    kind: participant ? AppIdentityKind.participant : AppIdentityKind.character,
  );
}
