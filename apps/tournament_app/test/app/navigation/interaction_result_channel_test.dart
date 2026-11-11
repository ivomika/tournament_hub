import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/navigation/interaction_result_channel.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/presentation/navigation/interaction_outcome.dart';

void main() => _InteractionResultChannelTests.run();

abstract final class _InteractionResultChannelTests {
  static const child = NavigationEntryId(10);
  static const otherChild = NavigationEntryId(11);

  static void run() {
    test('child publishes a typed result', _complete);
    test('a different child cannot complete this channel', _wrongEntry);
    test('duplicate publication keeps the first result', _duplicate);
    test('cancellation settles the waiting result', _cancel);
    test('late value after cancellation cannot overwrite the outcome', _late);
    test(
      'cancellation after completion preserves the selected value',
      _lateCancel,
    );
    test('technical failure stays distinct from cancellation', _failure);
    test('native null is a dismissed interaction', _dismiss);
    test('native value becomes a typed completed outcome', _nativeValue);
  }

  static Future<void> _complete() async {
    final channel = InteractionResultChannel<String>(child);
    expect(channel.complete(child, 'selected'), InteractionCompletion.accepted);
    final outcome = await channel.result;
    expect(outcome, isA<InteractionCompleted<String>>());
    expect((outcome as InteractionCompleted<String>).value, 'selected');
  }

  static Future<void> _wrongEntry() async {
    final channel = InteractionResultChannel<String>(child);
    expect(
      channel.complete(otherChild, 'wrong'),
      InteractionCompletion.wrongEntry,
    );
    expect(channel.complete(child, 'correct'), InteractionCompletion.accepted);
    final outcome = await channel.result as InteractionCompleted<String>;
    expect(outcome.value, 'correct');
  }

  static Future<void> _duplicate() async {
    final channel = InteractionResultChannel<String>(child);
    channel.complete(child, 'first');
    expect(
      channel.complete(child, 'second'),
      InteractionCompletion.alreadyCompleted,
    );
    final outcome = await channel.result as InteractionCompleted<String>;
    expect(outcome.value, 'first');
  }

  static Future<void> _cancel() async {
    final channel = InteractionResultChannel<String>(child);
    expect(
      channel.cancel(InteractionCancellationReason.ownerEnded),
      InteractionCompletion.accepted,
    );
    expect(
      channel.cancel(InteractionCancellationReason.requested),
      InteractionCompletion.alreadyCompleted,
    );
    final outcome = await channel.result as InteractionCancelled<String>;
    expect(outcome.reason, InteractionCancellationReason.ownerEnded);
  }

  static Future<void> _late() async {
    final channel = InteractionResultChannel<String>(child);
    channel.cancel(InteractionCancellationReason.requested);
    expect(
      channel.complete(child, 'late'),
      InteractionCompletion.alreadyCompleted,
    );
    expect(await channel.result, isA<InteractionCancelled<String>>());
  }

  static Future<void> _lateCancel() async {
    final channel = InteractionResultChannel<String>(child);
    channel.complete(child, 'selected');
    expect(
      channel.cancel(InteractionCancellationReason.ownerEnded),
      InteractionCompletion.alreadyCompleted,
    );
    final outcome = await channel.result as InteractionCompleted<String>;
    expect(outcome.value, 'selected');
  }

  static Future<void> _failure() async {
    final channel = InteractionResultChannel<String>(child);
    expect(
      channel.fail(InteractionFailureReason.presentationUnavailable),
      InteractionCompletion.accepted,
    );
    final outcome = await channel.result as InteractionFailed<String>;
    expect(outcome.reason, InteractionFailureReason.presentationUnavailable);
    expect(
      channel.complete(child, 'late'),
      InteractionCompletion.alreadyCompleted,
    );
  }

  static void _dismiss() {
    final outcome = InteractionOutcome<String>.fromNullable(null);
    expect(outcome, isA<InteractionCancelled<String>>());
    expect(
      (outcome as InteractionCancelled<String>).reason,
      InteractionCancellationReason.dismissed,
    );
  }

  static void _nativeValue() {
    final outcome = InteractionOutcome<String>.fromNullable('selected');
    expect(outcome, isA<InteractionCompleted<String>>());
    expect((outcome as InteractionCompleted<String>).value, 'selected');
  }
}
