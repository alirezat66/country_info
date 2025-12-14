import 'package:country_info/features/country/domain/usecases/get_countries.dart';
import 'package:country_info/features/country/domain/usecases/get_country_details.dart';
import 'package:country_info/features/country/presentation/providers/country_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCountriesProvider = Provider<GetCountries>((ref) {
  return GetCountries(ref.watch(countriesRepositoryProvider));
});
final getCountryDetailsProvider = Provider<GetCountryDetails>((ref) {
  return GetCountryDetails(ref.watch(countriesRepositoryProvider));
});
