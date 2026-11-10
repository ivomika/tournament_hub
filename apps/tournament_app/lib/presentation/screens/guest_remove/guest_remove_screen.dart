import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/guest_remove/guest_remove_screen_state.dart';
import 'package:tournament_app/presentation/screens/guest_remove/guest_remove_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_modal_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/dialog/app_dialog.dart';

class GuestRemoveScreen extends StatelessWidget {
  const GuestRemoveScreen({
    required this.state,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });
  final GuestRemoveScreenState state;
  final VoidCallback? onConfirm, onCancel;
  @override
  Widget build(BuildContext context) {
    final appearance = GuestRemoveScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    return AppModalCanvas(
      theme: appearance,
      underlay: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: localizations.screenParticipants,
            backLabel: localizations.screenBack,
            onBack: onCancel,
          ),
        ],
      ),
      child: AppDialog(
        title: localizations.screenRemoveGuestTitle,
        content: state.description,
        confirmLabel: localizations.screenDelete,
        cancelLabel: localizations.screenCancel,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}
