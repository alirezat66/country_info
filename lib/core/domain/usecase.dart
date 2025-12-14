import 'package:country_info/core/domain/result.dart';

abstract class UseCase<T> {
  Future<Result<T>> call();
}

abstract class UseCaseWithParams<T, P> {
  Future<Result<T>> call(P params);
}
