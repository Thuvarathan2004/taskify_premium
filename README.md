# Taskify Premium – Color Upgrade

A colorful Flutter To-Do app with a **5-second splash**, **4 image dashboard tiles**, **All / Pending / Completed tabs**, **Delete**, **Stats**, and a **create/edit profile** (name, bio, 6 emoji avatars). Tasks and profile are stored locally with `SharedPreferencesAsync`.

## Install or update existing app

1. Back up your existing Flutter project first.
2. If updating an existing `taskify_premium` app, replace **only** its `lib/` folder, `assets/`, `pubspec.yaml`, `analysis_options.yaml`, and `test/widget_test.dart` with ZIP contents. **Do not delete `.git`**, platform folders or other personal files.
3. If starting fresh, run `flutter create taskify_premium` first, then copy the same items.
4. `flutter pub get` then `flutter run -d chrome`.
5. `flutter analyze` and `flutter test` for local verification.

Profile: bottom `Profile` icon → enter a name, optional bio, choose an emoji avatar → **Save profile**. Edit from the same page later; dashboard avatar also takes you there. All existing tasks saved using key `taskify_todos` remain compatible with the previous version.

## GitHub

Run `git status`, then `git add .`, `git commit -m "Add editable profile and vibrant task colors"`, `git push` (assuming the existing project is already connected to your GitHub remote).

Flutter SDK is not installed in the artifact-build environment; run the checks above on your own PC. The splash screen test timing may need adjustment if the framework reports a test-specific timer issue; share its detailed exception log if so.
