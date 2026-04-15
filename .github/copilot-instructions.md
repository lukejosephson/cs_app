# Copilot Instructions for `cs_app`

## Build, test, and lint commands

Run from repository root:

- `flutter pub get` — install/update dependencies
- `flutter analyze` — run static analysis/lints (`flutter_lints` via `analysis_options.yaml`)
- `flutter test` — run all tests
- `flutter test <path/to/file_test.dart>` — run a single test file
- `flutter test <path/to/file_test.dart> --plain-name "<test name>"` — run a single named test
- `flutter run` — run the app locally
- `flutter build apk` / `flutter build ios` / `flutter build web` — build artifacts by target platform

## High-level architecture

- The repository has Flutter multi-platform scaffolding (`android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`) and dependency/lint config (`pubspec.yaml`, `analysis_options.yaml`).
- The Dart application layer is not yet populated (`lib/` and `test/` are currently empty), so upcoming feature work will define app entrypoints, state flow, and test structure.
- Product direction is captured in `REQUIREMENTS.md` (authentication + puzzle practice flows), which should drive how new modules are organized.

## Key conventions for this repository

- Use the Flutter lint baseline (`analysis_options.yaml` includes `package:flutter_lints/flutter.yaml`) unless a change is explicitly justified.
- Keep feature code modular and responsibilities separated as noted in `REQUIREMENTS.md`: avoid oversized widgets and separate UI from data model concerns.
- Project guidance in `PROMPTS.md` and `REQUIREMENTS.md` expects architecture to evolve toward separated layers (`models`, `services`, `providers`, `screens`, `widgets`) and to add tests for each feature in `test/`.

## Development Rules

1. Always commit the current code before implementing a new feature.
2. State Management: Use flutter_riverpod exclusively. Do not use setState for complex logic.
3. Architecture: Maintain strict separation of concerns:
● /models: Pure Dart data classes (use json_serializable or freezed if helpful).
● /services: Backend/API communication only. No UI code.
● /providers: Riverpod providers linking services to the UI.
● /screens & /widgets: UI only. Keep files small. Extract complex widgets into their own files.
4. Local Storage: Use shared_preferences for local app state (e.g., theme toggles, onboarding
status).
5. Database: Use [Firebase Firestore OR PostgreSQL] for persistent cloud data.
6. Stepwise Execution: Only implement the specific step requested in the prompt. Do not jump ahead.
7. Explain-First Policy: Before providing code, Gemini must briefly explain the architectural pattern chosen and why it is the standard approach for Flutter/Riverpod.
8. Commit Message Generation: After generating a successful code block, Gemini should suggest a concise Git commit message following the format: Feature Name: Short Description (Ref: Prompt #[X]).
9. Refactor Alert: If Gemini identifies a widget or logic block that could be made reusable, it must stop and suggest a refactor into the /widgets or /services folder before continuing with the UI.