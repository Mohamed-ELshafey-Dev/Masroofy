import 'package:equatable/equatable.dart';

import '../../../../core/utils/transaction_type.dart';

class TransactionEntity extends Equatable {
  final int? id;
  final double amount;
  final String? description;
  final String category;
  final TransactionType type;
  final DateTime date;
  final String? rawAiInput;

  const TransactionEntity({
    this.id,
    required this.amount,
    this.description,
    required this.category,
    required this.type,
    required this.date,
    this.rawAiInput,
  });

  @override
  List<Object?> get props => [
    id,
    amount,
    description,
    category,
    type,
    date,
    rawAiInput,
  ];
}
