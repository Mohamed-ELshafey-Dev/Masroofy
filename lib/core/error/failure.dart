/// Machine-readable reason for a [ValidationFailure].
///
/// WHY a code and not a message: the domain layer knows no `BuildContext` and
/// must not import Flutter or localization packages, so it cannot produce
/// localized text. It returns a code instead, and the presentation layer maps
/// that code to a localized string.
enum ValidationCode {
  /// The transaction amount is zero or negative.
  amountNotPositive,

  /// The transaction category is blank.
  categoryEmpty,

  /// The transaction id is zero or negative.
  invalidId,
}

/// Base failure type for structured error handling across the app.
///
/// WHY sealed: Dart 3 sealed classes force exhaustive `switch` statements.
/// The compiler will error if you forget to handle a failure type.
/// This is what separates junior code (catch-all `try/catch`) from
/// senior code (every failure type has a dedicated UI response).
sealed class Failure {
  /// Developer-facing/log text. Never show this to users — localize the
  /// failure by type/code in the presentation layer instead.
  final String message;
  final StackTrace? stackTrace;

  const Failure(this.message, {this.stackTrace});
}

/// Database operation failed (insert, query, delete, migration).
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.stackTrace});
}

/// User input validation failed (negative amount, empty category, etc.).
///
/// [code] is the machine-readable reason the UI localizes; [message] is only
/// for logs and must never reach the screen.
class ValidationFailure extends Failure {
  final ValidationCode code;

  const ValidationFailure(
    super.message, {
    required this.code,
    super.stackTrace,
  });
}

/// Unexpected/unrecoverable error — catch-all for truly unknown issues.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.stackTrace});
}
