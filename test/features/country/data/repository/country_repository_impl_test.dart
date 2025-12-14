import 'package:country_info/core/data/error/app_exception.dart';
import 'package:country_info/core/domain/failure.dart';
import 'package:country_info/core/domain/result.dart';
import 'package:country_info/features/country/data/datasource/country_datasource.dart';
import 'package:country_info/features/country/data/models/country_model.dart';
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

  group('CountryRepositoryImpl - getCountries', () {
    test('should return success with list of countries when data source succeeds',
        () async {
      // arrange
      final countryModels = [
        const CountryModel(
          code: 'US',
          name: 'United States',
          emoji: '🇺🇸',
        ),
        const CountryModel(
          code: 'CA',
          name: 'Canada',
          emoji: '🇨🇦',
        ),
      ];

      when(mockDataSource.getCountries())
          .thenAnswer((_) async => countryModels);

      // act
      final result = await repository.getCountries();

      // assert
      expect(result, isA<Success<List<Country>>>());
      result.fold(
        (failure) => fail('Expected success'),
        (countries) {
          expect(countries.length, 2);
          expect(countries[0].code, 'US');
          expect(countries[0].name, 'United States');
          expect(countries[0].emoji, '🇺🇸');
          expect(countries[1].code, 'CA');
          expect(countries[1].name, 'Canada');
          expect(countries[1].emoji, '🇨🇦');
        },
      );
      verify(mockDataSource.getCountries()).called(1);
    });

    test('should return success with empty list when data source returns empty',
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
    });

    test('should return failure with ServerFailure when ServerException occurs',
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
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server error occurred');
          expect(failure.code, 'SERVER_ERROR');
        },
        (countries) => fail('Expected failure'),
      );
      verify(mockDataSource.getCountries()).called(1);
    });

    test('should return failure with ServerFailure when unexpected error occurs',
        () async {
      // arrange
      when(mockDataSource.getCountries())
          .thenThrow(Exception('Unexpected error'));

      // act
      final result = await repository.getCountries();

      // assert
      expect(result, isA<FailureResult<List<Country>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Unexpected error'));
        },
        (countries) => fail('Expected failure'),
      );
    });

    test('should convert CountryModel to Country entity correctly', () async {
      // arrange
      final countryModels = [
        const CountryModel(
          code: 'GB',
          name: 'United Kingdom',
          emoji: '🇬🇧',
        ),
      ];

      when(mockDataSource.getCountries())
          .thenAnswer((_) async => countryModels);

      // act
      final result = await repository.getCountries();

      // assert
      result.fold(
        (failure) => fail('Expected success'),
        (countries) {
          expect(countries.length, 1);
          final country = countries.first;
          expect(country, isA<Country>());
          expect(country.code, 'GB');
          expect(country.name, 'United Kingdom');
          expect(country.emoji, '🇬🇧');
        },
      );
    });

    test('should handle multiple countries correctly', () async {
      // arrange
      final countryModels = [
        const CountryModel(code: 'FR', name: 'France', emoji: '🇫🇷'),
        const CountryModel(code: 'DE', name: 'Germany', emoji: '🇩🇪'),
        const CountryModel(code: 'IT', name: 'Italy', emoji: '🇮🇹'),
        const CountryModel(code: 'ES', name: 'Spain', emoji: '🇪🇸'),
      ];

      when(mockDataSource.getCountries())
          .thenAnswer((_) async => countryModels);

      // act
      final result = await repository.getCountries();

      // assert
      result.fold(
        (failure) => fail('Expected success'),
        (countries) {
          expect(countries.length, 4);
          expect(countries[0].code, 'FR');
          expect(countries[1].code, 'DE');
          expect(countries[2].code, 'IT');
          expect(countries[3].code, 'ES');
        },
      );
    });
  });
}

