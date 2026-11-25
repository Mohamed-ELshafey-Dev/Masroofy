import '../../l10n/app_localizations.dart';
import '../error/failure.dart';

/// Turns a domain [Failure] into user-facing, localized text.
///
/// WHY this lives in the presentation-facing core layer and not in domain:
/// the domain layer has no `BuildContext` and must not import Flutter, so it
/// can only return a machine-readable failure. This extension is the single
/// place where that failure becomes copy.
///
/// [Failure.message] is developer-facing/log text and is deliberately never
/// read here — leaking it would show English (or raw ids) in the Arabic UI.
extension FailureLocalizer on Failure {
  String localized(AppLocalizations l10n) => switch (this) {
    ValidationFailure(:final code) => switch (code) {
      ValidationCode.amountNotPositive => l10n.validationAmountNotPositive,
      ValidationCode.categoryEmpty => l10n.validationCategoryEmpty,
      ValidationCode.invalidId => l10n.validationInvalidId,
    },
    DatabaseFailure() => l10n.errorCouldNotComplete,
    UnexpectedFailure() => l10n.errorOccurred,
  };
}
