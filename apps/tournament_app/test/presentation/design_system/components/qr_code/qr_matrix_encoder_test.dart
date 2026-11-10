import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/encoding/app_qr_matrix_encoder.dart';
import 'package:zxing2/src/common/bit_matrix.dart';
import 'package:zxing2/src/qrcode/decoder/decoder.dart';
import 'package:zxing2/zxing2.dart' show DecodeHints;

void main() => _QrEncodingTests.run();

abstract final class _QrEncodingTests {
  static void run() {
    for (final payload in [
      'http://host.local/spectator',
      'https://example.test/spectator/tournament-with-a-long-session-address?session=48271930615&token=abcdefghijklmnopqrstuvwxyz0123456789',
      'https://example.test/турнир?имя=Иван',
    ]) {
      test('independent decode returns exact payload: $payload', () {
        final matrix = AppQrMatrixEncoder.encode(payload);
        final modules = matrix.modules;
        expect(modules.length, greaterThanOrEqualTo(21));
        expect((modules.length - 21) % 4, 0);
        for (final row in modules) {
          expect(row.length, modules.length);
        }
        final result = Decoder().decode(
          BitMatrix.parse(modules),
          hints: DecodeHints(),
        );
        // zxing2 0.2.4 passes signed Int8List to Utf8Codec; normalize
        // independently decoded byte segments to unsigned bytes at this test boundary.
        expect(
          utf8.decode(Uint8List.fromList(result.byteSegments!.single)),
          payload,
        );
      });
    }
    test(
      'same payload deterministic; different payload changes actual modules',
      () {
        final original = AppQrMatrixEncoder.encode(
          'http://host.local/spectator',
        );
        final same = AppQrMatrixEncoder.encode('http://host.local/spectator');
        final changed = AppQrMatrixEncoder.encode(
          'http://host.local/spectator?session=other',
        );
        expect(same.modules, original.modules);
        expect(changed.modules, isNot(original.modules));
      },
    );
    test(
      'oversized payload fails through owned API without library exception',
      () {
        expect(
          () => AppQrMatrixEncoder.encode('x' * 10000),
          throwsArgumentError,
        );
      },
    );
    test('matrix and each row are immutable', () {
      final matrix = AppQrMatrixEncoder.encode('http://host.local/spectator');
      expect(() => matrix.modules.clear(), throwsUnsupportedError);
      expect(() => matrix.modules.first.clear(), throwsUnsupportedError);
    });
  }
}
