import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select_option.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';

/// The actual mobile open state; callbacks only express selection/close intent.
class AppSelectSheet<T extends Object> extends StatelessWidget {
  const AppSelectSheet({
    required this.title,
    required this.description,
    required this.closeLabel,
    required this.options,
    required this.value,
    required this.onSelected,
    required this.onClose,
    super.key,
  });
  final String title, description, closeLabel;
  final List<AppSelectOption<T>> options;
  final T value;
  final ValueChanged<T> onSelected;
  final VoidCallback onClose;
  @override
  Widget build(BuildContext context) {
    final t = AppSelectTheme.of(context, true);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: t.sheetMaxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: t.sheetRadius,
          border: Border(
            top: BorderSide(color: t.border, width: t.sheetBorder),
            left: BorderSide(color: t.border, width: t.sheetBorder),
            right: BorderSide(color: t.border, width: t.sheetBorder),
          ),
        ),
        child: Padding(
          padding: t.sheetPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: t.stretch,
            children: [
              Center(
                child: SizedBox(
                  width: t.handleWidth,
                  height: t.handleHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: t.border,
                      borderRadius: t.handleRadius,
                    ),
                  ),
                ),
              ),
              SizedBox(height: t.handleGap),
              Row(
                children: [
                  Expanded(child: Text(title, style: t.titleStyle)),
                  SizedBox(width: t.headerGap),
                  SizedBox.square(
                    dimension: t.closeExtent,
                    child: IconButton(
                      onPressed: onClose,
                      tooltip: closeLabel,
                      style: IconButton.styleFrom(
                        backgroundColor: t.background,
                        padding: EdgeInsets.all(t.zero),
                      ),
                      icon: const AppIcon(AppGlyph.close),
                    ),
                  ),
                ],
              ),
              SizedBox(height: t.descriptionTop),
              Text(description, style: t.descriptionStyle),
              SizedBox(height: t.sectionGap),
              for (final (index, option) in options.indexed) ...[
                if (index > 0) SizedBox(height: t.gap),
                _SelectOption<T>(
                  option: option,
                  selected: option.value == value,
                  onSelected: onSelected,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectOption<T extends Object> extends StatelessWidget {
  const _SelectOption({
    required this.option,
    required this.selected,
    required this.onSelected,
  });
  final AppSelectOption<T> option;
  final bool selected;
  final ValueChanged<T> onSelected;
  void _choose() => onSelected(option.value);
  @override
  Widget build(BuildContext context) {
    final t = AppSelectTheme.of(context, true);
    return Semantics(
      selected: selected,
      button: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? t.background : t.transparent,
          borderRadius: t.optionRadius,
          border: Border.all(
            color: selected ? t.accent : t.transparent,
            width: t.sheetBorder,
          ),
        ),
        child: InkWell(
          onTap: _choose,
          borderRadius: t.optionRadius,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: t.optionMinHeight),
            child: Padding(
              padding: t.optionPadding,
              child: Row(
                children: [
                  Expanded(child: Text(option.label, style: t.optionStyle)),
                  SizedBox(width: t.headerGap),
                  Visibility(
                    visible: selected,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: AppIcon(AppGlyph.check, color: t.accent),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
