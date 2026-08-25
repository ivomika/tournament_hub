import 'package:flutter/material.dart';
import 'package:tournament_app/app/presentation/layout/app_breakpoints.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/tournament/application/tournament_creation_controller.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_format.dart';

class TournamentCreationScreen extends StatefulWidget {
  const TournamentCreationScreen({
    required this.controller,
    required this.tournamentScreenBuilder,
    super.key,
  });

  final TournamentCreationController controller;
  final Widget Function(TournamentDraft) tournamentScreenBuilder;

  @override
  State<TournamentCreationScreen> createState() =>
      _TournamentCreationScreenState();
}

class _TournamentCreationScreenState extends State<TournamentCreationScreen> {
  final _nameController = TextEditingController();
  final _guestController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _guestController.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новый турнир')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= AppBreakpoints.wide;
            return Center(
              child: ConstrainedBox(
                key: const Key('tournament-creation-content'),
                constraints: const BoxConstraints(
                  maxWidth: AppBreakpoints.maxContentWidth,
                ),
                child: ListenableBuilder(
                  listenable: widget.controller,
                  builder: (context, _) {
                    final details = _DetailsSection(
                      nameController: _nameController,
                      guestController: _guestController,
                      controller: widget.controller,
                      onCreate: _create,
                    );
                    final participants = _ParticipantsSection(
                      controller: widget.controller,
                      onRename: _renameGuest,
                    );
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: AppBreakpoints.formColumnWidth,
                                  child: details,
                                ),
                                const SizedBox(width: 32),
                                Expanded(child: participants),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                details,
                                const SizedBox(height: 32),
                                participants,
                              ],
                            ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _create() async {
    final created = await widget.controller.create(_nameController.text);
    if (!mounted || !created) return;
    final draft = widget.controller.savedDraft!;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => widget.tournamentScreenBuilder(draft),
      ),
    );
  }

  Future<void> _renameGuest(GuestProfile guest) async {
    final nickname = await showDialog<String>(
      context: context,
      builder: (context) =>
          _RenameGuestDialog(initialValue: guest.nickname.value),
    );
    if (nickname != null) {
      widget.controller.renameGuest(guest.id, nickname);
    }
  }
}

class _RenameGuestDialog extends StatefulWidget {
  const _RenameGuestDialog({required this.initialValue});

  final String initialValue;

  @override
  State<_RenameGuestDialog> createState() => _RenameGuestDialogState();
}

class _RenameGuestDialogState extends State<_RenameGuestDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Переименовать гостя'),
      content: TextField(
        key: const Key('rename-guest-input'),
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Nickname'),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({
    required this.nameController,
    required this.guestController,
    required this.controller,
    required this.onCreate,
  });

  final TextEditingController nameController;
  final TextEditingController guestController;
  final TournamentCreationController controller;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final isSaving = controller.status == TournamentCreationStatus.saving;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Параметры', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          key: const Key('tournament-name-input'),
          controller: nameController,
          enabled: !isSaving,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Название турнира',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<TournamentFormat>(
          key: const Key('tournament-format-input'),
          initialValue: controller.format,
          decoration: const InputDecoration(
            labelText: 'Формат',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final format in TournamentFormat.values)
              DropdownMenuItem(value: format, child: Text(format.displayName)),
          ],
          onChanged: isSaving
              ? null
              : (format) {
                  if (format != null) controller.selectFormat(format);
                },
        ),
        const SizedBox(height: 16),
        TextField(
          key: const Key('guest-nickname-input'),
          controller: guestController,
          enabled: !isSaving,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Nickname гостя',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              key: const Key('add-guest-button'),
              tooltip: 'Добавить гостя',
              onPressed: isSaving ? null : _addGuest,
              icon: const Icon(Icons.person_add_alt_1),
            ),
          ),
          onSubmitted: isSaving ? null : (_) => _addGuest(),
        ),
        if (controller.errorMessage case final message?) ...[
          const SizedBox(height: 12),
          Text(
            message,
            key: const Key('tournament-creation-error'),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton.icon(
          key: const Key('create-tournament-button'),
          onPressed: controller.canSubmit ? onCreate : null,
          icon: isSaving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.emoji_events_outlined),
          label: Text(isSaving ? 'Сохраняем…' : 'Создать турнир'),
        ),
      ],
    );
  }

  void _addGuest() {
    if (controller.addGuest(guestController.text)) {
      guestController.clear();
    }
  }
}

class _ParticipantsSection extends StatelessWidget {
  const _ParticipantsSection({
    required this.controller,
    required this.onRename,
  });

  final TournamentCreationController controller;
  final ValueChanged<GuestProfile> onRename;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Участники', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.phone_android),
            title: Text(controller.owner.nickname.value),
            subtitle: const Text('Локальный профиль · обязательно'),
            trailing: const Tooltip(
              message: 'Локальный профиль нельзя удалить',
              child: Icon(Icons.lock_outline),
            ),
          ),
        ),
        for (final guest in controller.guests)
          Card(
            key: ValueKey(guest.id.value),
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(guest.nickname.value),
              subtitle: const Text('Гость'),
              trailing: Wrap(
                children: [
                  IconButton(
                    tooltip: 'Переименовать ${guest.nickname.value}',
                    onPressed: () => onRename(guest),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: 'Удалить ${guest.nickname.value}',
                    onPressed: () => controller.removeGuest(guest.id),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          ),
        if (controller.guests.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'Нужен минимум ещё один игрок.',
              key: Key('minimum-participants-message'),
            ),
          ),
      ],
    );
  }
}
