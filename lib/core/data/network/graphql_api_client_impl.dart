import 'package:country_info/core/data/network/api/graphql_api_client.dart';
import 'package:country_info/core/data/network/api/graphql_query_result.dart';
import 'package:country_info/core/data/network/api/query_result_mapper.dart';
import 'package:graphql/client.dart' as graphql;

class GraphQLApiClientImpl implements GraphQLApiClient {
  final graphql.GraphQLClient _client;

  GraphQLApiClientImpl({required graphql.GraphQLClient client})
    : _client = client;

  @override
  Future<GraphQLQueryResult> query({
    required String query,
    Map<String, dynamic>? variables,
  }) async {
    final result = await _client.query(
      graphql.QueryOptions(
        document: graphql.gql(query),
        variables: variables ?? {},
      ),
    );
    return result.toGraphQLQueryResult();
  }
}
