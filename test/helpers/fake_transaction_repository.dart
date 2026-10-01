import 'package:masroofy/core/error/result.dart';
import 'package:masroofy/features/transactions/domain/entities/transaction_entity.dart';
import 'package:masroofy/features/transactions/domain/repositories/transaction_repository.dart';

/// Hand-written stand-in for [TransactionRepository], shared by the use case
/// tests.
///
/// WHY a fake and not a Mockito mock: the project has no `mockito_generator`,
/// so `@GenerateNiceMocks` would drag a codegen step into the test suite. A
/// fake also records the arguments it was called with, which is what lets these
/// tests assert *delegation* — that a use case passed the right entity through
/// untouched — rather than only checking the returned value.
class FakeTransactionRepository implements TransactionRepository {
  FakeTransactionRepository({
    this.getAllResult,
    this.saveResult,
    this.deleteResult,
  });

  /// Canned responses. Each falls back to a success when left null, so a test
  /// only has to set the one it actually cares about.
  Result<List<TransactionEntity>>? getAllResult;
  Result<int>? saveResult;
  Result<void>? deleteResult;

  /// Recorded calls, for assertions.
  int getAllCallCount = 0;
  int saveCallCount = 0;
  int deleteCallCount = 0;
  TransactionEntity? savedTransaction;
  int? deletedId;

  @override
  Future<Result<List<TransactionEntity>>> getAllTransactions() async {
    getAllCallCount++;
    return getAllResult ?? const Success(<TransactionEntity>[]);
  }

  @override
  Future<Result<int>> saveTransaction(TransactionEntity transaction) async {
    saveCallCount++;
    savedTransaction = transaction;
    return saveResult ?? const Success(1);
  }

  @override
  Future<Result<void>> deleteTransaction(int id) async {
    deleteCallCount++;
    deletedId = id;
    return deleteResult ?? const Success(null);
  }
}
