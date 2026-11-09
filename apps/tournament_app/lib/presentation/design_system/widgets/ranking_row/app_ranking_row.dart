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
    final t = AppRankingRowTheme.of(context, featured, placement, value);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: t.minHeight),
      child: DecoratedBox(
        decoration: t.decoration,
        child: Padding(
          padding: t.padding,
          child: Row(
            children: [
              if (placement == AppRankValuePlacement.leading) ...[
                SizedBox(
                  width: t.valueWidth,
                  child: Text(value, style: t.valueStyle, softWrap: false),
                ),
                SizedBox(width: t.small),
              ],
              Expanded(
                child: AppIdentity(
                  primary: primary,
                  initials: initials,
                  secondary: secondary,
                  theme: t.identity,
                ),
              ),
              if (placement == AppRankValuePlacement.trailing) ...[
                SizedBox(width: t.small),
                Text(value, style: t.valueStyle, softWrap: false),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
