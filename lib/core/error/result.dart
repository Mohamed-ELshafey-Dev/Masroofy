import 'failure.dart';

/// A lightweight Result type for structured success/failure returns.
///
/// WHY not use `dartz` Either or `fpdart`?
/// Those are heavy functional programming libraries. For Masroofy, a simple
/// sealed Result is more readable, doesn't add a dependency, and demonstrates
/// to interviewers that you understand the *pattern* — not just the package.
///
/// Usage in a Use Case:
/// ```dart
/// Future<Result<List<TransactionEntity>>> call() async {
///   try {
///     final data = await repository.getAllTransactions();
///     return Success(data);
///   } catch (e, s) {
///     return Error(DatabaseFailure('Failed to load transactions', stackTrace: s));
///   }
/// }
/// ```
///
/// Usage in a Bloc/Cubit:
/// ```dart
/// final result = await getTransactionsUseCase();
/// switch (result) {
///   case Success(:final data):
///     emit(TransactionsLoaded(data));
///   case Error(:final failure):
///     emit(TransactionsError(failure.message));
/// }
/// ```
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}
