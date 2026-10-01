# AGENT_INSTRUCTIONS.md

Working agreements for AI agents (and humans) touching this repository.
Read this before editing anything.

---

## Project

**Masroofy (مصروفي)** — bilingual (Arabic RTL / English LTR) personal finance
tracker. 100% offline, AI-assisted transaction entry. Flutter + Bloc + Drift.

Current phase: **Phase 1 — Clean Architecture** (per the career roadmap).

---

## Commands

```bash
flutter pub get                                          # also runs gen-l10n
dart run build_runner build --delete-conflicting-outputs # AFTER any @injectable/@DriftDatabase change
flutter analyze                                          # must be clean before commit
flutter test                                             # must pass before commit
flutter run
```

---

## Hard rules

1. **Never hand-edit generated files.** They are overwritten by codegen:
   - `lib/injection.config.dart`
   - `lib/core/database/app_database.g.dart`
   - `lib/l10n/app_localizations*.dart`
2. **Run `build_runner` after adding or changing any annotation**
   (`@injectable`, `@LazySingleton`, `@DriftDatabase`, `@freezed`).
3. **Verify before committing**: `flutter analyze` + `flutter test`.
4. **Atomic commits** — one logical change per commit. If a diff does not match
   its message, split it. Conventional Commit prefixes: `feat:`, `fix:`,
   `refactor:`, `chore:`, `docs:`, `test:`.
5. **Push only after the commit is verified and lands** (`git log --oneline -3`).

---

## Architecture

```
presentation (bloc/cubit, screens, widgets)
        ↓ depends on
domain       (entities, repository contracts, use cases)   ← knows nothing about data
        ↑ depends on
data         (repository impls, drift tables, models)
```

- **Dependency rule**: `domain` must never import `data` or `presentation`.
  `data` implements the contracts `domain` declares.
- Entities are pure Dart (`Equatable`), no Drift types, no JSON.
- Feature-first layout: `lib/features/<feature>/{data,domain,presentation}`.

---

## Conventions

**Error handling — never throw across a layer boundary**

```dart
sealed class Result<T> {}          // Success<T> | Failed<T>
sealed class Failure {}            // DatabaseFailure | ValidationFailure | UnexpectedFailure
```

- Repository methods return `Future<Result<T>>` and wrap DB work in
  `try/catch` → `Failed(DatabaseFailure(..., stackTrace: s))`.
- Use cases validate input first → `Failed(ValidationFailure(...))`, then delegate.
- Consumers `switch` on the result — the compiler enforces exhaustiveness.
- Corrupt/unknown DB values → `UnexpectedFailure`, not `DatabaseFailure`.

**Enums over strings**

`TransactionType { income, expense }` lives in `lib/core/utils/transaction_type.dart`.
The Drift column stays `text()`: write `type.label`, read with
`TransactionType.tryFromString(...)` (returns `null` instead of throwing).

**Dependency injection**

- Annotate the concrete class: `@LazySingleton(as: TransactionRepository)` for
  repositories/singletons, `@injectable` for use cases.
- Register the root via `configureDependencies()` in `lib/injection.dart`.

**Localization**

- Every user-facing string lives in `lib/l10n/app_en.arb` + `app_ar.arb`.
- Read with `AppLocalizations.of(context)!`. Never hardcode strings in widgets.
- `l10n.yaml` points at `lib/l10n`; regenerate via `flutter pub get`.

**Theming**

- Use `Theme.of(context)` and `AppTheme.light` / `AppTheme.dark`.
- Semantic money colors: `AppTheme.incomeColor` / `AppTheme.expenseColor`.
- No inline `Color(0x...)` in widgets.

---

## Known debt (do not "fix" casually — each has an owning phase)

| Debt | Phase |
|---|---|
| `AppDatabase` hardcodes its `QueryExecutor` in the constructor → no in-memory DB tests | 6 |
| `category` is free text; roadmap wants `CategoriesTable` + FK + `BudgetsTable` | 3 |
| No Android permissions yet (`INTERNET`, `CAMERA`, `RECORD_AUDIO`); iOS usage descriptions missing | 4 |
| No `updateTransaction` and no `watchTransactions()` stream — needed before Bloc | 2 |
| `AppTheme` green `#2E7D32` vs `DESIGN-apple.md` blue `#0066cc` — one source of truth not chosen | 5 |
| No `MigrationStrategy`; `schemaVersion` is 1 and nothing has shipped yet | 3 |
| No GitHub Actions CI workflow (deferred from Phase 0) | 7 |
| `pubspec.yaml` description is still the Flutter placeholder | 8 |

---

## Layout

```
lib/
├── core/
│   ├── ai/            → Gemini client, ML Kit wrapper      (empty — Phase 4)
│   ├── database/      → Drift schema + generated code
│   ├── error/         → Failure hierarchy, Result<T>
│   ├── localization/  → locale helpers                    (empty — Phase 5)
│   ├── theme/         → AppTheme light/dark
│   └── utils/         → constants, TransactionType
├── features/<feature>/{data,domain,presentation}
├── l10n/              → ARB sources + generated localizations
├── injection.dart     → configureDependencies()
└── main.dart          → MasroofyApp
```

`session_state.md` tracks where the work currently stands — update it last,
after the code commits are pushed.
