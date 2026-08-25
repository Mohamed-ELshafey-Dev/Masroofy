// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مصروفي';

  @override
  String get dashboard => 'الرئيسية';

  @override
  String get transactions => 'المعاملات';

  @override
  String get analytics => 'التحليلات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get quickAdd => 'إضافة سريعة';

  @override
  String get income => 'دخل';

  @override
  String get expense => 'مصروف';

  @override
  String get balance => 'الرصيد';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي المصروفات';

  @override
  String get noTransactions => 'لا توجد معاملات بعد';

  @override
  String get addTransaction => 'إضافة معاملة';

  @override
  String get deleteTransaction => 'حذف المعاملة';

  @override
  String get confirmDelete => 'هل أنت متأكد من حذف هذه المعاملة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get save => 'حفظ';

  @override
  String get amount => 'المبلغ';

  @override
  String get category => 'الفئة';

  @override
  String get description => 'الوصف';

  @override
  String get date => 'التاريخ';

  @override
  String get language => 'اللغة';

  @override
  String get currency => 'العملة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get monthly => 'شهري';

  @override
  String get weekly => 'أسبوعي';

  @override
  String get typeMessage => 'اكتب مصروفك...';

  @override
  String get transactionSaved => 'تم حفظ المعاملة!';

  @override
  String get transactionDeleted => 'تم حذف المعاملة';

  @override
  String get errorOccurred => 'حدث خطأ ما';
}
