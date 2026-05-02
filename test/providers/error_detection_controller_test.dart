import 'package:cs_app/providers/error_detection_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('error detection state starts with no selection', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(errorDetectionControllerProvider);
    expect(state.selectedLineIndex, isNull);
    expect(state.hasSubmitted, isFalse);
    expect(state.isCorrect, isNull);
  });

  test('selectLine updates selected line and clears submission result', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(errorDetectionControllerProvider.notifier);

    controller.checkSelection(2);
    controller.selectLine(3);

    final state = container.read(errorDetectionControllerProvider);
    expect(state.selectedLineIndex, 3);
    expect(state.hasSubmitted, isFalse);
    expect(state.isCorrect, isNull);
  });

  test('checkSelection sets submitted and true when selection matches', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(errorDetectionControllerProvider.notifier);

    controller.selectLine(4);
    controller.checkSelection(4);

    final state = container.read(errorDetectionControllerProvider);
    expect(state.hasSubmitted, isTrue);
    expect(state.isCorrect, isTrue);
  });

  test('checkSelection sets submitted and false when selection is wrong', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(errorDetectionControllerProvider.notifier);

    controller.selectLine(2);
    controller.checkSelection(5);

    final state = container.read(errorDetectionControllerProvider);
    expect(state.hasSubmitted, isTrue);
    expect(state.isCorrect, isFalse);
  });
}
