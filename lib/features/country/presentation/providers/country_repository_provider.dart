import 'package:country_info/features/country/data/repository/country_repository_impl.dart';
import 'package:country_info/features/country/domain/repository/country_repository.dart';
import 'package:country_info/features/country/presentation/providers/country_datasource_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final countriesRepositoryProvider = Provider<CountryRepository>((ref) {
  return CountryRepositoryImpl(
    remoteDataSource: ref.watch(countryDataSourceProvider),
  );
});
