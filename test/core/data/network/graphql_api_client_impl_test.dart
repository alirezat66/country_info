import 'package:country_info/core/data/network/api/graphql_query_result.dart';
import 'package:country_info/core/data/network/graphql_api_client_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'graphql_api_client_impl_test.mocks.dart';

// Helper function to create QueryResult with data
graphql.QueryResult _createQueryResultWithData(
  String query,
  Map<String, dynamic>? data,
) {
  return graphql.QueryResult.loading(
    options: graphql.QueryOptions(document: graphql.gql(query), variables: {}),
  ).copyWith(data: data);
}

// Helper function to create QueryResult with exception
graphql.QueryResult _createQueryResultWithException(
  String query,
  graphql.OperationException exception,
) {
  return graphql.QueryResult.loading(
    options: graphql.QueryOptions(document: graphql.gql(query), variables: {}),
  ).copyWith(exception: exception);
}

@GenerateMocks([graphql.GraphQLClient])
void main() {
  late GraphQLApiClientImpl apiClient;
  late MockGraphQLClient mockGraphQLClient;

  setUp(() {
    mockGraphQLClient = MockGraphQLClient();
    apiClient = GraphQLApiClientImpl(client: mockGraphQLClient);
  });

  group('GraphQLApiClientImpl - query', () {
    test('should return GraphQLQueryResult when query succeeds', () async {
      // arrange
      const query = 'query { test }';
      final queryResult = _createQueryResultWithData(query, {'test': 'value'});

      when(mockGraphQLClient.query(any)).thenAnswer((_) async => queryResult);

      // act
      final result = await apiClient.query(query: query);

      // assert
      expect(result, isA<GraphQLQueryResult>());
      expect(result.data, {'test': 'value'});
      expect(result.hasErrors, false);
      verify(mockGraphQLClient.query(any)).called(1);
    });

    test('should pass variables to query', () async {
      // arrange
      const query =
          r'query GetCountry($code: ID!) { country(code: $code) { name } }';
      final variables = {'code': 'US'};
      final queryResult =
          graphql.QueryResult.loading(
            options: graphql.QueryOptions(
              document: graphql.gql(query),
              variables: variables,
            ),
          ).copyWith(
            data: {
              'country': {'name': 'United States'},
            },
          );

      when(mockGraphQLClient.query(any)).thenAnswer((_) async => queryResult);

      // act
      final result = await apiClient.query(query: query, variables: variables);

      // assert
      expect(result.data, {
        'country': {'name': 'United States'},
      });
      final captured =
          verify(mockGraphQLClient.query(captureAny)).captured.first
              as graphql.QueryOptions;
      expect(captured.variables, variables);
      verifyNoMoreInteractions(mockGraphQLClient);
    });

    test('should handle query with GraphQL errors', () async {
      const query = 'query { test }';
      final queryResult = _createQueryResultWithException(
        query,
        graphql.OperationException(
          linkException: null,
          graphqlErrors: [
            graphql.GraphQLError(
              message: 'GraphQL error',
              extensions: {'code': 'GRAPHQL_ERROR'},
            ),
          ],
        ),
      );

      when(mockGraphQLClient.query(any)).thenAnswer((_) async => queryResult);

      final result = await apiClient.query(query: query);

      expect(result.hasErrors, true);
      expect(result.errors!.first.message, 'GraphQL error');
      expect(result.errors!.first.code, 'GRAPHQL_ERROR');
    });

    test('should use empty map when variables are null', () async {
      const query = 'query { test }';
      final queryResult = _createQueryResultWithData(query, {'test': 'value'});

      when(mockGraphQLClient.query(any)).thenAnswer((_) async => queryResult);

      await apiClient.query(query: query, variables: null);

      final captured =
          verify(mockGraphQLClient.query(captureAny)).captured.first
              as graphql.QueryOptions;
      expect(captured.variables, {});
    });
  });
}
