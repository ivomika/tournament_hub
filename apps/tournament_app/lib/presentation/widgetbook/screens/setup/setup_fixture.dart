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

  @override
  Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context);
    final de = widget.format == TournamentFormatDisplay.doubleElimination,
        rr = widget.format == TournamentFormatDisplay.roundRobin;
    return SetupScreen(
      state: SetupScreenState(
        format: widget.format,
        formatTitle: rr
            ? l.screenRrTitle
            : de
            ? l.screenDeTitle
            : l.screenSeTitle,
        formatHint: rr
            ? l.screenRrHint
            : de
            ? l.screenDeHint
            : l.screenSeHint,
        notice: rr
            ? l.screenRrNote
            : de
            ? l.screenDeNote
            : null,
        controls: rr
            ? []
            : [
                SetupFtControl(
                  label: l.screenMainBracket,
                  valueLabel: 'FT1',
                  onDecrease: null,
                  onIncrease: action,
                ),
                SetupFtControl(
                  label: de ? l.screenGrandFinal : l.screenFinal,
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
