import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/segmented_choice/app_segmented_choice.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

enum SegmentValue { de, se, rr }

class SegmentedFixture extends StatefulWidget {
  const SegmentedFixture({
    this.selected = SegmentValue.de,
    this.disabled = false,
    this.focused = false,
    super.key,
  });
  final SegmentValue selected;
  final bool disabled, focused;
  @override
  State<SegmentedFixture> createState() => _SegmentedFixtureState();
}

class _SegmentedFixtureState extends State<SegmentedFixture> {
  late SegmentValue _value = widget.selected;
  final _focus = FocusNode();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_apply);
  }

  void _apply(Duration elapsed) {
    if (mounted && widget.focused) _focus.requestFocus();
  }

  @override
  void didUpdateWidget(covariant SegmentedFixture old) {
    super.didUpdateWidget(old);
    if (old.selected != widget.selected) _value = widget.selected;
  }

  void _select(SegmentValue value) {
    _value = value;
    setState(_rebuild);
  }

  void _rebuild() {}
  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context);
    return AppSegmentedChoice<SegmentValue>(
      label: localizations.segmentedLabel,
      value: _value,
      focusNode: _focus,
      onChanged: widget.disabled ? null : _select,
      options: [
        AppSegment(value: SegmentValue.de, label: localizations.segmentDe),
        AppSegment(value: SegmentValue.se, label: localizations.segmentSe),
        AppSegment(value: SegmentValue.rr, label: localizations.segmentRr),
      ],
    );
  }
}
