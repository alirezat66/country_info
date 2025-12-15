import 'package:country_info/features/country/presentation/providers/show_more_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShowMoreNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should have initial state as false', () {
      // act
      final state = container.read(showMoreProvider);

      // assert
      expect(state, false);
    });

    test('should toggle state from false to true', () {
      // act
      container.read(showMoreProvider.notifier).toggle();

      // assert
      expect(container.read(showMoreProvider), true);
    });

    test('should toggle state from true to false', () {
      // arrange
      container.read(showMoreProvider.notifier).toggle(); // Set to true

      // act
      container
          .read(showMoreProvider.notifier)
          .toggle(); // Toggle back to false

      // assert
      expect(container.read(showMoreProvider), false);
    });

    test('should toggle state multiple times correctly', () {
      // act & assert
      expect(container.read(showMoreProvider), false);

      container.read(showMoreProvider.notifier).toggle();
      expect(container.read(showMoreProvider), true);

      container.read(showMoreProvider.notifier).toggle();
      expect(container.read(showMoreProvider), false);

      container.read(showMoreProvider.notifier).toggle();
      expect(container.read(showMoreProvider), true);

      container.read(showMoreProvider.notifier).toggle();
      expect(container.read(showMoreProvider), false);
    });

    test('should reset state to false when currently false', () {
      // act
      container.read(showMoreProvider.notifier).reset();

      // assert
      expect(container.read(showMoreProvider), false);
    });

    test('should reset state to false when currently true', () {
      // arrange
      container.read(showMoreProvider.notifier).toggle(); // Set to true

      // act
      container.read(showMoreProvider.notifier).reset();

      // assert
      expect(container.read(showMoreProvider), false);
    });

    test('should reset state to false after multiple toggles', () {
      // arrange
      container.read(showMoreProvider.notifier).toggle(); // true
      container.read(showMoreProvider.notifier).toggle(); // false
      container.read(showMoreProvider.notifier).toggle(); // true

      // act
      container.read(showMoreProvider.notifier).reset();

      // assert
      expect(container.read(showMoreProvider), false);
    });

    test('should maintain false state after reset and reset again', () {
      // arrange
      container.read(showMoreProvider.notifier).reset();

      // act
      container.read(showMoreProvider.notifier).reset();

      // assert
      expect(container.read(showMoreProvider), false);
    });

    test('should toggle correctly after reset', () {
      // arrange
      container.read(showMoreProvider.notifier).toggle(); // true
      container.read(showMoreProvider.notifier).reset(); // false

      // act
      container.read(showMoreProvider.notifier).toggle();

      // assert
      expect(container.read(showMoreProvider), true);
    });

    test('should handle complex state changes', () {
      // act & assert - complex sequence
      container.read(showMoreProvider.notifier).toggle();
      expect(container.read(showMoreProvider), true);

      container.read(showMoreProvider.notifier).toggle();
      expect(container.read(showMoreProvider), false);

      container.read(showMoreProvider.notifier).reset();
      expect(container.read(showMoreProvider), false);

      container.read(showMoreProvider.notifier).toggle();
      expect(container.read(showMoreProvider), true);

      container.read(showMoreProvider.notifier).reset();
      expect(container.read(showMoreProvider), false);
    });
  });
}
