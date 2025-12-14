import 'package:country_info/core/data/consts/const_queries.dart';
import 'package:country_info/core/data/network/api/graphql_api_client.dart';
import 'package:country_info/core/data/network/api/graphql_safe_mixin.dart';
import 'package:country_info/features/country/data/datasource/country_datasource.dart';

import '../models/country_model.dart';

class CountryRemoteDataSourceImpl
    with GraphqlSafeMixin
    implements CountryDataSource {
  final GraphQLApiClient client;

  CountryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CountryModel>> getCountries() async {
    return await safeQuery(
      call: client.query(query: ConstQueries.getCountriesQuery),
      requiredKeys: ['countries'],
      mapper: (data) => List<CountryModel>.from(
        (data['countries'] as List<dynamic>).map(
          (json) => CountryModel.fromJson(json as Map<String, dynamic>),
        ),
      ),
    );
  }
}
