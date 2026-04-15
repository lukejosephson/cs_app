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

[ ] 21.

[ ] 22.

[ ] 23.

[ ] 24.

[ ] 25.

[ ] 26.



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
