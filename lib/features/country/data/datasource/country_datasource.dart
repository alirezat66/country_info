import 'package:country_info/features/country/data/models/country_model.dart';

abstract class CountryDataSource {
  Future<List<CountryModel>> getCountries();
  Future<CountryModel> getCountryDetails(String code);
}
