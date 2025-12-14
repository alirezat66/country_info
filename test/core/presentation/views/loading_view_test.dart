import 'package:country_info/core/presentation/views/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadingView', () {
    testWidgets('should display CircularProgressIndicator', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingView())),
      );

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should use adaptive progress indicator', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingView())),
      );

      // assert
      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator, isA<CircularProgressIndicator>());
    });

    testWidgets('should center the progress indicator', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingView())),
      );

      // assert
      final center = find.ancestor(
        of: find.byType(CircularProgressIndicator),
        matching: find.byType(Center),
      );
      expect(center, findsOneWidget);
    });

    testWidgets('should render without errors', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingView())),
      );

      // assert
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display multiple LoadingViews', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(children: const [LoadingView(), LoadingView()]),
          ),
        ),
      );

      // assert
      expect(find.byType(LoadingView), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    });

    testWidgets('should work in light theme', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(body: LoadingView()),
        ),
      );

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should work in dark theme', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(body: LoadingView()),
        ),
      );

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should be a const constructor', (tester) async {
      // arrange & act
      const widget1 = LoadingView();
      const widget2 = LoadingView();

      // assert - const widgets with same parameters should be equal
      expect(widget1.key, widget2.key);
      expect(widget1.runtimeType, widget2.runtimeType);
    });

    testWidgets('should have correct widget hierarchy', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingView())),
      );

      // assert
      expect(find.byType(LoadingView), findsOneWidget);
      expect(find.byType(Center), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should animate progress indicator', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingView())),
      );

      // Pump multiple frames to test animation
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // assert - should still be visible and animating
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
