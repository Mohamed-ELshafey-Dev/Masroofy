/// App-wide constants for Masroofy.
///
/// WHY centralize constants?
/// - Hardcoded strings scattered across files are impossible to maintain.
/// - When you need to add a category or change the default currency,
///   you change ONE file — not grep through 30 widgets.
/// - In interviews: "Where do you keep magic strings?" → "I don't use them."
abstract final class AppConstants {
  /// App metadata
  static const String appName = 'Masroofy';
  static const String appNameAr = 'مصروفي';
  static const String appVersion = '1.0.0';

  /// Default currency codes — ISO 4217
  static const String defaultCurrency = 'EGP';
  static const List<String> supportedCurrencies = [
    'EGP', // Egyptian Pound
    'SAR', // Saudi Riyal
    'USD', // US Dollar
    'AED', // UAE Dirham
    'KWD', // Kuwaiti Dinar
  ];

  /// Default spending categories with emoji identifiers.
  /// These are used as defaults — users can customize later in premium.
  static const List<String> defaultCategories = [
    '🍔 Food & Drinks',
    '🚗 Transport',
    '🏠 Rent & Housing',
    '📱 Bills & Subscriptions',
    '🛒 Shopping',
    '💊 Health',
    '🎓 Education',
    '🎮 Entertainment',
    '💰 Salary',
    '📈 Investments',
    '🎁 Gifts',
    '❓ Other',
  ];

  /// Arabic category names — mapped 1:1 with [defaultCategories].
  static const List<String> defaultCategoriesAr = [
    '🍔 أكل ومشروبات',
    '🚗 مواصلات',
    '🏠 إيجار وسكن',
    '📱 فواتير واشتراكات',
    '🛒 تسوق',
    '💊 صحة',
    '🎓 تعليم',
    '🎮 ترفيه',
    '💰 مرتب',
    '📈 استثمارات',
    '🎁 هدايا',
    '❓ أخرى',
  ];
}
