import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/stage_progress/app_stage_progress_theme.dart';

class AppStageProgress extends StatelessWidget {
  const AppStageProgress({required this.highlights, super.key});
  final List<bool> highlights;
  @override
  Widget build(BuildContext context) {
    final t = AppStageProgressTheme.of(context);
    return ExcludeSemantics(
      child: Row(
        children: [
          for (final (index, highlight) in highlights.indexed) ...[
            if (index > 0) SizedBox(width: t.gap),
            Expanded(
              child: SizedBox(
                height: t.height,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: highlight ? t.current : t.upcoming,
                    borderRadius: t.radius,
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
