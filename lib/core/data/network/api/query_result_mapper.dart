import 'package:country_info/core/data/network/api/graphql_error.dart';
import 'package:country_info/core/data/network/api/graphql_query_result.dart';
import 'package:graphql/client.dart' hide GraphQLError;

extension QueryResultMapper on QueryResult {
  GraphQLQueryResult toGraphQLQueryResult() {
    // Map graphql package errors to our domain errors
    List<GraphQLError>? errors;

    if (exception != null) {
      errors = [];

      if (exception!.linkException != null) {
        errors.add(
          GraphQLError(
            message: 'Network error occurred',
            code: 'NETWORK_ERROR',
          ),
        );
      }

      if (exception!.graphqlErrors.isNotEmpty) {
        for (var error in exception!.graphqlErrors) {
          errors.add(
            GraphQLError(
              message: error.message,
              code: error.extensions?['code']?.toString(),
              extensions: error.extensions,
            ),
          );
        }
      }

      if (errors.isEmpty) {
        errors.add(GraphQLError(message: 'Unknown GraphQL error occurred'));
      }
    }

    return GraphQLQueryResult(data: data, errors: errors);
  }
}
