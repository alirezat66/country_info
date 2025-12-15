import 'package:country_info/features/country/presentation/providers/country_usecase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/country.dart';

part 'country_providers.g.dart';

@riverpod
Future<List<Country>> countries(Ref ref) async {
  final getCountriesUseCase = ref.watch(getCountriesProvider);
  final result = await getCountriesUseCase();
  return result.fold((failure) => throw failure, (countries) => countries);
}

@riverpod
Future<Country> countryDetails(Ref ref, String code) async {
  final getCountryDetailsUseCase = ref.watch(getCountryDetailsProvider);
  final result = await getCountryDetailsUseCase(code);
  return result.fold((failure) => throw failure, (country) => country);
}
