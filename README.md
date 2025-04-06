# hecto_clash_frontend
HectoClash

HectoClash is an engaging, math-based puzzle game built with Flutter. It challenges players with endless sequences, timed duels, and competitive leaderboards, offering a fun way to test and improve problem-solving skills. Developed as a cross-platform mobile application, HectoClash supports both Android and iOS devices.

Table of Contents
Features
HectoClash offers three exciting game modes, each designed to keep players hooked:

Endless Mode: Solve an unlimited series of puzzles at your own pace. Perfect for practice and relaxation.
Duel Mode: Face off in a 5-puzzle challenge with a timer. Get hints after incorrect attempts, but hurry—time’s ticking!
Blitz Mode: Coming soon! A fast-paced mode for quick reflexes and sharp minds.
Additional features:

Score Tracking: Earn points for correct answers and track your performance.
Results Screen: Review your game stats, including puzzles solved, accuracy, and time taken.
Leaderboard: Compete with others and climb the ranks (integration pending).
Responsive UI: Sleek, premium design with a consistent color palette across modes.
Cross-Platform: Runs seamlessly on Android and iOS.


		![WhatsApp Image 2025-04-06 at 12 51 46](https://github.com/user-attachments/assets/0fce0666-64a1-4fe3-b5eb-c4eb2eb9b1ba)
![WhatsApp Image 2025-04-06 at 12 51 46 (1)](https://github.com/user-attachments/assets/60654a08-b5c2-4336-83c6-43bcc8f38970)
![WhatsApp Image 2025-04-06 at 12 51 46 (2)](https://github.com/user-attachments/assets/f8c864cd-e80b-42b6-b509-67a1b966be27)

Solve puzzles endlessly	Race against the clock	Analyze your performance
Note: Replace placeholder images with actual screenshots of your app.

Installation
Prerequisites
Flutter SDK: Version 3.10.0 or higher (stable channel recommended).
Dart: Comes with Flutter (version 3.0.0+ recommended).
IDE: Android Studio, VS Code, or any Flutter-supported editor.
Device/Emulator: Android (API 21+) or iOS (12.0+) device/emulator.
Steps
Clone the Repository:
bash
Copy
git clone https://github.com/roshan2708/HectoClashv1.0
cd hectoclash
Install Dependencies: Ensure you have a pubspec.yaml file with required dependencies (see ). Then run:
bash

flutter pub get
Set Up Emulator/Device:
For Android: Open an emulator via Android Studio or connect a physical device with USB debugging enabled.
For iOS: Use an iOS simulator or connect an iPhone (requires Xcode on macOS).

Run the App:
bash

flutter run
Select your target device if prompted.
Build for Release (optional):
Android: flutter build apk --release
iOS: flutter build ios --release (requires Xcode setup).
Usage
Launch the App: Start HectoClash on your device/emulator.
Choose a Mode:
Endless Mode: Tap to start solving puzzles with no time limit.
Duel Mode: Begin a 5-puzzle duel with a countdown timer.
Play:
Use the numpad to input answers.
Submit your solution with the "Submit" button.
In Duel Mode, get a hint after one wrong attempt.
Review Results: After finishing, view your score, accuracy, and puzzle details.
Play Again: Reset and restart from the results screen.

yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5          # State management and navigation
Notes
Ensure the versions match your Flutter SDK compatibility. Run flutter pub get after updating pubspec.yaml.
Additional packages (e.g., for animations or leaderboards) may be added as features expand.
Contributing
We welcome contributions to make HectoClash even better! Here’s how to get started:

Fork the Repository: Click "Fork" on GitHub.
Clone Your Fork:

Copy
git clone https://github.com/roshan2708/HectoClashv1.0.git
Create a Branch:
bash
git checkout -b feature/your-feature-name
Make Changes: Implement your feature or fix.
Commit and Push:
bash

git add .
git commit -m "Add your message"
git push origin feature/your-feature-name
Submit a Pull Request: Open a PR on GitHub with a clear description.
Guidelines
Follow Flutter’s coding style (e.g., use dart format).
Test on both Android and iOS if possible.
Document any new features in this README.
License
This project is licensed under the MIT License. See the  file for details.

MIT License

Copyright (c) 2023 Roshan Singh

Permission is hereby granted, free of charge, to any person obtaining a copy...
Contact
Have questions or suggestions? Reach out!

Email: rs602543@gmail.com

