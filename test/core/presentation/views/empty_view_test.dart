import 'package:country_info/core/presentation/views/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmptyView', () {
    testWidgets('should display message correctly', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: EmptyView(message: 'No countries found')),
        ),
      );

      // assert
      expect(find.text('No countries found'), findsOneWidget);
    });

    testWidgets('should center the message', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: EmptyView(message: 'No data available')),
        ),
      );

      // assert
      final center = find.ancestor(
        of: find.text('No data available'),
        matching: find.byType(Center),
      );
      expect(center, findsOneWidget);
    });

    testWidgets('should display different messages', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: EmptyView(message: 'No results')),
        ),
      );

      // assert
      expect(find.text('No results'), findsOneWidget);
    });

    testWidgets('should display empty string', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: EmptyView(message: '')),
        ),
      );

      // assert
      expect(find.text(''), findsWidgets);
      expect(find.byType(EmptyView), findsOneWidget);
    });

    testWidgets('should display long message', (tester) async {
      // arrange
      const longMessage =
          'This is a very long message that explains '
          'why there are no items to display in great detail';

      // act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: EmptyView(message: longMessage)),
        ),
      );

      // assert
      expect(find.text(longMessage), findsOneWidget);
    });

    testWidgets('should display special characters', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: EmptyView(message: 'لا توجد بيانات')),
        ),
      );

      // assert
      expect(find.text('لا توجد بيانات'), findsOneWidget);
    });

    testWidgets('should render without errors', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: EmptyView(message: 'Test message')),
        ),
      );

      // assert
      expect(tester.takeException(), isNull);
    });

    testWidgets('should be a const constructor', (tester) async {
      // arrange & act
      const widget1 = EmptyView(message: 'Test');
      const widget2 = EmptyView(message: 'Test');

      // assert - same message should create identical widgets
      expect(widget1.message, widget2.message);
    });

    testWidgets('should have correct widget hierarchy', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: EmptyView(message: 'Empty state')),
        ),
      );

      // assert
      expect(find.byType(EmptyView), findsOneWidget);
      expect(find.byType(Center), findsWidgets);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('should display multiple EmptyViews', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                EmptyView(message: 'First empty'),
                EmptyView(message: 'Second empty'),
              ],
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(EmptyView), findsNWidgets(2));
      expect(find.text('First empty'), findsOneWidget);
      expect(find.text('Second empty'), findsOneWidget);
    });

    testWidgets('should work in light theme', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(body: EmptyView(message: 'No data')),
        ),
      );

      // assert
      expect(find.text('No data'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should work in dark theme', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(body: EmptyView(message: 'No data')),
        ),
      );

      // assert
      expect(find.text('No data'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle message with newlines', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: EmptyView(message: 'No data\navailable')),
        ),
      );

      // assert
      expect(find.text('No data\navailable'), findsOneWidget);
    });

    testWidgets('should display message with numbers and symbols', (
      tester,
    ) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyView(message: '0 items found! Try again...'),
          ),
        ),
      );

      // assert
      expect(find.text('0 items found! Try again...'), findsOneWidget);
    });
  });
}
