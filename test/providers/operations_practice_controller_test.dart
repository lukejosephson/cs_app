import 'package:cs_app/providers/operations_practice_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('operations practice state starts empty and unsubmitted', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(operationsPracticeControllerProvider);
    expect(state.currentInput, isEmpty);
    expect(state.isCorrect, isNull);
    expect(state.hasSubmitted, isFalse);
  });

  test('updateInput updates input and clears previous submission state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(
      operationsPracticeControllerProvider.notifier,
    );

    controller.updateInput('11');
    controller.checkAnswer('10');
    controller.updateInput('10');

    final state = container.read(operationsPracticeControllerProvider);
    expect(state.currentInput, '10');
    expect(state.isCorrect, isNull);
    expect(state.hasSubmitted, isFalse);
  });

  test('checkAnswer sets state correct when normalized answers match', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(
      operationsPracticeControllerProvider.notifier,
    );

    controller.updateInput('  HELLO   WORLD ');
    controller.checkAnswer('hello world');

    final state = container.read(operationsPracticeControllerProvider);
    expect(state.isCorrect, isTrue);
    expect(state.hasSubmitted, isTrue);
  });

  test('checkAnswer sets state incorrect when answers differ', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(
      operationsPracticeControllerProvider.notifier,
    );

    controller.updateInput('11');
    controller.checkAnswer('14');

    final state = container.read(operationsPracticeControllerProvider);
    expect(state.isCorrect, isFalse);
    expect(state.hasSubmitted, isTrue);
  });

  test('reset clears input, correctness, and submission state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(
      operationsPracticeControllerProvider.notifier,
    );

    controller.updateInput('11');
    controller.checkAnswer('11');
    controller.reset();

    final state = container.read(operationsPracticeControllerProvider);
    expect(state.currentInput, isEmpty);
    expect(state.isCorrect, isNull);
    expect(state.hasSubmitted, isFalse);
  });
}
