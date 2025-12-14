import 'package:country_info/core/data/error/app_exception.dart';
import 'package:country_info/core/domain/failure.dart';
import 'package:country_info/core/domain/result.dart';
import 'package:country_info/features/country/data/datasource/country_datasource.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/domain/repository/country_repository.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryDataSource remoteDataSource;

  CountryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<Country>>> getCountries() async {
    try {
      final countryModels = await remoteDataSource.getCountries();
      final countries = countryModels.map((model) => model.toEntity()).toList();
      return Result.success(countries);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Result.failure(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
