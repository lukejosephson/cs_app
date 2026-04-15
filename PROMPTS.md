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

[ ] 6. Display the current value of the flipped bits right below the tiles. Additionally,
the message after a correct answer should say: The binary equivalent of (number) is (answer).

[ ] 7. 

[ ] 8. 

[ ] 9. 

[ ] 10. 

[ ] 11. 

[ ] 12. 




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
