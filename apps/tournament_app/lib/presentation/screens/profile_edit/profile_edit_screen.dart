import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/profile_edit/profile_edit_screen_state.dart';
import 'package:tournament_app/presentation/screens/profile_edit/profile_edit_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_simple_form_layout.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/components/field/app_field.dart';
import 'package:tournament_app/presentation/design_system/components/notice/app_notice.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({
    required this.state,
    required this.nameController,
    required this.onBack,
    required this.onSave,
    required this.onNameChanged,
    super.key,
  });
  final ProfileEditScreenState state;
  final TextEditingController nameController;
  final VoidCallback? onBack, onSave;
  final ValueChanged<String>? onNameChanged;
  @override
  Widget build(BuildContext context) {
    final appearance = ProfileEditScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    return AppSimpleFormLayout(
      header: AppSectionHeader(
        title: localizations.screenEditing,
        backLabel: localizations.screenBack,
        onBack: state.busy ? null : onBack,
        action: AppHeaderAction(
          kind: AppHeaderActionKind.save,
          label: state.busy
              ? localizations.screenProfileSaving
              : localizations.screenSaveName,
          onPressed: state.busy ? null : onSave,
        ),
      ),
      form: Column(
        crossAxisAlignment: appearance.stretch,
        mainAxisSize: appearance.min,
        children: [
          AppField(
            label: localizations.screenName,
            controller: nameController,
            readOnly: state.busy,
            onChanged: state.busy ? null : onNameChanged,
            errorText: state.phase == ProfileEditPhase.invalidName
                ? localizations.screenProfileNameRequired
                : null,
          ),
          if (state.phase == ProfileEditPhase.saveError) ...[
            SizedBox(height: appearance.small),
            AppNotice(
              text: localizations.screenSaveError,
              kind: AppNoticeKind.inlineError,
            ),
          ],
          if (state.phase == ProfileEditPhase.navigationError) ...[
            SizedBox(height: appearance.small),
            AppNotice(
              text: localizations.screenProfileReturnError,
              kind: AppNoticeKind.inlineError,
            ),
          ],
        ],
      ),
    );
  }
}
