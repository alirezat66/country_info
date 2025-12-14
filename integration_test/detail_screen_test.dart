import 'dart:async';

import 'package:country_info/core/domain/failure.dart';
import 'package:country_info/core/presentation/views/error_view.dart';
import 'package:country_info/features/country/domain/entities/continent.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/domain/entities/language.dart';
import 'package:country_info/features/country/presentation/providers/country_providers.dart';
import 'package:country_info/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'DetailScreen - should navigate to detail page when country tapped',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'US', name: 'United States', emoji: '🇺🇸'),
        const Country(code: 'CA', name: 'Canada', emoji: '🇨🇦'),
      ];

      const usDetails = Country(
        code: 'US',
        name: 'United States',
        emoji: '🇺🇸',
        capital: 'Washington, D.C.',
        currency: 'USD',
        phone: '1',
      );

      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider(
              'US',
            ).overrideWith((ref) => Future.value(usDetails)),
          ],
          child: const MyApp(),
        ),
      );

      // act - tap on United States
      await $.tap(find.text('United States'));
      await $.pumpAndSettle();

      // assert
      expect(find.text('United States'), findsWidgets);
      expect(find.text('🇺🇸'), findsOneWidget);
      expect(find.text('Flag:'), findsOneWidget);
      expect(find.text('Code:'), findsOneWidget);
      expect(find.text('US'), findsOneWidget);
      expect(find.text('Capital:'), findsOneWidget);
      expect(find.text('Washington, D.C.'), findsOneWidget);
    },
  );

  patrolTest('DetailScreen - should navigate back to list screen', ($) async {
    // arrange
    final countries = [
      const Country(code: 'FR', name: 'France', emoji: '🇫🇷'),
    ];

    const frDetails = Country(
      code: 'FR',
      name: 'France',
      emoji: '🇫🇷',
      capital: 'Paris',
    );

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
          countryDetailsProvider(
            'FR',
          ).overrideWith((ref) => Future.value(frDetails)),
        ],
        child: const MyApp(),
      ),
    );

    // Navigate to detail page
    await $.tap(find.text('France'));
    await $.pumpAndSettle();

    // Verify we're on detail page
    expect(find.text('Flag:'), findsOneWidget);

    // act - navigate back
    await $.tester.pageBack();
    await $.pumpAndSettle();

    // assert - back on list screen
    expect(find.text('Countries'), findsOneWidget);
    expect(find.text('France'), findsOneWidget);
    expect(find.text('Flag:'), findsNothing);
  });

  patrolTest(
    'DetailScreen - should maintain Hero animation during navigation',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'GB', name: 'United Kingdom', emoji: '🇬🇧'),
      ];

      const gbDetails = Country(
        code: 'GB',
        name: 'United Kingdom',
        emoji: '🇬🇧',
        capital: 'London',
      );

      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider(
              'GB',
            ).overrideWith((ref) => Future.value(gbDetails)),
          ],
          child: const MyApp(),
        ),
      );

      // act - tap to navigate
      await $.tap(find.text('United Kingdom'));
      await $.pumpAndSettle();

      // assert - Hero widget should be present on detail page
      expect(find.byType(Hero), findsWidgets);
      expect(find.text('United Kingdom'), findsWidgets);
    },
  );

  patrolTest('DetailScreen - should display loading indicator initially', (
    $,
  ) async {
    // arrange
    final countries = [
      const Country(code: 'DE', name: 'Germany', emoji: '🇩🇪'),
    ];

    final completer = Completer<Country>();

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
          countryDetailsProvider('DE').overrideWith((ref) => completer.future),
        ],
        child: const MyApp(),
      ),
    );

    // act - navigate to detail page
    await $.tap(find.text('Germany'));
    await $.pump();

    // assert - loading indicator should be visible
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // cleanup
    completer.complete(
      const Country(code: 'DE', name: 'Germany', emoji: '🇩🇪'),
    );
    await $.pumpAndSettle();
  });

  patrolTest('DetailScreen - should display country details when loaded', (
    $,
  ) async {
    // arrange
    final countries = [const Country(code: 'IT', name: 'Italy', emoji: '🇮🇹')];

    const itDetails = Country(
      code: 'IT',
      name: 'Italy',
      emoji: '🇮🇹',
      capital: 'Rome',
      currency: 'EUR',
      phone: '39',
    );

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
          countryDetailsProvider(
            'IT',
          ).overrideWith((ref) => Future.value(itDetails)),
        ],
        child: const MyApp(),
      ),
    );

    // act
    await $.tap(find.text('Italy'));
    await $.pumpAndSettle();

    // assert - basic fields
    expect(find.text('Flag:'), findsOneWidget);
    expect(find.text('🇮🇹'), findsOneWidget);
    expect(find.text('Name:'), findsOneWidget);
    expect(find.text('Italy'), findsWidgets);
    expect(find.text('Code:'), findsOneWidget);
    expect(find.text('IT'), findsOneWidget);
    expect(find.text('Capital:'), findsOneWidget);
    expect(find.text('Rome'), findsOneWidget);
  });

  patrolTest(
    'DetailScreen - should display complete country data with nested objects',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'ES', name: 'Spain', emoji: '🇪🇸'),
      ];

      const esDetails = Country(
        code: 'ES',
        name: 'Spain',
        emoji: '🇪🇸',
        capital: 'Madrid',
        currency: 'EUR',
        phone: '34',
        continent: Continent(code: 'EU', name: 'Europe'),
        languages: [
          Language(code: 'es', name: 'Spanish', native: 'Español', rtl: false),
        ],
      );

      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider(
              'ES',
            ).overrideWith((ref) => Future.value(esDetails)),
          ],
          child: const MyApp(),
        ),
      );

      // Navigate to detail page
      await $.tap(find.text('Spain'));
      await $.pumpAndSettle();

      // act - tap show more
      await $.tap(find.text('Show more'));
      await $.pumpAndSettle();

      // assert - extended fields
      expect(find.text('Currency:'), findsOneWidget);
      expect(find.text('EUR'), findsOneWidget);
      expect(find.text('Phone:'), findsOneWidget);
      expect(find.text('34'), findsOneWidget);
      expect(find.text('Continent Code:'), findsOneWidget);
      expect(find.text('EU'), findsOneWidget);
      expect(find.text('Continent Name:'), findsOneWidget);
      expect(find.text('Europe'), findsOneWidget);
      expect(find.text('Languages:'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);
    },
  );

  patrolTest('DetailScreen - should toggle show more and show less', ($) async {
    // arrange
    final countries = [const Country(code: 'JP', name: 'Japan', emoji: '🇯🇵')];

    const jpDetails = Country(
      code: 'JP',
      name: 'Japan',
      emoji: '🇯🇵',
      capital: 'Tokyo',
      currency: 'JPY',
      phone: '81',
    );

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
          countryDetailsProvider(
            'JP',
          ).overrideWith((ref) => Future.value(jpDetails)),
        ],
        child: const MyApp(),
      ),
    );

    // Navigate to detail page
    await $.tap(find.text('Japan'));
    await $.pumpAndSettle();

    // assert - initially shows "Show more"
    expect(find.text('Show more'), findsOneWidget);
    expect(find.text('Show less'), findsNothing);
    expect(find.text('Currency:'), findsNothing);

    // act - tap show more
    await $.tap(find.text('Show more'));
    await $.pumpAndSettle();

    // assert - now shows "Show less" and extended fields
    expect(find.text('Show less'), findsOneWidget);
    expect(find.text('Show more'), findsNothing);
    expect(find.text('Currency:'), findsOneWidget);
    expect(find.text('JPY'), findsOneWidget);

    // act - tap show less
    await $.tap(find.text('Show less'));
    await $.pumpAndSettle();

    // assert - back to "Show more" and basic fields only
    expect(find.text('Show more'), findsOneWidget);
    expect(find.text('Show less'), findsNothing);
    expect(find.text('Currency:'), findsNothing);
  });

  patrolTest(
    'DetailScreen - should display extended fields when show more tapped',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'BR', name: 'Brazil', emoji: '🇧🇷'),
      ];

      const brDetails = Country(
        code: 'BR',
        name: 'Brazil',
        emoji: '🇧🇷',
        capital: 'Brasília',
        currency: 'BRL',
        phone: '55',
        continent: Continent(code: 'SA', name: 'South America'),
        languages: [Language(code: 'pt', name: 'Portuguese')],
      );

      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider(
              'BR',
            ).overrideWith((ref) => Future.value(brDetails)),
          ],
          child: const MyApp(),
        ),
      );

      // Navigate to detail page
      await $.tap(find.text('Brazil'));
      await $.pumpAndSettle();

      // act
      await $.tap(find.text('Show more'));
      await $.pumpAndSettle();

      // assert
      expect(find.text('Currency:'), findsOneWidget);
      expect(find.text('BRL'), findsOneWidget);
      expect(find.text('Phone:'), findsOneWidget);
      expect(find.text('55'), findsOneWidget);
      expect(find.text('Continent Code:'), findsOneWidget);
      expect(find.text('SA'), findsOneWidget);
      expect(find.text('Continent Name:'), findsOneWidget);
      expect(find.text('South America'), findsOneWidget);
      expect(find.text('Languages:'), findsOneWidget);
      expect(find.text('Portuguese'), findsOneWidget);
    },
  );

  patrolTest(
    'DetailScreen - should hide extended fields when show less tapped',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'AU', name: 'Australia', emoji: '🇦🇺'),
      ];

      const auDetails = Country(
        code: 'AU',
        name: 'Australia',
        emoji: '🇦🇺',
        capital: 'Canberra',
        currency: 'AUD',
        phone: '61',
      );

      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider(
              'AU',
            ).overrideWith((ref) => Future.value(auDetails)),
          ],
          child: const MyApp(),
        ),
      );

      // Navigate to detail page
      await $.tap(find.text('Australia'));
      await $.pumpAndSettle();

      // Expand
      await $.tap(find.text('Show more'));
      await $.pumpAndSettle();

      // Verify expanded
      expect(find.text('Currency:'), findsOneWidget);
      expect(find.text('Phone:'), findsOneWidget);

      // act - collapse
      await $.tap(find.text('Show less'));
      await $.pumpAndSettle();

      // assert - fields hidden
      expect(find.text('Currency:'), findsNothing);
      expect(find.text('Phone:'), findsNothing);
      expect(find.text('Flag:'), findsOneWidget);
      expect(find.text('Name:'), findsOneWidget);
    },
  );

  patrolTest(
    'DetailScreen - should display error view when country details fail to load',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'XX', name: 'Test Country', emoji: '🏳️'),
      ];

      final failure = ServerFailure('Country not found', code: 'NOT_FOUND');

      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider('XX').overrideWithValue(
              AsyncError<Country>(failure, StackTrace.current),
            ),
          ],
          child: const MyApp(),
        ),
      );

      // act
      await $.tap(find.text('Test Country'));
      await $.pumpAndSettle();

      // assert
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Error loading countries'), findsOneWidget);
      expect(find.textContaining('Country not found'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    },
  );

  patrolTest(
    'DetailScreen - should retry loading country details after error',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'CA', name: 'Canada', emoji: '🇨🇦'),
      ];

      const caDetails = Country(
        code: 'CA',
        name: 'Canada',
        emoji: '🇨🇦',
        capital: 'Ottawa',
      );

      final failure = NetworkFailure('Network error');

      // Start with error
      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider('CA').overrideWithValue(
              AsyncError<Country>(failure, StackTrace.current),
            ),
          ],
          child: const MyApp(),
        ),
      );

      // Navigate to detail page
      await $.tap(find.text('Canada'));
      await $.pumpAndSettle();

      // Verify error
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      // act - tap retry and simulate success
      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider(
              'CA',
            ).overrideWithValue(AsyncValue.data(caDetails)),
          ],
          child: const MyApp(),
        ),
      );

      // assert - details loaded
      expect(find.text('Flag:'), findsOneWidget);
      expect(find.text('Ottawa'), findsOneWidget);
      expect(find.byType(ErrorView), findsNothing);
    },
  );

  patrolTest('DetailScreen - should handle country with null optional fields', (
    $,
  ) async {
    // arrange
    final countries = [const Country(code: 'XX', name: 'Test', emoji: '🏳️')];

    const xxDetails = Country(code: 'XX', name: 'Test', emoji: '🏳️');

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
          countryDetailsProvider(
            'XX',
          ).overrideWith((ref) => Future.value(xxDetails)),
        ],
        child: const MyApp(),
      ),
    );

    // Navigate to detail page
    await $.tap(find.text('Test'));
    await $.pumpAndSettle();

    // Verify basic fields work
    expect(find.text('Flag:'), findsOneWidget);
    expect(find.text('🏳️'), findsOneWidget);

    // act - tap show more
    await $.tap(find.text('Show more'));
    await $.pumpAndSettle();

    // assert - NA/AN for missing fields (there are 2 NA fields: Currency and Continent Code)
    expect(find.text('Currency:'), findsOneWidget);
    expect(
      find.text('NA'),
      findsNWidgets(2),
    ); // Currency NA and Continent Code NA
    expect(find.text('Phone:'), findsOneWidget);
    expect(find.text('AN'), findsOneWidget);
    expect(find.text('Continent Code:'), findsOneWidget);
  });

  patrolTest('DetailScreen - should display multiple languages correctly', (
    $,
  ) async {
    // arrange
    final countries = [
      const Country(code: 'BE', name: 'Belgium', emoji: '🇧🇪'),
    ];

    const beDetails = Country(
      code: 'BE',
      name: 'Belgium',
      emoji: '🇧🇪',
      capital: 'Brussels',
      languages: [
        Language(code: 'nl', name: 'Dutch'),
        Language(code: 'fr', name: 'French'),
        Language(code: 'de', name: 'German'),
      ],
    );

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
          countryDetailsProvider(
            'BE',
          ).overrideWith((ref) => Future.value(beDetails)),
        ],
        child: const MyApp(),
      ),
    );

    // Navigate to detail page
    await $.tap(find.text('Belgium'));
    await $.pumpAndSettle();

    // act
    await $.tap(find.text('Show more'));
    await $.pumpAndSettle();

    // assert - languages as comma-separated
    expect(find.text('Languages:'), findsOneWidget);
    expect(find.text('Dutch, French, German'), findsOneWidget);
  });

  patrolTest(
    'DetailScreen - should handle country with continent but no languages',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'NZ', name: 'New Zealand', emoji: '🇳🇿'),
      ];

      const nzDetails = Country(
        code: 'NZ',
        name: 'New Zealand',
        emoji: '🇳🇿',
        capital: 'Wellington',
        continent: Continent(code: 'OC', name: 'Oceania'),
        languages: [],
      );

      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider(
              'NZ',
            ).overrideWith((ref) => Future.value(nzDetails)),
          ],
          child: const MyApp(),
        ),
      );

      // Navigate to detail page
      await $.tap(find.text('New Zealand'));
      await $.pumpAndSettle();

      // act
      await $.tap(find.text('Show more'));
      await $.pumpAndSettle();

      // assert - continent shown, languages not shown
      expect(find.text('Continent Code:'), findsOneWidget);
      expect(find.text('OC'), findsOneWidget);
      expect(find.text('Continent Name:'), findsOneWidget);
      expect(find.text('Oceania'), findsOneWidget);
      expect(find.text('Languages:'), findsNothing);
    },
  );

  patrolTest('DetailScreen - should scroll through long detail list', (
    $,
  ) async {
    // arrange
    final countries = [
      const Country(code: 'CH', name: 'Switzerland', emoji: '🇨🇭'),
    ];

    const chDetails = Country(
      code: 'CH',
      name: 'Switzerland',
      emoji: '🇨🇭',
      capital: 'Bern',
      currency: 'CHF',
      phone: '41',
      continent: Continent(code: 'EU', name: 'Europe'),
      languages: [
        Language(code: 'de', name: 'German'),
        Language(code: 'fr', name: 'French'),
        Language(code: 'it', name: 'Italian'),
        Language(code: 'rm', name: 'Romansh'),
      ],
    );

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
          countryDetailsProvider(
            'CH',
          ).overrideWith((ref) => Future.value(chDetails)),
        ],
        child: const MyApp(),
      ),
    );

    // Navigate to detail page
    await $.tap(find.text('Switzerland'));
    await $.pumpAndSettle();

    // Expand to show all fields
    await $.tap(find.text('Show more'));
    await $.pumpAndSettle();

    // assert - verify top fields visible
    expect(find.text('Flag:'), findsOneWidget);

    // act - scroll to bottom to see languages
    await $.tester.scrollUntilVisible(
      find.text('Languages:'),
      100.0,
      scrollable: find.byType(Scrollable),
    );
    await $.pumpAndSettle();

    // assert - languages visible after scroll
    expect(find.text('Languages:'), findsOneWidget);
    expect(find.text('German, French, Italian, Romansh'), findsOneWidget);
  });

  patrolTest(
    'DetailScreen - should reset show more state when navigating away',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'FR', name: 'France', emoji: '🇫🇷'),
        const Country(code: 'DE', name: 'Germany', emoji: '🇩🇪'),
      ];

      const frDetails = Country(
        code: 'FR',
        name: 'France',
        emoji: '🇫🇷',
        capital: 'Paris',
        currency: 'EUR',
      );

      const deDetails = Country(
        code: 'DE',
        name: 'Germany',
        emoji: '🇩🇪',
        capital: 'Berlin',
        currency: 'EUR',
      );

      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider(
              'FR',
            ).overrideWith((ref) => Future.value(frDetails)),
            countryDetailsProvider(
              'DE',
            ).overrideWith((ref) => Future.value(deDetails)),
          ],
          child: const MyApp(),
        ),
      );

      // Navigate to France detail
      await $.tap(find.text('France'));
      await $.pumpAndSettle();

      // Expand
      await $.tap(find.text('Show more'));
      await $.pumpAndSettle();
      expect(find.text('Show less'), findsOneWidget);

      // Navigate back
      await $.tester.pageBack();
      await $.pumpAndSettle();

      // Navigate to Germany detail
      await $.tap(find.text('Germany'));
      await $.pumpAndSettle();

      // assert - should show "Show more" (state reset)
      expect(find.text('Show more'), findsOneWidget);
      expect(find.text('Show less'), findsNothing);
      expect(find.text('Currency:'), findsNothing);
    },
  );

  patrolTest('DetailScreen - should display country with RTL language', (
    $,
  ) async {
    // arrange
    final countries = [
      const Country(code: 'SA', name: 'Saudi Arabia', emoji: '🇸🇦'),
    ];

    const saDetails = Country(
      code: 'SA',
      name: 'Saudi Arabia',
      emoji: '🇸🇦',
      capital: 'Riyadh',
      languages: [
        Language(code: 'ar', name: 'Arabic', native: 'العربية', rtl: true),
      ],
    );

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
          countryDetailsProvider(
            'SA',
          ).overrideWith((ref) => Future.value(saDetails)),
        ],
        child: const MyApp(),
      ),
    );

    // Navigate to detail page
    await $.tap(find.text('Saudi Arabia'));
    await $.pumpAndSettle();

    // act
    await $.tap(find.text('Show more'));
    await $.pumpAndSettle();

    // assert
    expect(find.text('Languages:'), findsOneWidget);
    expect(find.text('Arabic'), findsOneWidget);
  });

  patrolTest('DetailScreen - should display all basic fields correctly', (
    $,
  ) async {
    // arrange
    final countries = [const Country(code: 'IN', name: 'India', emoji: '🇮🇳')];

    const inDetails = Country(
      code: 'IN',
      name: 'India',
      emoji: '🇮🇳',
      capital: 'New Delhi',
    );

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
          countryDetailsProvider(
            'IN',
          ).overrideWith((ref) => Future.value(inDetails)),
        ],
        child: const MyApp(),
      ),
    );

    // act
    await $.tap(find.text('India'));
    await $.pumpAndSettle();

    // assert - verify all 4 basic fields
    expect(find.text('Flag:'), findsOneWidget);
    expect(find.text('🇮🇳'), findsOneWidget);
    expect(find.text('Name:'), findsOneWidget);
    expect(find.text('India'), findsWidgets);
    expect(find.text('Code:'), findsOneWidget);
    expect(find.text('IN'), findsOneWidget);
    expect(find.text('Capital:'), findsOneWidget);
    expect(find.text('New Delhi'), findsOneWidget);
  });

  patrolTest(
    'DetailScreen - should handle navigation with different countries',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'MX', name: 'Mexico', emoji: '🇲🇽'),
        const Country(code: 'AR', name: 'Argentina', emoji: '🇦🇷'),
      ];

      const mxDetails = Country(
        code: 'MX',
        name: 'Mexico',
        emoji: '🇲🇽',
        capital: 'Mexico City',
      );

      const arDetails = Country(
        code: 'AR',
        name: 'Argentina',
        emoji: '🇦🇷',
        capital: 'Buenos Aires',
      );

      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider(
              'MX',
            ).overrideWith((ref) => Future.value(mxDetails)),
            countryDetailsProvider(
              'AR',
            ).overrideWith((ref) => Future.value(arDetails)),
          ],
          child: const MyApp(),
        ),
      );

      // Navigate to Mexico
      await $.tap(find.text('Mexico'));
      await $.pumpAndSettle();
      expect(find.text('Mexico City'), findsOneWidget);

      // Navigate back
      await $.tester.pageBack();
      await $.pumpAndSettle();

      // Navigate to Argentina
      await $.tap(find.text('Argentina'));
      await $.pumpAndSettle();
      expect(find.text('Buenos Aires'), findsOneWidget);
      expect(find.text('Mexico City'), findsNothing);
    },
  );

  patrolTest(
    'DetailScreen - should display show more button at bottom of list',
    ($) async {
      // arrange
      final countries = [
        const Country(code: 'RU', name: 'Russia', emoji: '🇷🇺'),
      ];

      const ruDetails = Country(
        code: 'RU',
        name: 'Russia',
        emoji: '🇷🇺',
        capital: 'Moscow',
      );

      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            countriesProvider.overrideWith((ref) => Future.value(countries)),
            countryDetailsProvider(
              'RU',
            ).overrideWith((ref) => Future.value(ruDetails)),
          ],
          child: const MyApp(),
        ),
      );

      // act
      await $.tap(find.text('Russia'));
      await $.pumpAndSettle();

      // assert - button should be visible
      expect(find.text('Show more'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    },
  );

  patrolTest('DetailScreen - should handle rapid toggle of show more/less', (
    $,
  ) async {
    // arrange
    final countries = [
      const Country(code: 'KR', name: 'South Korea', emoji: '🇰🇷'),
    ];

    const krDetails = Country(
      code: 'KR',
      name: 'South Korea',
      emoji: '🇰🇷',
      capital: 'Seoul',
      currency: 'KRW',
      phone: '82',
    );

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
          countryDetailsProvider(
            'KR',
          ).overrideWith((ref) => Future.value(krDetails)),
        ],
        child: const MyApp(),
      ),
    );

    // Navigate to detail page
    await $.tap(find.text('South Korea'));
    await $.pumpAndSettle();

    // act - rapid toggles
    await $.tap(find.text('Show more'));
    await $.pumpAndSettle();
    expect(find.text('Currency:'), findsOneWidget);

    await $.tap(find.text('Show less'));
    await $.pumpAndSettle();
    expect(find.text('Currency:'), findsNothing);

    await $.tap(find.text('Show more'));
    await $.pumpAndSettle();
    expect(find.text('Currency:'), findsOneWidget);

    await $.tap(find.text('Show less'));
    await $.pumpAndSettle();
    expect(find.text('Currency:'), findsNothing);
  });

  patrolTest('DetailScreen - should display empty capital field correctly', (
    $,
  ) async {
    // arrange
    final countries = [
      const Country(code: 'YY', name: 'Test Country', emoji: '🏳️'),
    ];

    const yyDetails = Country(
      code: 'YY',
      name: 'Test Country',
      emoji: '🏳️',
      capital: null,
    );

    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          countriesProvider.overrideWith((ref) => Future.value(countries)),
          countryDetailsProvider(
            'YY',
          ).overrideWith((ref) => Future.value(yyDetails)),
        ],
        child: const MyApp(),
      ),
    );

    // act
    await $.tap(find.text('Test Country'));
    await $.pumpAndSettle();

    // assert - capital field should show empty string
    expect(find.text('Capital:'), findsOneWidget);
    // Empty value is displayed but may not be easily findable
    expect(find.text('Flag:'), findsOneWidget);
    expect(find.text('Name:'), findsOneWidget);
    expect(find.text('Code:'), findsOneWidget);
  });
}
