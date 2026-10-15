# Taskify Premium v1.2 — Sir Requirements Upgrade

A Flutter To-Do assignment with multiple Dart files, offline SharedPreferences,
asset-only images, a five-second animated splash, and a colorful interface.

## Implemented

- 5-second animation, then home dashboard
- Profile name, email, bio, emoji-avatar create/edit saved locally
- In-app notification bell displaying Todo/Pending items (not OS push notifications)
- Dashboard counts: Total To-Do, Pending, Approved, Cancelled
- Add/Edit task page: auto-generated ID, name, title, description, due date, status
- Save creates/updates and returns to the To-Do List page
- To-Do List with status filters, checkbox to approve/reopen, edit, delete confirmation
- Stats page, bottom navigation, asset images
- SharedPreferences keys stay `taskify_todos` and `taskify_profile`
- Earlier Taskify `{id, title, done}` records migrate to the new structure

## Install onto your already-working Flutter project

1. Make a backup of your current Flutter project.
2. Copy this package's `lib/`, `assets/`, `pubspec.yaml`, `analysis_options.yaml`
   and `test/widget_test.dart` into your existing `taskify_premium` folder.
3. Do not delete `.git/`, `android/`, `windows/`, `ios/`, etc.
4. In VS Code's terminal, from the project root, run:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

For an upgrade, existing browser/Windows app local storage should remain
available only if you run the same app under the same local storage origin.
GitHub does NOT sync locally saved tasks or profile details to another PC.

## Status colors

- Todo: blue
- Pending: orange
- Approved: green
- Cancelled: red/pink

An unchecked prior-version task migrates to **Pending**. A completed prior-version
task migrates to **Approved**. Newly added tasks default to **Todo**.

## Architecture

- `models/todo.dart`: task model, serialization, migration
- `services/todo_storage.dart`: SharedPreferences persistence
- `screens/splash_screen.dart`: five-second animated landing screen
- `screens/home_screen.dart`: dashboard, navigation, notifications, stats, CRUD
- `screens/task_form_screen.dart`: add/edit task form
- `screens/profile_screen.dart`: profile name/email/avatar/bio
- `widgets/task_list.dart`: status filters, task rows, edit/delete/approve actions

No extra runtime plugins beyond `shared_preferences`. All Dart files stay within
350 lines individually (the brief's per-file limit), not 350 lines in total.

## Notes for demo

- Tap Add To-Do > fill Name + Title + optional Description + Date > choose
  status > Save. It automatically opens the List tab.
- Tap the blue pencil on a task to edit, checkbox to approve, pink trash to
  delete. Use the Status dropdown to change to Cancelled.
- Tap the bell to see your pending/to-do tasks. This is an **in-app list**, not
  background notification delivery.
- Tap Profile to save your name/email and select an emoji avatar.

This ZIP contains source files and resources, not a full generated platform
project. The original Flutter project supplies platform folders and tooling.
