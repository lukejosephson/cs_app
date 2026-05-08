# Project Requirements: CS Practice App
Developer: Luke Josephson
Description: A Flutter app for new Computer Science students to practice core skills through interactive puzzle-based exercises.

## AI Assistant Guardrails

When reading this file to implement a step, the assistant must follow these rules:

1. State Management: Use `flutter_riverpod` exclusively. Do not use `setState` for complex logic.
2. Architecture: Maintain strict separation of concerns:
   - `/models`: Pure Dart data classes.
   - `/services`: Backend/API communication only. No UI code.
   - `/providers`: Riverpod providers linking services to UI.
   - `/screens` and `/widgets`: UI only. Keep files small and extract reusable widgets.
3. Local Storage: Use `shared_preferences` for basic local app state where needed.
4. Database: Use Firebase Firestore for persistent cloud data.
5. Stepwise Execution: Only implement the specific step requested in the prompt. Do not jump ahead.

## Functional Requirements (Current Product Scope)

### Required Features

1. [x] Authentication
   - User opens the app to a sign-in/create-account flow.

2. [x] Home Screen / Navigation
   - User sees a home screen with available puzzle/practice types.

3. [x] Binary Practice
   - User is given a number and flips binary tiles (`0`/`1`) to build the correct value.
   - User submission is checked for correctness.

4. [x] Error Detection
   - User is shown a code snippet with a syntax or logic error.
   - User selects where the error occurs.

5. [x] Loop Tracing
   - User is shown a loop-based code snippet that modifies variables.
   - User identifies the final result of a target variable.

6. [x] Fresh Questions
   - User is shown fresh questions during practice.

7. [x] Retry Missed Questions
   - User can retry questions answered incorrectly.

### Required Features as Implementation Steps (Backfilled)

Step RF.1 [x] Create authentication flow (sign in + create account) and route users through an auth gate.

Step RF.2 [x] Build home screen with first-class navigation to all current practice modes.

Step RF.3 [x] Implement Binary Practice interaction (flip bits, check answer, feedback, next challenge behavior).

Step RF.4 [x] Implement Loop Tracing module end-to-end (model/service/provider/controller/screen/widgets/tests).

Step RF.5 [x] Implement Error Detection module end-to-end (model/service/provider/controller/screen/widgets/tests).

Step RF.6 [x] Implement Operations Practice module end-to-end (model/service/provider/controller/screen/widgets/tests).

Step RF.7 [x] Implement puzzle progression logic for fresh question delivery across practice modes.

Step RF.8 [x] Implement retry logic using persistent user progress (`completedPuzzles` / `failedPuzzles`) and shared queue selection.


## Implementation Roadmap

### Phase 1: Project Setup & Core Infrastructure
Step 1.1 [x]: Dependencies & Theme Foundations
- Added core dependencies (`flutter_riverpod`, Firebase Core/Auth/Firestore, `shared_preferences`, `google_sign_in`, test tooling).
- Established app theming foundations and consistent dark UI styling.

Step 1.2 [x]: Base Architecture
- Established layered project structure (`models`, `services`, `providers`, `screens`, `widgets`, `utils`, `constants`).
- Wrapped app in `ProviderScope` and aligned state flow to Riverpod providers/controllers.

### Phase 2: Milestone 1 - Minimum Viable Product (MVP)
Goal: Core defining practice features function end-to-end.
Step 2.1 [x]: Binary Practice MVP
- Delivered interactive binary puzzle play (bit toggles, answer checks, immediate feedback, next prompt behavior).

Step 2.2 [x]: Loop Tracing MVP
- Implemented loop challenge data pipeline and interactive tracing UI with validation and progression.

Step 2.3 [x]: Error Detection MVP
- Implemented error-detection puzzle flow with selectable code lines / line-number submission and feedback.

Step 2.4 [x]: Operations Practice MVP
- Implemented operations puzzle flow with answer input, checking, feedback, and next-challenge handling.

### Phase 3: Milestone 2 - Functionality Integration (Auth & Database)
Goal: Complete major functionality with cloud-backed data and authentication.
Step 3.1 [x]: Firebase Authentication
- Implemented `AuthService` with Email/Password and Google Sign-In.
- Added sign-in and create-account UX with validation and error handling.

Step 3.2 [x]: Auth Gate Integration
- Implemented `AuthGateScreen` that reacts to auth state and routes to sign-in vs authenticated app content.

Step 3.3 [x]: Firestore Data Integration
- Implemented cloud-backed `DatabaseService` methods for puzzle fetches and user progress persistence.
- Wired providers/controllers to read live cloud data and update progress state.

Step 3.4 [x]: Shared Puzzle Queue + Progress-Aware Selection
- Implemented shared puzzle selection service prioritizing unattempted puzzles, then retries.
- Integrated shared selection across loop tracing, error detection, and operations practice controllers.

### Phase 4: Polish & Persistence
Step 4.1 [x]: Local Persistence
- Added local preferences persistence for binary-practice display settings via `shared_preferences`.

Step 4.2 [x]: Async Loading/Error States
- Standardized async loading/error handling with `AsyncValue.when()` across puzzle screens.

Step 4.3 [x]: Quality, Testing, and Refactor Cleanup
- Expanded/maintained unit + widget test coverage across auth, providers, services, and screens.
- Refactored oversized screens into reusable widgets/services to keep files maintainable and architecture-compliant.
- Removed unsupported light-mode toggle and kept app behavior aligned to project expectations.

## Development Quality Responsibilities

1. Test each feature after it is added.
2. Ensure tests are added under `test/`.
3. Review code and confirm understanding before finalizing.
4. Keep architecture clean:
   - Separate responsibilities by layer/file.
   - Extract large widgets into reusable components.
   - Keep models separate from UI logic.
