import 'package:country_info/core/data/consts/const_values.dart';
import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'graphql_client_provider.g.dart';

@riverpod
GraphQLClient graphqlClient(Ref ref) {
  return GraphQLClient(link: HttpLink(graphqlEndpoint), cache: GraphQLCache());
}
