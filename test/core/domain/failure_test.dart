import 'package:country_info/core/domain/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    test('should have message and optional code', () {
      // act
      const failure = ServerFailure('Error message', code: 'ERROR_CODE');

      // assert
      expect(failure.message, 'Error message');
      expect(failure.code, 'ERROR_CODE');
    });

    test('should work without code', () {
      // act
      const failure = ServerFailure('Error message');

      // assert
      expect(failure.message, 'Error message');
      expect(failure.code, isNull);
    });
  });

  group('ServerFailure', () {
    test('should create server failure with message', () {
      // act
      const failure = ServerFailure('Server error');

      // assert
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Server error');
    });

    test('should create server failure with message and code', () {
      // act
      const failure = ServerFailure('Server error', code: '500');

      // assert
      expect(failure.message, 'Server error');
      expect(failure.code, '500');
    });

    test('should be equal when message and code are same', () {
      // act
      const failure1 = ServerFailure('Error', code: 'CODE');
      const failure2 = ServerFailure('Error', code: 'CODE');

      // assert
      expect(failure1, failure2);
    });

    test('should not be equal when message differs', () {
      // act
      const failure1 = ServerFailure('Error 1', code: 'CODE');
      const failure2 = ServerFailure('Error 2', code: 'CODE');

      // assert
      expect(failure1, isNot(failure2));
    });

    test('should not be equal when code differs', () {
      // act
      const failure1 = ServerFailure('Error', code: 'CODE1');
      const failure2 = ServerFailure('Error', code: 'CODE2');

      // assert
      expect(failure1, isNot(failure2));
    });
  });

  group('NetworkFailure', () {
    test('should create network failure with message', () {
      // act
      const failure = NetworkFailure('Network error');

      // assert
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'Network error');
    });

    test('should create network failure with message and code', () {
      // act
      const failure = NetworkFailure('Network error', code: 'NET_ERR');

      // assert
      expect(failure.message, 'Network error');
      expect(failure.code, 'NET_ERR');
    });

    test('should be different type from ServerFailure', () {
      // arrange
      const serverFailure = ServerFailure('Error');
      const networkFailure = NetworkFailure('Error');

      // assert
      expect(serverFailure, isNot(networkFailure));
      expect(serverFailure.runtimeType, isNot(networkFailure.runtimeType));
    });
  });

  group('UnexpectedFailure', () {
    test('should create unexpected failure with message', () {
      // act
      const failure = UnexpectedFailure('Unexpected error');

      // assert
      expect(failure, isA<UnexpectedFailure>());
      expect(failure.message, 'Unexpected error');
    });

    test('should create unexpected failure with message and code', () {
      // act
      const failure = UnexpectedFailure('Unexpected error', code: 'UNEXP');

      // assert
      expect(failure.message, 'Unexpected error');
      expect(failure.code, 'UNEXP');
    });
  });

  group('Failure equality', () {
    test('should compare failures correctly', () {
      // arrange
      const failure1 = ServerFailure('Error', code: 'CODE');
      const failure2 = ServerFailure('Error', code: 'CODE');
      const failure3 = ServerFailure('Different', code: 'CODE');
      const failure4 = ServerFailure('Error', code: 'DIFFERENT');

      // assert
      expect(failure1, failure2);
      expect(failure1, isNot(failure3));
      expect(failure1, isNot(failure4));
    });

    test('should handle null codes in equality', () {
      // arrange
      const failure1 = ServerFailure('Error');
      const failure2 = ServerFailure('Error');

      // assert
      expect(failure1, failure2);
    });
  });
}
