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
  });

  test('updateInput updates input and clears correctness', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('42');
    expect(container.read(loopTracingControllerProvider).currentInput, '42');
    expect(container.read(loopTracingControllerProvider).isCorrect, isFalse);
    expect(container.read(loopTracingControllerProvider).hasSubmitted, isFalse);
  });

  test('submitAnswer marks state correct when answer matches', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(loopTracingControllerProvider.notifier);

    controller.updateInput('  6 ');
    controller.submitAnswer('6');

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
    },
  );
}
