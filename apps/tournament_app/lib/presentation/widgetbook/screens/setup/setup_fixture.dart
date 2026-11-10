import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/setup/setup_screen.dart';
import 'package:tournament_app/presentation/screens/setup/setup_screen_state.dart';
export 'package:tournament_app/presentation/screens/setup/setup_screen_state.dart';

class SetupFixture extends StatefulWidget {
  const SetupFixture({required this.format, super.key});
  final TournamentFormatDisplay format;
  @override
  State<SetupFixture> createState() => _FixtureState();
}

class _FixtureState extends State<SetupFixture> {
  final controller = TextEditingController(text: 'Пятничный турнир');
  void action() {}
  void changed(String value) {}
  void selected(TournamentFormatDisplay value) {}
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _resolveFormatTitle(FoundationLocalizations localizations) {
    if (widget.format == TournamentFormatDisplay.roundRobin) {
      return localizations.screenRrTitle;
    }
    if (widget.format == TournamentFormatDisplay.doubleElimination) {
      return localizations.screenDeTitle;
    }
    return localizations.screenSeTitle;
  }

  String _resolveFormatHint(FoundationLocalizations localizations) {
    if (widget.format == TournamentFormatDisplay.roundRobin) {
      return localizations.screenRrHint;
    }
    if (widget.format == TournamentFormatDisplay.doubleElimination) {
      return localizations.screenDeHint;
    }
    return localizations.screenSeHint;
  }

  String? _resolveNotice(FoundationLocalizations localizations) {
    if (widget.format == TournamentFormatDisplay.roundRobin) {
      return localizations.screenRrNote;
    }
    if (widget.format == TournamentFormatDisplay.doubleElimination) {
      return localizations.screenDeNote;
    }
    return null;
  }

  String _resolveFinalLabel(FoundationLocalizations localizations) {
    if (widget.format == TournamentFormatDisplay.doubleElimination) {
      return localizations.screenGrandFinal;
    }
    return localizations.screenFinal;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context);
    final rr = widget.format == TournamentFormatDisplay.roundRobin;
    return SetupScreen(
      state: SetupScreenState(
        format: widget.format,
        formatTitle: _resolveFormatTitle(localizations),
        formatHint: _resolveFormatHint(localizations),
        notice: _resolveNotice(localizations),
        controls: rr
            ? []
            : [
                SetupFtControl(
                  label: localizations.screenMainBracket,
                  valueLabel: 'FT1',
                  onDecrease: null,
                  onIncrease: action,
                ),
                SetupFtControl(
                  label: _resolveFinalLabel(localizations),
                  valueLabel: 'FT1',
                  onDecrease: null,
                  onIncrease: action,
                ),
              ],
      ),
      nameController: controller,
      onBack: action,
      onNameChanged: changed,
      onFormatChanged: selected,
      onContinue: action,
    );
  }
}
