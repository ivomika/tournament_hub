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
    final t = GuestRemoveScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    return AppModalCanvas(
      theme: t,
      underlay: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: l.screenParticipants,
            backLabel: l.screenBack,
            onBack: onCancel,
          ),
        ],
      ),
      child: AppDialog(
        title: l.screenRemoveGuestTitle,
        content: state.description,
        confirmLabel: l.screenDelete,
        cancelLabel: l.screenCancel,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}
