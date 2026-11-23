import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/error/failure.dart';
import 'package:masroofy/core/error/result.dart';
import 'package:masroofy/core/utils/transaction_type.dart';
import 'package:masroofy/features/transactions/domain/entities/transaction_entity.dart';
import 'package:masroofy/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:masroofy/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:masroofy/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:masroofy/features/transactions/presentation/cubit/transactions_state.dart';

import '../../../../helpers/fake_transaction_repository.dart';

void main() {
  late FakeTransactionRepository repository;
  late GetTransactionsUseCase getTransactions;
  late DeleteTransactionUseCase deleteTransaction;

  setUp(() {
    repository = FakeTransactionRepository();
    getTransactions = GetTransactionsUseCase(repository);
    deleteTransaction = DeleteTransactionUseCase(repository);
  });

  TransactionsCubit buildCubit() =>
      TransactionsCubit(getTransactions, deleteTransaction);

  group('TransactionsCubit', () {
    blocTest<TransactionsCubit, TransactionsState>(
      'load emits [Loading, Loaded] when repository returns data',
      build: () {
        repository.getAllResult = Success([_entity()]);
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const TransactionsLoading(),
        isA<TransactionsLoaded>()
            .having((s) => s.transactions, 'transactions', hasLength(1)),
      ],
    );

    blocTest<TransactionsCubit, TransactionsState>(
      'load emits [Loading, Empty] when repository returns []',
      build: () => buildCubit(),
      act: (cubit) => cubit.load(),
      expect: () => [
        const TransactionsLoading(),
        const TransactionsEmpty(),
      ],
    );

    blocTest<TransactionsCubit, TransactionsState>(
      'load emits [Loading, Error] when repository fails',
      build: () {
        repository.getAllResult =
            const Failed(DatabaseFailure('db is down'));
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const TransactionsLoading(),
        isA<TransactionsError>()
            .having((s) => s.failure, 'failure', isA<DatabaseFailure>()),
      ],
    );

    blocTest<TransactionsCubit, TransactionsState>(
      'delete reloads on success',
      build: () => buildCubit(),
      act: (cubit) => cubit.delete(1),
      expect: () => [
        // load() is called after successful delete
        const TransactionsLoading(),
        const TransactionsEmpty(),
      ],
      verify: (_) {
        expect(repository.deleteCallCount, 1);
        expect(repository.deletedId, 1);
        expect(repository.getAllCallCount, 1);
      },
    );

    blocTest<TransactionsCubit, TransactionsState>(
      'delete emits Error on failure without Loading',
      build: () {
        repository.deleteResult =
            const Failed(DatabaseFailure('delete failed'));
        return buildCubit();
      },
      act: (cubit) => cubit.delete(1),
      expect: () => [
        isA<TransactionsError>()
            .having((s) => s.failure, 'failure', isA<DatabaseFailure>()),
      ],
      verify: (_) {
        // load() was never called — getAllCallCount stays 0
        expect(repository.getAllCallCount, 0);
      },
    );
  });
}

TransactionEntity _entity({double amount = 50}) {
  return TransactionEntity(
    id: 1,
    amount: amount,
    category: 'Food',
    type: TransactionType.expense,
    date: DateTime(2026, 8, 25),
  );
}
