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
    final appearance = GuestAddScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    return AppSimpleFormLayout(
      header: AppSectionHeader(
        title: localizations.screenParticipants,
        backLabel: localizations.screenBack,
        onBack: onBack,
      ),
      intro: Text(localizations.screenNewGuest, style: appearance.heading),
      form: Column(
        mainAxisSize: appearance.min,
        crossAxisAlignment: appearance.stretch,
        children: [
          AppField(
            label: localizations.screenName,
            controller: nameController,
            onChanged: onNameChanged,
          ),
          SizedBox(height: appearance.gap),
          Text(state.notice, style: appearance.caption),
        ],
      ),
      footer: AppButton(
        label: localizations.screenAdd,
        glyph: AppGlyph.arrow,
        onPressed: onAdd,
      ),
    );
  }
}
