/// Transaction type — income or expense.
///
/// WHY an enum instead of a String?
/// - A String allows 'Expense', 'expenSE', 'debit', or any typo.
/// - An enum is checked at compile time. If you try `TransactionType.salary`,
///   the compiler errors immediately.
/// - The `label` getter gives you the DB-safe lowercase string for Drift storage.
/// - Companies expect enum-driven domain models. Raw strings = junior code.
enum TransactionType {
  income,
  expense;

  /// Returns a lowercase label for database storage.
  String get label => name;

  /// Parses a string from the database back to the enum.
  /// Throws [ArgumentError] if the value doesn't match — fail fast, don't hide bugs.
  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown TransactionType: $value'),
    );
  }
}
