import 'package:country_info/core/presentation/providers/graphql_api_client_provider.dart';
import 'package:country_info/features/country/data/datasource/country_datasource.dart';
import 'package:country_info/features/country/data/datasource/country_remote_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'country_datasource_provider.g.dart';

@riverpod
CountryDataSource countryDataSource(Ref ref) {
  final apiClient = ref.watch(graphqlApiClientProvider);
  return CountryRemoteDataSourceImpl(client: apiClient);
}
