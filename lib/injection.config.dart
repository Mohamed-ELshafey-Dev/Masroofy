// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'core/database/app_database.dart' as _i111;
import 'features/transactions/data/repositories/transaction_repository_impl.dart'
    as _i298;
import 'features/transactions/domain/repositories/transaction_repository.dart'
    as _i783;
import 'features/transactions/domain/usecases/add_transaction_usecase.dart'
    as _i58;
import 'features/transactions/domain/usecases/delete_transaction_usecase.dart'
    as _i721;
import 'features/transactions/domain/usecases/get_transactions_usecase.dart'
    as _i666;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.lazySingleton<_i111.AppDatabase>(() => _i111.AppDatabase());
  gh.lazySingleton<_i783.TransactionRepository>(
    () => _i298.TransactionRepositoryImpl(gh<_i111.AppDatabase>()),
  );
  gh.factory<_i58.AddTransactionUseCase>(
    () => _i58.AddTransactionUseCase(gh<_i783.TransactionRepository>()),
  );
  gh.factory<_i721.DeleteTransactionUseCase>(
    () => _i721.DeleteTransactionUseCase(gh<_i783.TransactionRepository>()),
  );
  gh.factory<_i666.GetTransactionsUseCase>(
    () => _i666.GetTransactionsUseCase(gh<_i783.TransactionRepository>()),
  );
  return getIt;
}
