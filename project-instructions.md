# SYE Capstone: 7-Week Flutter Final Project
## CS450 SYE Seminar - Mobile Design With Flutter

### 1. Development & AI Workflow (Strict Guardrails)
To succeed, you must follow a disciplined, iterative workflow:

* **The Product Requirements Document (`REQUIREMENTS.md`):** Create a markdown file at the root of your project based on your approved proposal. Break the app down into isolated, sequential features.
* **The Prompt Log (`PROMPTS.md`):** You must document the prompts you use to satisfy each requirement. Record successful prompts or the conversational sequence that led to the correct code.
* **Micro-Commits:** You must commit to Git frequently; one successful prompt or change equals one commit. Your Git history is your audit trail, and every commit message should refer to a prompt number in `PROMPTS.md`.
* **The "No Magic" Rule:** You are strictly responsible for understanding every single line of code generated. You may be asked to explain any block of code in your repository during weekly check-ins.

---

### 2. Technical Requirements
Your app must successfully integrate the following technologies:

* **State Management:** Use Riverpod to handle all internal app state and data flow.
* **Local Storage:** Use Shared Preferences to persist basic app state locally.
* **Authentication:** Use Firebase Authentication with advanced login methods (e.g., Google Sign-In, Apple Sign-In, or Anonymous login).
* **Cloud Database:** Use a cloud database (Firebase Firestore or Google Cloud PostgreSQL) for persistent data storage.
* **Theming:** Implement a consistent UI design using Flutter's `ThemeData`.
* **Note on Responsiveness:** You are not required to make the app responsive for tablets or handle landscape orientation. Focus entirely on a standard mobile portrait experience.

---

### 3. Architecture & Code Quality
You must enforce a strict **Separation of Concerns**:

* **Small Files & Widgets:** Do not let the AI dump hundreds of lines of code into a single file. Break complex screens into smaller, reusable custom widgets.
* **Directory Structure:** Your `lib/` folder must be organized logically:
    * `/models`: Pure Dart classes representing your data.
    * `/screens` (or `/views`): The main page layouts.
    * `/widgets`: Reusable, isolated UI components.
    * `/services`: Backend communication logic.
    * `/providers` (or `/controllers`): Riverpod providers containing the business logic connecting services to UI.

---

### 4. Grading Rubric (100 Points Total)

| Category | Description | Points |
| :--- | :--- | :--- |
| **AI Workflow & Version Control** | `REQUIREMENTS.md` is well-structured. `PROMPTS.md` accurately tracks the process. Git history shows frequent, incremental commits tied to AI prompts. | 20 |
| **Architecture & Code Quality** | Code strictly follows guidelines (Models, Services, UI separation). Widgets and files are kept small. You demonstrate a complete understanding of generated code. | 25 |
| **Technical Implementation** | Riverpod is correctly utilized. `SharedPreferences` is working. Firebase Auth uses advanced providers. Cloud DB is structured properly and syncs correctly. | 30 |
| **UX & Theming** | App utilizes a consistent `ThemeData`. The interface is intuitive, bug-free, and handles loading/error states gracefully. | 10 |
| **Milestones & Presentation** | Weekly check-ins were attended. MVP and Milestone 2 were met on time. Final presentation communicates the technical journey. | 15 |

---

### 5. Implementation Roadmap

#### Phase 1: Project Setup & Core Infrastructure
* **Step 1.1: Dependencies & Theme:** Add Riverpod, Firebase, and Shared Preferences to `pubspec.yaml`. Create a centralized `ThemeData` class in `lib/theme.dart`.
* **Step 1.2: Base Architecture:** Set up folder structure and wrap `MyApp` in a `ProviderScope`.

#### Phase 2: Milestone 1 - The Minimum Viable Product (MVP)
* **Goal:** The core defining feature must function with mock data or local state.
* **Step 2.1 - 2.3:** Implement isolated, sequential features based on your proposal.

#### Phase 3: Milestone 2 - Integration (Auth & Database)
* **Step 3.1: Firebase Authentication:** Implement `AuthService` with at least two providers and create Login/Registration screens.
* **Step 3.2: The Auth Gate:** Create an `AuthGate` widget to toggle between the LoginScreen and MVP screen based on auth state.
* **Step 3.3: Cloud Database Integration:** Replace mock data with a real `DatabaseService` and implement CRUD operations.

#### Phase 4: Polish & Persistence
* **Step 4.1: Local State:** Use Shared Preferences for features like Dark Mode or onboarding screens.
* **Step 4.2: Error Handling:** Use `AsyncValue.when()` to handle loading and error states in the UI.
* **Step 4.3: Final Cleanup:** Refactor files > 200 lines and finalize typography/padding.
