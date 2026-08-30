import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class RegistrationScreenPreview extends StatefulWidget {
  const RegistrationScreenPreview({this.onSubmit, super.key});

  final Future<void> Function(String nickname)? onSubmit;

  @override
  State<RegistrationScreenPreview> createState() =>
      _RegistrationScreenPreviewState();
}

class _RegistrationScreenPreviewState extends State<RegistrationScreenPreview> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nickname = _controller.text.trim();
    if (nickname.isEmpty) {
      setState(() => _error = 'Введите никнейм');
      return;
    }
    final submit = widget.onSubmit;
    if (submit == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await submit(nickname);
    } on Object {
      if (mounted) {
        setState(
          () => _error = 'Не удалось сохранить профиль. Попробуйте ещё раз.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Как тебя представить?',
    subtitle: 'Никнейм будет виден участникам турнира на этом устройстве.',
    sectionLabel: 'ПЕРВЫЙ ВХОД',
    navigationRole: AppNavigationRole.focused,
    child: PageLayout(
      preset: PageLayoutPreset.workspace,
      primary: const DsSurface(
        tone: DsSurfaceTone.accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DsText('ТВОЯ ЛОКАЛЬНАЯ АРЕНА', variant: DsTextVariant.label),
            DsGap(DsSpace.md),
            DsText(
              'Создавай турниры. Добавляй гостей. Играй офлайн.',
              variant: DsTextVariant.heading,
            ),
            DsGap(DsSpace.md),
            DsText(
              'Профиль хранится локально и не требует регистрации в интернете.',
              variant: DsTextVariant.secondary,
            ),
          ],
        ),
      ),
      secondary: DsSection(
        title: 'Создание профиля',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DsTextField(
              label: 'Никнейм',
              controller: _controller,
              helperText: 'Unicode и emoji разрешены',
              errorText: _error,
              enabled: !_loading,
              autofocus: true,
              textInputAction: DsTextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            const DsGap(DsSpace.md),
            DsAction(
              label: 'Войти в арену',
              status: _loading ? DsActionStatus.loading : DsActionStatus.idle,
              onPressed: _loading ? null : _submit,
            ),
          ],
        ),
      ),
    ),
  );
}
