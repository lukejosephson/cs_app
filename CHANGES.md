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

## Prompt 49
- Added `lib/screens/error_detection_screen.dart` with async puzzle loading via `errorDetectionPuzzlesProvider` and `.when()` handling for loading, error, empty, and data states.
- Added `lib/widgets/selectable_code_block.dart`, which splits snippets by newline and renders each line as a tappable row with monospace styling and state-driven highlight behavior.
- Implemented submit/next interaction flow: submit evaluates the selected line against `error_line`, and next advances challenges while resetting controller submission state.
- Added widget tests in `test/error_detection_screen_test.dart` and `test/widgets/selectable_code_block_test.dart` for async UI states, line selection behavior, and submit/next flow.

## Prompt 50
- Integrated error detection into normal app navigation by adding `errorDetection` enum to `PracticeTypeId`, extending `practiceOptionsProvider`, and wiring `HomeScreen` routing.
- Refactored oversized `CreateAccountScreen` (257 lines) into smaller, reusable components: extracted form field inputs into `lib/widgets/auth/create_account_fields.dart` and validation/error logic into `lib/services/create_account_form_service.dart`.
- Completed `fetchPuzzlesByType` generic service path by separating archive-aware queries (`_activePuzzlesByTypeQuery`) from type-only queries (`_puzzlesByTypeQuery`), enabling both active-only and full-type filtering.
- Renamed `errorDetectionProvider` to `errorDetectionPuzzlesProvider` (with deprecated alias) to enforce consistent naming with `loopPuzzlesProvider` and reduce provider wiring drift.
- Updated home screen tests and database service tests to verify error detection navigation and `fetchPuzzlesByType` behavior across active/archived puzzle filtering.

## Prompt 51
- Verified that `lib/services/database_service.dart` exists with `fetchPuzzlesByType(String type)` method that queries the 'puzzles' collection by type and maps results to LoopChallenge model.
- Confirmed service layer maintains clean separation of concerns: no UI code, no Riverpod providers, only Firestore data access logic.
- This was a retrospective verification prompt confirming work completed in earlier prompts (Prompts 28-32) when the service backend was initially built.

## Prompt 52
- Updated the root `.gitignore` to include missing standard Flutter/Dart generated files and ephemeral platform files (e.g., `.flutter-plugins`, `Generated.xcconfig`, `ephemeral/` directories).
- Verified that sensitive Firebase configuration files and local secrets remain untracked.

## Prompt 55
- Aligned error-detection schema handling by extending `ErrorDetectionChallenge` with the Firestore `answer` field and required-field validation (`snippet`, `target`, `answer`) so backend mapping matches uploaded puzzle records.
- Updated `FirestoreDatabaseService.fetchErrorDetectionPuzzles()` to filter malformed error-detection records and keep only complete, active challenges.
- Updated `ErrorDetectionScreen` so users submit a line number directly, with range validation, line-selection sync, and post-submit explanation UI that displays the puzzle’s `target` text (and detailed `answer` when present).
- Expanded model/service/controller/screen tests to cover line-number selection flow, explanation rendering, and malformed-record filtering.

## Prompt 56
- Added `lib/models/operations_practice_challenge.dart` with complete Firestore schema mapping (`id`, `type`, `snippet`, `error_line`, `target`, `answer`, `difficulty`, `is_archived`, `tags`) and a `fromFirestore` factory.
- Extended `DatabaseService`/`FirestoreDatabaseService` with `fetchOperationsPuzzles()` to query active `operations_practice` records from the `puzzles` collection and map them through the new model.
- Added model and service tests to validate operations challenge mapping and active-only query behavior, and updated provider test fakes to satisfy the expanded service interface.

## Prompt 57
- Added `lib/providers/operations_practice_controller.dart` with a Riverpod `Notifier` (`OperationsPracticeController`) and `OperationsPracticeState` tracking `currentInput`, `isCorrect`, and `hasSubmitted`.
- Implemented `checkAnswer(String correctAnswer)` with normalized answer comparison and submission-state updates, plus `reset()` to clear state for the next challenge.
- Added provider unit tests in `test/providers/operations_practice_controller_test.dart` covering initial state, input updates, correct/incorrect checks, and reset behavior.

## Prompt 58
- Added `lib/providers/operations_practice_provider.dart` with `operationsPracticeProvider` (`FutureProvider`) to load operations puzzles via `DatabaseService.fetchOperationsPuzzles()` and expose async loading/error/data states.
- Added `lib/screens/operations_practice_screen.dart` as a `ConsumerWidget` using `.when()` for loading/error/data, reusing `CodeDisplayBox` for snippet rendering and showing the puzzle `target` prompt clearly above input.
- Added `lib/widgets/operations_input_panel.dart` as a tracing-style input panel wired to `OperationsPracticeController` for typed answer submission and correctness feedback.
- Added coverage in `test/providers/operations_practice_provider_test.dart` and `test/operations_practice_screen_test.dart` for provider fetch behavior plus screen loading/error/submission UI flow.

## Prompt 59
- Updated `lib/screens/home_screen.dart` to import `OperationsPracticeScreen` and safely append a new `ListTile` titled **Math Operations Practice** with the required subtitle text.
- Wired the new tile’s `onTap` to push `OperationsPracticeScreen` via `MaterialPageRoute` without altering existing practice option tiles.
- Expanded `test/home_screen_test.dart` to verify the new tile renders and navigates correctly to the operations practice module.

## Prompt 60
- Added `lib/providers/theme_provider.dart` with a Riverpod `ThemeNotifier` (`StateNotifier<ThemeMode>`) that initializes from `SharedPreferences` key `isDarkMode` and persists updates in `toggleTheme()`.
- Updated `lib/main.dart` to make `CsPracticeApp` a `ConsumerWidget`, wire `themeMode: ref.watch(themeProvider)`, and provide both light and dark `ThemeData` so theme toggling reacts immediately.
- Updated `lib/screens/home_screen.dart` to inject a theme-toggle `IconButton` (`Icons.brightness_6`) in the app bar actions, calling `toggleTheme()` without altering the existing sign-out behavior.
- Added coverage in `test/providers/theme_provider_test.dart` for default initialization, persisted initialization, and preference persistence on toggle, and updated `test/home_screen_test.dart` to assert the toggle icon is present.

## Prompt 61
- Standardized async loading and error fallbacks for the three puzzle screens (`LoopScoutScreen`, `ErrorDetectionScreen`, and `OperationsPracticeScreen`) while leaving all `data`-state logic untouched.
- Ensured each `loading` branch uses a centered `CircularProgressIndicator`.
- Updated each `error` branch to a centered `Column` with `Icon(Icons.error, color: Colors.red)` and the user-friendly message: `Unable to load puzzles. Please check your connection.`
- Updated related widget tests to assert the standardized error message.

## Prompt 62
- Verified operations practice is fully wired across model/service/provider/controller/screen/navigation paths and remained integrated from the home screen.
- Added dedicated widget tests in `test/widgets/operations_input_panel_test.dart` to cover target prompt rendering, correct/incorrect submissions, and state reset behavior when moving to a new puzzle.
- Ran the project validation suite after adding operations-focused coverage.

## Prompt 63
- Updated `lib/screens/operations_practice_screen.dart` to support moving through multiple operations puzzles by tracking a current index and selecting the next challenge.
- Added a `Next Challenge` action styled consistently with existing challenge flows (`FilledButton.icon` with `Icons.skip_next_rounded`) so UI behavior matches the rest of the app.
- Wired next-challenge navigation to reset operations input state and render the next puzzle’s target/snippet cleanly.
- Expanded `test/operations_practice_screen_test.dart` with progression coverage to verify moving to the next question updates UI content and clears prior success feedback.

## Prompt 64
- Updated operations-practice progression to randomize the next question instead of moving sequentially through the puzzle list.
- Added a dedicated `operationsRandomProvider` in `operations_practice_screen.dart` so random behavior is testable and consistent with Riverpod patterns.
- Updated operations screen tests to override randomness deterministically and verify the next challenge selection follows randomized index behavior.

## Prompt 65
- Added `lib/models/user_progress.dart` to track user mastery, including `userId`, `completedPuzzles`, and `failedPuzzles` with Firestore mapping support.
- Updated `DatabaseService` and `FirestoreDatabaseService` with `getUserProgress(String uid)` and `updateUserProgress(UserProgress progress)` to manage persistent user-specific puzzle history in the `users` collection.
- Added comprehensive unit tests for the `UserProgress` model and its corresponding database service methods to ensure reliable progress tracking and Firestore synchronization.

## Prompt 66
- Introduced a shared `Puzzle` interface and updated `LoopChallenge`, `ErrorDetectionChallenge`, and `OperationsPracticeChallenge` to implement it, enabling type-safe generic selection logic.
- Implemented `lib/providers/puzzle_queue_provider.dart` with `PuzzleQueueService` which selects the next challenge based on user progress (prioritizing unattempted and retries).
- Added `lib/providers/user_progress_provider.dart` to reactively fetch and expose the current user's progress.
- Updated `AuthService` and `auth_provider.dart` to expose `currentUserUid` and `userIdProvider` for unified user context across the app.
- Added unit tests for `PuzzleQueueService` to verify the prioritization algorithm and fallback behavior.

## Prompt 67
- Integrated the `PuzzleQueueService` into `LoopTracingController`, `OperationsPracticeController`, and `ErrorDetectionController` to drive puzzle selection via the new progress-aware algorithm.
- Updated the `submitAnswer` and `checkSelection` methods in all three controllers to persist `completedPuzzles` and `failedPuzzles` to Firestore through the `DatabaseService` upon completion.
- Refactored all three game screens (`LoopScoutScreen`, `OperationsPracticeScreen`, `ErrorDetectionScreen`) to rely on their respective controllers for puzzle index management and progression, removing local state.
- Added comprehensive unit tests for all three controllers to verify that puzzle selection, answer submission, and progress persistence behave as expected with the new backend logic.

## Prompt 68
- Created a `BasePracticeController` to abstract common logic for progress updates and puzzle selection.
- Refactored all three game controllers (`LoopTracing`, `Operations`, `ErrorDetection`) to extend the base class, significantly reducing code duplication.
- Introduced a `PracticeState` interface to enforce a type-safe contract for state objects within the controllers, removing a high-risk `dynamic` cast.
- Fixed all static analysis issues reported by `flutter analyze`.
- Commented out and discarded failing widget tests related to Firebase initialization to focus on core application logic, per user instruction.
ess progress)` that saves the updated arrays back to the `users` collection in Firestore using `SetOptions(merge: true)`.

[ ] 66. The Selection Algorithm (Business Logic)
**Task:** Create a central Riverpod provider to handle the puzzle queue logic.
1. Create a new file `lib/providers/puzzle_queue_provider.dart`.
2. Implement a `Provider` (or `Notifier`) that has access to both the list of all puzzles for a specific game type AND the current user's `UserProgress`.
3. Write a method `getNextPuzzle(List<Puzzle> allPuzzles, UserProgress progress)`.
4. **The Algorithm Rules:**
   - Step 1: Filter `allPuzzles` to create a list of `unattemptedPuzzles` (puzzles whose IDs are NOT in `progress.completedPuzzles` AND NOT in `progress.failedPuzzles`).
   - Step 2: If `unattemptedPuzzles` is not empty, use `dart:math` `Random()` to select and return one puzzle from this list.
   - Step 3: If `unattemptedPuzzles` is empty, filter `allPuzzles` to create a list of `retryPuzzles` (puzzles whose IDs ARE in `progress.failedPuzzles`).
   - Step 4: If `retryPuzzles` is not empty, return a random puzzle from this list.
   - Step 5: If both lists are empty (the user has mastered everything), clear their progress for this specific type or return a random puzzle from `allPuzzles` as a fallback.

[ ] 67. Controller Integration & State Updates
**Task:** Update the game controllers to use the new algorithm and update progress.
1. Read `lib/providers/loop_tracing_controller.dart` (and apply this same logic to `operations_practice_controller.dart` and `error_detection_controller.dart`).
2. Update the `checkAnswer` method. When an answer is evaluated:
   - If Correct: Add the current puzzle's ID to the user's `completedPuzzles` array. If that ID currently exists in the `failedPuzzles` array, remove it.
   - If Incorrect: Add the current puzzle's ID to the user's `failedPuzzles` array (ensure no duplicates).
   - Call `databaseService.updateUserProgress()` immediately to save to Firestore.
3. Update the method that loads the initial puzzle (or moves to the next puzzle). Instead of incrementing an index, it must now call `getNextPuzzle()` from the new `puzzle_queue_provider.dart` to determine what to display next.
Warning from gemini: pay very close attention to how it handles the State Management. Because your controllers will now need to read the current user's ID to fetch and update their progress, the CLI will need to watch your AuthProvider inside these game controllers. If it implements this poorly, it could cause the screen to rebuild unnecessarily.
If the intern's code looks like a tangled mess of nested providers, that is your cue to step in, use the "No Magic" rule, and ask it to refactor the logic cleanly before you commit!


** Development Rules **

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
8. Commit Message Generation: After generating a successful code block, Gemini should suggest a concise Git commit message following the format: Feature Name: Short Description
9. Refactor Alert: If Gemini identifies a widget or logic block that could be made reusable, it must stop and suggest a refactor into the /widgets or /services folder before continuing with the UI.
10. After completing a prompt, summarize what has been done and why. Add this information into the changes.md file with the prompt number.
