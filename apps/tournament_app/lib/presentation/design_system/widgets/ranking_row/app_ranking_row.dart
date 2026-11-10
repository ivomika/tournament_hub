import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/ranking_row/app_ranking_row_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
export 'package:tournament_app/presentation/design_system/widgets/ranking_row/app_ranking_row_theme.dart'
    show AppRankValuePlacement;

class AppRankingRow extends StatelessWidget {
  const AppRankingRow({
    required this.value,
    required this.primary,
    required this.secondary,
    required this.initials,
    required this.placement,
    this.featured = false,
    super.key,
  });
  final String value, primary, secondary, initials;
  final AppRankValuePlacement placement;
  final bool featured;
  @override
  Widget build(BuildContext context) {
    final appearance = AppRankingRowTheme.of(
      context,
      featured,
      placement,
      value,
    );
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: appearance.minHeight),
      child: DecoratedBox(
        decoration: appearance.decoration,
        child: Padding(
          padding: appearance.padding,
          child: Row(
            children: [
              if (placement == AppRankValuePlacement.leading) ...[
                SizedBox(
                  width: appearance.valueWidth,
                  child: Text(
                    value,
                    style: appearance.valueStyle,
                    softWrap: false,
                  ),
                ),
                SizedBox(width: appearance.small),
              ],
              Expanded(
                child: AppIdentity(
                  primary: primary,
                  initials: initials,
                  secondary: secondary,
                  theme: appearance.identity,
                ),
              ),
              if (placement == AppRankValuePlacement.trailing) ...[
                SizedBox(width: appearance.small),
                Text(value, style: appearance.valueStyle, softWrap: false),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
