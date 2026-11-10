import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

enum HeaderSample { back, long, save, edit }

class HeaderFixture extends StatelessWidget {
  const HeaderFixture({
    this.sample = HeaderSample.back,
    this.disabled = false,
    super.key,
  });
  final HeaderSample sample;
  final bool disabled;
  void _back() {}
  void _action() {}
  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context);
    return AppSectionHeader(
      title: switch (sample) {
        HeaderSample.back => localizations.headerNew,
        HeaderSample.long => localizations.headerLong,
        HeaderSample.save => localizations.headerEditing,
        HeaderSample.edit => localizations.headerProfile,
      },
      backLabel: localizations.headerBack,
      onBack: disabled ? null : _back,
      action: switch (sample) {
        HeaderSample.save => AppHeaderAction(
          kind: AppHeaderActionKind.save,
          label: localizations.headerSave,
          onPressed: disabled ? null : _action,
        ),
        HeaderSample.edit => AppHeaderAction(
          kind: AppHeaderActionKind.edit,
          label: localizations.headerEdit,
          onPressed: disabled ? null : _action,
        ),
        _ => null,
      },
    );
  }
}
