import 'package:country_info/core/data/network/api/graphql_api_client.dart';
import 'package:country_info/core/data/network/graphql_api_client_impl.dart';
import 'package:country_info/core/presentation/providers/graphql_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'graphql_api_client_provider.g.dart';

@riverpod
GraphQLApiClient graphqlApiClient(Ref ref) {
  final graphqlClient = ref.watch(graphqlClientProvider);
  return GraphQLApiClientImpl(client: graphqlClient);
}
