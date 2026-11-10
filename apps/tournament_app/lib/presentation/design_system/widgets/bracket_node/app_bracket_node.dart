import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_node/app_bracket_models.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_node/app_bracket_node_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
export 'package:tournament_app/presentation/design_system/widgets/bracket_node/app_bracket_models.dart';

class AppBracketNode extends StatelessWidget {
  const AppBracketNode({
    required this.label,
    required this.first,
    required this.second,
    required this.onPressed,
    this.state = AppBracketState.ready,
    this.focusNode,
    super.key,
  });
  final String label;
  final AppBracketSlot first, second;
  final VoidCallback? onPressed;
  final AppBracketState state;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    final appearance = AppBracketNodeTheme.of(context, state);
    return SizedBox(
      width: appearance.width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: appearance.background,
          borderRadius: appearance.radius,
          border: Border.all(
            color: appearance.borderColor,
            width: appearance.borderWidth,
          ),
        ),
        child: TextButton(
          focusNode: focusNode,
          onPressed: onPressed,
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(appearance.buttonPadding),
            minimumSize: WidgetStatePropertyAll(appearance.minimumSize),
            shape: WidgetStatePropertyAll(appearance.shape),
            overlayColor: WidgetStatePropertyAll(appearance.transparent),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: appearance.minHeight),
            child: Padding(
              padding: appearance.padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: appearance.start,
                children: [
                  SizedBox(
                    height:
                        MediaQuery.textScalerOf(context)
                            .scale(appearance.labelStyle.fontSize!) *
                        appearance.labelStyle.height!,
                    child: Text(label, style: appearance.labelStyle),
                  ),
                  SizedBox(height: appearance.gap),
                  _BracketSlot(slot: first, theme: appearance),
                  SizedBox(height: appearance.gap),
                  _BracketSlot(slot: second, theme: appearance),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BracketSlot extends StatelessWidget {
  const _BracketSlot({required this.slot, required this.theme});
  final AppBracketSlot slot;
  final AppBracketNodeTheme theme;
  @override
  Widget build(BuildContext context) => switch (slot) {
    AppBracketParticipant(:final primary, :final secondary, :final initials) =>
      AppIdentity(
        primary: primary,
        secondary: secondary,
        initials: initials,
        theme: theme.identity,
      ),
    AppBracketPlaceholder(:final text) => ConstrainedBox(
      constraints: BoxConstraints(minHeight: theme.placeholderHeight),
      child: Row(
        crossAxisAlignment: theme.center,
        children: [Flexible(child: Text(text, style: theme.unknownStyle))],
      ),
    ),
  };
}
