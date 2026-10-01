import '../../../../core/error/result.dart';
import '../entities/transaction_entity.dart';

/// Contract boundary between the domain and data layers.
///
/// WHY every method returns `Result` instead of throwing:
/// - Callers are forced by the compiler to handle the failure path.
/// - A use case can never silently swallow a database error.
/// - The UI layer receives a structured [Failure] instead of a raw exception.
abstract class TransactionRepository {
  /// Returns every stored transaction, newest information preserved in the
  /// order the database yields it.
  Future<Result<List<TransactionEntity>>> getAllTransactions();

  /// Persists [transaction] and returns the id of the newly inserted row.
  Future<Result<int>> saveTransaction(TransactionEntity transaction);

  /// Updates the existing transaction identified by `transaction.id`.
  Future<Result<void>> updateTransaction(TransactionEntity transaction);

  /// Emits the full transaction list on every database change, newest first.
  ///
  /// WHY `Stream<Result<...>>` and not a plain stream: a stream lives longer
  /// than any single try/catch, so its failures arrive as events. Wrapping each
  /// emission keeps the same contract every other method has, and the Cubit can
  /// still exhaustively `switch` instead of using `onError`.
  Stream<Result<List<TransactionEntity>>> watchTransactions();

  /// Deletes the transaction identified by [id].
  Future<Result<void>> deleteTransaction(int id);
}
