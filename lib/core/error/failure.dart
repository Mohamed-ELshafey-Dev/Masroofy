/// Base failure type for structured error handling across the app.
///
/// WHY sealed: Dart 3 sealed classes force exhaustive `switch` statements.
/// The compiler will error if you forget to handle a failure type.
/// This is what separates junior code (catch-all `try/catch`) from
/// senior code (every failure type has a dedicated UI response).
sealed class Failure {
  final String message;
  final StackTrace? stackTrace;

  const Failure(this.message, {this.stackTrace});
}

/// Database operation failed (insert, query, delete, migration).
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.stackTrace});
}

/// User input validation failed (negative amount, empty category, etc.).
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.stackTrace});
}

/// Unexpected/unrecoverable error — catch-all for truly unknown issues.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.stackTrace});
}
