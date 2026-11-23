import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/transaction_entity.dart';

/// State contract for [TransactionsCubit].
///
/// WHY sealed: the Dart 3 compiler forces every `switch` to handle each
/// subclass. If a new state is added later, every screen that reads
/// transaction state gets a compile error until it handles it.
///
/// WHY `TransactionsEmpty` instead of `TransactionsLoaded([])`:
/// - The Cubit decides "no data" once. With `Loaded([])`, every consumer
///   re-implements `if (list.isEmpty)` — and the Dashboard and Transactions
///   screen will drift apart.
/// - A sealed class forces the UI `switch` to handle empty explicitly.
/// - The cost is one extra class. The gain is testability and exhaustiveness.
sealed class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any load has been attempted.
class TransactionsInitial extends TransactionsState {
  const TransactionsInitial();
}

/// A load or delete operation is in progress.
class TransactionsLoading extends TransactionsState {
  const TransactionsLoading();
}

/// The repository returned an empty list.
class TransactionsEmpty extends TransactionsState {
  const TransactionsEmpty();
}

/// The repository returned at least one transaction.
class TransactionsLoaded extends TransactionsState {
  final List<TransactionEntity> transactions;

  const TransactionsLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

/// An operation failed. Holds the [Failure] itself — not a pre-formatted
/// message — so the UI layer can pick localized text (Phase 5).
class TransactionsError extends TransactionsState {
  final Failure failure;

  const TransactionsError(this.failure);

  @override
  List<Object?> get props => [failure];
}
