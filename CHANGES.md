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
