import 'package:country_info/core/data/error/app_exception.dart';
import 'package:country_info/core/data/network/api/graphql_api_client.dart';
import 'package:country_info/core/data/network/api/graphql_error.dart';
import 'package:country_info/core/data/network/api/graphql_query_result.dart';
import 'package:country_info/features/country/data/datasource/country_remote_datasource.dart';
import 'package:country_info/features/country/data/models/country_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'country_remote_datasource_test.mocks.dart';

@GenerateMocks([GraphQLApiClient])
void main() {
  late CountryRemoteDataSourceImpl dataSource;
  late MockGraphQLApiClient mockClient;

  setUp(() {
    mockClient = MockGraphQLApiClient();
    dataSource = CountryRemoteDataSourceImpl(client: mockClient);
  });

  group('CountryRemoteDataSourceImpl - getCountries', () {
    test('should return list of CountryModel when query succeeds', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {
          'countries': [
            {'code': 'US', 'name': 'United States', 'emoji': '🇺🇸'},
            {'code': 'CA', 'name': 'Canada', 'emoji': '🇨🇦'},
          ],
        },
        errors: null,
      );

      when(
        mockClient.query(query: anyNamed('query')),
      ).thenAnswer((_) async => queryResult);

      // act
      final result = await dataSource.getCountries();

      // assert
      expect(result, isA<List<CountryModel>>());
      expect(result.length, 2);
      expect(result[0].code, 'US');
      expect(result[0].name, 'United States');
      expect(result[0].emoji, '🇺🇸');
      expect(result[1].code, 'CA');
      expect(result[1].name, 'Canada');
      expect(result[1].emoji, '🇨🇦');
      verify(mockClient.query(query: anyNamed('query'))).called(1);
    });

    test('should throw ServerException when query has errors', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: null,
        errors: [GraphQLError(message: 'GraphQL error', code: 'ERROR_CODE')],
      );

      when(
        mockClient.query(query: anyNamed('query')),
      ).thenAnswer((_) async => queryResult);

      // act & assert
      expect(() => dataSource.getCountries(), throwsA(isA<ServerException>()));
      verify(mockClient.query(query: anyNamed('query'))).called(1);
    });

    test('should throw ServerException when data is empty', () async {
      // arrange
      final queryResult = GraphQLQueryResult(data: {}, errors: null);

      when(
        mockClient.query(query: anyNamed('query')),
      ).thenAnswer((_) async => queryResult);

      // act & assert
      expect(() => dataSource.getCountries(), throwsA(isA<ServerException>()));
    });

    test(
      'should throw ServerException when countries key is missing',
      () async {
        // arrange
        final queryResult = GraphQLQueryResult(
          data: {'otherKey': 'value'},
          errors: null,
        );

        when(
          mockClient.query(query: anyNamed('query')),
        ).thenAnswer((_) async => queryResult);

        // act & assert
        expect(
          () => dataSource.getCountries(),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test('should throw ServerException when countries is null', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {'countries': null},
        errors: null,
      );

      when(
        mockClient.query(query: anyNamed('query')),
      ).thenAnswer((_) async => queryResult);

      // act & assert
      expect(() => dataSource.getCountries(), throwsA(isA<ServerException>()));
    });

    test('should handle empty countries list', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {'countries': []},
        errors: null,
      );

      when(
        mockClient.query(query: anyNamed('query')),
      ).thenAnswer((_) async => queryResult);

      // act
      final result = await dataSource.getCountries();

      // assert
      expect(result, isA<List<CountryModel>>());
      expect(result.isEmpty, true);
    });

    test('should throw ServerException on unexpected error', () async {
      // arrange
      when(
        mockClient.query(query: anyNamed('query')),
      ).thenAnswer((_) async => throw Exception('Network error'));

      // act & assert
      expect(() => dataSource.getCountries(), throwsA(isA<ServerException>()));
      verify(mockClient.query(query: anyNamed('query'))).called(1);
    });

    test('should map JSON data correctly to CountryModel', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {
          'countries': [
            {'code': 'JP', 'name': 'Japan', 'emoji': '🇯🇵'},
          ],
        },
        errors: null,
      );

      when(
        mockClient.query(query: anyNamed('query')),
      ).thenAnswer((_) async => queryResult);

      // act
      final result = await dataSource.getCountries();

      // assert
      expect(result.length, 1);
      final country = result.first;
      expect(country.code, 'JP');
      expect(country.name, 'Japan');
      expect(country.emoji, '🇯🇵');
      expect(country, isA<CountryModel>());
    });
  });

  group('CountryRemoteDataSourceImpl - getCountryDetails', () {
    test(
      'should return CountryModel when query succeeds with full data',
      () async {
        // arrange
        final queryResult = GraphQLQueryResult(
          data: {
            'country': {
              'code': 'US',
              'name': 'United States',
              'emoji': '🇺🇸',
              'capital': 'Washington, D.C.',
              'currency': 'USD',
              'phone': '1',
              'continent': {'code': 'NA', 'name': 'North America'},
              'languages': [
                {
                  'code': 'en',
                  'name': 'English',
                  'native': 'English',
                  'rtl': false,
                },
              ],
            },
          },
          errors: null,
        );

        when(
          mockClient.query(
            query: anyNamed('query'),
            variables: anyNamed('variables'),
          ),
        ).thenAnswer((_) async => queryResult);

        // act
        final result = await dataSource.getCountryDetails('US');

        // assert
        expect(result, isA<CountryModel>());
        expect(result.code, 'US');
        expect(result.name, 'United States');
        expect(result.emoji, '🇺🇸');
        expect(result.capital, 'Washington, D.C.');
        expect(result.currency, 'USD');
        expect(result.phone, '1');
        expect(result.continent, isNotNull);
        expect(result.continent?.code, 'NA');
        expect(result.continent?.name, 'North America');
        expect(result.languages.length, 1);
        expect(result.languages[0].code, 'en');
        verify(
          mockClient.query(
            query: anyNamed('query'),
            variables: anyNamed('variables'),
          ),
        ).called(1);
      },
    );

    test('should pass code variable correctly', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {
          'country': {
            'code': 'CA',
            'name': 'Canada',
            'emoji': '🇨🇦',
            'capital': 'Ottawa',
            'currency': 'CAD',
            'phone': '1',
          },
        },
        errors: null,
      );

      when(
        mockClient.query(
          query: anyNamed('query'),
          variables: anyNamed('variables'),
        ),
      ).thenAnswer((_) async => queryResult);

      // act
      await dataSource.getCountryDetails('CA');

      // assert
      verify(
        mockClient.query(query: anyNamed('query'), variables: {'code': 'CA'}),
      ).called(1);
    });

    test('should return CountryModel with optional fields null', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {
          'country': {'code': 'XX', 'name': 'Test Country', 'emoji': '🏳️'},
        },
        errors: null,
      );

      when(
        mockClient.query(
          query: anyNamed('query'),
          variables: anyNamed('variables'),
        ),
      ).thenAnswer((_) async => queryResult);

      // act
      final result = await dataSource.getCountryDetails('XX');

      // assert
      expect(result.code, 'XX');
      expect(result.capital, null);
      expect(result.currency, null);
      expect(result.phone, null);
      expect(result.continent, null);
      expect(result.languages, isEmpty);
    });

    test('should return CountryModel with multiple languages', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {
          'country': {
            'code': 'BE',
            'name': 'Belgium',
            'emoji': '🇧🇪',
            'languages': [
              {'code': 'nl', 'name': 'Dutch'},
              {'code': 'fr', 'name': 'French'},
              {'code': 'de', 'name': 'German'},
            ],
          },
        },
        errors: null,
      );

      when(
        mockClient.query(
          query: anyNamed('query'),
          variables: anyNamed('variables'),
        ),
      ).thenAnswer((_) async => queryResult);

      // act
      final result = await dataSource.getCountryDetails('BE');

      // assert
      expect(result.languages.length, 3);
      expect(result.languages[0].code, 'nl');
      expect(result.languages[1].code, 'fr');
      expect(result.languages[2].code, 'de');
    });

    test('should throw ServerException when query has errors', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: null,
        errors: [GraphQLError(message: 'Country not found', code: 'NOT_FOUND')],
      );

      when(
        mockClient.query(
          query: anyNamed('query'),
          variables: anyNamed('variables'),
        ),
      ).thenAnswer((_) async => queryResult);

      // act & assert
      expect(
        () => dataSource.getCountryDetails('INVALID'),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException when data is empty', () async {
      // arrange
      final queryResult = GraphQLQueryResult(data: {}, errors: null);

      when(
        mockClient.query(
          query: anyNamed('query'),
          variables: anyNamed('variables'),
        ),
      ).thenAnswer((_) async => queryResult);

      // act & assert
      expect(
        () => dataSource.getCountryDetails('US'),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException when country key is missing', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {'otherKey': 'value'},
        errors: null,
      );

      when(
        mockClient.query(
          query: anyNamed('query'),
          variables: anyNamed('variables'),
        ),
      ).thenAnswer((_) async => queryResult);

      // act & assert
      expect(
        () => dataSource.getCountryDetails('US'),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException when country is null', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {'country': null},
        errors: null,
      );

      when(
        mockClient.query(
          query: anyNamed('query'),
          variables: anyNamed('variables'),
        ),
      ).thenAnswer((_) async => queryResult);

      // act & assert
      expect(
        () => dataSource.getCountryDetails('US'),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException on unexpected error', () async {
      // arrange
      when(
        mockClient.query(
          query: anyNamed('query'),
          variables: anyNamed('variables'),
        ),
      ).thenAnswer((_) async => throw Exception('Network error'));

      // act & assert
      expect(
        () => dataSource.getCountryDetails('US'),
        throwsA(isA<ServerException>()),
      );
    });

    test(
      'should map JSON data correctly to CountryModel with nested objects',
      () async {
        // arrange
        final queryResult = GraphQLQueryResult(
          data: {
            'country': {
              'code': 'FR',
              'name': 'France',
              'emoji': '🇫🇷',
              'capital': 'Paris',
              'currency': 'EUR',
              'phone': '33',
              'continent': {'code': 'EU', 'name': 'Europe'},
              'languages': [
                {
                  'code': 'fr',
                  'name': 'French',
                  'native': 'Français',
                  'rtl': false,
                },
              ],
            },
          },
          errors: null,
        );

        when(
          mockClient.query(
            query: anyNamed('query'),
            variables: anyNamed('variables'),
          ),
        ).thenAnswer((_) async => queryResult);

        // act
        final result = await dataSource.getCountryDetails('FR');

        // assert
        expect(result.code, 'FR');
        expect(result.name, 'France');
        expect(result.capital, 'Paris');
        expect(result.currency, 'EUR');
        expect(result.phone, '33');
        expect(result.continent?.code, 'EU');
        expect(result.continent?.name, 'Europe');
        expect(result.languages[0].code, 'fr');
        expect(result.languages[0].name, 'French');
        expect(result.languages[0].native, 'Français');
        expect(result.languages[0].rtl, false);
      },
    );

    test('should handle languages with rtl true', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {
          'country': {
            'code': 'SA',
            'name': 'Saudi Arabia',
            'emoji': '🇸🇦',
            'languages': [
              {
                'code': 'ar',
                'name': 'Arabic',
                'native': 'العربية',
                'rtl': true,
              },
            ],
          },
        },
        errors: null,
      );

      when(
        mockClient.query(
          query: anyNamed('query'),
          variables: anyNamed('variables'),
        ),
      ).thenAnswer((_) async => queryResult);

      // act
      final result = await dataSource.getCountryDetails('SA');

      // assert
      expect(result.languages[0].rtl, true);
      expect(result.languages[0].native, 'العربية');
    });

    test('should handle empty languages array', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {
          'country': {
            'code': 'XX',
            'name': 'Test',
            'emoji': '🏳️',
            'languages': [],
          },
        },
        errors: null,
      );

      when(
        mockClient.query(
          query: anyNamed('query'),
          variables: anyNamed('variables'),
        ),
      ).thenAnswer((_) async => queryResult);

      // act
      final result = await dataSource.getCountryDetails('XX');

      // assert
      expect(result.languages, isEmpty);
    });
  });
}
