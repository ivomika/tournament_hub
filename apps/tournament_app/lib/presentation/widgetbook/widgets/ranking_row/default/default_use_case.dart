import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/widgets/ranking_row/app_ranking_row.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';

final rankingRowDefaultUseCase = WidgetbookUseCase(
  name: 'places and points',
  builder: RankingRowDefaultUseCase.build,
);

abstract final class RankingRowDefaultUseCase {
  static Widget build(BuildContext context) => const RankingRowFixture();
}

class RankingRowFixture extends StatelessWidget {
  const RankingRowFixture({super.key});
  @override
  Widget build(BuildContext context) {
    final t = AppScreenLayoutTheme.of(context);
    return Padding(
      padding: t.inset,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: t.min,
          children: [
            const AppRankingRow(
              value: '1',
              primary: 'Kitana',
              secondary: 'Мария',
              initials: 'KT',
              placement: AppRankValuePlacement.leading,
              featured: true,
            ),
            SizedBox(height: t.gap),
            const AppRankingRow(
              value: '2',
              primary: 'Sub-Zero',
              secondary: 'Иван',
              initials: 'SZ',
              placement: AppRankValuePlacement.leading,
            ),
            SizedBox(height: t.gap),
            const AppRankingRow(
              value: '12',
              primary: 'Scorpion',
              secondary: 'Алексей',
              initials: 'SC',
              placement: AppRankValuePlacement.trailing,
            ),
          ],
        ),
      ),
    );
  }
}
