import 'dart:convert';
import 'dart:io';

const _bindings = <String, List<String>>{
  'space-0': ['space', '0'],
  'space-1': ['space', '1'],
  'space-2': ['space', '2'],
  'space-3': ['space', '3'],
  'space-4': ['space', '4'],
  'space-5': ['space', '5'],
  'space-6': ['space', '6'],
  'space-8': ['space', '8'],
  'space-10': ['space', '10'],
  'space-12': ['space', '12'],
  'space-16': ['space', '16'],
  'space-20': ['space', '20'],
  'space-24': ['space', '24'],
  'layout-page-padding-medium-min': ['layout', 'pagePaddingMediumMin'],
  'layout-page-padding-desktop-max': ['layout', 'pagePaddingDesktopMax'],
  'layout-standings-place-column-min': ['layout', 'standingsPlaceColumnMin'],
  'layout-spectator-max': ['layout', 'spectatorContentMaxMax'],
  'color-canvas': ['color', 'background', 'canvas'],
  'color-subtle': ['color', 'background', 'subtle'],
  'color-elevated': ['color', 'background', 'elevated'],
  'color-surface-primary': ['color', 'surface', 'primary'],
  'color-surface-secondary': ['color', 'surface', 'secondary'],
  'color-surface-tertiary': ['color', 'surface', 'tertiary'],
  'color-surface-hover': ['color', 'surface', 'hover'],
  'color-text-primary': ['color', 'text', 'primary'],
  'color-text-secondary': ['color', 'text', 'secondary'],
  'color-text-tertiary': ['color', 'text', 'tertiary'],
  'color-accent': ['color', 'accent', 'primary'],
  'color-success': ['color', 'status', 'success'],
  'color-danger': ['color', 'status', 'danger'],
  'color-warning': ['color', 'status', 'warning'],
  'color-info': ['color', 'status', 'info'],
  'font-12': ['font', 'size', '12'],
  'font-14': ['font', 'size', '14'],
  'font-16': ['font', 'size', '16'],
  'font-18': ['font', 'size', '18'],
  'font-20': ['font', 'size', '20'],
  'font-24': ['font', 'size', '24'],
  'font-28': ['font', 'size', '28'],
  'font-32': ['font', 'size', '32'],
  'font-40': ['font', 'size', '40'],
  'font-48': ['font', 'size', '48'],
  'font-56': ['font', 'size', '56'],
  'line-20': ['font', 'lineHeight', '20'],
  'line-24': ['font', 'lineHeight', '24'],
  'line-32': ['font', 'lineHeight', '32'],
  'line-40': ['font', 'lineHeight', '40'],
  'line-48': ['font', 'lineHeight', '48'],
  'line-56': ['font', 'lineHeight', '56'],
  'line-64': ['font', 'lineHeight', '64'],
  'weight-regular': ['font', 'weight', 'regular'],
  'weight-medium': ['font', 'weight', 'medium'],
  'weight-semibold': ['font', 'weight', 'semibold'],
  'weight-bold': ['font', 'weight', 'bold'],
  'radius-sm': ['radius', 'sm'],
  'radius-md': ['radius', 'md'],
  'radius-lg': ['radius', 'lg'],
  'radius-xl': ['radius', 'xl'],
  'radius-full': ['radius', 'full'],
  'border': ['border', 'widthBase'],
  'control-min': ['control', 'touchTargetMin'],
  'artwork-compact': ['artwork', 'size', 'compact'],
  'artwork-standard': ['artwork', 'size', 'standard'],
  'artwork-matchup': ['artwork', 'size', 'matchup'],
  'artwork-hero': ['artwork', 'size', 'hero'],
  'motion-fast': ['motion', 'fast'],
  'motion-normal': ['motion', 'normal'],
  'motion-presentation': ['motion', 'presentation'],
};

Future<void> main(List<String> arguments) async {
  final root = File.fromUri(Platform.script).parent.parent;
  final source = File('${root.path}/docs/design/tokens.json');
  final target = File(
    '${root.path}/apps/spectator_web/src/presentation/design-system/tokens.css',
  );
  final manifest =
      jsonDecode(await source.readAsString()) as Map<String, Object?>;
  final tokens = manifest['tokens']! as Map<String, Object?>;
  final lines = _bindings.entries
      .map((entry) {
        var node = tokens;
        for (final segment in entry.value) {
          node = node[segment]! as Map<String, Object?>;
        }
        final value = node['value']!;
        final unit = node['unit'] as String? ?? '';
        return '  --ds-${entry.key}: $value$unit;';
      })
      .join('\n');
  final output =
      '/* GENERATED FILE. DO NOT EDIT. Source: docs/design/tokens.json */\n:root {\n$lines\n}\n';
  if (arguments.contains('--check')) {
    if (!target.existsSync() || await target.readAsString() != output) {
      stderr.writeln('Web design tokens are stale. Run make generate-tokens.');
      exitCode = 1;
    }
    return;
  }
  await target.parent.create(recursive: true);
  await target.writeAsString(output);
}
