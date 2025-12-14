import 'package:country_info/core/domain/result.dart';
import 'package:country_info/core/domain/usecase.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/domain/repository/country_repository.dart';

class GetCountries implements UseCase<List<Country>> {
  final CountryRepository repository;

  GetCountries(this.repository);

  @override
  Future<Result<List<Country>>> call() {
    return repository.getCountries();
  }
}
