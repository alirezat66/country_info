import 'package:country_info/core/data/network/api/graphql_error.dart';
import 'package:country_info/core/data/network/api/graphql_query_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GraphQLQueryResult', () {
    test('should create result with data and no errors', () {
      // arrange
      final data = {'key': 'value'};

      // act
      final result = GraphQLQueryResult(data: data, errors: null);

      // assert
      expect(result.data, data);
      expect(result.errors, isNull);
      expect(result.hasErrors, false);
      expect(result.hasData, true);
      expect(result.isEmpty, false);
    });

    test('should create result with errors and no data', () {
      // arrange
      final errors = [
        GraphQLError(message: 'Error message', code: 'ERROR_CODE'),
      ];

      // act
      final result = GraphQLQueryResult(data: null, errors: errors);

      // assert
      expect(result.data, isNull);
      expect(result.errors, errors);
      expect(result.hasErrors, true);
      expect(result.hasData, false);
      expect(result.isEmpty, true);
    });

    test('should create result with both data and errors', () {
      // arrange
      final data = {'key': 'value'};
      final errors = [
        GraphQLError(message: 'Error message', code: 'ERROR_CODE'),
      ];

      // act
      final result = GraphQLQueryResult(data: data, errors: errors);

      // assert
      expect(result.data, data);
      expect(result.errors, errors);
      expect(result.hasErrors, true);
      expect(result.hasData, true);
      expect(result.isEmpty, false);
    });

    test('should mark as empty when data is null', () {
      // act
      final result = GraphQLQueryResult(data: null, errors: null);

      // assert
      expect(result.hasData, false);
      expect(result.isEmpty, true);
    });

    test('should mark as empty when data is empty map', () {
      // act
      final result = GraphQLQueryResult(data: {}, errors: null);

      // assert
      expect(result.hasData, false);
      expect(result.isEmpty, true);
    });

    test('should not have errors when errors list is empty', () {
      // act
      final result = GraphQLQueryResult(data: {'key': 'value'}, errors: []);

      // assert
      expect(result.hasErrors, false);
    });
  });

  group('GraphQLError', () {
    test('should create error with message only', () {
      // act
      final error = GraphQLError(message: 'Error message');

      // assert
      expect(error.message, 'Error message');
      expect(error.code, isNull);
      expect(error.extensions, isNull);
    });

    test('should create error with message and code', () {
      // act
      final error = GraphQLError(message: 'Error message', code: 'ERROR_CODE');

      // assert
      expect(error.message, 'Error message');
      expect(error.code, 'ERROR_CODE');
      expect(error.extensions, isNull);
    });

    test('should create error with all properties', () {
      // arrange
      final extensions = {'key': 'value'};

      // act
      final error = GraphQLError(
        message: 'Error message',
        code: 'ERROR_CODE',
        extensions: extensions,
      );

      // assert
      expect(error.message, 'Error message');
      expect(error.code, 'ERROR_CODE');
      expect(error.extensions, extensions);
    });
  });
}
