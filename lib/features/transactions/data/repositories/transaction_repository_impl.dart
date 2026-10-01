import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/transaction_type.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';

// Register this implementation as the concrete driver for the abstract contract
@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase _db;

  TransactionRepositoryImpl(this._db);

  @override
  Future<Result<List<TransactionEntity>>> getAllTransactions() async {
    try {
      final List<Transaction> rows = await _db.select(_db.transactions).get();

      final entities = <TransactionEntity>[];
      for (final row in rows) {
        final type = TransactionType.tryFromString(row.type);
        if (type == null) {
          // Bad data is not a database outage — report it as its own failure so
          // the UI can tell "retry" apart from "your data is broken".
          return Failed(
            UnexpectedFailure(
              'Transaction ${row.id} has an unknown type "${row.type}"',
              stackTrace: StackTrace.current,
            ),
          );
        }
        entities.add(
          TransactionEntity(
            id: row.id,
            amount: row.amount,
            description: row.description,
            category: row.category,
            type: type,
            date: row.date,
            rawAiInput: row.rawAiInput,
          ),
        );
      }

      return Success(entities);
    } catch (e, s) {
      return Failed(
        DatabaseFailure('Failed to load transactions', stackTrace: s),
      );
    }
  }

  @override
  Future<Result<int>> saveTransaction(TransactionEntity transaction) async {
    try {
      final id = await _db
          .into(_db.transactions)
          .insert(
            TransactionsCompanion.insert(
              amount: transaction.amount,
              category: transaction.category,
              type: transaction.type.label,
              date: transaction.date,
              description: Value(transaction.description),
              rawAiInput: Value(transaction.rawAiInput),
            ),
          );
      return Success(id);
    } catch (e, s) {
      return Failed(
        DatabaseFailure('Failed to save transaction', stackTrace: s),
      );
    }
  }

  @override
  Future<Result<void>> updateTransaction(TransactionEntity transaction) async {
    final id = transaction.id;
    if (id == null) {
      return Failed(
        ValidationFailure('Cannot update a transaction without an id'),
      );
    }

    try {
      // Update writes every mutable column: the entity is the whole truth for
      // this row, so a field the caller cleared (e.g. an emptied description)
      // must be overwritten rather than left behind.
      final changed = await (_db.update(_db.transactions)
            ..where((t) => t.id.equals(id)))
          .write(
        TransactionsCompanion(
          amount: Value(transaction.amount),
          category: Value(transaction.category),
          type: Value(transaction.type.label),
          date: Value(transaction.date),
          description: Value(transaction.description),
          rawAiInput: Value(transaction.rawAiInput),
        ),
      );

      // Drift reports the affected row count and does NOT throw when nothing
      // matched — without this check a deleted row would look like success.
      if (changed == 0) {
        return Failed(
          UnexpectedFailure('No transaction found with id $id'),
        );
      }

      return const Success(null);
    } catch (e, s) {
      return Failed(
        DatabaseFailure('Failed to update transaction $id', stackTrace: s),
      );
    }
  }

  @override
  Future<Result<void>> deleteTransaction(int id) async {
    try {
      await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
      return const Success(null);
    } catch (e, s) {
      return Failed(
        DatabaseFailure('Failed to delete transaction $id', stackTrace: s),
      );
    }
  }
}
