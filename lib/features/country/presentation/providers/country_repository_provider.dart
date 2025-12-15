import 'package:country_info/features/country/data/repository/country_repository_impl.dart';
import 'package:country_info/features/country/domain/repository/country_repository.dart';
import 'package:country_info/features/country/presentation/providers/country_datasource_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'country_repository_provider.g.dart';

@riverpod
CountryRepository countriesRepository(Ref ref) {
  return CountryRepositoryImpl(
    remoteDataSource: ref.watch(countryDataSourceProvider),
  );
}
