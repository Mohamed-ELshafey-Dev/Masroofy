import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../repositories/transaction_repository.dart';

/// Use case: delete a transaction by id.
///
/// Guards against a non-positive id so a bug upstream (an uninitialised
/// nullable id, an off-by-one list index) fails loudly here instead of
/// silently matching nothing in the database.
@injectable
class DeleteTransactionUseCase {
  final TransactionRepository _repository;

  const DeleteTransactionUseCase(this._repository);

  Future<Result<void>> call(int id) async {
    if (id <= 0) {
      return Failed(
        ValidationFailure('Invalid transaction id: $id'),
      );
    }

    return _repository.deleteTransaction(id);
  }
}
