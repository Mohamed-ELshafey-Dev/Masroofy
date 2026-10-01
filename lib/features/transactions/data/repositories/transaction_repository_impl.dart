import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/transaction_type.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';

// Register this implementation as the concrete driver for the abstract contract
@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase _db;

  TransactionRepositoryImpl(this._db);

  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    final List<Transaction> rows = await _db.select(_db.transactions).get();

    return rows
        .map(
          (row) => TransactionEntity(
            id: row.id,
            amount: row.amount,
            description: row.description,
            category: row.category,
            type: TransactionType.fromString(row.type),
            date: row.date,
            rawAiInput: row.rawAiInput,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    await _db
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
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }
}
