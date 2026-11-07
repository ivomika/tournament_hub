#!/usr/bin/env python3
"""Fail on theme-boundary regressions or consumers frozen to primitive defaults.

Run from any directory; use --static-only when Flutter is unavailable.
DART and FLUTTER may name alternative SDK executables.
"""
import argparse
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--static-only', action='store_true')
    args = parser.parse_args()
    dart = os.environ.get('DART', 'dart')
    flutter = os.environ.get('FLUTTER', 'flutter')
    checker = ROOT / 'tools/domain-check'
    checks = [
        (checker, [dart, 'run', 'bin/check_flutter_architecture.dart', '--self-test']),
        (checker, [dart, 'run', 'test/theme_boundaries_test.dart']),
        (checker, [dart, 'run', 'bin/check_flutter_architecture.dart']),
    ]
    if not args.static_only:
        checks.append((ROOT / 'apps/tournament_app', [
            flutter, 'test', '--no-pub',
            'test/presentation/design_system/foundation/theme_propagation_test.dart',
        ]))
    for cwd, command in checks:
        print(f'[{cwd.relative_to(ROOT)}] {" ".join(command)}', flush=True)
        try:
            result = subprocess.run(command, cwd=cwd, check=False)
        except OSError as error:
            print(f'Theme contract: {error}', file=sys.stderr)
            return 127
        if result.returncode:
            return result.returncode if result.returncode > 0 else 1
    print('Theme contract: PASS', flush=True)
    return 0


if __name__ == '__main__':
    sys.exit(main())
