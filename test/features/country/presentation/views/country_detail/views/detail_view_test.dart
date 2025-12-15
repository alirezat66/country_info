import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/presentation/providers/show_more_notifier.dart';
import 'package:country_info/features/country/presentation/views/country_detail/views/detail_view.dart';
import 'package:country_info/features/country/presentation/views/widgets/country_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DetailView', () {
    testWidgets('should render CustomScrollView with slivers', (tester) async {
      // arrange
      const country = Country(code: 'US', name: 'United States', emoji: '🇺🇸');

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(country: country, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(
        find.byType(CountryDetailItem),
        findsNWidgets(4),
      ); // 4 basic fields
    });

    testWidgets('should render CountryDetailItem for each field', (
      tester,
    ) async {
      // arrange
      const country = Country(
        code: 'US',
        name: 'United States',
        emoji: '🇺🇸',
        capital: 'Washington, D.C.',
        currency: 'USD',
      );

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(country: country, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      expect(
        find.byType(CountryDetailItem),
        findsNWidgets(4),
      ); // 4 basic fields
      expect(find.text('Capital:'), findsOneWidget);
      expect(find.text('Washington, D.C.'), findsOneWidget);
    });

    testWidgets('should display "Show more" button when showMore is false', (
      tester,
    ) async {
      // arrange
      const country = Country(code: 'FR', name: 'France', emoji: '🇫🇷');

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(country: country, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Show more'), findsOneWidget);
      expect(find.text('Show less'), findsNothing);
    });

    testWidgets('should display "Show less" button when showMore is true', (
      tester,
    ) async {
      // arrange
      final container = ProviderContainer();

      const country = Country(code: 'DE', name: 'Germany', emoji: '🇩🇪');

      // Set showMore to true before building
      container.read(showMoreProvider.notifier).toggle();

      // act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(country: country, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.text('Show less'), findsOneWidget);
      expect(find.text('Show more'), findsNothing);

      // Clean up
      container.dispose();
    });

    testWidgets('should call onExpandToggle when button tapped', (
      tester,
    ) async {
      // arrange
      bool callbackCalled = false;
      const country = Country(code: 'CA', name: 'Canada', emoji: '🇨🇦');

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(
                country: country,
                onExpandToggle: () => callbackCalled = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // assert
      expect(callbackCalled, true);
    });

    testWidgets('should show basic fields and button', (tester) async {
      // arrange
      const country = Country(code: 'XX', name: 'Test', emoji: '🏳️');

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(country: country, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      expect(
        find.byType(CountryDetailItem),
        findsNWidgets(4),
      ); // 4 basic fields
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should render all basic fields correctly', (tester) async {
      // arrange
      const country = Country(
        code: 'GB',
        name: 'United Kingdom',
        emoji: '🇬🇧',
        capital: 'London',
      );

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(country: country, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      expect(
        find.byType(CountryDetailItem),
        findsNWidgets(4),
      ); // 4 basic fields
      expect(find.text('Flag:'), findsOneWidget);
      expect(find.text('Name:'), findsOneWidget);
      expect(find.text('Code:'), findsOneWidget);
      expect(find.text('Capital:'), findsOneWidget);
    });

    testWidgets('should have button centered with padding', (tester) async {
      // arrange
      const country = Country(code: 'XX', name: 'Test', emoji: '🏳️');

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(country: country, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      final center = find.ancestor(
        of: find.byType(ElevatedButton),
        matching: find.byType(Center),
      );
      expect(center, findsOneWidget);

      final padding = find.ancestor(
        of: find.byType(ElevatedButton),
        matching: find.byType(Padding),
      );
      expect(padding, findsOneWidget);
    });

    testWidgets('should maintain field order', (tester) async {
      // arrange
      const country = Country(
        code: 'IT',
        name: 'Italy',
        emoji: '🇮🇹',
        capital: 'Rome',
      );

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(country: country, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert - basic fields should be in order: Flag, Name, Code, Capital
      final detailItems = tester
          .widgetList<CountryDetailItem>(find.byType(CountryDetailItem))
          .toList();
      expect(detailItems[0].label, 'Flag');
      expect(detailItems[1].label, 'Name');
      expect(detailItems[2].label, 'Code');
      expect(detailItems[3].label, 'Capital');
    });

    testWidgets('should handle button tap multiple times', (tester) async {
      // arrange
      int tapCount = 0;
      const country = Country(code: 'IT', name: 'Italy', emoji: '🇮🇹');

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(
                country: country,
                onExpandToggle: () => tapCount++,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // assert
      expect(tapCount, 3);
    });

    testWidgets('should use CustomScrollView with slivers', (tester) async {
      // arrange
      const country = Country(code: 'XX', name: 'Test', emoji: '🏳️');

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(country: country, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('should handle country names with special characters', (
      tester,
    ) async {
      // arrange
      const country = Country(
        code: 'FR',
        name: 'Français',
        emoji: '🇫🇷',
        capital: 'العربية',
      );

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(country: country, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Français'), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);
    });

    testWidgets('should render button after all fields', (tester) async {
      // arrange
      const country = Country(
        code: 'ES',
        name: 'Spain',
        emoji: '🇪🇸',
        capital: 'Madrid',
      );

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(country: country, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert - button should be after all basic fields
      expect(
        find.byType(CountryDetailItem),
        findsNWidgets(4),
      ); // 4 basic fields
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
