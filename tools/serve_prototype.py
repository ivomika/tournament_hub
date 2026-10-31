#!/usr/bin/env python3
"""Локальный preview HTML-макетов и двух проектных шрифтов, без доступа ко всему repo."""
import argparse
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import unquote, urlsplit

REPO = Path(__file__).resolve().parents[1]
PROTOTYPE = REPO / 'docs/design/prototype'
FONT_PATHS = {
    '/apps/tournament_app/assets/fonts/inter/Inter-Variable.ttf': REPO / 'apps/tournament_app/assets/fonts/inter/Inter-Variable.ttf',
    '/apps/tournament_app/assets/fonts/roboto_condensed/RobotoCondensed-Variable.ttf': REPO / 'apps/tournament_app/assets/fonts/roboto_condensed/RobotoCondensed-Variable.ttf',
}


class PrototypeHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(PROTOTYPE), **kwargs)

    def translate_path(self, path):
        font = FONT_PATHS.get(unquote(urlsplit(path).path))
        if font is not None:
            return str(font)
        candidate = Path(super().translate_path(path)).resolve()
        if candidate.is_relative_to(PROTOTYPE):
            return str(candidate)
        return str(PROTOTYPE / '.not-found')

    def list_directory(self, path):
        self.send_error(404)
        return None


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--port', type=int, default=8094)
    args = parser.parse_args()
    server = ThreadingHTTPServer(('127.0.0.1', args.port), PrototypeHandler)
    print(f'Prototype: http://127.0.0.1:{args.port}/desktop.html', flush=True)
    server.serve_forever()
