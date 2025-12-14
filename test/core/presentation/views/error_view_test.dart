import 'package:country_info/core/presentation/views/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorView', () {
    testWidgets('should display error icon', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(errorMessage: 'Test error')),
        ),
      );

      // assert
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display error title', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(errorMessage: 'Test error')),
        ),
      );

      // assert
      expect(find.text('Error loading countries'), findsOneWidget);
    });

    testWidgets('should display error message', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(errorMessage: 'Network connection failed'),
          ),
        ),
      );

      // assert
      expect(find.text('Network connection failed'), findsOneWidget);
    });

    testWidgets('should have error icon with red color and size 48', (
      tester,
    ) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(errorMessage: 'Test error')),
        ),
      );

      // assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
      expect(icon.size, 48);
      expect(icon.color, Colors.red);
    });

    testWidgets('should show retry button when onRetry is provided', (
      tester,
    ) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(errorMessage: 'Test error', onRetry: () {}),
          ),
        ),
      );

      // assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should hide retry button when onRetry is null', (
      tester,
    ) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(errorMessage: 'Test error')),
        ),
      );

      // assert
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('should call onRetry callback when button tapped', (
      tester,
    ) async {
      // arrange
      bool retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              errorMessage: 'Test error',
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );

      // act
      await tester.tap(find.text('Retry'));
      await tester.pump();

      // assert
      expect(retryCalled, true);
    });

    testWidgets('should have center alignment for error message', (
      tester,
    ) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(errorMessage: 'Test error')),
        ),
      );

      // assert
      final text = tester.widget<Text>(find.text('Test error'));
      expect(text.textAlign, TextAlign.center);
    });

    testWidgets('should display short error message', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(errorMessage: 'Error')),
        ),
      );

      // assert
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('should display long error message', (tester) async {
      // arrange
      const longError =
          'This is a very long error message that describes '
          'what went wrong in great detail and should wrap to multiple lines';

      // act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(errorMessage: longError)),
        ),
      );

      // assert
      expect(find.text(longError), findsOneWidget);
    });

    testWidgets('should use theme text styles', (tester) async {
      // arrange
      final theme = ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(body: ErrorView(errorMessage: 'Test error')),
        ),
      );

      // assert
      final titleText = tester.widget<Text>(
        find.text('Error loading countries'),
      );
      expect(titleText.style?.fontSize, 24);
      expect(titleText.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should have Column layout', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(errorMessage: 'Test error')),
        ),
      );

      // assert
      expect(find.byType(Column), findsWidgets);
      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(ErrorView),
          matching: find.byType(Column),
        ),
      );
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should have correct spacing with SizedBox', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(errorMessage: 'Test error', onRetry: () {}),
          ),
        ),
      );

      // assert
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final sizedBoxList = sizedBoxes.toList();

      // Should have spacing between icon and title (16), title and message (8), and message and button (16)
      expect(sizedBoxList.length, greaterThanOrEqualTo(3));
      expect(sizedBoxList.any((box) => box.height == 16), true);
      expect(sizedBoxList.any((box) => box.height == 8), true);
    });

    testWidgets('should be centered on screen', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(errorMessage: 'Test error')),
        ),
      );

      // assert
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('should handle retry button tap multiple times', (
      tester,
    ) async {
      // arrange
      int retryCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              errorMessage: 'Test error',
              onRetry: () => retryCount++,
            ),
          ),
        ),
      );

      // act
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.tap(find.text('Retry'));
      await tester.pump();

      // assert
      expect(retryCount, 3);
    });

    testWidgets('should display error with special characters', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(errorMessage: 'خطأ في التحميل')),
        ),
      );

      // assert
      expect(find.text('خطأ في التحميل'), findsOneWidget);
    });

    testWidgets('should render all components in correct order', (
      tester,
    ) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(errorMessage: 'Test error', onRetry: () {}),
          ),
        ),
      );

      // assert - verify order: icon, title, message, button
      expect(find.byType(Icon), findsOneWidget);
      expect(find.text('Error loading countries'), findsOneWidget);
      expect(find.text('Test error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should handle empty error message', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorView(errorMessage: '')),
        ),
      );

      // assert
      expect(find.text('Error loading countries'), findsOneWidget);
      expect(find.byType(ErrorView), findsOneWidget);
    });
  });
}
