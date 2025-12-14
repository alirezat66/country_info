import 'package:country_info/core/domain/failure.dart';
import 'package:country_info/core/domain/result.dart';
import 'package:country_info/core/domain/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

// Test implementations
class TestUseCase implements UseCase<String> {
  final String Function() _action;

  TestUseCase(this._action);

  @override
  Future<Result<String>> call() async {
    try {
      final value = _action();
      return Result.success(value);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}

class TestUseCaseWithParams implements UseCaseWithParams<String, int> {
  final String Function(int) _action;

  TestUseCaseWithParams(this._action);

  @override
  Future<Result<String>> call(int params) async {
    try {
      final value = _action(params);
      return Result.success(value);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}

void main() {
  group('UseCase', () {
    test('should execute use case and return success', () async {
      // arrange
      final useCase = TestUseCase(() => 'test value');

      // act
      final result = await useCase();

      // assert
      expect(result, isA<Success<String>>());
      result.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, 'test value'),
      );
    });

    test('should execute use case and return failure on error', () async {
      // arrange
      final useCase = TestUseCase(() => throw Exception('Error occurred'));

      // act
      final result = await useCase();

      // assert
      expect(result, isA<FailureResult<String>>());
      result.fold(
        (failure) => expect(failure.message, contains('Error occurred')),
        (value) => fail('Expected failure'),
      );
    });

    test('should be callable as function', () async {
      // arrange
      final useCase = TestUseCase(() => 'test');

      // act
      final result = await useCase();

      // assert
      expect(result, isA<Success<String>>());
    });
  });

  group('UseCaseWithParams', () {
    test('should execute use case with params and return success', () async {
      // arrange
      final useCase = TestUseCaseWithParams((params) => 'value: $params');

      // act
      final result = await useCase(42);

      // assert
      expect(result, isA<Success<String>>());
      result.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, 'value: 42'),
      );
    });

    test(
      'should execute use case with params and return failure on error',
      () async {
        // arrange
        final useCase = TestUseCaseWithParams((params) {
          throw Exception('Error with param: $params');
        });

        // act
        final result = await useCase(42);

        // assert
        expect(result, isA<FailureResult<String>>());
        result.fold(
          (failure) =>
              expect(failure.message, contains('Error with param: 42')),
          (value) => fail('Expected failure'),
        );
      },
    );

    test('should work with different param types', () async {
      // arrange
      final useCase = TestUseCaseWithParams((params) => params.toString());

      // act
      final result1 = await useCase(1);
      final result2 = await useCase(100);

      // assert
      result1.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, '1'),
      );
      result2.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, '100'),
      );
    });

    test('should be callable as function', () async {
      // arrange
      final useCase = TestUseCaseWithParams((params) => 'test');

      // act
      final result = await useCase(42);

      // assert
      expect(result, isA<Success<String>>());
    });
  });
}
