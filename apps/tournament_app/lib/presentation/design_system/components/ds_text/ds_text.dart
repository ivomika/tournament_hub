import 'package:flutter/material.dart';

import 'ds_text_theme.dart';

enum DsTextVariant { display, heading, title, body, secondary, label }

class DsText extends StatelessWidget {
  const DsText(
    this.data, {
    this.variant = DsTextVariant.body,
    this.textAlign,
    this.maxLines,
    super.key,
  });

  final String data;
  final DsTextVariant variant;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsTextTheme>()!;
    final style = switch (variant) {
      DsTextVariant.display => theme.display,
      DsTextVariant.heading => theme.heading,
      DsTextVariant.title => theme.title,
      DsTextVariant.body => theme.body,
      DsTextVariant.secondary => theme.secondary,
      DsTextVariant.label => theme.label,
    };
    return Text(
      data,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );
  }
}
