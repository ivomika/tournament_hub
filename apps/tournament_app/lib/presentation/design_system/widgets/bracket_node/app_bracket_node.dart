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
    final t = AppBracketNodeTheme.of(context, state);
    return SizedBox(
      width: t.width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.background,
          borderRadius: t.radius,
          border: Border.all(color: t.borderColor, width: t.borderWidth),
        ),
        child: TextButton(
          focusNode: focusNode,
          onPressed: onPressed,
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(t.buttonPadding),
            minimumSize: WidgetStatePropertyAll(t.minimumSize),
            shape: WidgetStatePropertyAll(t.shape),
            overlayColor: WidgetStatePropertyAll(t.transparent),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: t.minHeight),
            child: Padding(
              padding: t.padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: t.start,
                children: [
                  SizedBox(
                    height:
                        MediaQuery.textScalerOf(context)
                            .scale(t.labelStyle.fontSize!) *
                        t.labelStyle.height!,
                    child: Text(label, style: t.labelStyle),
                  ),
                  SizedBox(height: t.gap),
                  _BracketSlot(slot: first, theme: t),
                  SizedBox(height: t.gap),
                  _BracketSlot(slot: second, theme: t),
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
