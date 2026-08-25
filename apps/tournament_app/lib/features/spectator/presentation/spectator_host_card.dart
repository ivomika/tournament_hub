import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tournament_app/features/spectator/application/spectator_host_controller.dart';

class SpectatorHostCard extends StatelessWidget {
  const SpectatorHostCard({required this.controller, super.key});

  final SpectatorHostController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final uri = controller.publicUri;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Экран зрителя',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                if (controller.isStarting)
                  const LinearProgressIndicator()
                else if (uri != null) ...[
                  const Text(
                    'Откройте адрес на телевизоре или другом устройстве в этой Wi-Fi сети.',
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: ColoredBox(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: QrImageView(
                          data: uri.toString(),
                          size: 148,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    uri.toString(),
                    key: const Key('spectator-host-url'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    key: const Key('copy-spectator-url'),
                    onPressed: () => _copy(context, uri.toString()),
                    icon: const Icon(Icons.copy),
                    label: const Text('Копировать адрес'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Подключено зрителей: ${controller.clientCount}',
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text(
                    controller.errorMessage ?? 'Spectator Host ещё не запущен.',
                    style: TextStyle(
                      color: controller.errorMessage == null
                          ? null
                          : Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: controller.start,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Запустить снова'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Адрес Spectator скопирован.')),
    );
  }
}
