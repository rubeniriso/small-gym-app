# Gym app

Local phone app for weightlifting routines. The UI is Flutter, in English, simple, with light and dark themes. Workout data stays on the device in SQLite.

The phone build is Android. On this machine, `flutter run` opens a Linux desktop window, the same way kangym does. The Dart package is `gym_app`.

## Stack

- Flutter stable and Material 3. Follow the system light/dark theme, and add an in-app toggle for system, light, or dark.
- Drift on SQLite. No remote API.
- Riverpod for app state.
- go_router for Home and Routines.
- Hardcoded English. Add an English ARB catalog only if copy spreads past the first slice.

## Out of scope

- Cloud backend, remote API, or sync
- Accounts or auth
- Store release

## Easy to get wrong

- The base template prescribes deadlift at 5×5, same as the other lifts.
- Progression reads the previous logged session of that exercise (rep total greater than 24 adds 2.5 kg). Squat is one stream across workouts A and B. No deloads.
- Many routines, one current. Home opens on the current routine.

## Plan

The product plan is Spanish and lives only in the Project store. Do not copy it into this repo.

`/home/rubeniriso/.local/state/cursor/agent-stores/cursor_agent_stores/bc-1f4db54c-3b7a-4933-b02c-bef26e0bc75d/files/docs/first-steps.md`

## Commands

Flutter stable is `$HOME/sdks/flutter` (not on the default PATH). The Android SDK is `$HOME/Android/Sdk`. Flutter is configured to use JDK 21 at `$HOME/sdks/jdk-21`.

The Makefile puts Flutter, the Android SDK, and JDK 21 on `PATH` for its recipes.

```bash
make mobile-flutter
make mobile-flutter-apk
```

`make mobile-flutter` runs `flutter pub get` and `flutter run`. With no phone attached it opens the Linux desktop window. A connected Android device or a running emulator is used when you pass it with `ARGS` (`make mobile-flutter ARGS="-d <id>"`).

`make mobile-flutter-apk` builds a release APK, signed with the debug key so it can be installed on a phone:

`build/app/outputs/flutter-apk/app-release.apk`
