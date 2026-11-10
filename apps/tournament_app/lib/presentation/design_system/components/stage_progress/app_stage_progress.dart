import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/stage_progress/app_stage_progress_theme.dart';

class AppStageProgress extends StatelessWidget {
  const AppStageProgress({required this.highlights, super.key});
  final List<bool> highlights;
  @override
  Widget build(BuildContext context) {
    final appearance = AppStageProgressTheme.of(context);
    return ExcludeSemantics(
      child: Row(
        children: [
          for (final (index, highlight) in highlights.indexed) ...[
            if (index > 0) SizedBox(width: appearance.gap),
            Expanded(
              child: SizedBox(
                height: appearance.height,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: highlight ? appearance.current : appearance.upcoming,
                    borderRadius: appearance.radius,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
