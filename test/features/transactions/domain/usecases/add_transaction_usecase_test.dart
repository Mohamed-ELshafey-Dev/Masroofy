import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/error/failure.dart';
import 'package:masroofy/core/error/result.dart';
import 'package:masroofy/core/utils/transaction_type.dart';
import 'package:masroofy/features/transactions/domain/entities/transaction_entity.dart';
import 'package:masroofy/features/transactions/domain/usecases/add_transaction_usecase.dart';

import '../../../../helpers/fake_transaction_repository.dart';

/// Validation lives in the use case, not the widget — these tests are the only
/// thing standing between a bad input and the database, so every guard branch
/// gets a case.
void main() {
  group('AddTransactionUseCase', () {
    late FakeTransactionRepository repository;
    late AddTransactionUseCase useCase;

    setUp(() {
      repository = FakeTransactionRepository();
      useCase = AddTransactionUseCase(repository);
    });

    test('rejects a zero amount without touching the repository', () async {
      final result = await useCase(_entity(amount: 0));

      switch (result) {
        case Failed(:final failure):
          expect(failure, isA<ValidationFailure>());
        case Success():
          fail('expected a ValidationFailure, got a Success');
      }
      expect(
        repository.saveCallCount,
        0,
        reason: 'invalid input must never reach the database',
      );
    });

    test('rejects a negative amount', () async {
      final result = await useCase(_entity(amount: -12.5));

      switch (result) {
        case Failed(:final failure):
          expect(failure, isA<ValidationFailure>());
        case Success():
          fail('expected a ValidationFailure, got a Success');
      }
      expect(repository.saveCallCount, 0);
    });

    test('rejects a blank category', () async {
      final result = await useCase(_entity(category: '   '));

      switch (result) {
        case Failed(:final failure):
          expect(failure, isA<ValidationFailure>());
        case Success():
          fail('expected a ValidationFailure, got a Success');
      }
      expect(repository.saveCallCount, 0);
    });

    test('delegates a valid transaction and returns the new row id', () async {
      repository.saveResult = const Success(42);
      final entity = _entity();

      final result = await useCase(entity);

      switch (result) {
        case Success(:final data):
          expect(data, 42);
        case Failed(:final failure):
          fail('unexpected failure: ${failure.message}');
      }
      expect(repository.saveCallCount, 1);
      expect(
        repository.savedTransaction,
        entity,
        reason: 'the use case must pass the entity through untouched',
      );
    });

    test('propagates a repository failure instead of masking it', () async {
      repository.saveResult = const Failed(DatabaseFailure('db is down'));

      final result = await useCase(_entity());

      switch (result) {
        case Failed(:final failure):
          expect(failure, isA<DatabaseFailure>());
        case Success():
          fail('expected the repository failure to surface');
      }
    });
  });
}

TransactionEntity _entity({
  double amount = 50,
  String category = 'Food',
}) {
  return TransactionEntity(
    id: 1,
    amount: amount,
    category: category,
    type: TransactionType.expense,
    date: DateTime(2026, 8, 25),
  );
}
