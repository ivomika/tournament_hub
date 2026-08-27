import 'dart:io';

const _flutterAppRelativePath = 'apps/tournament_app';
const _spectatorAppRelativePath = 'apps/spectator_web';

Future<void> main(List<String> arguments) async {
  final command = arguments.isEmpty ? 'help' : arguments.first;
  final options = _parseOptions(arguments.skip(1));
  final runner = ProjectRunner();

  switch (command) {
    case 'help':
      runner.printHelp();
      return;
    case 'setup':
      await runner.flutter(const ['pub', 'get']);
      await runner.npm(const ['ci']);
      return;
    case 'run':
      final device = options['device'];
      await runner.flutter([
        'run',
        if (device != null && device.isNotEmpty) ...['-d', device],
      ]);
      return;
    case 'run-spectator':
      await runner.npm(const ['run', 'dev']);
      return;
    case 'build':
      await runner.buildFlutter(options['target']);
      await runner.buildSpectator();
      return;
    case 'build-flutter':
      await runner.buildFlutter(options['target']);
      return;
    case 'build-spectator':
      await runner.buildSpectator();
      return;
    case 'format':
      await runner.dart([
        'format',
        runner.flutterDirectory.path,
        runner.toolDirectory.path,
      ]);
      await runner.npm(const ['run', 'format']);
      return;
    case 'lint':
      await runner.flutter(const ['analyze']);
      await runner.npm(const ['run', 'check']);
      return;
    case 'test':
      await runner.flutter(const ['test']);
      return;
    case 'check':
      await runner.dart([
        'format',
        '--output=none',
        '--set-exit-if-changed',
        runner.flutterDirectory.path,
        runner.toolDirectory.path,
      ]);
      await runner.npm(const ['run', 'format:check']);
      await runner.flutter(const ['analyze']);
      await runner.flutter(const ['test']);
      await runner.npm(const ['run', 'check']);
      return;
    case 'clean':
      await runner.flutter(const ['clean']);
      return;
    default:
      stderr.writeln('Unknown command: $command');
      runner.printHelp();
      exitCode = 64;
  }
}

Map<String, String> _parseOptions(Iterable<String> arguments) {
  final result = <String, String>{};
  final values = arguments.toList();

  for (var index = 0; index < values.length; index++) {
    final argument = values[index];
    if (!argument.startsWith('--')) {
      throw FormatException('Expected --name option, got: $argument');
    }
    final name = argument.substring(2);
    if (index + 1 >= values.length) {
      throw FormatException('Missing value for --$name');
    }
    result[name] = values[++index];
  }

  return result;
}

final class ProjectRunner {
  ProjectRunner()
    : repositoryRoot = File.fromUri(Platform.script).parent.parent,
      flutterExecutable =
          Platform.environment['FLUTTER'] ??
          (Platform.isWindows ? 'flutter.bat' : 'flutter'),
      dartExecutable =
          Platform.environment['DART'] ??
          (Platform.isWindows ? 'dart.exe' : 'dart'),
      npmExecutable =
          Platform.environment['NPM'] ??
          (Platform.isWindows ? 'npm.cmd' : 'npm');

  final Directory repositoryRoot;
  final String flutterExecutable;
  final String dartExecutable;
  final String npmExecutable;

  Directory get flutterDirectory => Directory(
    '${repositoryRoot.path}${Platform.pathSeparator}$_flutterAppRelativePath',
  );

  Directory get spectatorDirectory => Directory(
    '${repositoryRoot.path}${Platform.pathSeparator}$_spectatorAppRelativePath',
  );

  Directory get toolDirectory =>
      Directory('${repositoryRoot.path}${Platform.pathSeparator}tool');

  Future<void> flutter(List<String> arguments) =>
      _run(flutterExecutable, arguments, workingDirectory: flutterDirectory);

  Future<void> dart(List<String> arguments) =>
      _run(dartExecutable, arguments, workingDirectory: repositoryRoot);

  Future<void> npm(List<String> arguments) =>
      _run(npmExecutable, arguments, workingDirectory: spectatorDirectory);

  Future<void> buildFlutter(String? requestedTarget) async {
    final target = requestedTarget == null || requestedTarget.isEmpty
        ? _defaultBuildTarget()
        : requestedTarget;
    const supportedTargets = {
      'apk',
      'appbundle',
      'ios',
      'linux',
      'macos',
      'web',
      'windows',
    };

    if (!supportedTargets.contains(target)) {
      stderr.writeln(
        'Unknown TARGET=$target. Allowed: ${supportedTargets.join(', ')}.',
      );
      exit(64);
    }

    await flutter(['build', target]);
  }

  Future<void> buildSpectator() => npm(const ['run', 'build']);

  String _defaultBuildTarget() {
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    throw UnsupportedError('Set TARGET explicitly for this host OS.');
  }

  Future<void> _run(
    String executable,
    List<String> arguments, {
    required Directory workingDirectory,
  }) async {
    stdout.writeln('> $executable ${arguments.join(' ')}');
    final process = await Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory.path,
      mode: ProcessStartMode.inheritStdio,
      runInShell: Platform.isWindows,
    );
    final result = await process.exitCode;
    if (result != 0) exit(result);
  }

  void printHelp() {
    stdout.writeln('''
Tournament Hub project commands

  make setup                 Install Flutter and Spectator dependencies
  make run                   Run on Flutter's selected device
  make run DEVICE=windows    Run Flutter on an explicit device
  make run-spectator         Run the Spectator Vite dev server
  make build                 Build Flutter and Spectator Web
  make build TARGET=web      Build selected Flutter target and Spectator Web
  make build-flutter         Build only Flutter
  make build-spectator       Build only Spectator Web
  make format                Format Dart and TypeScript sources
  make lint                  Analyze/typecheck both applications
  make test                  Run Flutter tests
  make check                 Check format, analyze, typecheck and test
  make clean                 Remove Flutter build outputs

Requirements: Flutter SDK, Dart SDK, Node.js, npm and GNU Make in PATH.
Set FLUTTER, DART or NPM environment variables to override executable names.
''');
  }
}
