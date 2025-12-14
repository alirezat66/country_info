import 'package:country_info/features/country/domain/repository/country_repository.dart';

import '../../../../core/domain/result.dart';
import '../../../../core/domain/usecase.dart';
import '../entities/country.dart';

/// Use case to get country details by code
class GetCountryDetails implements UseCaseWithParams<Country, String> {
  final CountryRepository repository;

  GetCountryDetails(this.repository);

  @override
  Future<Result<Country>> call(String code) {
    return repository.getCountryDetails(code);
  }
}
