import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

/// Use case: fetch every transaction.
///
/// WHY a use case for a plain delegating call? The domain layer owns the
/// *intent* ("give me all transactions"), so Blocs never talk to a repository
/// directly. When filtering, sorting or a date range is needed later, only this
/// file changes — the Bloc and the repository stay untouched.
@injectable
class GetTransactionsUseCase {
  final TransactionRepository _repository;

  const GetTransactionsUseCase(this._repository);

  Future<Result<List<TransactionEntity>>> call() =>
      _repository.getAllTransactions();
}
