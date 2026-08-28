import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class BootstrapScreenPreview extends StatelessWidget {
  const BootstrapScreenPreview({super.key});

  @override
  Widget build(BuildContext context) =>
      const AppShell(title: 'Tournament Hub', child: DsProgress());
}
