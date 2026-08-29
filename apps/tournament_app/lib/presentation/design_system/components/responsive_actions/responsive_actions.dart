import 'package:flutter/material.dart';

import 'responsive_actions_theme.dart';

enum ResponsiveActionsLayout { auto, horizontal, vertical }

class ResponsiveActions extends StatelessWidget {
  const ResponsiveActions({
    required this.primary,
    this.secondary = const [],
    this.destructive,
    this.showSurface = false,
    this.layout = ResponsiveActionsLayout.auto,
    super.key,
  });

  final Widget primary;
  final List<Widget> secondary;
  final Widget? destructive;
  final bool showSurface;
  final ResponsiveActionsLayout layout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ResponsiveActionsTheme>()!;
    final actions = <Widget>[primary, ...secondary];
    final content = LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = switch (layout) {
          ResponsiveActionsLayout.auto =>
            constraints.maxWidth >= theme.horizontalBreakpoint,
          ResponsiveActionsLayout.horizontal => true,
          ResponsiveActionsLayout.vertical => false,
        };
        if (horizontal) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (destructive != null) ...[
                destructive!,
                SizedBox(width: theme.sectionGap),
              ],
              for (var index = 0; index < actions.length; index++) ...[
                if (index > 0) SizedBox(width: theme.gap),
                actions[index],
              ],
            ],
          );
        }
        return Column(
          crossAxisAlignment: showSurface
              ? CrossAxisAlignment.stretch
              : CrossAxisAlignment.end,
          children: [
            for (var index = 0; index < actions.length; index++) ...[
              if (index > 0) SizedBox(height: theme.gap),
              actions[index],
            ],
            if (destructive != null) ...[
              SizedBox(height: theme.sectionGap),
              destructive!,
            ],
          ],
        );
      },
    );
    if (!showSurface) return content;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        border: Border(top: BorderSide(color: theme.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(padding: EdgeInsets.all(theme.padding), child: content),
      ),
    );
  }
}
