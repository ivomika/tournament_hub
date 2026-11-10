import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/withdraw/withdraw_screen_state.dart';
import 'package:tournament_app/presentation/screens/withdraw/withdraw_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_modal_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/dialog/app_dialog.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({
    required this.state,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });
  final WithdrawScreenState state;
  final VoidCallback? onConfirm, onCancel;
  @override
  Widget build(BuildContext context) {
    final appearance = WithdrawScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    return AppModalCanvas(
      theme: appearance,
      underlay: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: localizations.screenTournament,
            backLabel: localizations.screenBack,
            onBack: onCancel,
          ),
        ],
      ),
      child: AppDialog(
        title: state.title,
        content: state.description,
        confirmLabel: localizations.screenWithdrawAction,
        cancelLabel: localizations.screenCancel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        leading: AppIdentity(
          primary: state.player.character,
          initials: state.player.initials,
          secondary: state.player.name,
          size: AppAvatarSize.small,
        ),
      ),
    );
  }
}
