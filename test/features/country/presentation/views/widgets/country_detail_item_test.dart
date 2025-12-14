import 'package:country_info/features/country/presentation/views/widgets/country_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountryDetailItem', () {
    testWidgets('should display label and value correctly', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountryDetailItem(
              label: 'Capital',
              value: 'Washington, D.C.',
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Capital:'), findsOneWidget);
      expect(find.text('Washington, D.C.'), findsOneWidget);
    });

    testWidgets('should display label with colon', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountryDetailItem(label: 'Currency', value: 'USD'),
          ),
        ),
      );

      // assert
      expect(find.text('Currency:'), findsOneWidget);
      expect(find.text('Currency'), findsNothing);
    });

    testWidgets('should have label with bold font weight', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountryDetailItem(label: 'Name', value: 'United States'),
          ),
        ),
      );

      // assert
      final labelText = tester.widget<Text>(find.text('Name:'));
      expect(labelText.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should use default padding', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountryDetailItem(label: 'Code', value: 'US'),
          ),
        ),
      );

      // assert
      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(
        padding.padding,
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      );
    });

    testWidgets('should use custom padding when provided', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountryDetailItem(
              label: 'Phone',
              value: '1',
              padding: EdgeInsets.all(20.0),
            ),
          ),
        ),
      );

      // assert
      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, const EdgeInsets.all(20.0));
    });

    testWidgets('should display with empty strings', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountryDetailItem(label: '', value: ''),
          ),
        ),
      );

      // assert
      expect(find.text(':'), findsOneWidget);
      expect(find.text(''), findsWidgets);
    });

    testWidgets('should handle long text values', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountryDetailItem(
              label: 'Languages',
              value: 'English, Spanish, French, German, Italian, Portuguese',
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Languages:'), findsOneWidget);
      expect(
        find.text('English, Spanish, French, German, Italian, Portuguese'),
        findsOneWidget,
      );
    });

    testWidgets('should have Row with two Expanded widgets', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountryDetailItem(label: 'Flag', value: '🇺🇸'),
          ),
        ),
      );

      // assert
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, 2);
      expect(row.children[0], isA<Expanded>());
      expect(row.children[1], isA<Expanded>());
    });

    testWidgets('should have correct flex values for Expanded widgets', (
      tester,
    ) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountryDetailItem(label: 'Capital', value: 'London'),
          ),
        ),
      );

      // assert
      final expandedWidgets = tester.widgetList<Expanded>(
        find.byType(Expanded),
      );
      final expandedList = expandedWidgets.toList();
      expect(expandedList[0].flex, 1);
      expect(expandedList[1].flex, 2);
    });

    testWidgets('should have CrossAxisAlignment.start for Row', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountryDetailItem(
              label: 'Description',
              value: 'A very long description that spans multiple lines',
            ),
          ),
        ),
      );

      // assert
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('should display different country details', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CountryDetailItem(label: 'Code', value: 'FR'),
                CountryDetailItem(label: 'Name', value: 'France'),
                CountryDetailItem(label: 'Capital', value: 'Paris'),
              ],
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Code:'), findsOneWidget);
      expect(find.text('FR'), findsOneWidget);
      expect(find.text('Name:'), findsOneWidget);
      expect(find.text('France'), findsOneWidget);
      expect(find.text('Capital:'), findsOneWidget);
      expect(find.text('Paris'), findsOneWidget);
    });

    testWidgets('should use theme text style', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
          home: const Scaffold(
            body: CountryDetailItem(label: 'Test', value: 'Value'),
          ),
        ),
      );

      // assert
      final valueText = tester.widget<Text>(find.text('Value'));
      expect(valueText.style?.fontSize, 16);
    });

    testWidgets('should handle special characters in values', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountryDetailItem(label: 'Native', value: 'العربية'),
          ),
        ),
      );

      // assert
      expect(find.text('Native:'), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);
    });
  });
}
