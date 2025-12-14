import 'package:country_info/core/presentation/providers/graphql_api_client_provider.dart';
import 'package:country_info/features/country/data/datasource/country_datasource.dart';
import 'package:country_info/features/country/data/datasource/country_remote_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final countryDataSourceProvider = Provider<CountryDataSource>((ref) {
  final apiClient = ref.watch(graphqlApiClientProvider);
  return CountryRemoteDataSourceImpl(client: apiClient);
});
