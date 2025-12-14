import 'package:country_info/core/data/network/api/graphql_query_result.dart';
import 'package:country_info/core/data/error/app_exception.dart'
    as app_exceptions;
extension GraphQLQueryResultErrorHandler on GraphQLQueryResult {

  void ensureNoError() {
    if (hasErrors) {
      final error = errors!.first;
      final errorCode = error.code;

      throw app_exceptions.ServerException(
        message: error.message,
        code: errorCode,
      );
    }
  }

  /// Ensures the result contains data
  /// Throws ServerException if data is null or empty
  void ensureDataIsNotEmpty() {
    if (isEmpty) {
      throw app_exceptions.ServerException(
        message: 'No data received from server',
      );
    }
  }

  /// Ensures all required keys are present in the data
  /// Throws ServerException if any required key is missing
  void ensureRequiredKeysArePresent(List<String> requiredKeys) {
    if (requiredKeys.isNotEmpty) {
      for (var key in requiredKeys) {
        if (data?[key] == null) {
          throw app_exceptions.ServerException(
            message: 'Required key $key is missing',
          );
        }
      }
    }
  }
}
