import 'package:country_info/features/country/presentation/providers/country_usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/country.dart';

final countriesProvider = FutureProvider<List<Country>>((ref) async {
  final getCountries = ref.watch(getCountriesProvider);
  final result = await getCountries();
  return result.fold((failure) => throw failure, (countries) => countries);
});

final countryDetailsProvider = FutureProvider.family<Country, String>((
  ref,
  code,
) async {
  final getCountryDetails = ref.watch(getCountryDetailsProvider);
  final result = await getCountryDetails(code);
  return result.fold((failure) => throw failure, (country) => country);
});
