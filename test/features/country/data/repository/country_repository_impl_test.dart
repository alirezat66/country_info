import 'package:country_info/core/data/error/app_exception.dart';
import 'package:country_info/core/domain/failure.dart';
import 'package:country_info/core/domain/result.dart';
import 'package:country_info/features/country/data/datasource/country_datasource.dart';
import 'package:country_info/features/country/data/models/continent_model.dart';
import 'package:country_info/features/country/data/models/country_model.dart';
import 'package:country_info/features/country/data/models/language_model.dart';
import 'package:country_info/features/country/data/repository/country_repository_impl.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'country_repository_impl_test.mocks.dart';

@GenerateMocks([CountryDataSource])
void main() {
  late CountryRepositoryImpl repository;
  late MockCountryDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockCountryDataSource();
    repository = CountryRepositoryImpl(remoteDataSource: mockDataSource);
  });

  tearDown(() {
    reset(mockDataSource);
  });

  group('CountryRepositoryImpl - getCountries', () {
    test(
      'should return success with list of countries when data source succeeds',
      () async {
        // arrange
        final countryModels = [
          const CountryModel(code: 'US', name: 'United States', emoji: '🇺🇸'),
          const CountryModel(code: 'CA', name: 'Canada', emoji: '🇨🇦'),
        ];

        when(
          mockDataSource.getCountries(),
        ).thenAnswer((_) async => countryModels);

        // act
        final result = await repository.getCountries();

        // assert
        expect(result, isA<Success<List<Country>>>());
        result.fold((failure) => fail('Expected success'), (countries) {
          expect(countries.length, 2);
          expect(countries[0].code, 'US');
          expect(countries[0].name, 'United States');
          expect(countries[0].emoji, '🇺🇸');
          expect(countries[1].code, 'CA');
          expect(countries[1].name, 'Canada');
          expect(countries[1].emoji, '🇨🇦');
        });
        verify(mockDataSource.getCountries()).called(1);
      },
    );

    test(
      'should return success with empty list when data source returns empty',
      () async {
        // arrange
        when(mockDataSource.getCountries()).thenAnswer((_) async => []);

        // act
        final result = await repository.getCountries();

        // assert
        expect(result, isA<Success<List<Country>>>());
        result.fold(
          (failure) => fail('Expected success'),
          (countries) => expect(countries.isEmpty, true),
        );
      },
    );

    test(
      'should return failure with ServerFailure when ServerException occurs',
      () async {
        // arrange
        final exception = ServerException(
          message: 'Server error occurred',
          code: 'SERVER_ERROR',
        );

        when(mockDataSource.getCountries()).thenThrow(exception);

        // act
        final result = await repository.getCountries();

        // assert
        expect(result, isA<FailureResult<List<Country>>>());
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server error occurred');
          expect(failure.code, 'SERVER_ERROR');
        }, (countries) => fail('Expected failure'));
        verify(mockDataSource.getCountries()).called(1);
      },
    );

    test(
      'should return failure with ServerFailure when unexpected error occurs',
      () async {
        // arrange
        when(
          mockDataSource.getCountries(),
        ).thenThrow(Exception('Unexpected error'));

        // act
        final result = await repository.getCountries();

        // assert
        expect(result, isA<FailureResult<List<Country>>>());
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Unexpected error'));
        }, (countries) => fail('Expected failure'));
      },
    );

    test('should convert CountryModel to Country entity correctly', () async {
      // arrange
      final countryModels = [
        const CountryModel(code: 'GB', name: 'United Kingdom', emoji: '🇬🇧'),
      ];

      when(
        mockDataSource.getCountries(),
      ).thenAnswer((_) async => countryModels);

      // act
      final result = await repository.getCountries();

      // assert
      result.fold((failure) => fail('Expected success'), (countries) {
        expect(countries.length, 1);
        final country = countries.first;
        expect(country, isA<Country>());
        expect(country.code, 'GB');
        expect(country.name, 'United Kingdom');
        expect(country.emoji, '🇬🇧');
      });
    });

    test('should handle multiple countries correctly', () async {
      // arrange
      final countryModels = [
        const CountryModel(code: 'FR', name: 'France', emoji: '🇫🇷'),
        const CountryModel(code: 'DE', name: 'Germany', emoji: '🇩🇪'),
        const CountryModel(code: 'IT', name: 'Italy', emoji: '🇮🇹'),
        const CountryModel(code: 'ES', name: 'Spain', emoji: '🇪🇸'),
      ];

      when(
        mockDataSource.getCountries(),
      ).thenAnswer((_) async => countryModels);

      // act
      final result = await repository.getCountries();

      // assert
      result.fold((failure) => fail('Expected success'), (countries) {
        expect(countries.length, 4);
        expect(countries[0].code, 'FR');
        expect(countries[1].code, 'DE');
        expect(countries[2].code, 'IT');
        expect(countries[3].code, 'ES');
      });
    });
  });

  group('CountryRepositoryImpl - getCountryDetails', () {
    test(
      'should return success with country when data source succeeds',
      () async {
        // arrange
        const countryModel = CountryModel(
          code: 'US',
          name: 'United States',
          emoji: '🇺🇸',
          capital: 'Washington, D.C.',
          currency: 'USD',
          phone: '1',
        );

        when(
          mockDataSource.getCountryDetails('US'),
        ).thenAnswer((_) async => countryModel);

        // act
        final result = await repository.getCountryDetails('US');

        // assert
        expect(result, isA<Success<Country>>());
        result.fold((failure) => fail('Expected success'), (country) {
          expect(country.code, 'US');
          expect(country.name, 'United States');
          expect(country.emoji, '🇺🇸');
          expect(country.capital, 'Washington, D.C.');
          expect(country.currency, 'USD');
          expect(country.phone, '1');
        });
        verify(mockDataSource.getCountryDetails('US')).called(1);
      },
    );

    test(
      'should return success with complete country data including nested objects',
      () async {
        // arrange
        const countryModel = CountryModel(
          code: 'FR',
          name: 'France',
          emoji: '🇫🇷',
          capital: 'Paris',
          currency: 'EUR',
          phone: '33',
          continent: ContinentModel(code: 'EU', name: 'Europe'),
          languages: [
            LanguageModel(
              code: 'fr',
              name: 'French',
              native: 'Français',
              rtl: false,
            ),
          ],
        );

        when(
          mockDataSource.getCountryDetails('FR'),
        ).thenAnswer((_) async => countryModel);

        // act
        final result = await repository.getCountryDetails('FR');

        // assert
        expect(result, isA<Success<Country>>());
        result.fold((failure) => fail('Expected success'), (country) {
          expect(country.code, 'FR');
          expect(country.name, 'France');
          expect(country.capital, 'Paris');
          expect(country.currency, 'EUR');
          expect(country.phone, '33');
          expect(country.continent, isNotNull);
          expect(country.continent?.code, 'EU');
          expect(country.continent?.name, 'Europe');
          expect(country.languages.length, 1);
          expect(country.languages[0].code, 'fr');
          expect(country.languages[0].name, 'French');
          expect(country.languages[0].native, 'Français');
          expect(country.languages[0].rtl, false);
        });
      },
    );

    test(
      'should return success with country with multiple languages',
      () async {
        // arrange
        const countryModel = CountryModel(
          code: 'BE',
          name: 'Belgium',
          emoji: '🇧🇪',
          languages: [
            LanguageModel(code: 'nl', name: 'Dutch'),
            LanguageModel(code: 'fr', name: 'French'),
            LanguageModel(code: 'de', name: 'German'),
          ],
        );

        when(
          mockDataSource.getCountryDetails('BE'),
        ).thenAnswer((_) async => countryModel);

        // act
        final result = await repository.getCountryDetails('BE');

        // assert
        result.fold((failure) => fail('Expected success'), (country) {
          expect(country.languages.length, 3);
          expect(country.languages[0].name, 'Dutch');
          expect(country.languages[1].name, 'French');
          expect(country.languages[2].name, 'German');
        });
      },
    );

    test(
      'should return failure with ServerFailure when ServerException occurs',
      () async {
        // arrange
        final exception = ServerException(
          message: 'Country not found',
          code: 'NOT_FOUND',
        );

        when(mockDataSource.getCountryDetails('INVALID')).thenThrow(exception);

        // act
        final result = await repository.getCountryDetails('INVALID');

        // assert
        expect(result, isA<FailureResult<Country>>());
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Country not found');
        }, (country) => fail('Expected failure'));
        verify(mockDataSource.getCountryDetails('INVALID')).called(1);
      },
    );

    test(
      'should return failure with ServerFailure when unexpected error occurs',
      () async {
        // arrange
        when(
          mockDataSource.getCountryDetails('US'),
        ).thenThrow(Exception('Unexpected error'));

        // act
        final result = await repository.getCountryDetails('US');

        // assert
        expect(result, isA<FailureResult<Country>>());
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Unexpected error'));
        }, (country) => fail('Expected failure'));
      },
    );

    test('should convert CountryModel to Country entity correctly', () async {
      // arrange
      const countryModel = CountryModel(
        code: 'GB',
        name: 'United Kingdom',
        emoji: '🇬🇧',
        capital: 'London',
        currency: 'GBP',
        phone: '44',
        continent: ContinentModel(code: 'EU', name: 'Europe'),
        languages: [LanguageModel(code: 'en', name: 'English')],
      );

      when(
        mockDataSource.getCountryDetails('GB'),
      ).thenAnswer((_) async => countryModel);

      // act
      final result = await repository.getCountryDetails('GB');

      // assert
      result.fold((failure) => fail('Expected success'), (country) {
        expect(country, isA<Country>());
        expect(country.code, countryModel.code);
        expect(country.name, countryModel.name);
        expect(country.emoji, countryModel.emoji);
        expect(country.capital, countryModel.capital);
        expect(country.currency, countryModel.currency);
        expect(country.phone, countryModel.phone);
        expect(country.continent?.code, countryModel.continent?.code);
        expect(country.languages.length, countryModel.languages.length);
      });
    });

    test('should handle country with null optional fields', () async {
      // arrange
      const countryModel = CountryModel(
        code: 'XX',
        name: 'Test Country',
        emoji: '🏳️',
      );

      when(
        mockDataSource.getCountryDetails('XX'),
      ).thenAnswer((_) async => countryModel);

      // act
      final result = await repository.getCountryDetails('XX');

      // assert
      result.fold((failure) => fail('Expected success'), (country) {
        expect(country.capital, null);
        expect(country.currency, null);
        expect(country.phone, null);
        expect(country.continent, null);
        expect(country.languages, isEmpty);
      });
    });

    test('should pass correct code parameter to data source', () async {
      // arrange
      const countryModel = CountryModel(
        code: 'CA',
        name: 'Canada',
        emoji: '🇨🇦',
      );

      when(
        mockDataSource.getCountryDetails('CA'),
      ).thenAnswer((_) async => countryModel);

      // act
      await repository.getCountryDetails('CA');

      // assert
      verify(mockDataSource.getCountryDetails('CA')).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should handle ServerException without code', () async {
      // arrange
      final exception = ServerException(message: 'Server error');

      when(mockDataSource.getCountryDetails('US')).thenThrow(exception);

      // act
      final result = await repository.getCountryDetails('US');

      // assert
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Server error');
      }, (country) => fail('Expected failure'));
    });

    test('should handle country with continent but no languages', () async {
      // arrange
      const countryModel = CountryModel(
        code: 'IT',
        name: 'Italy',
        emoji: '🇮🇹',
        continent: ContinentModel(code: 'EU', name: 'Europe'),
        languages: [],
      );

      when(
        mockDataSource.getCountryDetails('IT'),
      ).thenAnswer((_) async => countryModel);

      // act
      final result = await repository.getCountryDetails('IT');

      // assert
      result.fold((failure) => fail('Expected success'), (country) {
        expect(country.continent, isNotNull);
        expect(country.languages, isEmpty);
      });
    });
  });
}
