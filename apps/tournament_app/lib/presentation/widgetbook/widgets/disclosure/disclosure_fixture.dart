import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/disclosure/app_disclosure.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class DisclosureFixture extends StatefulWidget {
  const DisclosureFixture({
    this.open = false,
    this.disabled = false,
    this.long = false,
    super.key,
  });
  final bool open, disabled, long;
  @override
  State<DisclosureFixture> createState() => _DisclosureFixtureState();
}

class _DisclosureFixtureState extends State<DisclosureFixture> {
  late bool _expanded = widget.open;
  @override
  void didUpdateWidget(covariant DisclosureFixture old) {
    super.didUpdateWidget(old);
    if (old.open != widget.open) _expanded = widget.open;
  }

  void _toggle() {
    _expanded = !_expanded;
    setState(_rebuild);
  }

  void _rebuild() {}
  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context);
    return AppDisclosure(
      title: localizations.disclosureTitle,
      expanded: _expanded,
      onToggle: widget.disabled ? null : _toggle,
      child: Text(
        widget.long
            ? '${localizations.disclosureBody} ${localizations.disclosureBody}'
            : localizations.disclosureBody,
      ),
    );
  }
}
