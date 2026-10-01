import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

/// Use case: validate and persist a new transaction.
///
/// WHY validation lives here and not in the UI: a widget can be bypassed —
/// deep links, AI-parsed input, integration tests and future migrations all
/// write transactions. Business rules belong in the domain layer so every
/// entry point is guarded by the same rules.
@injectable
class AddTransactionUseCase {
  final TransactionRepository _repository;

  const AddTransactionUseCase(this._repository);

  /// Returns the id of the inserted row, or a [ValidationFailure] when
  /// [transaction] breaks a business rule.
  Future<Result<int>> call(TransactionEntity transaction) async {
    if (transaction.amount <= 0) {
      return Failed(
        ValidationFailure('Amount must be greater than zero'),
      );
    }

    if (transaction.category.trim().isEmpty) {
      return Failed(
        ValidationFailure('Category cannot be empty'),
      );
    }

    return _repository.saveTransaction(transaction);
  }
}
