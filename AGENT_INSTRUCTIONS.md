# AGENT_INSTRUCTIONS.md

Working agreements for AI agents (and humans) touching this repository.
Read this before editing anything.

> Last verified against the repo at commit `84b3fb2`. If the code and this file
> disagree, the code wins — then fix this file in the same PR.

---

## Project

**Masroofy (مصروفي)** — bilingual (Arabic RTL / English LTR) personal finance
tracker. 100% offline, AI-assisted transaction entry. Flutter + Bloc + Drift.

Current phase: **Phase 2 — State management (Bloc/Cubit)** per the career roadmap.

- Done: `transactions` feature domain + data layers, three use cases,
  `TransactionsState` + `TransactionsCubit`, bloc tests.
- Not started: any screen/widget UI, categories feature, Quick Add, Analytics,
  Settings, AI (Gemini / ML Kit).
- The receipt-scan feature is postponed; voice input is post-V1. Do not start them.

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
6. **Uncommitted code does not exist.** Progress claims are verified against the
   committed repo, not against `session_state.md` or local-only folders.
7. **Don't make product/architecture decisions silently.** Items under
   "Open decisions" below belong to the owner — propose options, don't pick.

---

## Architecture

```
presentation (cubit/bloc, screens, widgets)
        ↓ depends on
domain       (entities, repository contracts, use cases)   ← knows nothing about data
        ↑ depends on
data         (repository impls, drift tables, models)
```

- **Dependency rule**: `domain` must never import `data` or `presentation`.
  `data` implements the contracts `domain` declares.
- Entities are pure Dart (`Equatable`), no Drift types, no JSON.
- Feature-first layout: `lib/features/<feature>/{data,domain,presentation}`.
- Presentation talks to **use cases only**, never to a repository directly.

---

## Conventions

### Error handling — never throw across a layer boundary

```dart
sealed class Result<T> {}          // Success<T> | Failed<T>
sealed class Failure {}            // DatabaseFailure | ValidationFailure | UnexpectedFailure
```

- Repository methods return `Future<Result<T>>` and wrap DB work in
  `try/catch` → `Failed(DatabaseFailure(..., stackTrace: s))`.
- Use cases validate input first → `Failed(ValidationFailure(...))`, then delegate.
- Consumers `switch` on the result — the compiler enforces exhaustiveness.
- Corrupt/unknown DB values → `UnexpectedFailure`, not `DatabaseFailure`.

### Enums over strings

`TransactionType { income, expense }` lives in `lib/core/utils/transaction_type.dart`.
The Drift column stays `text()`: write `type.label`, read with
`TransactionType.tryFromString(...)` (returns `null` instead of throwing).

### State management (Bloc/Cubit)

- States are **sealed** classes extending `Equatable`. Every `switch` over a
  state must be exhaustive — no `default:`.
- Explicit variants over flags: `Initial`, `Loading`, `Empty`, `Loaded`, `Error`.
  "No data" is decided once, in the Cubit (`Empty`), not re-checked in widgets.
- **Error states hold the `Failure` object, not a formatted string**, so the UI
  can pick localized text (Phase 5).
- Cubits contain **zero business logic**: call a use case, map `Result` → state.
  Validation and rules belong in use cases.
- Cubits are `@injectable` (factory), never singletons — they are tied to a
  widget's lifecycle.

### Dependency injection

- Annotate the concrete class: `@LazySingleton(as: TransactionRepository)` for
  repositories/singletons, `@injectable` for use cases and cubits.
- Register the root via `configureDependencies()` in `lib/injection.dart`.

### Localization

- Every user-facing string lives in `lib/l10n/app_en.arb` + `app_ar.arb`.
- Read with `AppLocalizations.of(context)!`. Never hardcode strings in widgets.
- `l10n.yaml` points at `lib/l10n`; regenerate via `flutter pub get`.
- Layout must be RTL-safe from day one: prefer directional primitives
  (`EdgeInsetsDirectional`, `AlignmentDirectional`, `Directionality`) over
  hardcoded left/right. Arabic text runs 20–30% longer than English — test fixed-width
  widgets with the Arabic string.

### Design system

`DESIGN-apple.md` is the **single source of truth** for UI. Read it before
building any screen or widget.

- Use `Theme.of(context)` and `AppTheme.light` / `AppTheme.dark`. No inline
  `Color(0x...)` in widgets.
- **One accent color only**: Action Blue `#0066CC` (dark mode `#2997FF`).
- **No red/green income-vs-expense coding.** There is no `incomeColor` /
  `expenseColor` in this project — do not invent them. Distinguish transaction
  types with sign, label, and icon, not hue.
- The error color is reserved for validation and destructive actions only.
- Secondary text uses `ink-secondary` (`#6E6E73` light / `#98989D` dark), never
  `ink-muted-48`.
- Touch targets are at least 44×44 on every tappable element.
- Typography: SF Pro + Cairo for Arabic. Numerals stay Western digits (`123`).
- Charts: category charts carry visible text labels; time-axis charts do **not**
  mirror in RTL.

### UI reference workflow

Visual references are generated with **Google Stitch** before Flutter
implementation. Always include the `DESIGN-apple.md` constraints in the prompt
(single accent, no shadows/gradients, RTL-first, Arabic copy) and request both
light and dark variants. A reference is for layout and hierarchy only — never
copy generated code; implement in Flutter on top of the layers above.

### Testing

- Use hand-written fakes (see `test/helpers/fake_transaction_repository.dart`),
  not generated Mockito mocks — the project has no mock codegen step. Fakes also
  record call arguments so tests can assert delegation.
- Use cases: test validation failures *and* delegation.
- Cubits: `bloc_test` for every state transition, success and failure paths.
- Tests mirror the `lib/` structure under `test/`.

---

## Open decisions (owner: Mohamed — do not resolve unilaterally)

| Decision | Context |
|---|---|
| Shape of `TransactionsCubit.delete` outcome | On failure it emits `TransactionsError`, replacing the list state, so the list is lost from state. On success `load()` emits `Loading`, flashing a full-screen spinner. The existing doc comment claiming the list is "left as-is" is inaccurate until this is decided. |
| Where transaction ordering lives | `142ecf7` removed `orderBy date desc` from `getAllTransactions`; it currently returns DB order. Dashboard "recent transactions" needs a defined order. Repository vs use case is undecided. |
| Cross-screen refresh | Cubits are factories, so one screen saving a transaction does not notify another. `watchTransactions` was reverted in `142ecf7`; no replacement mechanism is chosen yet. |

---

## Known debt (each has an owning phase)

| Debt | Phase |
|---|---|
| `AppDatabase` hardcodes its `QueryExecutor` in the constructor → no in-memory DB tests (repository impl is untested) | 6 |
| `category` is free text; roadmap wants `CategoriesTable` + FK + `BudgetsTable` | 3 |
| No `MigrationStrategy`; `schemaVersion` is 1 and nothing has shipped yet | 3 |
| No Android permissions yet (`INTERNET`, `CAMERA`, `RECORD_AUDIO`); iOS usage descriptions missing | 4 |
| No GitHub Actions CI workflow (deferred from Phase 0) | 7 |
| `pubspec.yaml` description is still the Flutter placeholder | 8 |
| `main.dart` still shows `_PlaceholderHome`; no screen consumes `TransactionsCubit` yet | 2 |

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
├── features/transactions/
│   ├── data/repositories/        → TransactionRepositoryImpl
│   ├── domain/{entities,repositories,usecases}/
│   └── presentation/cubit/       → TransactionsCubit + TransactionsState
├── l10n/              → ARB sources + generated localizations
├── injection.dart     → configureDependencies()
└── main.dart          → MasroofyApp
test/
├── helpers/           → shared fakes
└── features/transactions/{domain/usecases,presentation/cubit}/
```

`session_state.md` (repo root) tracks where the work currently stands — update it
last, after the code commits are pushed. It is a secondary signal; the committed
code is the ground truth.