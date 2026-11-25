import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/error/failure.dart';
import 'package:masroofy/core/localization/failure_localizer.dart';
import 'package:masroofy/l10n/app_localizations_ar.dart';
import 'package:masroofy/l10n/app_localizations_en.dart';

void main() {
  final en = AppLocalizationsEn();
  final ar = AppLocalizationsAr();

  // Deliberately recognizable so the test can prove it never leaks into the UI.
  const sentinel = 'DEVELOPER-ONLY-MESSAGE';

  // Every failure the presentation layer can receive.
  const failures = <Failure>[
    ValidationFailure(sentinel, code: ValidationCode.amountNotPositive),
    ValidationFailure(sentinel, code: ValidationCode.categoryEmpty),
    ValidationFailure(sentinel, code: ValidationCode.invalidId),
    DatabaseFailure(sentinel),
    UnexpectedFailure(sentinel),
  ];

  group('FailureLocalizer', () {
    for (final entry in {'English': en, 'Arabic': ar}.entries) {
      test('maps every failure to non-empty ${entry.key} text', () {
        for (final failure in failures) {
          final text = failure.localized(entry.value);

          expect(
            text,
            isNotEmpty,
            reason: '${failure.runtimeType} produced empty ${entry.key} text',
          );
        }
      });

      test('never exposes Failure.message in ${entry.key} text', () {
        for (final failure in failures) {
          expect(
            failure.localized(entry.value),
            isNot(contains(sentinel)),
            reason: '${failure.runtimeType} leaked its developer message',
          );
        }
      });
    }

    test('each validation code maps to a distinct English message', () {
      final messages = failures
          .whereType<ValidationFailure>()
          .map((failure) => failure.localized(en))
          .toList();

      expect(messages.toSet(), hasLength(ValidationCode.values.length));
    });
  });
}
