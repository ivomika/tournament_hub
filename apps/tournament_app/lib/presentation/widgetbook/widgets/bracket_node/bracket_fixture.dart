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
  AppBracketSlot _resolveFirst(FoundationLocalizations localizations) {
    if (state == AppBracketState.pending) {
      return AppBracketPlaceholder(localizations.bracketUnknownFirst);
    }
    return AppBracketParticipant(
      primary: 'Sub-Zero',
      secondary: long ? 'Александр Константинопольский' : 'Иван',
      initials: 'SZ',
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context);
    return AppBracketNode(
      label: switch (state) {
        AppBracketState.ready => localizations.bracketReady,
        AppBracketState.current => localizations.bracketCurrent,
        AppBracketState.pending => localizations.bracketPending,
      },
      state: state,
      onPressed: disabled ? null : _open,
      first: _resolveFirst(localizations),
      second: state == AppBracketState.pending
          ? AppBracketPlaceholder(localizations.bracketUnknownSecond)
          : const AppBracketParticipant(
              primary: 'Scorpion',
              secondary: 'Алексей',
              initials: 'SC',
            ),
    );
  }
}
