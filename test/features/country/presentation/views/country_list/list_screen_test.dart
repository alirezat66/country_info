import 'dart:async';

import 'package:country_info/core/domain/failure.dart';
import 'package:country_info/core/presentation/views/error_view.dart';
import 'package:country_info/core/presentation/views/loading_view.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/presentation/providers/country_providers.dart';
import 'package:country_info/features/country/presentation/views/country_list/list_screen.dart';
import 'package:country_info/features/country/presentation/views/country_list/views/loaded_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ListScreen', () {
    testWidgets('should display AppBar with title', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith(
              (ref) => Future.value(<Country>[]),
            ),
          ],
          child: const MaterialApp(
            home: ListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.text('Countries'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display LoadingView when data is loading',
        (tester) async {
      // arrange
      final completer = Completer<List<Country>>();

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith(
              (ref) => completer.future,
            ),
          ],
          child: const MaterialApp(
            home: ListScreen(),
          ),
        ),
      );

      await tester.pump();

      // assert
      expect(find.byType(LoadingView), findsOneWidget);
      expect(find.byType(CountryLoadedView), findsNothing);
      expect(find.byType(ErrorView), findsNothing);

      // cleanup
      completer.complete([]);
    });

    testWidgets('should display CountryLoadedView when data is loaded',
        (tester) async {
      // arrange
      final countries = [
        const Country(code: 'US', name: 'United States', emoji: '🇺🇸'),
        const Country(code: 'CA', name: 'Canada', emoji: '🇨🇦'),
      ];

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith(
              (ref) => Future.value(countries),
            ),
          ],
          child: const MaterialApp(
            home: ListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(CountryLoadedView), findsOneWidget);
      expect(find.byType(LoadingView), findsNothing);
      expect(find.byType(ErrorView), findsNothing);
      expect(find.text('United States'), findsOneWidget);
      expect(find.text('Canada'), findsOneWidget);
    });

    testWidgets('should display ErrorView when error occurs', (tester) async {
      // arrange
      final failure = ServerFailure('Server error', code: 'ERROR_CODE');

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith(
              (ref) => Future<List<Country>>.error(failure),
            ),
          ],
          child: const MaterialApp(
            home: ListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.byType(LoadingView), findsNothing);
      expect(find.byType(CountryLoadedView), findsNothing);
      expect(find.text('Server error'), findsOneWidget);
    });

    testWidgets('should display ErrorView with retry button', (tester) async {
      // arrange
      final failure = NetworkFailure('Network error');

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith(
              (ref) => Future<List<Country>>.error(failure),
            ),
          ],
          child: const MaterialApp(
            home: ListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should handle non-Failure error types', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith(
              (ref) => Future<List<Country>>.error('String error'),
            ),
          ],
          child: const MaterialApp(
            home: ListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.textContaining('String error'), findsOneWidget);
    });

    testWidgets('should display empty list correctly', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith(
              (ref) => Future.value(<Country>[]),
            ),
          ],
          child: const MaterialApp(
            home: ListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(CountryLoadedView), findsOneWidget);
      expect(find.text('No countries found'), findsOneWidget);
    });
  });
}
