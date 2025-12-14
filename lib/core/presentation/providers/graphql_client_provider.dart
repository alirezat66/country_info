import 'package:country_info/core/data/consts/const_values.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';

final graphqlClientProvider = Provider<GraphQLClient>((ref) {
  return GraphQLClient(link: HttpLink(graphqlEndpoint), cache: GraphQLCache());
});
