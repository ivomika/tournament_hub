import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/navigation/interaction_result_channel.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/presentation/navigation/interaction_operation.dart';
import 'package:tournament_app/presentation/navigation/interaction_outcome.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';

void main() => _InteractionOperationTests.run();

abstract final class _InteractionOperationTests {
  static void run() {
    test('opening acknowledgement does not wait for screen result', _separate);
    test(
      'operation cancellation is idempotent and settles the result',
      _cancel,
    );
  }

  static Future<void> _separate() async {
    final fixture = _InteractionFixture();
    final operation = fixture.operation;
    fixture.opening.complete(const NavigationAccepted());
    expect(await operation.transition, isA<NavigationAccepted>());
    // The owner can continue after acknowledgement and complete the child later.
    fixture.channel.complete(_InteractionFixture.child, 'selected');
    final outcome = await operation.result as InteractionCompleted<String>;
    expect(outcome.value, 'selected');
  }

  static Future<void> _cancel() async {
    final fixture = _InteractionFixture();
    final operation = fixture.operation;
    fixture.opening.complete(const NavigationAccepted());
    await Future.wait<void>([operation.cancel(), operation.cancel()]);
    expect(fixture.cancelCalls, 1);
    expect(await operation.transition, isA<NavigationAccepted>());
    final outcome = await operation.result as InteractionCancelled<String>;
    expect(outcome.reason, InteractionCancellationReason.requested);
  }
}

class _InteractionFixture {
  static const child = NavigationEntryId(10);

  final opening = Completer<NavigationFeedback>();
  final channel = InteractionResultChannel<String>(child);
  int cancelCalls = 0;

  late final InteractionOperation<String> operation =
      InteractionOperation<String>(
        transition: opening.future,
        result: channel.result,
        onCancel: cancel,
      );

  Future<void> cancel() {
    cancelCalls++;
    channel.cancel(InteractionCancellationReason.requested);
    return Future<void>.value();
  }
}
