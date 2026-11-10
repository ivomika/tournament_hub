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
    final appearance = AppSelectTheme.of(context, true);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: appearance.sheetMaxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: appearance.surface,
          borderRadius: appearance.sheetRadius,
          border: Border(
            top: BorderSide(
              color: appearance.border,
              width: appearance.sheetBorder,
            ),
            left: BorderSide(
              color: appearance.border,
              width: appearance.sheetBorder,
            ),
            right: BorderSide(
              color: appearance.border,
              width: appearance.sheetBorder,
            ),
          ),
        ),
        child: Padding(
          padding: appearance.sheetPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: appearance.stretch,
            children: [
              Center(
                child: SizedBox(
                  width: appearance.handleWidth,
                  height: appearance.handleHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: appearance.border,
                      borderRadius: appearance.handleRadius,
                    ),
                  ),
                ),
              ),
              SizedBox(height: appearance.handleGap),
              Row(
                children: [
                  Expanded(child: Text(title, style: appearance.titleStyle)),
                  SizedBox(width: appearance.headerGap),
                  SizedBox.square(
                    dimension: appearance.closeExtent,
                    child: IconButton(
                      onPressed: onClose,
                      tooltip: closeLabel,
                      style: IconButton.styleFrom(
                        backgroundColor: appearance.background,
                        padding: EdgeInsets.all(appearance.zero),
                      ),
                      icon: const AppIcon(AppGlyph.close),
                    ),
                  ),
                ],
              ),
              SizedBox(height: appearance.descriptionTop),
              Text(description, style: appearance.descriptionStyle),
              SizedBox(height: appearance.sectionGap),
              for (final (index, option) in options.indexed) ...[
                if (index > 0) SizedBox(height: appearance.gap),
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
    final appearance = AppSelectTheme.of(context, true);
    return Semantics(
      selected: selected,
      button: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? appearance.background : appearance.transparent,
          borderRadius: appearance.optionRadius,
          border: Border.all(
            color: selected ? appearance.accent : appearance.transparent,
            width: appearance.sheetBorder,
          ),
        ),
        child: InkWell(
          onTap: _choose,
          borderRadius: appearance.optionRadius,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: appearance.optionMinHeight),
            child: Padding(
              padding: appearance.optionPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Text(option.label, style: appearance.optionStyle),
                  ),
                  SizedBox(width: appearance.headerGap),
                  Visibility(
                    visible: selected,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: AppIcon(AppGlyph.check, color: appearance.accent),
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
