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

  /// Fallible variant of [fromString] — returns `null` instead of throwing.
  ///
  /// WHY: rows read back from SQLite can hold corrupted or legacy values.
  /// Throwing there turns a data problem into a crash; returning `null` lets
  /// the data layer report it as a structured failure instead.
  static TransactionType? tryFromString(String value) {
    final normalized = value.toLowerCase();
    for (final type in values) {
      if (type.name == normalized) return type;
    }
    return null;
  }
}
