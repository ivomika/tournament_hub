import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ParticipantDistributionScreenPreview extends StatelessWidget {
  const ParticipantDistributionScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Ваш персонаж',
    child: Column(
      children: [
        ParticipantIdentity(
          participant: previewParticipants.first,
          artworkVariant: FighterArtworkVariant.hero,
        ),
        const DsGap(DsSpace.lg),
        const StatusBadge(label: 'Ожидаем сетку', kind: StatusKind.info),
      ],
    ),
  );
}
