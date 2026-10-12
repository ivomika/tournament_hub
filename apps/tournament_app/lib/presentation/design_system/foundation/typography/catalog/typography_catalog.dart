import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/catalog/typography_catalog_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

typedef TextStyleSample = ({String label, String text, TextStyle style});

class TypographyCatalog extends StatelessWidget {
  const TypographyCatalog({
    required this.theme,
    required this.samples,
    super.key,
  });

  final TypographyCatalogTheme theme;
  final List<TextStyleSample> samples;

  @override
  Widget build(BuildContext context) {
    final strings = FoundationLocalizations.of(context);
    final layout = theme.layout;
    return ColoredBox(
      color: theme.colors.background,
      child: SingleChildScrollView(
        padding: layout.pagePadding,
        child: Column(
          crossAxisAlignment: layout.textAlignment,
          children: [
            Text(strings.typographyTitle, style: theme.heading),
            SizedBox(height: layout.smallGap),
            Text(strings.typographyDescription, style: theme.description),
            SizedBox(height: layout.sectionGap),
            for (final sample in samples) ...[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colors.surface,
                  borderRadius: layout.cornerRadius,
                  border: Border.all(
                    color: theme.colors.border,
                    width: layout.borderWidth,
                  ),
                ),
                child: Padding(
                  padding: layout.tilePadding,
                  child: SizedBox(
                    width: layout.fullWidth,
                    child: Column(
                      crossAxisAlignment: layout.textAlignment,
                      children: [
                        Text(sample.label, style: theme.label),
                        SizedBox(height: layout.smallGap),
                        Text(
                          sample.text,
                          style: theme.sampleStyle(sample.style),
                        ),
                        SizedBox(height: layout.smallGap),
                        Text(
                          strings.fontDetails(
                            sample.style.fontFamily!,
                            sample.style.fontSize!.round(),
                            sample.style.fontWeight!.value,
                          ),
                          style: theme.details,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: layout.gap),
            ],
          ],
        ),
      ),
    );
  }
}
