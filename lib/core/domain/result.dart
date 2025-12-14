import 'failure.dart';

sealed class Result<T> {
  const Result();

  /// Create a successful result
  factory Result.success(T value) = Success<T>;

  /// Create a failed result
  factory Result.failure(Failure failure) = FailureResult<T>;

  /// Fold the result into a single value
  R fold<R>(R Function(Failure) onFailure, R Function(T) onSuccess);
}

class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  R fold<R>(R Function(Failure) onFailure, R Function(T) onSuccess) {
    return onSuccess(value);
  }
}

class FailureResult<T> extends Result<T> {
  final Failure failure;

  const FailureResult(this.failure);

  @override
  R fold<R>(R Function(Failure) onFailure, R Function(T) onSuccess) {
    return onFailure(failure);
  }
}
