import 'package:flutter/material.dart';

import '../ds_text/ds_text.dart';
import 'page_header_theme.dart';

enum PageHeaderVariant { compact, standard, hero }

class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.title,
    required this.sectionLabel,
    this.subtitle,
    this.trailing,
    this.variant = PageHeaderVariant.standard,
    super.key,
  });

  final String title;
  final String sectionLabel;
  final String? subtitle;
  final Widget? trailing;
  final PageHeaderVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<PageHeaderTheme>()!;
    final titleVariant = switch (variant) {
      PageHeaderVariant.compact => DsTextVariant.title,
      PageHeaderVariant.standard => DsTextVariant.heading,
      PageHeaderVariant.hero => DsTextVariant.display,
    };
    final copy = Semantics(
      header: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: theme.accent),
            child: SizedBox(
              width: theme.markerWidth,
              height: theme.markerHeight,
            ),
          ),
          SizedBox(width: theme.gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DsText(sectionLabel, variant: DsTextVariant.label),
                SizedBox(height: theme.labelGap),
                DsText(title, variant: titleVariant),
                if (subtitle != null) ...[
                  SizedBox(height: theme.labelGap),
                  DsText(subtitle!, variant: DsTextVariant.secondary),
                ],
              ],
            ),
          ),
        ],
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final trailing = this.trailing;
        if (trailing == null) return copy;
        if (constraints.maxWidth < theme.trailingBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              copy,
              SizedBox(height: theme.gap),
              Align(alignment: Alignment.centerLeft, child: trailing),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: copy),
            SizedBox(width: theme.gap),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(top: theme.trailingTopPadding),
                child: trailing,
              ),
            ),
          ],
        );
      },
    );
  }
}
