import 'package:country_info/core/data/error/app_exception.dart'
    as app_exceptions;
import 'package:country_info/core/data/network/api/graphql_query_result.dart';
import 'package:country_info/core/data/network/api/graphql_query_result_error_handler.dart';

mixin GraphqlSafeMixin {
  Future<T> safeQuery<T>({
    required Future<GraphQLQueryResult> call,
    required List<String>
    requiredKeys, //todo : we can use chain of responsibility pattern for make it more flexible and expandable
    required T Function(dynamic data) mapper,
  }) async {
    try {
      final result = await call;
      result.ensureNoError();
      result.ensureDataIsNotEmpty();
      result.ensureRequiredKeysArePresent(requiredKeys);
      return mapper(result.data!);
    } catch (e) {
      if (e is app_exceptions.AppException) {
        rethrow;
      }
      throw app_exceptions.ServerException(
        message: e.toString(),
        code: 'Unexpected Error',
      );
    }
  }
}
