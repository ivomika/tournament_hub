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
    final l = FoundationLocalizations.of(context);
    return AppSectionHeader(
      title: switch (sample) {
        HeaderSample.back => l.headerNew,
        HeaderSample.long => l.headerLong,
        HeaderSample.save => l.headerEditing,
        HeaderSample.edit => l.headerProfile,
      },
      backLabel: l.headerBack,
      onBack: disabled ? null : _back,
      action: switch (sample) {
        HeaderSample.save => AppHeaderAction(
          kind: AppHeaderActionKind.save,
          label: l.headerSave,
          onPressed: disabled ? null : _action,
        ),
        HeaderSample.edit => AppHeaderAction(
          kind: AppHeaderActionKind.edit,
          label: l.headerEdit,
          onPressed: disabled ? null : _action,
        ),
        _ => null,
      },
    );
  }
}
