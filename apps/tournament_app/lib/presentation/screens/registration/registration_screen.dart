import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/field/app_field.dart';
import 'package:tournament_app/presentation/design_system/components/notice/app_notice.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_simple_form_layout.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/registration/registration_screen_state.dart';
import 'package:tournament_app/presentation/screens/registration/registration_screen_theme.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({
    required this.state,
    required this.nameController,
    required this.onNameChanged,
    required this.onSubmit,
    super.key,
  });

  final RegistrationScreenState state;
  final TextEditingController nameController;
  final ValueChanged<String>? onNameChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final appearance = RegistrationScreenTheme.of(context);
    final localizations = FoundationLocalizations.of(context);
    return AppSimpleFormLayout(
      header: Semantics(
        header: true,
        child: Text(
          localizations.screenRegistrationTitle,
          style: appearance.heading,
        ),
      ),
      intro: Text(
        localizations.screenRegistrationIntro,
        style: appearance.muted,
      ),
      form: Column(
        mainAxisSize: appearance.min,
        crossAxisAlignment: appearance.stretch,
        children: [
          AppField(
            label: localizations.screenName,
            controller: nameController,
            readOnly: state.busy,
            onChanged: state.busy ? null : onNameChanged,
            errorText: state.phase == RegistrationPhase.invalidName
                ? localizations.screenRegistrationNameRequired
                : null,
          ),
          if (state.phase == RegistrationPhase.saveError) ...[
            SizedBox(height: appearance.small),
            AppNotice(
              text: localizations.screenRegistrationSaveError,
              kind: AppNoticeKind.inlineError,
            ),
          ],
        ],
      ),
      footer: AppButton(
        label: state.busy
            ? localizations.screenRegistrationSaving
            : localizations.screenRegistrationContinue,
        onPressed: state.busy ? null : onSubmit,
      ),
    );
  }
}
