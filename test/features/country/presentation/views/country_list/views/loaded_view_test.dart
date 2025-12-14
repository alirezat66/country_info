import 'package:country_info/core/presentation/views/empty_view.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/presentation/views/country_list/views/country_list_view.dart';
import 'package:country_info/features/country/presentation/views/country_list/views/loaded_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountryLoadedView', () {
    testWidgets('should display CountryListView when countries list is not empty',
        (tester) async {
      // arrange
      final countries = [
        const Country(code: 'US', name: 'United States', emoji: '🇺🇸'),
        const Country(code: 'CA', name: 'Canada', emoji: '🇨🇦'),
      ];

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryLoadedView(
              countries: countries,
              onCountrySelected: (code, name) {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(CountryListView), findsOneWidget);
      expect(find.byType(EmptyView), findsNothing);
      expect(find.text('United States'), findsOneWidget);
      expect(find.text('Canada'), findsOneWidget);
    });

    testWidgets('should display EmptyView when countries list is empty',
        (tester) async {
      // arrange
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryLoadedView(
              countries: [],
              onCountrySelected: (code, name) {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(EmptyView), findsOneWidget);
      expect(find.byType(CountryListView), findsNothing);
      expect(find.text('No countries found'), findsOneWidget);
    });

    testWidgets('should pass onCountrySelected to CountryListView',
        (tester) async {
      // arrange
      final countries = [
        const Country(code: 'GB', name: 'United Kingdom', emoji: '🇬🇧'),
      ];
      String? selectedCode;
      String? selectedName;

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryLoadedView(
              countries: countries,
              onCountrySelected: (code, name) {
                selectedCode = code;
                selectedName = name;
              },
            ),
          ),
        ),
      );

      // act - tap on country
      await tester.tap(find.text('United Kingdom'));
      await tester.pump();

      // assert
      expect(selectedCode, 'GB');
      expect(selectedName, 'United Kingdom');
    });

    testWidgets('should handle single country correctly', (tester) async {
      // arrange
      final countries = [
        const Country(code: 'JP', name: 'Japan', emoji: '🇯🇵'),
      ];

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryLoadedView(
              countries: countries,
              onCountrySelected: (code, name) {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(CountryListView), findsOneWidget);
      expect(find.text('Japan'), findsOneWidget);
      expect(find.byType(EmptyView), findsNothing);
    });
  });
}

