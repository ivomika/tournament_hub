import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select_sheet.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select_theme.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

enum SelectValue { dark, light, system }

enum SelectSample { normal, focused, disabled, sheet }

abstract final class SelectOptions {
  static List<AppSelectOption<SelectValue>> of(BuildContext context) {
    final localizations = FoundationLocalizations.of(context);
    return [
      AppSelectOption(value: SelectValue.dark, label: localizations.selectDark),
      AppSelectOption(
        value: SelectValue.light,
        label: localizations.selectLight,
      ),
      AppSelectOption(
        value: SelectValue.system,
        label: localizations.selectSystem,
      ),
    ];
  }
}

class SelectFixture extends StatefulWidget {
  const SelectFixture({this.sample = SelectSample.normal, super.key});
  final SelectSample sample;
  @override
  State<SelectFixture> createState() => _SelectFixtureState();
}

class _SelectFixtureState extends State<SelectFixture> {
  final _focus = FocusNode();
  SelectValue _value = SelectValue.dark;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_apply);
  }

  void _apply(Duration elapsed) {
    if (mounted && widget.sample == SelectSample.focused) _focus.requestFocus();
  }

  @override
  void didUpdateWidget(covariant SelectFixture old) {
    super.didUpdateWidget(old);
    if (old.sample != widget.sample) {
      _focus.unfocus();
      WidgetsBinding.instance.addPostFrameCallback(_apply);
    }
  }

  void _choose(SelectValue value) {
    _value = value;
    setState(_rebuild);
  }

  void _rebuild() {}
  void _close() {}
  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context),
        appearance = AppSelectTheme.of(context, true);
    if (widget.sample == SelectSample.sheet) {
      return AppSelectSheet<SelectValue>(
        title: localizations.selectLabel,
        description: localizations.selectDescription,
        closeLabel: localizations.selectClose,
        options: SelectOptions.of(context),
        value: _value,
        onSelected: _choose,
        onClose: _close,
      );
    }
    return _SelectAdaptation(
      desktop: appearance.desktop,
      child: AppSelect<SelectValue>(
        label: localizations.selectLabel,
        sheetDescription: localizations.selectDescription,
        closeLabel: localizations.selectClose,
        options: SelectOptions.of(context),
        value: _value,
        focusNode: _focus,
        onChanged: widget.sample == SelectSample.disabled ? null : _choose,
      ),
    );
  }
}

class _SelectAdaptation extends StatelessWidget {
  const _SelectAdaptation({required this.desktop, required this.child});
  final bool desktop;
  final Widget child;
  @override
  Widget build(BuildContext context) =>
      desktop ? child : AppSurface(child: child);
}
