import 'package:flutter/material.dart';

import 'ds_progress_theme.dart';

class DsProgress extends StatelessWidget {
  const DsProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsProgressTheme>()!;
    return Center(
      child: SizedBox.square(
        dimension: theme.size,
        child: CircularProgressIndicator(color: theme.color),
      ),
    );
  }
}
