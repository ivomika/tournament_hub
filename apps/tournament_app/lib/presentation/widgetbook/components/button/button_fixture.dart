import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class ButtonFixture extends StatefulWidget {
  const ButtonFixture({
    this.kind = AppButtonKind.primary,
    this.state,
    this.long = false,
    this.fill = true,
    super.key,
  });
  final AppButtonKind kind;
  final WidgetState? state;
  final bool long, fill;
  @override
  State<ButtonFixture> createState() => _ButtonFixtureState();
}

class _ButtonFixtureState extends State<ButtonFixture> {
  late final _states = WidgetStatesController({
    if (widget.state != null) widget.state!,
  });
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_scheduleState);
  }

  void _scheduleState(Duration elapsed) {
    WidgetsBinding.instance.addPostFrameCallback(_applyState);
    WidgetsBinding.instance.scheduleFrame();
  }

  void _applyState(Duration elapsed) {
    if (mounted && widget.state != null) _states.update(widget.state!, true);
  }

  @override
  void didUpdateWidget(covariant ButtonFixture old) {
    super.didUpdateWidget(old);
    if (old.state != widget.state) {
      _states.value = {if (widget.state != null) widget.state!};
    }
  }

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  void _pressed() {}
  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context);
    return AppButton(
      kind: widget.kind,
      fill: widget.fill,
      statesController: _states,
      onPressed: widget.state == WidgetState.disabled ? null : _pressed,
      label: widget.long
          ? localizations.buttonLong
          : switch (widget.kind) {
              AppButtonKind.primary => localizations.buttonContinue,
              AppButtonKind.secondary => localizations.buttonCancel,
              AppButtonKind.destructive => localizations.buttonRemove,
              AppButtonKind.icon => localizations.buttonBack,
              AppButtonKind.accentIcon => localizations.buttonSave,
              _ => localizations.rosterDelete,
            },
      glyph: switch (widget.kind) {
        AppButtonKind.primary => AppGlyph.arrow,
        AppButtonKind.icon => AppGlyph.back,
        AppButtonKind.accentIcon => AppGlyph.check,
        AppButtonKind.removeIcon => AppGlyph.trash,
        _ => null,
      },
    );
  }
}
