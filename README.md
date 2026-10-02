# My Creative Routine

A clean, green-themed Flutter to-do app for organizing your daily tasks.

This is **phase one**: the full UI with every screen connected. Tasks are kept in memory, and sign-up / login are UI-only until the backend is connected in the next phase.

## Features

- **Onboarding** – splash screen, a "Let's Start" screen, then Register and Login.
- **Tasks list** – task count badge, cards showing the group icon, end time and description. Completed tasks are crossed out. Friendly empty state when there are no tasks.
- **Add task** – title (required), description, group (Home / Personal / Work), and an end time picked with a date + time picker.
- **Edit task** – edit every field, toggle Done / In Progress, update, or delete.
- **Profile** – update profile, change password (with show/hide for each field), and settings with an AR / EN language switch.

## Tech Stack

| | |
|---|---|
| Framework | Flutter (Dart 3) |
| UI | Material 3, Poppins font |
| State | `StatefulWidget` + `setState` |
| Dependencies | None beyond the Flutter SDK (`cupertino_icons` only) |

## App Flow

```
Splash → Let's Start → Register → Login → Home
                                           ├── Add Task
                                           ├── Edit Task
                                           └── Profile
                                                ├── Update Profile
                                                ├── Change Password
                                                └── Settings
```

## Project Structure

```
lib/
├── main.dart
├── core/
│   ├── utils/        # colors, text styles, asset paths, date picker helper
│   └── widgets/      # shared text field
└── features/
    ├── splash_screen/
    ├── starting_screen/
    ├── register_screen/
    ├── login_screen/
    ├── home_screen/
    │   ├── data/models/      # TaskModel
    │   └── presentation/     # home, add/edit task, task list widgets
    └── profile_screen/
```

## Getting Started

**Requirements:** Flutter SDK 3.x

```bash
git clone https://github.com/<your-username>/my_creative_routine.git
cd my_creative_routine
flutter pub get
flutter run
```

## Roadmap

- [ ] Connect Register / Login to an API and keep the user signed in
- [ ] Persist tasks (API or local database)
- [ ] Load the user's real name and picture
- [ ] Working Arabic / English localization
- [ ] Filter tasks by group and status
