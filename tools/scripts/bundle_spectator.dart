import 'dart:io';

void main(List<String> arguments) async {
  if (arguments.contains('--help') || arguments.contains('-h')) {
    stdout.writeln(
      'Копирует собранный Spectator Web из apps/spectator_web/dist '
      'в assets Flutter-приложения.',
    );
    return;
  }

  final scriptFile = File.fromUri(Platform.script);
  final repositoryRoot = scriptFile.parent.parent.parent;
  final source = Directory(
    _join([repositoryRoot.path, 'apps', 'spectator_web', 'dist']),
  );
  final destination = Directory(
    _join([
      repositoryRoot.path,
      'apps',
      'tournament_app',
      'assets',
      'spectator',
    ]),
  );

  if (!source.existsSync()) {
    stderr.writeln(
      'Spectator bundle не найден: ${source.path}. '
      'Сначала выполните target build-web.',
    );
    exitCode = 1;
    return;
  }

  await destination.create(recursive: true);
  await for (final entity in source.list(recursive: true)) {
    final relativePath = entity.path.substring(source.path.length + 1);
    final targetPath = _join([destination.path, relativePath]);
    switch (entity) {
      case Directory():
        await Directory(targetPath).create(recursive: true);
      case File():
        await File(targetPath).parent.create(recursive: true);
        await entity.copy(targetPath);
      case Link():
        stderr.writeln(
          'Символическая ссылка в spectator bundle не поддерживается: '
          '${entity.path}',
        );
        exitCode = 1;
        return;
    }
  }

  stdout.writeln('Spectator bundle скопирован в ${destination.path}.');
}

String _join(Iterable<String> segments) =>
    segments.join(Platform.pathSeparator);
