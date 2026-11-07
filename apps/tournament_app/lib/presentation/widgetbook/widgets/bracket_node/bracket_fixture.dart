import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_node/app_bracket_node.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class BracketFixture extends StatelessWidget {
  const BracketFixture({
    this.state = AppBracketState.ready,
    this.disabled = false,
    this.long = false,
    super.key,
  });
  final AppBracketState state;
  final bool disabled, long;
  void _open() {}
  @override
  Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context);
    return AppBracketNode(
      label: switch (state) {
        AppBracketState.ready => l.bracketReady,
        AppBracketState.current => l.bracketCurrent,
        AppBracketState.pending => l.bracketPending,
      },
      state: state,
      onPressed: disabled ? null : _open,
      first: state == AppBracketState.pending
          ? AppBracketPlaceholder(l.bracketUnknownFirst)
          : AppBracketParticipant(
              primary: 'Sub-Zero',
              secondary: long ? 'Александр Константинопольский' : 'Иван',
              initials: 'SZ',
            ),
      second: state == AppBracketState.pending
          ? AppBracketPlaceholder(l.bracketUnknownSecond)
          : const AppBracketParticipant(
              primary: 'Scorpion',
              secondary: 'Алексей',
              initials: 'SC',
            ),
    );
  }
}
