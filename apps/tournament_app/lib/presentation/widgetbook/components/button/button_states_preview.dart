import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/button_fixture.dart';

class ButtonStatesPreview extends StatelessWidget {
  const ButtonStatesPreview({required this.kind, super.key});
  final AppButtonKind kind;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final state in <WidgetState?>[
        null,
        WidgetState.hovered,
        WidgetState.pressed,
        WidgetState.focused,
        WidgetState.disabled,
      ])
        Padding(
          padding: EdgeInsets.all(
            Theme.of(context).extension<AppSpacing>()!.space12,
          ),
          child: ButtonFixture(kind: kind, state: state),
        ),
    ],
  );
}
