import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/progress_indicator/app_progress_indicator.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class ProgressFixture extends StatelessWidget {
  const ProgressFixture({this.frozen = false, this.reduced = false, super.key});
  final bool frozen, reduced;
  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: reduced || frozen),
    child: TickerMode(
      enabled: !frozen,
      child: AppProgressIndicator(
        semanticLabel: FoundationLocalizations.of(context).progressLoading,
      ),
    ),
  );
}
