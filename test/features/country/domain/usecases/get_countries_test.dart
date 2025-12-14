import 'package:country_info/core/domain/failure.dart';
import 'package:country_info/core/domain/result.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/domain/repository/country_repository.dart';
import 'package:country_info/features/country/domain/usecases/get_countries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'get_countries_test.mocks.dart';

@GenerateMocks([CountryRepository])
void main() {
  // Provide dummy values for Result type
  provideDummy<Result<List<Country>>>(Result.success([]));
  late GetCountries useCase;
  late MockCountryRepository mockRepository;

  setUp(() {
    mockRepository = MockCountryRepository();
    useCase = GetCountries(mockRepository);
  });

  group('GetCountries', () {
    test('should return success with list of countries when repository succeeds',
        () async {
      // arrange
      final countries = [
        const Country(code: 'US', name: 'United States', emoji: '🇺🇸'),
        const Country(code: 'CA', name: 'Canada', emoji: '🇨🇦'),
      ];

      when(mockRepository.getCountries())
          .thenAnswer((_) async => Result.success(countries));

      // act
      final result = await useCase();

      // assert
      expect(result, isA<Success<List<Country>>>());
      result.fold(
        (failure) => fail('Expected success'),
        (value) {
          expect(value.length, 2);
          expect(value[0].code, 'US');
          expect(value[1].code, 'CA');
        },
      );
      verify(mockRepository.getCountries()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository returns failure', () async {
      // arrange
      final failure = ServerFailure('Server error', code: 'ERROR_CODE');

      when(mockRepository.getCountries())
          .thenAnswer((_) async => Result.failure(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, isA<FailureResult<List<Country>>>());
      result.fold(
        (f) {
          expect(f, isA<ServerFailure>());
          expect(f.message, 'Server error');
          expect(f.code, 'ERROR_CODE');
        },
        (value) => fail('Expected failure'),
      );
      verify(mockRepository.getCountries()).called(1);
    });

    test('should return success with empty list when repository returns empty',
        () async {
      // arrange
      when(mockRepository.getCountries())
          .thenAnswer((_) async => Result.success([]));

      // act
      final result = await useCase();

      // assert
      expect(result, isA<Success<List<Country>>>());
      result.fold(
        (failure) => fail('Expected success'),
        (countries) => expect(countries.isEmpty, true),
      );
    });

    test('should be callable as function', () async {
      // arrange
      final countries = [
        const Country(code: 'GB', name: 'United Kingdom', emoji: '🇬🇧'),
      ];

      when(mockRepository.getCountries())
          .thenAnswer((_) async => Result.success(countries));

      // act
      final result = await useCase();

      // assert
      expect(result, isA<Success<List<Country>>>());
    });

    test('should handle multiple countries correctly', () async {
      // arrange
      final countries = [
        const Country(code: 'FR', name: 'France', emoji: '🇫🇷'),
        const Country(code: 'DE', name: 'Germany', emoji: '🇩🇪'),
        const Country(code: 'IT', name: 'Italy', emoji: '🇮🇹'),
      ];

      when(mockRepository.getCountries())
          .thenAnswer((_) async => Result.success(countries));

      // act
      final result = await useCase();

      // assert
      result.fold(
        (failure) => fail('Expected success'),
        (value) {
          expect(value.length, 3);
          expect(value[0].code, 'FR');
          expect(value[1].code, 'DE');
          expect(value[2].code, 'IT');
        },
      );
    });

    test('should propagate NetworkFailure from repository', () async {
      // arrange
      final failure = NetworkFailure('Network error', code: 'NETWORK_ERROR');

      when(mockRepository.getCountries())
          .thenAnswer((_) async => Result.failure(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, isA<FailureResult<List<Country>>>());
      result.fold(
        (f) {
          expect(f, isA<NetworkFailure>());
          expect(f.message, 'Network error');
        },
        (value) => fail('Expected failure'),
      );
    });
  });
}

