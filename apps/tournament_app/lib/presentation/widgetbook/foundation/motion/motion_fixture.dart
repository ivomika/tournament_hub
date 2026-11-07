import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/roster_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

class MotionFixture extends StatelessWidget {
  const MotionFixture({this.reduced = false, this.revealed = false, super.key});
  final bool reduced, revealed;
  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(size: VisualViewport.mobile.size, disableAnimations: reduced),
    child: RosterFixture(revealed: revealed),
  );
}

/// Native Material3 animation; the HTML waveform is deliberately not copied.
class MotionProgressFixture extends StatelessWidget {
  const MotionProgressFixture({super.key});
  @override
  Widget build(BuildContext context) => const CircularProgressIndicator();
}
