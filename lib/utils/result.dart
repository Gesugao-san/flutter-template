/// A minimal `Result` type for operations that can fail.
library;

/// Outcome of an operation: either [Ok] with a value or [Failure] with an
/// error.
///
/// Repositories and services return results instead of throwing, so callers
/// must handle the failure case explicitly (with an exhaustive `switch`).
sealed class Result<T> {
  const Result();

  /// Creates a successful result holding [value].
  const factory Result.ok(T value) = Ok<T>;

  /// Creates a failed result holding [error].
  const factory Result.failure(Exception error) = Failure<T>;
}

/// Successful [Result] with a [value].
final class Ok<T> extends Result<T> {
  /// Creates a successful result holding [value].
  const Ok(this.value);

  /// The produced value.
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// Failed [Result] with an [error].
///
/// Named `Failure` rather than `Error` to avoid clashing with `dart:core`.
final class Failure<T> extends Result<T> {
  /// Creates a failed result holding [error].
  const Failure(this.error);

  /// What went wrong.
  final Exception error;

  @override
  String toString() => 'Result<$T>.failure($error)';
}
