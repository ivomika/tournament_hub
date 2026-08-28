import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostResultEntryScreenPreview extends StatelessWidget {
  const HostResultEntryScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Результат схватки',
    child: Column(
      children: [
        TournamentMatchCard(
          title: 'Раун 2',
          first: previewParticipants.first,
          second: previewParticipants[1],
          identityVariant: FighterArtworkVariant.matchup,
        ),
        const DsGap(DsSpace.lg),
        DsSection(
          title: 'Выберите победителя',
          child: DsFlow(
            children: [
              DsAction(label: 'Выбрать первого', onPressed: () {}),
              DsAction(
                label: 'Выбрать второго',
                kind: DsActionKind.secondary,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
