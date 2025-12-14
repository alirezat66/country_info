import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/presentation/views/country_list/views/country_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountryListView', () {
    testWidgets('should display list of countries', (tester) async {
      // arrange
      final countries = [
        const Country(code: 'US', name: 'United States', emoji: '🇺🇸'),
        const Country(code: 'CA', name: 'Canada', emoji: '🇨🇦'),
        const Country(code: 'GB', name: 'United Kingdom', emoji: '🇬🇧'),
      ];
      String? selectedCode;
      String? selectedName;

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListView(
              countries: countries,
              onCountrySelected: (code, name) {
                selectedCode = code;
                selectedName = name;
              },
            ),
          ),
        ),
      );

      // assert
      expect(find.text('United States'), findsOneWidget);
      expect(find.text('Canada'), findsOneWidget);
      expect(find.text('United Kingdom'), findsOneWidget);
      expect(find.text('🇺🇸'), findsOneWidget);
      expect(find.text('🇨🇦'), findsOneWidget);
      expect(find.text('🇬🇧'), findsOneWidget);
    });

    testWidgets('should call onCountrySelected when country is tapped',
        (tester) async {
      // arrange
      final countries = [
        const Country(code: 'FR', name: 'France', emoji: '🇫🇷'),
      ];
      String? selectedCode;
      String? selectedName;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListView(
              countries: countries,
              onCountrySelected: (code, name) {
                selectedCode = code;
                selectedName = name;
              },
            ),
          ),
        ),
      );

      // act
      await tester.tap(find.text('France'));
      await tester.pump();

      // assert
      expect(selectedCode, 'FR');
      expect(selectedName, 'France');
    });

    testWidgets('should handle empty list', (tester) async {
      // arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListView(
              countries: [],
              onCountrySelected: (code, name) {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('should display correct number of items', (tester) async {
      // arrange
      final countries = List.generate(
        5,
        (index) => Country(
          code: 'C$index',
          name: 'Country $index',
          emoji: '🏳️',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListView(
              countries: countries,
              onCountrySelected: (code, name) {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(ListTile), findsNWidgets(5));
    });
  });
}

