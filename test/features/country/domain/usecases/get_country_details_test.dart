import 'package:country_info/core/domain/failure.dart';
import 'package:country_info/core/domain/result.dart';
import 'package:country_info/features/country/domain/entities/continent.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/domain/entities/language.dart';
import 'package:country_info/features/country/domain/repository/country_repository.dart';
import 'package:country_info/features/country/domain/usecases/get_country_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'get_country_details_test.mocks.dart';

@GenerateMocks([CountryRepository])
void main() {
  // Provide dummy values for Result type
  provideDummy<Result<Country>>(
    Result.success(const Country(code: '', name: '', emoji: '')),
  );

  late GetCountryDetails useCase;
  late MockCountryRepository mockRepository;

  setUp(() {
    mockRepository = MockCountryRepository();
    useCase = GetCountryDetails(mockRepository);
  });

  group('GetCountryDetails', () {
    test(
      'should return success with country when repository succeeds',
      () async {
        // arrange
        const country = Country(
          code: 'US',
          name: 'United States',
          emoji: '🇺🇸',
          capital: 'Washington, D.C.',
        );

        when(
          mockRepository.getCountryDetails('US'),
        ).thenAnswer((_) async => Result.success(country));

        // act
        final result = await useCase('US');

        // assert
        expect(result, isA<Success<Country>>());
        result.fold((failure) => fail('Expected success'), (value) {
          expect(value.code, 'US');
          expect(value.name, 'United States');
          expect(value.emoji, '🇺🇸');
          expect(value.capital, 'Washington, D.C.');
        });
        verify(mockRepository.getCountryDetails('US')).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return success with complete country data', () async {
      // arrange
      const country = Country(
        code: 'FR',
        name: 'France',
        emoji: '🇫🇷',
        capital: 'Paris',
        currency: 'EUR',
        phone: '33',
        continent: Continent(code: 'EU', name: 'Europe'),
        languages: [
          Language(code: 'fr', name: 'French', native: 'Français', rtl: false),
        ],
      );

      when(
        mockRepository.getCountryDetails('FR'),
      ).thenAnswer((_) async => Result.success(country));

      // act
      final result = await useCase('FR');

      // assert
      expect(result, isA<Success<Country>>());
      result.fold((failure) => fail('Expected success'), (value) {
        expect(value.code, 'FR');
        expect(value.capital, 'Paris');
        expect(value.currency, 'EUR');
        expect(value.phone, '33');
        expect(value.continent?.code, 'EU');
        expect(value.languages.length, 1);
        expect(value.languages[0].name, 'French');
      });
    });

    test('should return failure when repository returns failure', () async {
      // arrange
      final failure = ServerFailure('Country not found', code: 'NOT_FOUND');

      when(
        mockRepository.getCountryDetails('INVALID'),
      ).thenAnswer((_) async => Result.failure(failure));

      // act
      final result = await useCase('INVALID');

      // assert
      expect(result, isA<FailureResult<Country>>());
      result.fold((f) {
        expect(f, isA<ServerFailure>());
        expect(f.message, 'Country not found');
        expect(f.code, 'NOT_FOUND');
      }, (value) => fail('Expected failure'));
      verify(mockRepository.getCountryDetails('INVALID')).called(1);
    });

    test('should propagate ServerFailure from repository', () async {
      // arrange
      final failure = ServerFailure('Server error', code: 'SERVER_ERROR');

      when(
        mockRepository.getCountryDetails('US'),
      ).thenAnswer((_) async => Result.failure(failure));

      // act
      final result = await useCase('US');

      // assert
      expect(result, isA<FailureResult<Country>>());
      result.fold((f) {
        expect(f, isA<ServerFailure>());
        expect(f.message, 'Server error');
        expect(f.code, 'SERVER_ERROR');
      }, (value) => fail('Expected failure'));
    });

    test('should propagate NetworkFailure from repository', () async {
      // arrange
      final failure = NetworkFailure('Network error', code: 'NETWORK_ERROR');

      when(
        mockRepository.getCountryDetails('CA'),
      ).thenAnswer((_) async => Result.failure(failure));

      // act
      final result = await useCase('CA');

      // assert
      expect(result, isA<FailureResult<Country>>());
      result.fold((f) {
        expect(f, isA<NetworkFailure>());
        expect(f.message, 'Network error');
      }, (value) => fail('Expected failure'));
    });

    test('should be callable as function', () async {
      // arrange
      const country = Country(
        code: 'GB',
        name: 'United Kingdom',
        emoji: '🇬🇧',
      );

      when(
        mockRepository.getCountryDetails('GB'),
      ).thenAnswer((_) async => Result.success(country));

      // act
      final result = await useCase('GB');

      // assert
      expect(result, isA<Success<Country>>());
    });

    test('should pass correct country code to repository', () async {
      // arrange
      const country = Country(code: 'DE', name: 'Germany', emoji: '🇩🇪');

      when(
        mockRepository.getCountryDetails('DE'),
      ).thenAnswer((_) async => Result.success(country));

      // act
      await useCase('DE');

      // assert
      verify(mockRepository.getCountryDetails('DE')).called(1);
    });

    test('should handle country with multiple languages', () async {
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

      when(
        mockRepository.getCountryDetails('BE'),
      ).thenAnswer((_) async => Result.success(country));

      // act
      final result = await useCase('BE');

      // assert
      result.fold((failure) => fail('Expected success'), (value) {
        expect(value.languages.length, 3);
        expect(value.languages[0].name, 'Dutch');
        expect(value.languages[1].name, 'French');
        expect(value.languages[2].name, 'German');
      });
    });

    test('should handle country with null optional fields', () async {
      // arrange
      const country = Country(code: 'XX', name: 'Test Country', emoji: '🏳️');

      when(
        mockRepository.getCountryDetails('XX'),
      ).thenAnswer((_) async => Result.success(country));

      // act
      final result = await useCase('XX');

      // assert
      result.fold((failure) => fail('Expected success'), (value) {
        expect(value.capital, null);
        expect(value.currency, null);
        expect(value.phone, null);
        expect(value.continent, null);
        expect(value.languages, isEmpty);
      });
    });

    test('should handle different country codes', () async {
      // arrange
      const countries = [
        Country(code: 'IT', name: 'Italy', emoji: '🇮🇹'),
        Country(code: 'ES', name: 'Spain', emoji: '🇪🇸'),
        Country(code: 'JP', name: 'Japan', emoji: '🇯🇵'),
      ];

      for (final country in countries) {
        when(
          mockRepository.getCountryDetails(country.code),
        ).thenAnswer((_) async => Result.success(country));
      }

      // act & assert
      for (final country in countries) {
        final result = await useCase(country.code);
        result.fold(
          (failure) => fail('Expected success'),
          (value) => expect(value.code, country.code),
        );
      }
    });

    test('should handle country with continent but no languages', () async {
      // arrange
      const country = Country(
        code: 'IT',
        name: 'Italy',
        emoji: '🇮🇹',
        continent: Continent(code: 'EU', name: 'Europe'),
        languages: [],
      );

      when(
        mockRepository.getCountryDetails('IT'),
      ).thenAnswer((_) async => Result.success(country));

      // act
      final result = await useCase('IT');

      // assert
      result.fold((failure) => fail('Expected success'), (value) {
        expect(value.continent, isNotNull);
        expect(value.languages, isEmpty);
      });
    });

    test('should handle language with rtl property', () async {
      // arrange
      const country = Country(
        code: 'SA',
        name: 'Saudi Arabia',
        emoji: '🇸🇦',
        languages: [
          Language(code: 'ar', name: 'Arabic', native: 'العربية', rtl: true),
        ],
      );

      when(
        mockRepository.getCountryDetails('SA'),
      ).thenAnswer((_) async => Result.success(country));

      // act
      final result = await useCase('SA');

      // assert
      result.fold((failure) => fail('Expected success'), (value) {
        expect(value.languages[0].rtl, true);
        expect(value.languages[0].native, 'العربية');
      });
    });
  });
}
