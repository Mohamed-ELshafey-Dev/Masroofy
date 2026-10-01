# مصروفي — Masroofy

> **Your personal finance tracker, powered by AI.**  
> Bilingual (Arabic + English) • Chat-style input • 100% offline

Masroofy is a mobile personal finance tracker designed for young Arabs. Type, speak, or photograph a receipt — AI fills in the rest. No accounts, no cloud, no subscriptions. Your money data stays on your device.

---

## ✨ Features (MVP)

| Screen | Description |
|--------|-------------|
| **Dashboard** | Balance overview, income vs expense chart, recent transactions |
| **Quick Add** | Chat-style input — type, voice, or camera → AI auto-categorizes |
| **Transactions** | Full list with search and filter |
| **Analytics** | Monthly bar chart, category pie chart |
| **Settings** | Language toggle (AR/EN), currency selector, dark/light mode |

## 🛠 Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter (Dart) |
| **Architecture** | Clean Architecture — feature-first |
| **State Management** | Bloc / Cubit |
| **Dependency Injection** | get_it + injectable |
| **Local Database** | Drift (SQLite) |
| **AI — NLP** | Google Gemini API |
| **AI — OCR** | Google ML Kit (on-device) |
| **Localization** | Flutter l10n (ARB files) — Arabic RTL + English LTR |
| **Charts** | fl_chart |
| **Testing** | flutter_test, bloc_test, hand-written fakes |
| **Design System** | [DESIGN-apple.md](DESIGN-apple.md) — single source of truth for color |

Color tokens live in `DESIGN-apple.md` and are mirrored into `AppTheme`; change the
design doc first, then the theme. The design system forbids red/green for
income vs. expense — sign, icon, and position carry that meaning instead.

## 🏗 Architecture

Target structure. Only `core/{database,error,theme,utils}`, `l10n`, and the
transactions `domain` + `data` layers have code today — the roadmap tracks the rest.

```
lib/
├── core/
│   ├── database/         # Drift database + table definitions
│   ├── error/            # Failure types, Result<T> sealed class
│   ├── theme/            # Light + dark ThemeData (mirrors DESIGN-apple.md)
│   ├── utils/            # Constants, enums, helpers
│   ├── ai/               # Gemini API, ML Kit wrappers
│   └── localization/     # Localization utilities
├── l10n/                 # ARB files + generated AppLocalizations
├── features/
│   ├── transactions/
│   │   ├── data/         # Repository implementations, models
│   │   ├── domain/       # Entities, repository contracts, use cases
│   │   └── presentation/ # Blocs, screens, widgets
│   ├── dashboard/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── analytics/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── quick_add/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── settings/
│       ├── data/
│       └── domain/
├── injection.dart        # DI setup (hand-written registrations)
├── injection.config.dart # DI graph — generated, do not edit
└── main.dart             # App entry point
```

The transactions repository queries Drift directly; a DAO/service layer is planned
rather than assumed.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.47.1 (stable)
- Dart ≥ 3.12.0

### Setup
```bash
# Clone the repository
git clone https://github.com/Mohamed-ELshafey-Dev/Masroofy.git
cd Masroofy

# Install dependencies
flutter pub get

# Run code generation (Drift + Injectable)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Run Tests
```bash
flutter test
```

### Static Analysis
```bash
flutter analyze
```

## 📸 Screenshots

> *Coming soon — screenshots will be added as screens are built.*

## 🗺 Roadmap

- [x] Project setup + Clean Architecture folder structure
- [x] Drift database schema
- [x] DI with get_it + injectable
- [x] Localization setup (Arabic + English)
- [x] Core scaffolding (error types, theme, constants)
- [x] Use Cases (transactions feature) — get, add, delete
- [ ] Bloc/Cubit state management
- [ ] Dashboard screen
- [ ] Quick Add screen (chat-style input)
- [ ] Transactions list screen
- [ ] Analytics screen
- [ ] Settings screen
- [ ] Gemini API integration
- [ ] ML Kit receipt scanner
- [ ] Testing suite
- [ ] Play Store deployment

## 👤 Author

**Mohamed Alshafei**  
- GitHub: [@Mohamed-ELshafey-Dev](https://github.com/Mohamed-ELshafey-Dev)

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
