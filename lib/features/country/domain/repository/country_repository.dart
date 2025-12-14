import 'package:country_info/core/domain/result.dart';
import 'package:country_info/features/country/domain/entities/country.dart';

abstract class CountryRepository {
  Future<Result<List<Country>>> getCountries();
  Future<Result<Country>> getCountryDetails(String code);
}
