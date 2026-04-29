**Cold Start**

[x] 1. I am going to create an app that serves as a way for new Computer Science 
students to practice skills. Create a flutter CS Practice app with a home screen
to begin the development process. There should be a quick welcome to the app
with a short explanation of the purpose, and a list of types of practice to do.
Start with just a binary practice. 

[x] 2. Make the theme dark and make the UI more professional while keeping a simple color scheme.

[x] 3. Implement the new screen for the binary practice. Binary practice should consist of 
6 flippable bits. A number should be given, and the user should get to flip the bits to
make the number, and then be able to check for correctness. If correct, the user should get a
message that they got it correct, and be given another number. If wrong, the correct answer 
should be shown.

[x] 4. For binary practice, give users the option to show or not show the current value of 
their flipped bits and the option to show or not show the value of a bit at a given place.

[x] 5. Change the number of bits to 7 and improve the UI. The tiles should be closer together
and square, and should change color to green when flipped.

[x] 6. Display the current value of the flipped bits right below the tiles. Additionally,
the message after a correct answer should say: The binary equivalent of (number) is (answer).

[x] 7. Improve the organization of the code. The code should adhere to the standards set in the requirements.

[x] 8. I am now beginning to implement user authentication. I am getting firebase auth set up. I just used
flutterfire configure, and now I want firebase to be initialized in my code.

[x] 9. Firebase should be ready to be initialized now. I have a project called cs-practice-app in my firebase
console, and the recent changes to this project. Ensure firebase is set up and initialized, and do not commit
anything yet.

[x] 10. Ensure that the .gitignore file prevents any keys or private information from being committed. Check
for other possible safety issues as well.

[x] 11. I have successfully configured Firebase. We are now implementing user authentication. 
Create lib/services/auth_service.dart. Implement a class AuthService that handles Anonymous login 
and Google Sign-In using firebase_auth and google_sign_in. Do any other work needed to set up user authentication.
Create a sign in screen that the user is brought to before the home screen.

[x] 12. Implement the option to log in with email and password. There should also be functionality for creating
an account.

[x] 13. I do not need functionality for anonymous sign in. Remove that functionality and maintain clean code.

[x] 14. The create account button should take the user to a screen where they can create an account using email and password.

[x] 15. There should be checks in the create account ensuring that a user has entered a 
valid email address and a valid password. If a user does not, they should recieve a message 
explaining why what they entered was invalid.

[x] 16. Upon attempted to create an account with an email and password, it took around 15 seconds
to buffer and then gave a message that authentication failed. Troubleshoot, explain what the problem could be, 
and verify changes with me before making them.

[x] 17. The user should be askedd to verify their password when creating an account. 
Upon successful account creation, the user should be sent back to the sign in screen with a message that the
creation of their account was successful. Upon successful sign in, they should be brought to the home screen. 

[x] 18. While the app runs on the android simulator, it is not running on the ios 
simulator. Troubleshoot the problem.

[x] 19. The menu for stopping the program and rot restarting the program is not 
appearing when running in either ios or android. Explain the possible reasons
for this.

[x] 20. Improve testing code by seperating the tests into their own files, following
best practice outlined by the instructions.

[x] 21. According to the guidelines laid out, give constructive criticism for
the current code. Do not make any changes. Give feedback on what could be improved and why.

[x] 22.We are starting the Model Layer for the Loop Scout module. Create 
lib/models/loop_challenge.dart. Define a class LoopChallenge with fields 
matching our Firestore schema, which is as follows below:

answer
""
(string)


difficulty
0
(int64)


error_line
0
(int64)


id
0
(int64)


is_archived
false
(boolean)


snippet
""
(string)



tags
(array)


0
""
(string)


target
""
(string)


type
""
(string)

[x] 23. Implement a fromFirestore factory constructor if it does not already exist. The plan is to
store puzzles in firestore that will then be used for a loop tracing game. This schema also plans 
ahead for further games like error identification, which we will not implement yet. Ensure that
the models directory is thorough and ready. do not move on to the services yet.

[x] 24. The app is not launching successfully on ios. Identify the issue, and explain what is 
casuing the issue. If possible, identify the commit that the issue was introduced. do not change code yet.

[x] 25. Ensure the ios issues have been fixed. prepare for the work session to end.

[x] 26. Debug current functionality. Ensure that past issues that were fixed have tests to ensure the same errors don't reoccur.
Should there be any areas of improvement for the code and current basic function, explain what they are and how they would be fixed

[x] 27. Check if lib/models/loop_challenge.dart exists. If not, create it. It must be a pure Dart class with these fields: id (int), type (String), snippet (String), target (String), answer (String), difficulty (int), error_line (int), is_archived (bool), and tags (List). Include a fromFirestore factory constructor.

[x] 28. Check if lib/services/database_service.dart exists. If not, create it. Implement a method getLoopPuzzles() that fetches documents from the 'puzzles' collection where type == 'loop_scout' and is_archived == false. It should return a Stream<List<LoopChallenge>>

[x] 29. Create lib/providers/loop_provider.dart. Use a Riverpod StreamProvider that wraps the DatabaseService call. We will use this to handle the loading/error states in the UI later using AsyncValue.

[x] 30. I have added a new markdown file CHANGES.md to contain summaries of the changes made by CLI code assist. I have also added a development 
rule to add to this file after every prompt. Follow this rule moving forward. If past prompts have summaries available or you are able to generate them, add them retroactively to the CHANGES.md file

[x] 31. add serviceAccountKey.json and any other files containing private keys to the .gitignore file. do general security checks

[x] 32. ensure that the entirety of the backend work has been completed and is correct for the loop tracing. 

[x] 33. We are starting the front end / UI for the loop tracing. If not already done, In the providers folder, create a controller for the loop tracing. Implement a Notifier that manages a simple state class (e.g., LoopTracingState) containing the user's currentInput and a bool for isCorrect. Rule 7 (Explain-First): Briefly explain why we use a UI-specific Notifier separate from the Database Provider. Ensure it uses correct Riverpod syntax.


[x] 34. The Main Screen Skeleton (Async Handling)
Goal: Build the LoopScoutScreen using AsyncValue.when() to handle data from Firestore . 
If any of this has been done or is in another name, adapt as necessary.
"Create lib/screens/loop_scout_screen.dart.
This screen should watch the puzzleProvider (which fetches data from Firestore).
Constraint: Use .when() to handle data, loading, and error states.
For loading, show a CircularProgressIndicator. For error, show a professional error message using ThemeData.
For data, display a placeholder Column that will eventually hold our widgets.

[x] 35. The Code Display Widget (Aesthetic)Goal: Create a reusable widget for the code snippet that uses your monospace developer theme.
"Create lib/widgets/code_display_box.dart.This widget should take a String snippet as a parameter.Wrap the snippet in a Container with a dark background, subtle borders, and padding.Requirement: Use a monospace font (like Fira Code via GoogleFonts) as specified in the 'developer aesthetic' guidelines.Ensure it handles multi-line snippets properly.

[x] 36. The Interaction Layer (Input & Logic)
Goal: Build the input field and the "Check Answer" button that talks to the controller.
"Create lib/widgets/loop_input_panel.dart. This widget should display the target variable name and a TextField for the user's answer. Add a 'Check Answer' button that triggers a method in our LoopScoutController.
If the answer is correct, display a 'Success' message using the green color from our ThemeData. If wrong, show the correct answer as per the requirements.

[x] 37. Inspect the code that handles the front end of the loop tracing. What still needs to be done? What could cause errors? What could be improved?

[ ] 38. Add puzzle progression (next/random challenge) instead of always using puzzles.first.

[ ] 39. Preserve/reset answer input intentionally between puzzles (currently no puzzle lifecycle flow yet).

[ ] 40. Integrate loop screen navigation from home so this flow is reachable in normal app usage.

[ ] 41.  Add richer validation/UX for answers (empty input messaging, optional case/whitespace policy).

[ ] 42.Add retry/wrong-answer tracking hooks to align with requirements.

[ ] 43. These are possible sources of error. Address these as necessary.
 1. puzzleProvider is a stream alias; if provider types/names change later, screen wiring can silently drift.
 2. LoopInputPanel relies on TextField.onChanged; programmatic text updates won’t sync unless controller logic handles them.
 3. Correctness is strict string match; formatting differences can appear “wrong” even when semantically correct.
 4. UI currently assumes first puzzle is valid; malformed backend records could degrade UX without defensive display handling.

[ ] 44. These are sources of improvement. Address these as necessary.
 1. Move answer normalization logic into controller/service helper for consistent comparison rules.
 2. Replace inline success/error message strings with centralized constants/localization-ready structure.
 3. Show puzzle metadata (difficulty, tags) and add explicit “Next challenge” action.
 4. Add widget tests for empty-data state and input-reset behavior when changing puzzles

[ ] 45. 

[ ] 46. 

[ ] 47. 

[ ] 48. 

[ ] 49. 

[ ] 50. 

[ ] 51.




Now create lib/services/database_service.dart. Implement a fetchPuzzlesByType(String type) method. 
It should query the 'puzzles' collection where 'type' matches the argument.
Map the Firestore documents into our LoopChallenge model. Ensure no UI code or Riverpod code is in this file



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
