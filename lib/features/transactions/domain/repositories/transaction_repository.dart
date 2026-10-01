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

  /// Deletes the transaction identified by [id].
  Future<Result<void>> deleteTransaction(int id);
}
