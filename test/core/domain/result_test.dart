import 'package:country_info/core/domain/failure.dart';
import 'package:country_info/core/domain/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('should create success result with value', () {
        // act
        const result = Success<String>('test value');

        // assert
        expect(result.value, 'test value');
        expect(result, isA<Success<String>>());
      });

      test('should fold success to onSuccess callback', () {
        // arrange
        const result = Success<String>('test value');

        // act
        final folded = result.fold(
          (failure) => 'failure',
          (value) => 'success: $value',
        );

        // assert
        expect(folded, 'success: test value');
      });

      test('should work with different types', () {
        // act
        const stringResult = Success<String>('string');
        const intResult = Success<int>(42);
        const listResult = Success<List<String>>(['a', 'b']);

        // assert
        expect(stringResult.value, 'string');
        expect(intResult.value, 42);
        expect(listResult.value, ['a', 'b']);
      });
    });

    group('FailureResult', () {
      test('should create failure result with failure', () {
        // arrange
        const failure = ServerFailure('Error message', code: 'ERROR_CODE');

        // act
        final result = FailureResult<String>(failure);

        // assert
        expect(result.failure, failure);
        expect(result, isA<FailureResult<String>>());
      });

      test('should fold failure to onFailure callback', () {
        // arrange
        const failure = ServerFailure('Error message', code: 'ERROR_CODE');
        final result = FailureResult<String>(failure);

        // act
        final folded = result.fold(
          (failure) => 'failure: ${failure.message}',
          (value) => 'success: $value',
        );

        // assert
        expect(folded, 'failure: Error message');
      });

      test('should work with different failure types', () {
        // arrange
        const serverFailure = ServerFailure('Server error');
        const networkFailure = NetworkFailure('Network error');
        const unexpectedFailure = UnexpectedFailure('Unexpected error');

        // act
        final serverResult = FailureResult<String>(serverFailure);
        final networkResult = FailureResult<String>(networkFailure);
        final unexpectedResult = FailureResult<String>(unexpectedFailure);

        // assert
        expect(serverResult.failure, serverFailure);
        expect(networkResult.failure, networkFailure);
        expect(unexpectedResult.failure, unexpectedFailure);
      });
    });

    group('Result factory methods', () {
      test('Result.success should create Success', () {
        // act
        final result = Result.success('test');

        // assert
        expect(result, isA<Success<String>>());
        if (result is Success<String>) {
          expect(result.value, 'test');
        }
      });

      test('Result.failure should create FailureResult', () {
        // arrange
        const failure = ServerFailure('Error');

        // act
        final result = FailureResult<String>(failure);

        // assert
        expect(result, isA<FailureResult<String>>());

        expect(result.failure, failure);
      });
    });

    group('Result fold method', () {
      test('should handle complex fold operations', () {
        // arrange
        const successResult = Success<int>(100);
        const failureResult = FailureResult<int>(
          ServerFailure('Error', code: 'ERR'),
        );

        // act
        final successFolded = successResult.fold(
          (failure) => -1,
          (value) => value * 2,
        );
        final failureFolded = failureResult.fold(
          (failure) => -1,
          (value) => value * 2,
        );

        // assert
        expect(successFolded, 200);
        expect(failureFolded, -1);
      });

      test('should allow different return types in fold', () {
        // arrange
        const successResult = Success<String>('hello');
        const failureResult = FailureResult<String>(
          NetworkFailure('Network error'),
        );

        // act
        final successFolded = successResult.fold(
          (failure) => 0,
          (value) => value.length,
        );
        final failureFolded = failureResult.fold(
          (failure) => 0,
          (value) => value.length,
        );

        // assert
        expect(successFolded, 5);
        expect(failureFolded, 0);
      });
    });
  });
}
