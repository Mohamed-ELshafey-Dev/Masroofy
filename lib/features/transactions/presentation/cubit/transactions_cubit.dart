import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/result.dart';
import '../../domain/usecases/delete_transaction_usecase.dart';
import '../../domain/usecases/get_transactions_usecase.dart';
import 'transactions_state.dart';

/// Manages transaction list state.
///
/// Zero business logic lives here. The Cubit's only job is to call
/// use cases and map their [Result] to the appropriate [TransactionsState].
///
/// WHY `@injectable` (factory) and not `@lazySingleton`:
/// Cubits are tied to a widget's lifecycle. A singleton would survive
/// navigation and leak stale state across screens.
@injectable
class TransactionsCubit extends Cubit<TransactionsState> {
  final GetTransactionsUseCase _getTransactions;
  final DeleteTransactionUseCase _deleteTransaction;

  TransactionsCubit(this._getTransactions, this._deleteTransaction)
      : super(const TransactionsInitial());

  /// Fetches all transactions and emits the appropriate state.
  Future<void> load() async {
    emit(const TransactionsLoading());

    final result = await _getTransactions();

    switch (result) {
      case Success(:final data):
        emit(data.isEmpty
            ? const TransactionsEmpty()
            : TransactionsLoaded(data));
      case Failed(:final failure):
        emit(TransactionsError(failure));
    }
  }

  /// Deletes the transaction identified by [id], then reloads the list.
  ///
  /// On failure the error is emitted and the existing list is left as-is —
  /// the user sees an error overlay but doesn't lose their data.
  Future<void> delete(int id) async {
    final result = await _deleteTransaction(id);

    switch (result) {
      case Success():
        await load();
      case Failed(:final failure):
        emit(TransactionsError(failure));
    }
  }
}
