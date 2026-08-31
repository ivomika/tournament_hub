import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

typedef SaveHostDraft = Future<void> Function({
  required String title,
  required String formatId,
});

class HostDraftScreenPreview extends StatefulWidget {
  const HostDraftScreenPreview({
    this.title = 'Новый турнир',
    this.formatId = 'double-elimination',
    this.onSave,
    this.onOpen,
    this.onCancel,
    super.key,
  });

  final String title;
  final String formatId;
  final SaveHostDraft? onSave;
  final Future<void> Function()? onOpen;
  final VoidCallback? onCancel;

  @override
  State<HostDraftScreenPreview> createState() => _HostDraftScreenPreviewState();
}

class _HostDraftScreenPreviewState extends State<HostDraftScreenPreview> {
  late final TextEditingController _title;
  late String _formatId;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.title);
    _formatId = widget.formatId;
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppShell(
    title: widget.title,
    subtitle: 'Проверь параметры перед открытием лобби.',
    sectionLabel: 'ЧЕРНОВИК · ЭТАП 1 ИЗ 5',
    headerVariant: PageHeaderVariant.compact,
    actionDock: ActionDock(
      primary: DsAction(
        key: const Key('save-and-open-draft'),
        label: _isSaving ? 'Сохраняем…' : 'Сохранить и открыть лобби',
        onPressed: _canSubmit ? _saveAndOpen : null,
      ),
      destructive: ActionDockAction(
        label: 'Отменить турнир',
        kind: ActionDockActionKind.destructive,
        confirmationTitle: 'Отменить турнир?',
        confirmationMessage: 'Факт отмены будет сохранён в истории.',
        onSelected: widget.onCancel ?? () {},
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DsSection(
          title: 'Параметры',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DsTextField(
                key: const Key('draft-title'),
                label: 'Название турнира',
                controller: _title,
                enabled: !_isSaving,
                errorText: _error,
                textInputAction: DsTextInputAction.done,
                onChanged: (_) => setState(() => _error = null),
                onSubmitted: (_) {
                  if (_canSubmit) _saveAndOpen();
                },
              ),
              const DsGap(DsSpace.md),
              DsSelect<String>(
                key: const Key('draft-format'),
                label: 'Режим',
                value: _formatId,
                options: _formatOptions,
                enabled: !_isSaving,
                onChanged: (value) => setState(() {
                  _formatId = value;
                  _error = null;
                }),
              ),
            ],
          ),
        ),
        const DsGap(DsSpace.lg),
        TournamentStageHeader(
          variant: TournamentStageVariant.strip,
          stage: 'Черновик',
          progress: _formatLabel(_formatId),
          detail: 'Правила будут зафиксированы после открытия лобби.',
        ),
      ],
    ),
  );

  bool get _canSubmit => !_isSaving && _title.text.trim().isNotEmpty;

  Future<void> _saveAndOpen() async {
    if (!_canSubmit) return;
    setState(() {
      _isSaving = true;
      _error = null;
    });
    try {
      await widget.onSave?.call(title: _title.text, formatId: _formatId);
      await widget.onOpen?.call();
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _error = 'Не удалось сохранить черновик. Попробуйте ещё раз.',
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

const _formatOptions = <DsSelectOption<String>>[
  DsSelectOption(value: 'double-elimination', label: 'Double Elimination'),
  DsSelectOption(value: 'single-elimination', label: 'Single Elimination'),
  DsSelectOption(value: 'round-robin', label: 'Round Robin'),
];

String _formatLabel(String formatId) => switch (formatId) {
  'double-elimination' => 'Double Elimination',
  'single-elimination' => 'Single Elimination',
  'round-robin' => 'Round Robin',
  _ => formatId,
};
