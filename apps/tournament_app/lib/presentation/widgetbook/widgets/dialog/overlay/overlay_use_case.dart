import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/dialog/app_dialog_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/dialog/dialog_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

final dialogOverlayUseCase = WidgetbookUseCase(
  name: 'Actual modal overlay',
  builder: DialogOverlayUseCase.build,
);

abstract final class DialogOverlayUseCase {
  static Widget build(BuildContext context) => const DialogOverlayFixture();
}

class DialogOverlayFixture extends StatefulWidget {
  const DialogOverlayFixture({super.key});
  @override
  State<DialogOverlayFixture> createState() => _DialogOverlayState();
}

class _DialogOverlayState extends State<DialogOverlayFixture> {
  final _trigger = FocusNode(), _cancel = FocusNode();
  @override
  void dispose() {
    _trigger.dispose();
    _cancel.dispose();
    super.dispose();
  }

  void _focusCancel(Duration elapsed) {
    if (mounted) _cancel.requestFocus();
  }

  Future<void> _open() async {
    _trigger.requestFocus();
    WidgetsBinding.instance.addPostFrameCallback(_focusCancel);
    await showDialog<void>(
      context: context,
      barrierColor: Theme.of(context).colorScheme.scrim,
      builder: _modal,
    );
    if (mounted) _trigger.requestFocus();
  }

  void _close() => Navigator.of(context).pop();
  Widget _modal(BuildContext context) {
    final t = AppDialogTheme.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
            Theme.of(context).extension<AppSpacing>()!.space24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: t.maxWidth),
            child: DialogFixture(
              cancelFocus: _cancel,
              onConfirm: _close,
              onCancel: _close,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AppButton(
    label: FoundationLocalizations.of(context).dialogOpen,
    kind: AppButtonKind.secondary,
    onPressed: _open,
    focusNode: _trigger,
  );
}
