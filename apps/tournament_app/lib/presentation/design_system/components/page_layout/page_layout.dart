import 'package:flutter/material.dart';

import 'page_layout_preset.dart';
import 'page_layout_theme.dart';

export 'page_layout_preset.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({
    required this.preset,
    required this.primary,
    this.secondary,
    this.supporting,
    super.key,
  }) : assert(
         preset == PageLayoutPreset.focused || secondary != null,
         'Для двухпанельного preset требуется secondary region.',
       );

  final PageLayoutPreset preset;
  final Widget primary;
  final Widget? secondary;
  final Widget? supporting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<PageLayoutTheme>()!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final expanded = constraints.maxWidth >= theme.expandedBreakpoint;
        final main = expanded ? _expanded(theme) : _compact(theme);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            main,
            if (supporting != null) ...[
              SizedBox(height: theme.supportingGap),
              KeyedSubtree(
                key: const Key('page-layout-supporting'),
                child: supporting!,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _compact(PageLayoutTheme theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      KeyedSubtree(key: const Key('page-layout-primary'), child: primary),
      if (secondary != null) ...[
        SizedBox(height: theme.panelGap),
        KeyedSubtree(
          key: const Key('page-layout-secondary'),
          child: secondary!,
        ),
      ],
    ],
  );

  Widget _expanded(PageLayoutTheme theme) {
    if (preset == PageLayoutPreset.focused) {
      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: theme.focusedMaxWidth),
          child: KeyedSubtree(
            key: const Key('page-layout-primary'),
            child: primary,
          ),
        ),
      );
    }

    final (primaryFlex, secondaryFlex) = switch (preset) {
      PageLayoutPreset.focused => throw StateError('Недостижимый preset'),
      PageLayoutPreset.split => (
        theme.splitPrimaryFlex,
        theme.splitSecondaryFlex,
      ),
      PageLayoutPreset.workspace => (
        theme.workspacePrimaryFlex,
        theme.workspaceSecondaryFlex,
      ),
      PageLayoutPreset.archive => (
        theme.archivePrimaryFlex,
        theme.archiveSecondaryFlex,
      ),
      PageLayoutPreset.hero => (theme.heroPrimaryFlex, theme.heroSecondaryFlex),
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: primaryFlex,
          child: KeyedSubtree(
            key: const Key('page-layout-primary'),
            child: primary,
          ),
        ),
        SizedBox(width: theme.panelGap),
        Expanded(
          flex: secondaryFlex,
          child: KeyedSubtree(
            key: const Key('page-layout-secondary'),
            child: secondary!,
          ),
        ),
      ],
    );
  }
}
