# Application identifiers

The app uses **two spellings of the same identifier**, because no single
spelling is valid everywhere. Keep them in sync and do not mix them up.

| Spelling | Used by |
|---|---|
| `io.github.gesugao_san.flutter_template` | Android, Linux |
| `io.github.gesugao-san.flutter-template` | iOS, macOS (and Windows MSIX, if added) |

## Why two spellings

| Platform | Allowed in the identifier | Breaks on |
|---|---|---|
| Android | letters, digits, `_`; each segment starts with a letter | `-` |
| iOS, macOS | letters, digits, `-`, `.` | `_` |
| Windows MSIX package name | letters, digits, `-`, `.` | `_` |
| Linux (GApplication ID) | letters, digits, `_`, `-` (hyphens discouraged) | — |

The GitHub user name `Gesugao-san` contains a hyphen, so Android needs it as
`gesugao_san` (the usual Java convention for hyphens in domain names), while
Apple platforms keep the hyphen and cannot use the underscore.

## Where each identifier is set

| Platform | File | Setting |
|---|---|---|
| Android | `android/app/build.gradle.kts` | `namespace`, `applicationId` |
| Android | `android/app/src/main/kotlin/io/github/gesugao_san/flutter_template/MainActivity.kt` | `package` line and folder path (must match `namespace`) |
| Linux | `linux/CMakeLists.txt` | `APPLICATION_ID` |
| iOS | `ios/Runner.xcodeproj/project.pbxproj` | `PRODUCT_BUNDLE_IDENTIFIER` (app and `.RunnerTests`) |
| macOS | `macos/Runner/Configs/AppInfo.xcconfig` | `PRODUCT_BUNDLE_IDENTIFIER` |
| macOS | `macos/Runner.xcodeproj/project.pbxproj` | `PRODUCT_BUNDLE_IDENTIFIER` of `.RunnerTests` |

Find every occurrence with:

```sh
git grep -n -e "gesugao_san.flutter_template" -e "gesugao-san.flutter-template"
```

## Rules

- **Change the identifiers before the first public release** of a project
  made from this template. App stores and package managers treat a new
  identifier as a different app: users of the old one stop receiving
  updates.
- When renaming, change **both** spellings in **all** files above in one
  commit, and move the Android `MainActivity.kt` folder to match the new
  `namespace`.
- Derive the two spellings from one name: replace `-` with `_` for Android and
  Linux, and `_` with `-` for Apple platforms and MSIX.
