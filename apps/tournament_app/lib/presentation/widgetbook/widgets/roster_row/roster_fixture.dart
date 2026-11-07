import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/roster_row/app_roster_row.dart';

class RosterFixture extends StatefulWidget {
  const RosterFixture({
    this.revealed = false,
    this.focused = false,
    this.disabled = false,
    this.long = false,
    super.key,
  });
  final bool revealed, focused, disabled, long;
  @override
  State<RosterFixture> createState() => _RosterFixtureState();
}

class _RosterFixtureState extends State<RosterFixture> {
  late final _states = WidgetStatesController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_schedule);
  }

  void _schedule(Duration elapsed) {
    WidgetsBinding.instance.addPostFrameCallback(_apply);
    WidgetsBinding.instance.scheduleFrame();
  }

  void _apply(Duration elapsed) {
    if (mounted) _states.update(WidgetState.focused, widget.focused);
  }

  @override
  void didUpdateWidget(covariant RosterFixture old) {
    super.didUpdateWidget(old);
    if (old.focused != widget.focused) {
      _states.update(WidgetState.focused, widget.focused);
    }
  }

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  void _remove() {} // Demo consumes intent; does not delete the participant.
  @override
  Widget build(BuildContext context) => AppRosterRow(
    key: ValueKey('${widget.revealed}-${widget.long}'),
    name: widget.long ? 'Александр Константинопольский' : 'Иван',
    initials: 'И',
    onRemove: widget.disabled ? null : _remove,
    initiallyRevealed: widget.revealed,
    removeStatesController: _states,
  );
}
