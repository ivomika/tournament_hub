import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_painter.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select_option.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select_theme.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select_sheet.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
export 'package:tournament_app/presentation/design_system/components/select/app_select_option.dart';

/// Controlled selection; popup/sheet is transient UI, selected value belongs to caller.
class AppSelect<T extends Object> extends StatefulWidget {
  const AppSelect({
    required this.label,
    required this.options,
    required this.value,
    required this.sheetDescription,
    required this.closeLabel,
    required this.onChanged,
    this.focusNode,
    super.key,
  });
  final String label, sheetDescription, closeLabel;
  final List<AppSelectOption<T>> options;
  final T value;
  final ValueChanged<T>? onChanged;
  final FocusNode? focusNode;
  @override
  State<AppSelect<T>> createState() => _AppSelectState<T>();
}

class _AppSelectState<T extends Object> extends State<AppSelect<T>> {
  final _ownedFocus = FocusNode(), _menu = MenuController();
  FocusNode get _focus => widget.focusNode ?? _ownedFocus;
  @override
  void initState() {
    super.initState();
    _focus.addListener(_changed);
  }

  @override
  void didUpdateWidget(covariant AppSelect<T> old) {
    super.didUpdateWidget(old);
    if (old.focusNode != widget.focusNode) {
      (old.focusNode ?? _ownedFocus).removeListener(_changed);
      _focus.addListener(_changed);
    }
  }

  void _changed() {
    setState(_rebuild);
  }

  void _rebuild() {}
  @override
  void dispose() {
    _focus.removeListener(_changed);
    _ownedFocus.dispose();
    super.dispose();
  }

  Object? _activate(ActivateIntent intent) {
    _open();
    return null;
  }

  Future<void> _open() async {
    if (widget.onChanged == null) return;
    final appearance = AppSelectTheme.of(context, true);
    if (appearance.desktop) {
      _menu.isOpen ? _menu.close() : _menu.open();
      return;
    }
    final value = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: appearance.transparent,
      barrierColor: Theme.of(context).colorScheme.scrim,
      constraints: BoxConstraints(maxWidth: appearance.sheetMaxWidth),
      builder: _sheet,
    );
    if (!mounted) return;
    if (value != null) widget.onChanged?.call(value);
    _focus.requestFocus();
  }

  Widget _sheet(BuildContext context) => _SelectModal<T>(
    label: widget.label,
    description: widget.sheetDescription,
    closeLabel: widget.closeLabel,
    options: widget.options,
    value: widget.value,
  );
  @override
  Widget build(BuildContext context) {
    final enabled = widget.onChanged != null,
        appearance = AppSelectTheme.of(context, enabled),
        selected = widget.options.singleWhere(
          (option) => option.value == widget.value,
        );
    return MenuAnchor(
      controller: _menu,
      childFocusNode: _focus,
      menuChildren: [
        for (final option in widget.options)
          _DesktopOption<T>(option: option, onSelected: widget.onChanged),
      ],
      builder: (context, controller, child) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: appearance.stretch,
        children: [
          if (appearance.desktop) ...[
            Text(widget.label, style: appearance.labelStyle),
            SizedBox(height: appearance.gap),
          ],
          Semantics(
            button: true,
            enabled: enabled,
            label: widget.label,
            value: selected.label,
            excludeSemantics: true,
            child: FocusableActionDetector(
              enabled: enabled,
              focusNode: _focus,
              shortcuts: const {
                SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
                SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
                SingleActivator(LogicalKeyboardKey.arrowDown): ActivateIntent(),
              },
              actions: {
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: _activate,
                ),
              },
              child: GestureDetector(
                onTap: enabled ? _open : null,
                child: CustomPaint(
                  foregroundPainter: _focus.hasFocus
                      ? AppFocusRingPainter(
                          AppFocusRingTheme(
                            color: appearance.focusColor,
                            width: appearance.focusWidth,
                            offset: appearance.focusOffset,
                            radius: appearance.radius,
                            capsule: false,
                            half: appearance.half,
                          ),
                        )
                      : null,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: appearance.desktop
                          ? appearance.background
                          : appearance.transparent,
                      borderRadius: appearance.radius,
                      border: appearance.desktop
                          ? Border.all(
                              color: appearance.border,
                              width: appearance.borderWidth,
                            )
                          : null,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: appearance.height),
                      child: Padding(
                        padding: appearance.padding,
                        child: Row(
                          mainAxisAlignment: appearance.spaceBetween,
                          children: [
                            if (!appearance.desktop)
                              Flexible(
                                child: Text(
                                  widget.label,
                                  style: appearance.mobileLabel,
                                ),
                              ),
                            if (appearance.desktop)
                              Expanded(
                                child: Text(
                                  selected.label,
                                  style: appearance.desktopStyle,
                                ),
                              ),
                            SizedBox(width: appearance.headerGap),
                            if (appearance.desktop)
                              RotatedBox(
                                quarterTurns: appearance.chevronTurns,
                                child: AppIcon(
                                  AppGlyph.chevron,
                                  color: appearance.labelStyle.color,
                                ),
                              )
                            else
                              Flexible(
                                child: Text(
                                  selected.label,
                                  style: appearance.selectedStyle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopOption<T extends Object> extends StatelessWidget {
  const _DesktopOption({required this.option, required this.onSelected});
  final AppSelectOption<T> option;
  final ValueChanged<T>? onSelected;
  void _choose() => onSelected?.call(option.value);
  @override
  Widget build(BuildContext context) => MenuItemButton(
    onPressed: onSelected == null ? null : _choose,
    child: Text(
      option.label,
      style: AppSelectTheme.of(context, onSelected != null).desktopStyle,
    ),
  );
}

class _SelectModal<T extends Object> extends StatefulWidget {
  const _SelectModal({
    required this.label,
    required this.description,
    required this.closeLabel,
    required this.options,
    required this.value,
  });
  final String label, description, closeLabel;
  final List<AppSelectOption<T>> options;
  final T value;
  @override
  State<_SelectModal<T>> createState() => _SelectModalState<T>();
}

class _SelectModalState<T extends Object> extends State<_SelectModal<T>> {
  void _choose(T value) => Navigator.of(context).pop(value);
  void _close() => Navigator.of(context).pop();
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: AppSelectSheet<T>(
      title: widget.label,
      description: widget.description,
      closeLabel: widget.closeLabel,
      options: widget.options,
      value: widget.value,
      onSelected: _choose,
      onClose: _close,
    ),
  );
}
