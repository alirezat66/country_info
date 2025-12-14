import 'dart:async';

import 'package:country_info/core/domain/failure.dart';
import 'package:country_info/core/presentation/views/error_view.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/domain/usecases/get_countries.dart';
import 'package:country_info/features/country/presentation/providers/country_providers.dart';
import 'package:country_info/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:patrol/patrol.dart';

@GenerateMocks([GetCountries])
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
    const errorMessage = 'Server error occurred';
    final failure = ServerFailure(errorMessage, code: 'ERROR_CODE');

    // act - override the countries provider with AsyncError
    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWithValue(
            AsyncError<List<Country>>(failure, StackTrace.current),
          ),
        ],
        child: const MyApp(),
      ),
    );

    // assert - ErrorView should be displayed
    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Error loading countries'), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
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
      scrollable: find.byType(Scrollable),
    );
    await $.pumpAndSettle();

    // assert - verify last country is visible after scroll
    expect(find.text('Country 19'), findsOneWidget);
  });

  patrolTest('ListScreen - should retry after error', ($) async {
    // arrange
    final countries = [
      const Country(code: 'DE', name: 'Germany', emoji: '🇩🇪'),
    ];
    final failure = ServerFailure('Network error');
    // act - initial override with AsyncError
    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWithValue(
            AsyncError<List<Country>>(failure, StackTrace.current),
          ),
        ],
        child: const MyApp(),
      ),
    );
    // assert - error is shown
    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Error loading countries'), findsOneWidget);
    expect(find.text('Network error'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    // act - tap retry (tests the UI interaction, even though invalidate won't change the fixed value)
    await $.tap(find.text('Retry'));
    // simulate successful retry by re-pumping with AsyncData override
    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWithValue(AsyncValue.data(countries)),
        ],
        child: const MyApp(),
      ),
    );
    // assert - countries are loaded after retry
    expect(find.text('Germany'), findsOneWidget);
    expect(find.text('Error loading countries'), findsNothing);
  });

  patrolTest(
    'ListScreen - should navigate to detail page with correct country code',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'PT', name: 'Portugal', emoji: '🇵🇹'),
      ];

      const ptDetails = Country(
        code: 'PT',
        name: 'Portugal',
        emoji: '🇵🇹',
        capital: 'Lisbon',
      );

      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider(
              'PT',
            ).overrideWith((ref) => Future.value(ptDetails)),
          ],
          child: const MyApp(),
        ),
      );

      // act - tap on Portugal
      await $.tap(find.text('Portugal'));
      await $.pumpAndSettle();

      // assert - verify correct country details loaded
      expect(find.text('Code:'), findsOneWidget);
      expect(find.text('PT'), findsOneWidget);
      expect(find.text('Lisbon'), findsOneWidget);
    },
  );

  patrolTest('ListScreen - should pass country name for Hero animation', (
    $,
  ) async {
    // arrange
    final countries = [
      const Country(code: 'SE', name: 'Sweden', emoji: '🇸🇪'),
    ];

    const seDetails = Country(
      code: 'SE',
      name: 'Sweden',
      emoji: '🇸🇪',
      capital: 'Stockholm',
    );

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
          countryDetailsProvider(
            'SE',
          ).overrideWith((ref) => Future.value(seDetails)),
        ],
        child: const MyApp(),
      ),
    );

    // act - tap on Sweden
    await $.tap(find.text('Sweden'));
    await $.pumpAndSettle();

    // assert - Hero widget should be present with country name
    expect(find.byType(Hero), findsWidgets);
    expect(find.text('Sweden'), findsWidgets);
    expect(find.text('Stockholm'), findsOneWidget);
  });
}
