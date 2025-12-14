import 'package:country_info/features/country/presentation/providers/country_usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/country.dart';

final countriesProvider = FutureProvider<List<Country>>((ref) async {
  final getCountriesUseCase = ref.watch(getCountriesProvider);
  final result = await getCountriesUseCase();
  return result.fold((failure) => throw failure, (countries) => countries);
});

final countryDetailsProvider = FutureProvider.family<Country, String>((
  ref,
  code,
) async {
  final getCountryDetailsUseCase = ref.watch(getCountryDetailsProvider);
  final result = await getCountryDetailsUseCase(code);
  return result.fold((failure) => throw failure, (country) => country);
});
