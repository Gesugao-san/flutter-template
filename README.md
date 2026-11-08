# Flutter Base

[![CI](https://github.com/Gesugao-san/flutter-base/actions/workflows/ci.yml/badge.svg)](https://github.com/Gesugao-san/flutter-base/actions/workflows/ci.yml)

A universal cross-platform starter: one Flutter code base that runs on
**Android, iOS, Windows, macOS, Linux and the web**.

It is a localized "Hello, World!" that already contains the pieces most
projects need:

- **Material 3** light and dark themes from one seed color; the system theme
  is followed by default and can be overridden in the app.
- **Localization** (English, Russian) generated from ARB files; the system
  language is followed by default and can be overridden in the app.
- **Adaptive layout**: content is width-constrained on desktop and web,
  labels stay on one line on narrow phones.
- **CI** on GitHub Actions: format check, static analysis, tests and release
  builds for all six platforms, uploaded as artifacts.
- **Self-contained web build**: the renderer is bundled with the app
  (`--no-web-resources-cdn`), nothing is loaded from Google's CDN.

## Requirements

- Flutter **3.47.9** (pinned in `pubspec.yaml`; CI uses the same version).
- Platform toolchains as described in the
  [Flutter install guide](https://docs.flutter.dev/get-started/install).
  iOS and macOS builds need a Mac with Xcode; CI covers them on
  `macos-latest` runners.

## Quick start

```sh
flutter pub get        # also generates lib/l10n/generated/
flutter run            # pick a device, e.g. -d windows, -d chrome
flutter test
```

## Building

| Platform | Command | Output |
|---|---|---|
| Android | `flutter build apk --release` | `build/app/outputs/flutter-apk/` |
| iOS | `flutter build ios --release` | `build/ios/iphoneos/` |
| Windows | `flutter build windows --release` | `build/windows/x64/runner/Release/` |
| macOS | `flutter build macos --release` | `build/macos/Build/Products/Release/` |
| Linux | `flutter build linux --release` | `build/linux/x64/release/bundle/` |
| Web | `flutter build web --release --wasm --no-web-resources-cdn` | `build/web/` |

Every push to `main` builds all of them in CI; download the results from the
run's **Artifacts** section.

## Releases

Pushing a version tag publishes a GitHub Release with ready-to-use packages
for all six platforms and a `SHA256SUMS.txt`:

```sh
# 1. Set the same version in pubspec.yaml (`version: 1.2.3+1`) and commit it.
# 2. Tag and push; the workflow refuses tags that differ from pubspec.yaml.
git tag v1.2.3
git push origin v1.2.3
```

Tags with a suffix such as `v1.2.3-beta.1` become pre-releases. The build
number is the release workflow's run number, so it grows with every release.

### Android signing

Without signing secrets the release APK is signed with a throwaway debug key
that CI generates anew on every run, so a newer APK **cannot update** an
installed older one. Create an upload key once and keep it safe; losing it
means users have to reinstall the app:

```sh
keytool -genkeypair -v -keystore upload-keystore.jks -storetype JKS \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
base64 -w0 upload-keystore.jks   # value for ANDROID_KEYSTORE_BASE64
```

Then add repository secrets (Settings → Secrets and variables → Actions):
`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`,
`ANDROID_KEY_PASSWORD`. For local signed builds put the same values into
`android/key.properties` (git-ignored):

```properties
storeFile=upload-keystore.jks
storePassword=...
keyAlias=upload
keyPassword=...
```

### Apple platforms

The macOS app is not notarized and the iOS `.ipa` is unsigned: signing for
Apple platforms needs a paid Apple Developer account and is not set up here.

## Project structure

```
lib/
  main.dart                  entry point
  app.dart                   MaterialApp: theme, localization, settings
  home/home_page.dart        the Hello World screen
  settings/app_settings.dart theme mode and locale (ChangeNotifier + scope)
  theme/app_theme.dart       light/dark Material 3 themes
  platform/platform_name.dart human-readable platform name
  l10n/app_en.arb            English strings (template)
  l10n/app_ru.arb            Russian strings
test/widget_test.dart        widget and unit tests
.github/workflows/build.yml  reusable check + build + package pipeline
.github/workflows/ci.yml     runs it on every push and pull request
.github/workflows/release.yml publishes a release for version tags
```

## Using it as a base for a new project

1. Use this repository as a template (or copy it).
2. Rename the package: `name:` in `pubspec.yaml` and the `package:flutter_base`
   imports in `test/`.
3. Change the application ID: `io.github.gesugaosan.flutter_base` (Android
   `applicationId`/`namespace`, Linux `APPLICATION_ID`) and
   `io.github.gesugaosan.flutterBase` (iOS/macOS `PRODUCT_BUNDLE_IDENTIFIER`),
   plus the display name "Flutter Base".
4. Change `AppTheme.seedColor` to your brand color.
5. Add strings to `lib/l10n/app_en.arb` first, then translate them in the
   other ARB files.

Settings are kept in memory only; add persistence (for example
`shared_preferences`) when a project needs it.

## Adding a language

Create `lib/l10n/app_<code>.arb`, run `flutter pub get`, then add the language
to `_Language` and `_languageLocales` in `lib/home/home_page.dart` and to
`CFBundleLocalizations` in `ios/Runner/Info.plist` and
`macos/Runner/Info.plist`.

## License

[MIT](LICENSE)
