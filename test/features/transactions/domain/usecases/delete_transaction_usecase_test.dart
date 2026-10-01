import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/error/failure.dart';
import 'package:masroofy/core/error/result.dart';
import 'package:masroofy/features/transactions/domain/usecases/delete_transaction_usecase.dart';

import '../../../../helpers/fake_transaction_repository.dart';

void main() {
  group('DeleteTransactionUseCase', () {
    late FakeTransactionRepository repository;
    late DeleteTransactionUseCase useCase;

    setUp(() {
      repository = FakeTransactionRepository();
      useCase = DeleteTransactionUseCase(repository);
    });

    test('rejects a zero id without touching the repository', () async {
      final result = await useCase(0);

      switch (result) {
        case Failed(:final failure):
          expect(failure, isA<ValidationFailure>());
        case Success():
          fail('expected a ValidationFailure, got a Success');
      }
      expect(
        repository.deleteCallCount,
        0,
        reason: 'an invalid id must never reach the database',
      );
    });

    test('rejects a negative id', () async {
      final result = await useCase(-7);

      switch (result) {
        case Failed(:final failure):
          expect(failure, isA<ValidationFailure>());
        case Success():
          fail('expected a ValidationFailure, got a Success');
      }
      expect(repository.deleteCallCount, 0);
    });

    test('delegates a valid id', () async {
      final result = await useCase(12);

      switch (result) {
        case Success():
          break;
        case Failed(:final failure):
          fail('unexpected failure: ${failure.message}');
      }
      expect(repository.deleteCallCount, 1);
      expect(repository.deletedId, 12);
    });

    test('propagates a repository failure', () async {
      repository.deleteResult = const Failed(DatabaseFailure('db is down'));

      final result = await useCase(12);

      switch (result) {
        case Failed(:final failure):
          expect(failure, isA<DatabaseFailure>());
        case Success():
          fail('expected the repository failure to surface');
      }
    });
  });
}
