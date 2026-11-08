import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/screens/contact/contact_screen_state.dart';
import 'package:tournament_app/presentation/screens/contact/contact_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_simple_form_layout.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/components/field/app_field.dart';
import 'package:tournament_app/presentation/design_system/components/notice/app_notice.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({
    required this.state,
    required this.messageController,
    required this.onBack,
    required this.onMessageChanged,
    required this.onSend,
    super.key,
  });
  final ContactScreenState state;
  final TextEditingController messageController;
  final VoidCallback? onBack, onSend;
  final ValueChanged<String>? onMessageChanged;
  @override
  Widget build(BuildContext context) {
    final t = ContactScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    return AppSimpleFormLayout(
      header: AppSectionHeader(
        title: l.screenContact,
        backLabel: l.screenBack,
        onBack: onBack,
      ),
      intro: Column(
        mainAxisSize: t.min,
        crossAxisAlignment: t.start,
        children: [
          Text(l.screenIdea, style: t.heading),
          Text(l.screenTell, style: t.heading),
        ],
      ),
      form: Column(
        mainAxisSize: t.min,
        crossAxisAlignment: t.stretch,
        children: [
          AppField(
            label: l.screenMessage,
            controller: messageController,
            kind: AppFieldKind.multiline,
            onChanged: onMessageChanged,
          ),
          SizedBox(height: t.gap),
          AppNotice(text: state.notice),
        ],
      ),
      footer: AppButton(
        label: l.screenSend,
        glyph: AppGlyph.arrow,
        onPressed: onSend,
      ),
    );
  }
}
