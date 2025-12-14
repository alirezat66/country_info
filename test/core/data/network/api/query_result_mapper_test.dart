import 'package:country_info/core/data/network/api/query_result_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:mockito/annotations.dart';

import 'query_result_mapper_test.mocks.dart';

@GenerateMocks([graphql.LinkException])
void main() {
  group('QueryResultMapper', () {
    const testQuery = 'query { test }';

    test('should map successful query result with data', () {
      // arrange
      final data = {'key': 'value'};
      final queryResult = graphql.QueryResult.loading(
        options: graphql.QueryOptions(
          document: graphql.gql(testQuery),
          variables: {},
        ),
      ).copyWith(data: data);

      // act
      final result = queryResult.toGraphQLQueryResult();

      // assert
      expect(result.data, data);
      expect(result.errors, isNull);
      expect(result.hasErrors, false);
      expect(result.hasData, true);
    });

    test('should map query result with network error', () {
      // arrange
      final queryResult =
          graphql.QueryResult.loading(
            options: graphql.QueryOptions(
              document: graphql.gql(testQuery),
              variables: {},
            ),
          ).copyWith(
            exception: graphql.OperationException(
              linkException: MockLinkException(),
              graphqlErrors: [],
            ),
          );

      // act
      final result = queryResult.toGraphQLQueryResult();

      // assert
      expect(result.data, isNull);
      expect(result.errors, isNotNull);
      expect(result.errors!.length, 1);
      expect(result.errors!.first.message, 'Network error occurred');
      expect(result.errors!.first.code, 'NETWORK_ERROR');
      expect(result.errors!.first.extensions, isNull);
      expect(result.hasErrors, true);
    });

    test('should map query result with GraphQL errors', () {
      // arrange
      final queryResult =
          graphql.QueryResult.loading(
            options: graphql.QueryOptions(
              document: graphql.gql(testQuery),
              variables: {},
            ),
          ).copyWith(
            exception: graphql.OperationException(
              linkException: null,
              graphqlErrors: [
                graphql.GraphQLError(
                  message: 'GraphQL error message',
                  extensions: {'code': 'GRAPHQL_ERROR'},
                ),
              ],
            ),
          );

      // act
      final result = queryResult.toGraphQLQueryResult();

      // assert
      expect(result.data, isNull);
      expect(result.errors, isNotNull);
      expect(result.errors!.length, 1);
      expect(result.errors!.first.message, 'GraphQL error message');
      expect(result.errors!.first.code, 'GRAPHQL_ERROR');
      expect(result.errors!.first.extensions, {'code': 'GRAPHQL_ERROR'});
      expect(result.hasErrors, true);
    });

    test('should map query result with GraphQL errors without code', () {
      // arrange
      final queryResult =
          graphql.QueryResult.loading(
            options: graphql.QueryOptions(
              document: graphql.gql(testQuery),
              variables: {},
            ),
          ).copyWith(
            exception: graphql.OperationException(
              linkException: null,
              graphqlErrors: [
                graphql.GraphQLError(
                  message: 'GraphQL error without code',
                  extensions: {'other': 'value'},
                ),
              ],
            ),
          );

      // act
      final result = queryResult.toGraphQLQueryResult();

      // assert
      expect(result.errors, isNotNull);
      expect(result.errors!.length, 1);
      expect(result.errors!.first.message, 'GraphQL error without code');
      expect(result.errors!.first.code, isNull);
      expect(result.errors!.first.extensions, {'other': 'value'});
    });

    test('should map query result with multiple GraphQL errors', () {
      // arrange
      final queryResult =
          graphql.QueryResult.loading(
            options: graphql.QueryOptions(
              document: graphql.gql(testQuery),
              variables: {},
            ),
          ).copyWith(
            exception: graphql.OperationException(
              linkException: null,
              graphqlErrors: [
                graphql.GraphQLError(
                  message: 'First error',
                  extensions: {'code': 'ERROR_1'},
                ),
                graphql.GraphQLError(
                  message: 'Second error',
                  extensions: {'code': 'ERROR_2'},
                ),
              ],
            ),
          );

      // act
      final result = queryResult.toGraphQLQueryResult();

      // assert
      expect(result.errors, isNotNull);
      expect(result.errors!.length, 2);
      expect(result.errors!.first.message, 'First error');
      expect(result.errors!.first.code, 'ERROR_1');
      expect(result.errors!.last.message, 'Second error');
      expect(result.errors!.last.code, 'ERROR_2');
    });

    test('should map query result with both network and GraphQL errors', () {
      // arrange
      final queryResult =
          graphql.QueryResult.loading(
            options: graphql.QueryOptions(
              document: graphql.gql(testQuery),
              variables: {},
            ),
          ).copyWith(
            exception: graphql.OperationException(
              linkException: MockLinkException(),
              graphqlErrors: [
                graphql.GraphQLError(
                  message: 'GraphQL error',
                  extensions: {'code': 'GRAPHQL_ERROR'},
                ),
              ],
            ),
          );

      // act
      final result = queryResult.toGraphQLQueryResult();

      // assert
      expect(result.errors, isNotNull);
      expect(result.errors!.length, 2);
      expect(result.errors!.first.message, 'Network error occurred');
      expect(result.errors!.first.code, 'NETWORK_ERROR');
      expect(result.errors!.last.message, 'GraphQL error');
      expect(result.errors!.last.code, 'GRAPHQL_ERROR');
    });

    test('should map query result with exception but no specific errors', () {
      // arrange
      final queryResult =
          graphql.QueryResult.loading(
            options: graphql.QueryOptions(
              document: graphql.gql(testQuery),
              variables: {},
            ),
          ).copyWith(
            exception: graphql.OperationException(
              linkException: null,
              graphqlErrors: [],
            ),
          );

      // act
      final result = queryResult.toGraphQLQueryResult();

      // assert
      expect(result.errors, isNotNull);
      expect(result.errors!.length, 1);
      expect(result.errors!.first.message, 'Unknown GraphQL error occurred');
      expect(result.errors!.first.code, isNull);
      expect(result.hasErrors, true);
    });

    test('should map query result with data and errors', () {
      // arrange
      final data = {'key': 'value'};
      final queryResult =
          graphql.QueryResult.loading(
            options: graphql.QueryOptions(
              document: graphql.gql(testQuery),
              variables: {},
            ),
          ).copyWith(
            data: data,
            exception: graphql.OperationException(
              linkException: null,
              graphqlErrors: [
                graphql.GraphQLError(
                  message: 'Partial error',
                  extensions: {'code': 'PARTIAL_ERROR'},
                ),
              ],
            ),
          );

      // act
      final result = queryResult.toGraphQLQueryResult();

      // assert
      expect(result.data, data);
      expect(result.errors, isNotNull);
      expect(result.errors!.length, 1);
      expect(result.hasErrors, true);
      expect(result.hasData, true);
    });

    test('should map query result with no data and no errors', () {
      // arrange
      final queryResult = graphql.QueryResult.loading(
        options: graphql.QueryOptions(
          document: graphql.gql(testQuery),
          variables: {},
        ),
      ).copyWith(data: null);

      // act
      final result = queryResult.toGraphQLQueryResult();

      // assert
      expect(result.data, isNull);
      expect(result.errors, isNull);
      expect(result.hasErrors, false);
      expect(result.hasData, false);
      expect(result.isEmpty, true);
    });

    test('should map GraphQL error with code as non-string type', () {
      // arrange
      final queryResult =
          graphql.QueryResult.loading(
            options: graphql.QueryOptions(
              document: graphql.gql(testQuery),
              variables: {},
            ),
          ).copyWith(
            exception: graphql.OperationException(
              linkException: null,
              graphqlErrors: [
                graphql.GraphQLError(
                  message: 'Error with numeric code',
                  extensions: {'code': 404},
                ),
              ],
            ),
          );

      // act
      final result = queryResult.toGraphQLQueryResult();

      // assert
      expect(result.errors, isNotNull);
      expect(result.errors!.length, 1);
      expect(result.errors!.first.code, '404');
    });
  });
}
