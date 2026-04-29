# Summary of changes made by CLI coding assistants

## Prompt 22
- Added `lib/models/loop_challenge.dart` with the Firestore puzzle schema fields so loop/error challenge content can be represented as a typed model in the app.

## Prompt 23
- Added a Firestore-aware `fromFirestore` constructor to `LoopChallenge` (plus mapping helpers), so puzzle documents can be safely converted into model instances.

## Prompt 24
- Investigated iOS launch failures and identified root-cause areas instead of changing code immediately, matching the “diagnose first” request.

## Prompt 25
- Applied iOS Firebase/CocoaPods fixes and confirmed iOS build stability so local development could continue on simulator/device.

## Prompt 26
- Added regression tests for account-creation flows (success path and timeout/failure handling) to prevent previously fixed auth issues from reappearing.

## Prompt 27
- Verified `lib/models/loop_challenge.dart` already existed and matched required fields/factory requirements, so no functional model changes were needed.

## Prompt 28
- Extended `DatabaseService` with `getLoopPuzzles()` returning `Stream<List<LoopChallenge>>`, filtering Firestore `puzzles` by `type == loop_scout` and `is_archived == false`.
- Added service tests to confirm only active `loop_scout` records are emitted.

## Prompt 29
- Added `lib/providers/loop_provider.dart` with Riverpod providers:
  - `databaseServiceProvider` to expose `FirestoreDatabaseService`
  - `loopPuzzlesProvider` as a `StreamProvider<List<LoopChallenge>>` using `getLoopPuzzles()`

## Prompt 30
- Added this running `CHANGES.md` log and retroactively summarized available completed prompts so future prompt-by-prompt change tracking is centralized in one file.

## Prompt 31
- Expanded `.gitignore` to block `serviceAccountKey.json` (root and nested), Firebase Admin SDK key JSON patterns, and `android/app/src/google-services.json` so private key material and local Firebase config files are less likely to be committed.
- Performed repository security checks to identify secret-like files and confirm ignore coverage for sensitive Firebase-related files.

## Prompt 32
- Completed and tightened loop-tracing backend data access in `DatabaseService` by centralizing active-puzzle query logic, enforcing non-empty puzzle type input, and adding `fetchLoopPuzzles()` for one-time loop puzzle loads.
- Updated loop providers with `loopPuzzlesOnceProvider` so UI can consume either streaming or one-shot loop puzzle fetches from the same backend service layer.
- Expanded backend test coverage to verify archived puzzles are excluded, invalid type input is rejected, loop-specific one-shot fetching works, and loop providers correctly read backend puzzle data.

## Prompt 33
- Added `lib/providers/loop_tracing_provider.dart` with a UI-focused Riverpod `Notifier` (`LoopTracingController`) and `LoopTracingState` containing `currentInput` and `isCorrect`.
- Implemented controller actions for input updates, answer submission, and reset so loop-tracing UI state is managed separately from Firestore data-fetch providers.
- Added provider tests in `test/providers/loop_tracing_provider_test.dart` to validate initial state, correctness checks, and reset behavior.
