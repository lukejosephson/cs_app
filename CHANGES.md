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

## Prompt 34
- Added `lib/screens/loop_scout_screen.dart` as the loop tracing main screen skeleton using `AsyncValue.when()` against `puzzleProvider` for loading, error, and data UI states.
- Implemented a loading state with `CircularProgressIndicator`, a themed/professional error card, and a placeholder `Column` data layout for upcoming loop-tracing widgets.
- Added `test/loop_scout_screen_test.dart` to cover loading, error, and data rendering behavior for the new async screen flow.

## Prompt 35
- Added `lib/widgets/code_display_box.dart`, a reusable snippet widget with dark background, subtle border, padding, and multiline-friendly rendering for code content.
- Applied a developer-style monospace typography using `GoogleFonts.firaCode` for snippet readability and consistent coding aesthetic.
- Added widget tests in `test/widgets/code_display_box_test.dart` and introduced the `google_fonts` dependency in `pubspec.yaml`.

## Prompt 36
- Added `lib/widgets/loop_input_panel.dart`, a reusable loop interaction widget showing the target variable, answer `TextField`, and a `Check Answer` action wired to the loop controller.
- Extended loop UI state in `loop_tracing_provider.dart` with `hasSubmitted` and added `LoopScoutController`/`loopScoutControllerProvider` aliases so the interaction layer can follow prompt naming while keeping Riverpod wiring consistent.
- Updated `LoopScoutScreen` to render live interaction UI for loaded puzzles and added tests for controller state updates and success/error answer feedback (`test/widgets/loop_input_panel_test.dart`, updated loop screen/provider tests).

## Prompt 37
- Audited the loop-tracing frontend path (`LoopScoutScreen`, `LoopInputPanel`, loop providers/controller, and related tests) and documented remaining work, likely error sources, and targeted improvements before moving to the next build steps.

## Prompt 38
- Added puzzle progression support in the loop UI state/controller with `moveToNextPuzzle` and `moveToRandomPuzzle`, including `currentPuzzleIndex` tracking and state reset behavior between challenge changes.
- Updated `LoopScoutScreen` to render puzzles by controller index instead of always using the first record, and added explicit `Next Challenge` and `Random` actions for navigation.
- Expanded frontend tests to verify progression behavior and controller index/state updates.

## Prompt 39
- Added intentional puzzle lifecycle input behavior by upgrading `LoopInputPanel` to a stateful, controller-backed widget that syncs its `TextField` with loop controller state.
- Implemented explicit response reset support (`clearResponse`) in the loop controller and triggered it when the active puzzle changes so answer text/feedback reset cleanly between challenges while preserving same-puzzle edits.
- Expanded loop UI tests to verify input/feedback are reset after moving to a new challenge and that response clearing keeps puzzle index progression intact.

## Prompt 40
- Integrated loop tracing into normal app navigation by adding a `Loop Scout` practice option on the home screen and routing it to `LoopScoutScreen`.
- Improved practice option modeling with a typed `PracticeTypeId` so home navigation selects destination screens via explicit identifiers instead of implicit title matching.
- Expanded home screen tests to verify both practice options render and loop navigation opens the Loop Scout flow.

## Prompt 41
- Added richer answer-validation UX in loop tracing: empty submissions now surface an explicit validation message instead of evaluating as wrong answers.
- Implemented a comparison policy that normalizes answers by trimming, collapsing repeated whitespace, and ignoring letter case before correctness checks.
- Updated loop input and controller tests to cover empty-input feedback and case/whitespace-insensitive answer matching behavior.

## Prompt 42
- Added retry/wrong-answer tracking hooks in loop controller state via `wrongAttemptsByPuzzle` and `retryPuzzleIds`, with incorrect submissions incrementing per-puzzle counters and adding retry candidates.
- Updated answer submission flow to carry puzzle identity (`puzzleId`) so tracking is tied to specific challenges.
- Surfaced hook state in the loop UI with a retry pool indicator and expanded tests to verify wrong-attempt accumulation and retry list behavior.

## Prompt 43
- Reduced provider-wiring drift risk by moving `LoopScoutScreen` to the canonical `loopPuzzlesProvider` and deprecating the legacy `puzzleProvider` alias.
- Hardened puzzle data handling by filtering malformed challenges (missing snippet/target/answer) in `FirestoreDatabaseService`, with UI fallback messaging when no valid challenge remains.
- Added regression tests for malformed-puzzle filtering and programmatic input synchronization so front-end behavior stays robust as provider/controller wiring evolves.

## Prompt 44
- Extracted loop-answer normalization into a shared helper (`AnswerNormalizer`) and reused it in the loop controller to keep comparison rules centralized and consistent.
- Centralized loop-facing UI strings into `lib/constants/loop_strings.dart` to reduce inline text and keep message handling localization-ready.
- Enhanced `LoopScoutScreen` to show puzzle metadata (`difficulty`, `tags`) while preserving explicit next-challenge navigation, and expanded widget tests for empty-data state plus input reset on puzzle changes.

## Prompt 45
- Investigated cross-platform launch blockers and found no universal Dart/code-level startup failure: analysis/tests pass and Android debug build succeeds.
- Identified the immediate iOS launch blocker as local Xcode simulator platform setup (`iOS 26.4 is not installed`), which is an environment/toolchain issue rather than app logic.
- Documented likely non-code causes for “both platforms won’t launch” when shared app code is healthy (simulator/device runtime configuration and local SDK tooling state).

## Prompt 46
- Ran required validation suite (`flutter analyze`, full `flutter test`) and confirmed app code quality/test baseline is passing.
- Tested iOS startup first: Flutter can detect a booted iOS simulator, but launch fails at Xcode build destination resolution with `iOS 26.4 is not installed`, indicating a local Xcode platform/components mismatch.
- Tested Android startup second on `emulator-5554`: build succeeds, but install/launch fails due to emulator storage exhaustion (`Requested internal only, but not enough space`).

## Prompt 47
- Added `lib/models/error_detection_challenge.dart` with a Firestore-mapped `ErrorDetectionChallenge` model (`id`, `type`, `snippet`, `error_line`, `target`, `difficulty`, `is_archived`, `tags`) and `fromFirestore` mapping support.
- Updated `DatabaseService`/`FirestoreDatabaseService` with `fetchErrorDetectionPuzzles()` to query active `error_detection` puzzles from the `puzzles` collection and map records through `ErrorDetectionChallenge.fromFirestore`.
- Expanded test coverage with `test/models/error_detection_challenge_test.dart` and a new service test validating that only non-archived `error_detection` records are returned.

## Prompt 48
- Added `lib/providers/error_detection_controller.dart` with a UI-decoupled Riverpod `Notifier` (`ErrorDetectionController`) and `ErrorDetectionState`.
- Implemented required state fields (`selectedLineIndex`, `hasSubmitted`, `isCorrect`) and controller methods: `selectLine(int index)` and `checkSelection(int correctLineIndex)`.
- Added provider tests in `test/providers/error_detection_controller_test.dart` covering initial state, line selection behavior, and correct/incorrect submission outcomes.
