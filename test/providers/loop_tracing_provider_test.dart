import 'package:cs_app/providers/loop_tracing_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_random.dart';

void main() {
  test('loop tracing state starts empty and incorrect', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(loopTracingControllerProvider);
    expect(state.currentInput, isEmpty);
    expect(state.isCorrect, isFalse);
    expect(state.hasSubmitted, isFalse);
    expect(state.currentPuzzleIndex, 0);
    expect(state.inputErrorMessage, isNull);
  });

  test('updateInput updates input and clears correctness', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('42');
    expect(container.read(loopTracingControllerProvider).currentInput, '42');
    expect(container.read(loopTracingControllerProvider).isCorrect, isFalse);
    expect(container.read(loopTracingControllerProvider).hasSubmitted, isFalse);
    expect(
      container.read(loopTracingControllerProvider).inputErrorMessage,
      isNull,
    );
  });

  test('submitAnswer marks state correct when answer matches', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('  6 ');
    controller.submitAnswer('6');

    expect(container.read(loopTracingControllerProvider).isCorrect, isTrue);
    expect(container.read(loopTracingControllerProvider).hasSubmitted, isTrue);
    expect(
      container.read(loopTracingControllerProvider).inputErrorMessage,
      isNull,
    );
  });

  test('submitAnswer ignores case and repeated whitespace', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('  Hello   World  ');
    controller.submitAnswer('hello world');

    expect(container.read(loopTracingControllerProvider).isCorrect, isTrue);
    expect(container.read(loopTracingControllerProvider).hasSubmitted, isTrue);
  });

  test('submitAnswer marks state incorrect when answer does not match', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('5');
    controller.submitAnswer('6');

    expect(container.read(loopTracingControllerProvider).isCorrect, isFalse);
    expect(container.read(loopTracingControllerProvider).hasSubmitted, isTrue);
  });

  test('submitAnswer with empty input sets validation message', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('   ');
    controller.submitAnswer('6');

    final state = container.read(loopTracingControllerProvider);
    expect(state.hasSubmitted, isFalse);
    expect(state.isCorrect, isFalse);
    expect(state.inputErrorMessage, 'Please enter an answer before checking.');
  });

  test('reset returns state to default values', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('6');
    controller.submitAnswer('6');
    controller.reset();

    final state = container.read(loopTracingControllerProvider);
    expect(state.currentInput, isEmpty);
    expect(state.isCorrect, isFalse);
    expect(state.hasSubmitted, isFalse);
    expect(state.currentPuzzleIndex, 0);
    expect(state.inputErrorMessage, isNull);
  });

  test('clearResponse clears answer state without changing puzzle index', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.moveToNextPuzzle(3);
    controller.updateInput('6');
    controller.submitAnswer('6');
    controller.clearResponse();

    final state = container.read(loopTracingControllerProvider);
    expect(state.currentPuzzleIndex, 1);
    expect(state.currentInput, isEmpty);
    expect(state.isCorrect, isFalse);
    expect(state.hasSubmitted, isFalse);
    expect(state.inputErrorMessage, isNull);
  });

  test('moveToNextPuzzle advances index and clears input state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('6');
    controller.submitAnswer('6');
    controller.moveToNextPuzzle(3);

    final state = container.read(loopTracingControllerProvider);
    expect(state.currentPuzzleIndex, 1);
    expect(state.currentInput, isEmpty);
    expect(state.isCorrect, isFalse);
    expect(state.hasSubmitted, isFalse);
    expect(state.inputErrorMessage, isNull);
  });

  test(
    'moveToRandomPuzzle picks a different puzzle and clears input state',
    () {
      final container = ProviderContainer(
        overrides: [
          loopRandomProvider.overrideWithValue(FakeRandom([1])),
        ],
      );
      addTearDown(container.dispose);
      final controller = container.read(loopTracingControllerProvider.notifier);

      controller.updateInput('6');
      controller.submitAnswer('6');
      controller.moveToRandomPuzzle(3);

      final state = container.read(loopTracingControllerProvider);
      expect(state.currentPuzzleIndex, 1);
      expect(state.currentInput, isEmpty);
      expect(state.isCorrect, isFalse);
      expect(state.hasSubmitted, isFalse);
      expect(state.inputErrorMessage, isNull);
    },
  );
}
