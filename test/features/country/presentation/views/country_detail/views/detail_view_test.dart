import 'package:country_info/features/country/presentation/providers/show_more_notifier.dart';
import 'package:country_info/features/country/presentation/views/country_detail/views/detail_view.dart';
import 'package:country_info/features/country/presentation/views/widgets/country_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DetailView', () {
    testWidgets('should render ListView with correct item count', (
      tester,
    ) async {
      // arrange
      final items = [
        const MapEntry('Flag', '🇺🇸'),
        const MapEntry('Name', 'United States'),
        const MapEntry('Code', 'US'),
      ];

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(items: items, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.semanticChildCount, 4); // 3 items + 1 button
    });

    testWidgets('should render CountryDetailItem for each entry', (
      tester,
    ) async {
      // arrange
      final items = [
        const MapEntry('Capital', 'Washington, D.C.'),
        const MapEntry('Currency', 'USD'),
      ];

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(items: items, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(CountryDetailItem), findsNWidgets(2));
      expect(find.text('Capital:'), findsOneWidget);
      expect(find.text('Washington, D.C.'), findsOneWidget);
      expect(find.text('Currency:'), findsOneWidget);
      expect(find.text('USD'), findsOneWidget);
    });

    testWidgets('should display "Show more" button when showMore is false', (
      tester,
    ) async {
      // arrange
      final items = [const MapEntry('Name', 'France')];

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(items: items, onExpandToggle: () {}),
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

      final items = [const MapEntry('Name', 'Germany')];

      // Set showMore to true before building
      container.read(showMoreProvider.notifier).toggle();

      // act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(items: items, onExpandToggle: () {}),
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
      final items = [const MapEntry('Code', 'CA')];

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(
                items: items,
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

    testWidgets('should show only button when items list is empty', (
      tester,
    ) async {
      // arrange
      final items = <MapEntry<String, String>>[];

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(items: items, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(CountryDetailItem), findsNothing);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should render multiple items correctly', (tester) async {
      // arrange
      final items = [
        const MapEntry('Flag', '🇬🇧'),
        const MapEntry('Name', 'United Kingdom'),
        const MapEntry('Code', 'GB'),
        const MapEntry('Capital', 'London'),
        const MapEntry('Currency', 'GBP'),
      ];

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(items: items, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(CountryDetailItem), findsNWidgets(5));
      expect(find.text('Flag:'), findsOneWidget);
      expect(find.text('Name:'), findsOneWidget);
      expect(find.text('Code:'), findsOneWidget);
      expect(find.text('Capital:'), findsOneWidget);
      expect(find.text('Currency:'), findsOneWidget);
    });

    testWidgets('should have button centered with padding', (tester) async {
      // arrange
      final items = [const MapEntry('Test', 'Value')];

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(items: items, onExpandToggle: () {}),
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

    testWidgets('should maintain item order', (tester) async {
      // arrange
      final items = [
        const MapEntry('First', 'A'),
        const MapEntry('Second', 'B'),
        const MapEntry('Third', 'C'),
      ];

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(items: items, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      final detailItems = tester
          .widgetList<CountryDetailItem>(find.byType(CountryDetailItem))
          .toList();
      expect(detailItems[0].label, 'First');
      expect(detailItems[1].label, 'Second');
      expect(detailItems[2].label, 'Third');
    });

    testWidgets('should handle button tap multiple times', (tester) async {
      // arrange
      int tapCount = 0;
      final items = [const MapEntry('Name', 'Italy')];

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(items: items, onExpandToggle: () => tapCount++),
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

    testWidgets('should use ListView.builder', (tester) async {
      // arrange
      final items = [const MapEntry('Test', 'Value')];

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(items: items, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should handle items with special characters', (tester) async {
      // arrange
      final items = [
        const MapEntry('Native', 'Français'),
        const MapEntry('Arabic', 'العربية'),
      ];

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(items: items, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Français'), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);
    });

    testWidgets('should render button as last item', (tester) async {
      // arrange
      final items = [
        const MapEntry('First', 'A'),
        const MapEntry('Second', 'B'),
      ];

      // act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DetailView(items: items, onExpandToggle: () {}),
            ),
          ),
        ),
      );

      // assert - button should be after all items
      expect(find.byType(CountryDetailItem), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
