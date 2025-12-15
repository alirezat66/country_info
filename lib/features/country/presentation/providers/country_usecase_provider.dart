import 'package:country_info/features/country/domain/usecases/get_countries.dart';
import 'package:country_info/features/country/domain/usecases/get_country_details.dart';
import 'package:country_info/features/country/presentation/providers/country_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'country_usecase_provider.g.dart';

@riverpod
GetCountries getCountries(Ref ref) {
  return GetCountries(ref.watch(countriesRepositoryProvider));
}

@riverpod
GetCountryDetails getCountryDetails(Ref ref) {
  return GetCountryDetails(ref.watch(countriesRepositoryProvider));
}
