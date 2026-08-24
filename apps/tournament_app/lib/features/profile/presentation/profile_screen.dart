import 'package:flutter/material.dart';
import 'package:tournament_app/features/profile/application/local_profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.controller, super.key});

  final LocalProfileController controller;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nicknameController;
  var _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(
      text: widget.controller.profile!.nickname.value,
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _startEditing() {
    widget.controller.clearError();
    _nicknameController.text = widget.controller.profile!.nickname.value;
    setState(() => _isEditing = true);
  }

  void _cancelEditing() {
    widget.controller.clearError();
    _nicknameController.text = widget.controller.profile!.nickname.value;
    setState(() => _isEditing = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final saved = await widget.controller.updateNickname(
      _nicknameController.text,
    );
    if (saved && mounted) setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final profile = widget.controller.profile!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Профиль'),
            actions: [
              if (!_isEditing)
                IconButton(
                  tooltip: 'Изменить nickname',
                  onPressed: _startEditing,
                  icon: const Icon(Icons.edit_outlined),
                ),
            ],
          ),
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CircleAvatar(
                          radius: 42,
                          child: Text(
                            profile.nickname.value.characters.first
                                .toUpperCase(),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        const SizedBox(height: 28),
                        if (_isEditing)
                          TextFormField(
                            controller: _nicknameController,
                            autofocus: true,
                            enabled: !widget.controller.isSaving,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Nickname',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Введите nickname.'
                                : null,
                            onFieldSubmitted: (_) => _save(),
                          )
                        else
                          _ProfileField(
                            label: 'Nickname',
                            value: profile.nickname.value,
                          ),
                        if (widget.controller.errorMessage
                            case final message?) ...[
                          const SizedBox(height: 12),
                          Text(
                            message,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        if (_isEditing) ...[
                          const SizedBox(height: 20),
                          Wrap(
                            alignment: WrapAlignment.end,
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              TextButton(
                                onPressed: widget.controller.isSaving
                                    ? null
                                    : _cancelEditing,
                                child: const Text('Отмена'),
                              ),
                              FilledButton(
                                onPressed: widget.controller.isSaving
                                    ? null
                                    : _save,
                                child: widget.controller.isSaving
                                    ? const SizedBox.square(
                                        dimension: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Сохранить'),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
