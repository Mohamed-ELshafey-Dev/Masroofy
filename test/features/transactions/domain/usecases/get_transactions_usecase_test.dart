import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/error/failure.dart';
import 'package:masroofy/core/error/result.dart';
import 'package:masroofy/core/utils/transaction_type.dart';
import 'package:masroofy/features/transactions/domain/entities/transaction_entity.dart';
import 'package:masroofy/features/transactions/domain/usecases/get_transactions_usecase.dart';

import '../../../../helpers/fake_transaction_repository.dart';

void main() {
  group('GetTransactionsUseCase', () {
    late FakeTransactionRepository repository;
    late GetTransactionsUseCase useCase;

    setUp(() {
      repository = FakeTransactionRepository();
      useCase = GetTransactionsUseCase(repository);
    });

    test('returns the transactions the repository produced', () async {
      repository.getAllResult = Success([_entity()]);

      final result = await useCase();

      switch (result) {
        case Success(:final data):
          expect(data, hasLength(1));
          expect(data.single.amount, 50);
        case Failed(:final failure):
          fail('unexpected failure: ${failure.message}');
      }
      expect(repository.getAllCallCount, 1);
    });

    test('returns an empty list when nothing is stored', () async {
      final result = await useCase();

      switch (result) {
        case Success(:final data):
          expect(data, isEmpty);
        case Failed(:final failure):
          fail('unexpected failure: ${failure.message}');
      }
    });

    test('propagates a repository failure', () async {
      repository.getAllResult = const Failed(DatabaseFailure('db is down'));

      final result = await useCase();

      switch (result) {
        case Failed(:final failure):
          expect(failure, isA<DatabaseFailure>());
        case Success():
          fail('expected the repository failure to surface');
      }
    });
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
