import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/screens/guest_add/guest_add_screen_state.dart';
import 'package:tournament_app/presentation/screens/guest_add/guest_add_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_simple_form_layout.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/components/field/app_field.dart';

class GuestAddScreen extends StatelessWidget {
  const GuestAddScreen({
    required this.state,
    required this.nameController,
    required this.onBack,
    required this.onNameChanged,
    required this.onAdd,
    super.key,
  });
  final GuestAddScreenState state;
  final TextEditingController nameController;
  final VoidCallback? onBack, onAdd;
  final ValueChanged<String>? onNameChanged;
  @override
  Widget build(BuildContext context) {
    final t = GuestAddScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    return AppSimpleFormLayout(
      header: AppSectionHeader(
        title: l.screenParticipants,
        backLabel: l.screenBack,
        onBack: onBack,
      ),
      intro: Text(l.screenNewGuest, style: t.heading),
      form: Column(
        mainAxisSize: t.min,
        crossAxisAlignment: t.stretch,
        children: [
          AppField(
            label: l.screenName,
            controller: nameController,
            onChanged: onNameChanged,
          ),
          SizedBox(height: t.gap),
          Text(state.notice, style: t.caption),
        ],
      ),
      footer: AppButton(
        label: l.screenAdd,
        glyph: AppGlyph.arrow,
        onPressed: onAdd,
      ),
    );
  }
}
