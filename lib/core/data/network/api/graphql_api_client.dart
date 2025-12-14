import 'package:country_info/core/data/network/api/graphql_query_result.dart';

abstract class GraphQLApiClient {
  Future<GraphQLQueryResult> query({
    required String query,
    Map<String, dynamic>? variables,
  });
}
