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
            {
              'code': 'US',
              'name': 'United States',
              'emoji': '🇺🇸',
            },
            {
              'code': 'CA',
              'name': 'Canada',
              'emoji': '🇨🇦',
            },
          ],
        },
        errors: null,
      );

      when(mockClient.query(query: anyNamed('query')))
          .thenAnswer((_) async => queryResult);

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
        errors: [
          GraphQLError(
            message: 'GraphQL error',
            code: 'ERROR_CODE',
          ),
        ],
      );

      when(mockClient.query(query: anyNamed('query')))
          .thenAnswer((_) async => queryResult);

      // act & assert
      expect(
        () => dataSource.getCountries(),
        throwsA(isA<ServerException>()),
      );
      verify(mockClient.query(query: anyNamed('query'))).called(1);
    });

    test('should throw ServerException when data is empty', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {},
        errors: null,
      );

      when(mockClient.query(query: anyNamed('query')))
          .thenAnswer((_) async => queryResult);

      // act & assert
      expect(
        () => dataSource.getCountries(),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException when countries key is missing', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {
          'otherKey': 'value',
        },
        errors: null,
      );

      when(mockClient.query(query: anyNamed('query')))
          .thenAnswer((_) async => queryResult);

      // act & assert
      expect(
        () => dataSource.getCountries(),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException when countries is null', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {
          'countries': null,
        },
        errors: null,
      );

      when(mockClient.query(query: anyNamed('query')))
          .thenAnswer((_) async => queryResult);

      // act & assert
      expect(
        () => dataSource.getCountries(),
        throwsA(isA<ServerException>()),
      );
    });

    test('should handle empty countries list', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {
          'countries': [],
        },
        errors: null,
      );

      when(mockClient.query(query: anyNamed('query')))
          .thenAnswer((_) async => queryResult);

      // act
      final result = await dataSource.getCountries();

      // assert
      expect(result, isA<List<CountryModel>>());
      expect(result.isEmpty, true);
    });

    test('should throw ServerException on unexpected error', () async {
      // arrange
      when(mockClient.query(query: anyNamed('query')))
          .thenAnswer((_) async => throw Exception('Network error'));

      // act & assert
      expect(
        () => dataSource.getCountries(),
        throwsA(isA<ServerException>()),
      );
      verify(mockClient.query(query: anyNamed('query'))).called(1);
    });

    test('should map JSON data correctly to CountryModel', () async {
      // arrange
      final queryResult = GraphQLQueryResult(
        data: {
          'countries': [
            {
              'code': 'JP',
              'name': 'Japan',
              'emoji': '🇯🇵',
            },
          ],
        },
        errors: null,
      );

      when(mockClient.query(query: anyNamed('query')))
          .thenAnswer((_) async => queryResult);

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
}

