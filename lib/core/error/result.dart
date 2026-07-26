import 'failures.dart';

sealed class Result<T> {
  const Result();

  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess);

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Err<T>;
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) =>
      onSuccess(data);
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;

  @override
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) =>
      onFailure(failure);
}
