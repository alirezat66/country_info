import 'dart:async';

import 'package:country_info/core/domain/failure.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/presentation/providers/country_providers.dart';
import 'package:country_info/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'ListScreen - should display countries list when data loads successfully',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'US', name: 'United States', emoji: '🇺🇸'),
        const Country(code: 'CA', name: 'Canada', emoji: '🇨🇦'),
        const Country(code: 'GB', name: 'United Kingdom', emoji: '🇬🇧'),
      ];

      // act
      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
          ],
          child: const MyApp(),
        ),
      );

      // assert
      expect(find.text('Countries'), findsOneWidget);
      expect(find.text('United States'), findsOneWidget);
      expect(find.text('Canada'), findsOneWidget);
      expect(find.text('United Kingdom'), findsOneWidget);
      expect(find.text('🇺🇸'), findsOneWidget);
      expect(find.text('🇨🇦'), findsOneWidget);
      expect(find.text('🇬🇧'), findsOneWidget);
    },
  );

  patrolTest('ListScreen - should display loading indicator initially', (
    $,
  ) async {
    // arrange
    final completer = Completer<List<Country>>();

    // act
    await $.pumpWidget(
      ProviderScope(
        overrides: [countriesProvider.overrideWith((ref) => completer.future)],
        child: const MyApp(),
      ),
    );

    await $.pump();

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // cleanup
    completer.complete([]);
    await $.pumpAndSettle();
  });

  patrolTest('ListScreen - should display error view when error occurs', (
    $,
  ) async {
    // arrange
    final failure = ServerFailure('Server error occurred', code: 'ERROR_CODE');

    // act
    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith(
            (ref) => Future<List<Country>>.error(failure),
          ),
        ],
        child: const MyApp(),
      ),
    );

    // assert
    expect(find.text('Error loading countries'), findsOneWidget);
    expect(find.text('Server error occurred'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  patrolTest('ListScreen - should display empty view when no countries', (
    $,
  ) async {
    // arrange & act
    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(<Country>[])),
        ],
        child: const MyApp(),
      ),
    );

    // assert
    expect(find.text('No countries found'), findsOneWidget);
  });

  patrolTest('ListScreen - should tap on country item', ($) async {
    // arrange
    final countries = [
      const Country(code: 'FR', name: 'France', emoji: '🇫🇷'),
    ];

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
        ],
        child: const MyApp(),
      ),
    );

    // act
    await $.tester.tap(find.text('France'));
    await $.pumpAndSettle();

    // assert
    // Note: In a real scenario, this would navigate to detail screen
    // For now, we just verify the tap was successful
    expect(find.text('France'), findsOneWidget);
  });

  patrolTest('ListScreen - should scroll through country list', ($) async {
    // arrange
    final countries = List.generate(
      20,
      (index) => Country(code: 'C$index', name: 'Country $index', emoji: '🏳️'),
    );

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
        ],
        child: const MyApp(),
      ),
    );

    // assert - verify first country is visible
    expect(find.text('Country 0'), findsOneWidget);

    // act - scroll down
    await $.tester.scrollUntilVisible(
      find.text('Country 19'),
      500.0,
      scrollable: find.byType(ListView),
    );
    await $.pumpAndSettle();

    // assert - verify last country is visible after scroll
    expect(find.text('Country 19'), findsOneWidget);
  });

  patrolTest('ListScreen - should retry after error', ($) async {
    // arrange
    var shouldFail = true;
    final countries = [
      const Country(code: 'DE', name: 'Germany', emoji: '🇩🇪'),
    ];

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) {
            if (shouldFail) {
              shouldFail = false;
              return Future<List<Country>>.error(
                ServerFailure('Network error'),
              );
            }
            return Future.value(countries);
          }),
        ],
        child: const MyApp(),
      ),
    );

    // assert - error is shown
    expect(find.text('Error loading countries'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    // act - tap retry
    await $.tester.tap(find.text('Retry'));
    await $.pumpAndSettle();

    // assert - countries are loaded after retry
    expect(find.text('Germany'), findsOneWidget);
    expect(find.text('Error loading countries'), findsNothing);
  });
}
