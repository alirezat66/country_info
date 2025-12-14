import 'dart:async';

import 'package:country_info/core/presentation/views/error_view.dart';
import 'package:country_info/core/presentation/views/loading_view.dart';
import 'package:country_info/core/presentation/widgets/hero_text.dart';
import 'package:country_info/features/country/domain/entities/continent.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/domain/entities/language.dart';
import 'package:country_info/features/country/presentation/providers/country_providers.dart';
import 'package:country_info/features/country/presentation/providers/show_more_provider.dart';
import 'package:country_info/features/country/presentation/views/country_detail/detail_screen.dart';
import 'package:country_info/features/country/presentation/views/country_detail/views/detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DetailScreen', () {
    testWidgets('should display LoadingView while loading', (tester) async {
      // arrange
      final completer = Completer<Country>();

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider(
              'US',
            ).overrideWith((ref) => completer.future),
          ],
          child: const MaterialApp(home: DetailScreen(countryCode: 'US')),
        ),
      );

      // Pump once to build the widget tree but don't wait for futures
      await tester.pump();

      // assert
      expect(find.byType(LoadingView), findsOneWidget);
      expect(find.byType(DetailView), findsNothing);
      expect(find.byType(ErrorView), findsNothing);

      // Clean up - complete the future to avoid timer pending error
      completer.complete(
        const Country(code: 'US', name: 'United States', emoji: '🇺🇸'),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('should display DetailView when data is loaded', (
      tester,
    ) async {
      // arrange
      const country = Country(
        code: 'US',
        name: 'United States',
        emoji: '🇺🇸',
        capital: 'Washington, D.C.',
      );

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider(
              'US',
            ).overrideWith((ref) => Future.value(country)),
          ],
          child: const MaterialApp(home: DetailScreen(countryCode: 'US')),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(DetailView), findsOneWidget);
      expect(find.byType(LoadingView), findsNothing);
      expect(find.byType(ErrorView), findsNothing);
    });

    testWidgets('should display ErrorView on error', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider('INVALID').overrideWith(
              (ref) => Future.error(Exception('Country not found')),
            ),
          ],
          child: const MaterialApp(home: DetailScreen(countryCode: 'INVALID')),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.byType(DetailView), findsNothing);
      expect(find.byType(LoadingView), findsNothing);
    });

    testWidgets('should display country name in AppBar', (tester) async {
      // arrange
      const country = Country(code: 'FR', name: 'France', emoji: '🇫🇷');

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider(
              'FR',
            ).overrideWith((ref) => Future.value(country)),
          ],
          child: const MaterialApp(
            home: DetailScreen(countryCode: 'FR', countryName: 'France'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AppBar), findsOneWidget);
      // Find HeroText specifically in the AppBar
      final appBarFinder = find.byType(AppBar);
      final heroTextInAppBar = find.descendant(
        of: appBarFinder,
        matching: find.byType(HeroText),
      );
      expect(heroTextInAppBar, findsOneWidget);

      final heroText = tester.widget<HeroText>(heroTextInAppBar);
      expect(heroText.text, 'France');
    });

    testWidgets('should display HeroText with correct tag', (tester) async {
      // arrange
      const country = Country(
        code: 'GB',
        name: 'United Kingdom',
        emoji: '🇬🇧',
      );

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider(
              'GB',
            ).overrideWith((ref) => Future.value(country)),
          ],
          child: const MaterialApp(
            home: DetailScreen(
              countryCode: 'GB',
              countryName: 'United Kingdom',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      final heroText = tester.widget<HeroText>(find.byType(HeroText));
      expect(heroText.tag, 'name_GB');
      expect(heroText.text, 'United Kingdom');
    });

    testWidgets(
      'should display empty string in HeroText when countryName is null',
      (tester) async {
        // arrange
        const country = Country(code: 'DE', name: 'Germany', emoji: '🇩🇪');

        // act
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              countryDetailsProvider(
                'DE',
              ).overrideWith((ref) => Future.value(country)),
            ],
            child: const MaterialApp(home: DetailScreen(countryCode: 'DE')),
          ),
        );

        await tester.pumpAndSettle();

        // assert
        final heroText = tester.widget<HeroText>(find.byType(HeroText));
        expect(heroText.text, '');
      },
    );

    testWidgets('should show basic fields when showMore is false', (
      tester,
    ) async {
      // arrange
      const country = Country(
        code: 'IT',
        name: 'Italy',
        emoji: '🇮🇹',
        capital: 'Rome',
        currency: 'EUR',
        phone: '39',
      );

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider(
              'IT',
            ).overrideWith((ref) => Future.value(country)),
          ],
          child: const MaterialApp(home: DetailScreen(countryCode: 'IT')),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.text('Flag:'), findsOneWidget);
      expect(find.text('Name:'), findsOneWidget);
      expect(find.text('Code:'), findsOneWidget);
      expect(find.text('Capital:'), findsOneWidget);
      expect(find.text('Currency:'), findsNothing); // Not shown in basic fields
    });

    testWidgets('should show extended fields when showMore is true', (
      tester,
    ) async {
      // arrange
      const country = Country(
        code: 'ES',
        name: 'Spain',
        emoji: '🇪🇸',
        capital: 'Madrid',
        currency: 'EUR',
        phone: '34',
        continent: Continent(code: 'EU', name: 'Europe'),
        languages: [Language(code: 'es', name: 'Spanish')],
      );

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider(
              'ES',
            ).overrideWith((ref) => Future.value(country)),
          ],
          child: const MaterialApp(home: DetailScreen(countryCode: 'ES')),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the show more button
      await tester.tap(find.text('Show more'));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Currency:'), findsOneWidget);
      expect(find.text('Phone:'), findsOneWidget);
      expect(find.text('Continent Code:'), findsOneWidget);
      expect(find.text('Languages:'), findsOneWidget);
    });

    testWidgets('should toggle button text when tapped', (tester) async {
      // arrange
      const country = Country(
        code: 'CA',
        name: 'Canada',
        emoji: '🇨🇦',
        capital: 'Ottawa',
      );

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider(
              'CA',
            ).overrideWith((ref) => Future.value(country)),
          ],
          child: const MaterialApp(home: DetailScreen(countryCode: 'CA')),
        ),
      );

      await tester.pumpAndSettle();

      // assert - initially shows "Show more"
      expect(find.text('Show more'), findsOneWidget);
      expect(find.text('Show less'), findsNothing);

      // act - tap button
      await tester.tap(find.text('Show more'));
      await tester.pumpAndSettle();

      // assert - now shows "Show less"
      expect(find.text('Show less'), findsOneWidget);
      expect(find.text('Show more'), findsNothing);

      // act - tap button again
      await tester.tap(find.text('Show less'));
      await tester.pumpAndSettle();

      // assert - back to "Show more"
      expect(find.text('Show more'), findsOneWidget);
      expect(find.text('Show less'), findsNothing);
    });

    testWidgets('should display error message in ErrorView', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider('XX').overrideWith(
              (ref) => Future.error(Exception('Test error message')),
            ),
          ],
          child: const MaterialApp(home: DetailScreen(countryCode: 'XX')),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.textContaining('Test error message'), findsOneWidget);
    });

    testWidgets('should have retry button in ErrorView', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider(
              'XX',
            ).overrideWith((ref) => Future.error(Exception('Error'))),
          ],
          child: const MaterialApp(home: DetailScreen(countryCode: 'XX')),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(ErrorView), findsOneWidget);
      final errorView = tester.widget<ErrorView>(find.byType(ErrorView));
      expect(errorView.onRetry, isNotNull);
    });

    testWidgets('should display country with multiple languages', (
      tester,
    ) async {
      // arrange
      const country = Country(
        code: 'BE',
        name: 'Belgium',
        emoji: '🇧🇪',
        languages: [
          Language(code: 'nl', name: 'Dutch'),
          Language(code: 'fr', name: 'French'),
          Language(code: 'de', name: 'German'),
        ],
      );

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider(
              'BE',
            ).overrideWith((ref) => Future.value(country)),
          ],
          child: const MaterialApp(home: DetailScreen(countryCode: 'BE')),
        ),
      );

      await tester.pumpAndSettle();

      // Tap show more to see languages
      await tester.tap(find.text('Show more'));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Dutch, French, German'), findsOneWidget);
    });

    testWidgets('should display continent information when present', (
      tester,
    ) async {
      // arrange
      const country = Country(
        code: 'BR',
        name: 'Brazil',
        emoji: '🇧🇷',
        continent: Continent(code: 'SA', name: 'South America'),
      );

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider(
              'BR',
            ).overrideWith((ref) => Future.value(country)),
          ],
          child: const MaterialApp(home: DetailScreen(countryCode: 'BR')),
        ),
      );

      await tester.pumpAndSettle();

      // Tap show more to see continent
      await tester.tap(find.text('Show more'));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('SA'), findsOneWidget);
      expect(find.text('South America'), findsOneWidget);
    });

    testWidgets('should have Scaffold with AppBar and body', (tester) async {
      // arrange
      const country = Country(code: 'JP', name: 'Japan', emoji: '🇯🇵');

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider(
              'JP',
            ).overrideWith((ref) => Future.value(country)),
          ],
          child: const MaterialApp(home: DetailScreen(countryCode: 'JP')),
        ),
      );

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should handle country with null optional fields', (
      tester,
    ) async {
      // arrange
      const country = Country(code: 'XX', name: 'Test Country', emoji: '🏳️');

      // act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            countryDetailsProvider(
              'XX',
            ).overrideWith((ref) => Future.value(country)),
          ],
          child: const MaterialApp(home: DetailScreen(countryCode: 'XX')),
        ),
      );

      await tester.pumpAndSettle();

      // assert - should display basic fields without error
      expect(find.byType(DetailView), findsOneWidget);
      expect(find.text('🏳️'), findsOneWidget);
      expect(find.text('Test Country'), findsOneWidget);
    });
  });
}
