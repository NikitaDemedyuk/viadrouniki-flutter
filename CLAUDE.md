# viadrouniki

Flutter client for the viadrouniki.by road-trip API (`https://api.viadrouniki.by/v1`) — trips,
points of interest and the cars that drive them, across Belarus. A port of the SwiftUI app
[viadrouniki-ios](https://github.com/NikitaDemedyuk/viadrouniki-ios), styled after the web version
(viadrouniki.by) on Material 3. Colours come from the mobile design system's **Android light and
dark** palettes, used on every platform.

This file holds project **invariants** — facts that hold whether or not anyone remembers why.
When code and this file disagree, find out which is wrong and fix that one.

## Toolchain

| | |
|---|---|
| Flutter / Dart | **3.47.5 / 3.13.4**, pinned in `.fvmrc` |
| iOS | Xcode 27.1, deployment target **15.0** |
| Android | Gradle 9.3.1, AGP 9.1.0, Kotlin 2.4.0, run on **JDK 21** |

- **Always run `fvm flutter …` / `fvm dart …`.** The machine's global Flutter is 3.38.9, kept for
  other projects, and it **cannot build iOS with Xcode 27.1**: its `debug_unpack_ios` step misreads
  the output of Xcode 27's `lipo` (`does not contain architectures "arm64 x86_64"` while `lipo -info`
  lists exactly those). No project setting fixes it. Never verify a build with the global SDK.
- FVM is installed with `dart pub global activate fvm`, then `fvm install` in the repo.
- VS Code uses the pinned SDK through the committed `.vscode/settings.json`. Android Studio must be
  pointed at `.fvm/flutter_sdk` by hand.
- **Line width is 80**, Dart's default, which `dart format` uses because `analysis_options.yaml` sets no
  `page_width`. `.vscode/settings.json` pins `"dart.lineLength": 80` so a personal VS Code
  `dart.lineLength` can't make Format Document disagree with `dart format --set-exit-if-changed`.
- Gradle runs on JDK 21 LTS via `flutter config --jdk-dir=<jdk-21 home>` (a machine-wide Flutter
  setting). Android Studio's bundled Java 25 also works but prints JEP 472 "restricted method"
  warnings from Gradle's `native-platform` library.
- A dropped connection mid-download has produced a "✓ setup" from `fvm install` over an incomplete
  Dart SDK. Trust `fvm list` / `fvm flutter --version`, not the success message.

```bash
fvm flutter pub get                          # also regenerates l10n (generate: true)
fvm dart format --set-exit-if-changed .
fvm flutter analyze
fvm flutter test
fvm flutter build ios --simulator --debug
fvm flutter build apk --debug
```

## Claude Code

- `.claude/settings.json` enables the official **Dart and Flutter plugin**
  (`dart-flutter@dart-flutter`, from `github.com/flutter/agent-plugins`) for its skills.
- The plugin would start its MCP server with a bare `dart`, which is the global 3.38.9. That
  launcher always exports its own `FLUTTER_ROOT`, so no setting can move that server onto the
  pinned SDK, and its Flutter-driven tools (`run_tests`, `pub`, `launch_app`) fail here with
  "requires SDK version ^3.13.4".
- **`.mcp.json` adds a `dart` server run through `fvm dart mcp-server`**, so every tool runs on
  3.47.5; use its `mcp__dart__*` tools. The plugin's own server is blocked by `deniedMcpServers` in
  `.claude/settings.json` (by name and by its exact `dart mcp-server` command, which the `fvm`
  server doesn't match); the `/mcp` toggle can't switch plugin servers off. The plugin's skills
  keep working without it.
- The pinned server (1.1.2) has no `run_tests`, `launch_app` or `dart_format`: it attaches to an
  app already started with `fvm flutter run`, through `dtd`, for hot reload, runtime errors and
  the widget inspector. Run tests, formatting and builds with the commands above.

## Branches and PRs

- GitHub flow: **`main`** is the only long-lived branch, the default branch and the base of every
  PR. It is kept buildable, and releases are tagged on it.
- Every change goes on its own branch cut from `main`: `feature/<slug>`, `fix/<slug>`,
  `chore/<slug>` (deps, config, tooling), `docs/<slug>`. Nothing is committed directly to `main`.
- PR and commit titles use Conventional Commits: `<type>(<scope>): <summary>`, lowercase,
  imperative, no period, ≤ 72 chars. Branch prefix → type: `feature/` → `feat`, `fix/` → `fix`,
  `docs/` → `docs`, `chore/` → `chore` (or `refactor`/`test`/`build`/`style` when those fit better).
- The PR body follows `.github/pull_request_template.md`: Summary, Changes (grouped by concern),
  Screenshots (UI only), Reviewer notes, Verification. Leave out optional sections that don't
  apply rather than writing "N/A".
- **Merge with "Squash and merge"**, the only method the repo allows. The PR title becomes the
  commit on `main` and its body stays empty, so the title must describe the whole change.
- The **"Main protection" ruleset** on `main` (no bypass) blocks direct pushes, force-pushes and
  deletion, allows squash merge only, and requires the `Format, analyze, test, build` check.
  That check is the CI job's `name:` in `ci.yml`: renaming the job leaves every PR waiting on a
  check that never reports, so update the ruleset in the same PR.
- A PR is one concern. Commits inside the branch are free-form: only the PR title lands on
  `main`, and each PR must pass format, analyze and test as a whole.
- Add a dependency in the PR that first uses it — never ahead of time.
- A PR that changes something this file states updates this file in the same PR, not after it.

## CI and releases

- GitHub Actions. **`ci.yml`** runs on every PR, stacked ones included, and every push to
  `main`: `dart format --set-exit-if-changed .`, `flutter analyze`, `flutter test`,
  `flutter build apk --debug`.
- **`.github/actions/setup-flutter` reads the SDK version from `.fvmrc`**, so CI can't drift from
  FVM: an SDK upgrade changes `.fvmrc` only. It also sets up JDK 21, as locally.
- CI builds Android only. iOS is verified locally with `fvm flutter build ios --simulator --debug`.
- **Pushing a tag `v<x.y.z>`** on a commit in `main` runs **`release.yml`**: the `ci.yml`
  checks, then a release APK attached to a GitHub **pre-release**. `--build-name` is the tag and
  `--build-number` is `x·10000 + y·100 + z`, so the versionCode grows with the version and is the
  same on a re-run; minor and patch must stay below 100. A tag that isn't on `main` fails. The
  APK is signed with the debug key, through the template's release `signingConfig`: it installs by
  sideloading but can't be published to Google Play, hence pre-release.

## Platform projects

- `ios/` and `android/` are the **Flutter 3.47.5 app template, unmodified** apart from the Android
  label. On an SDK upgrade, run `flutter create` with the same org and name in a temp directory and
  copy its tracked platform files over: `flutter build`'s automatic migrations cover only part of a
  template change (they never add `SceneDelegate.swift`, Swift Package Manager, or Gradle updates).
- **The bundle id stays `com.example.viadrouniki` until the app is prepared for store release** — a
  deliberate decision, not an oversight. Renaming later means updating iOS
  `PRODUCT_BUNDLE_IDENTIFIER`, Android `applicationId`/`namespace`/`MainActivity` package, and
  re-running `flutterfire configure`. `com.example` ids can't be published to either store.
- iOS uses the **UIScene lifecycle**. `SceneDelegate` is an empty `FlutterSceneDelegate` subclass,
  kept to match the template; it is where the app's own scene-level native code goes (URL
  contexts, user activities). Plugins already receive those events without it.
- iOS plugins come through **Swift Package Manager**, not CocoaPods.
- `ios/Flutter/AppFrameworkInfo.plist` has **no `MinimumOSVersion`**, on purpose: Flutter writes it
  into `App.framework/Info.plist` at build time, so it can't drift from the deployment target.
  Don't add it back.

## Localization

- Only **Russian (`ru`) and Belarusian (`be`)**. There is deliberately no English UI: the API has no
  English content, and `locale=en` silently returns Russian.
- `app_ru.arb` is the **template**; `app_be.arb` holds translations only. `@key` metadata
  (`description`, `placeholders`, plural/select) goes **only in the template** — the generator
  ignores it elsewhere. `required-resource-attributes: true` makes a key without a description fail
  generation.
- Generated code in `lib/core/l10n/gen/` is gitignored and excluded from analysis; `pub get`
  recreates it.
- **The language is app-controlled, never the device's.** With a device locale outside ru/be,
  Flutter would fall back to whichever supported locale sorts first (`be`), so `MaterialApp.locale`
  is always set, from `LanguageCubit`'s saved language (default `ru`).
- Flutter ships Material, Cupertino and Widgets strings for `be` — unlike iOS, which has no
  Belarusian system language — so system UI needs no extra work.
- The brand name «Вядроўнікі» is Belarusian in every locale, as on the web.

## Code style

- Lints: **`very_good_analysis` 11**, with `public_member_api_docs` off (an app, not a package).
- It enforces Dart 3.13's abbreviated constructors: `const new({super.key})` instead of repeating the
  class name. Call sites are unchanged (`const ViadrounikiApp()`). `dart fix --apply` converts
  existing code.

## Comments

Comments are for people reading the code, not for Claude or other tools: project context lives in
this file. **Default to none.** Names, types and tests say *what* the code does.

- **A fact that holds across the project goes here, not in the code.** An API quirk or a
  convention is stated once in this file and not repeated in a comment; a comment carries only a
  *why* that is true of the line it sits on.
- **Write one only for a *why* the code can't show:** a hidden backend behaviour, a deliberate
  deviation from a convention, a platform or SDK quirk, or a trap someone would otherwise "fix".
  One or two lines.
- **Never:**
  - restate the code (`// Emit the new mode`, `/// The only two languages` above a two-value
    enum);
  - describe plans or future work (`later`, `will`, `TODO`) — that belongs in an issue or a PR;
  - tell the history of the code (`previously`, `changed to`) — that belongs in the commit message;
  - mention PR numbers, internal plans or tools.
- `///` documents a declaration and appears in IDE hovers; `//` explains a line inside a body.
  `public_member_api_docs` is off, so a public member without a doc comment is fine.
- A comment that no longer matches the code is worse than none: update or delete it in the same
  change.

Example — a *what* that the code already says, versus the *why* nobody could guess:

```dart
/// The brand green.                                        // ✗ restates the name
/// White text on it is 2.3:1, so the light theme's
/// accent is a darker green from the same scale.          // ✓ deliberate deviation
static const brand = Color(0xFF52C41A);
```

## Architecture (rules for code as it lands)

- Feature-first folders under `lib/features/<feature>/` with `data/`, `domain/`, `presentation/`;
  shared code under `lib/core/`. Dependencies point downward only.
- State: `flutter_bloc`. Blocs depend on **use cases** received through the constructor; a use case
  is one operation in `domain/` and depends on **abstract repositories**. Blocs never import
  `material.dart`.
- `get_it` is used only at the composition root and in route builders; no class looks up its own
  dependencies.
- Navigation: `go_router` with a `StatefulShellRoute.indexedStack`, one branch per `AppTab` in the
  enum's order, so each tab keeps its own stack. Tab paths are the web's (`/trips`, `/attractions`,
  `/cars`), so a viadrouniki.by link maps onto the same route. An unknown location redirects to
  the start tab through `onException`, so go_router's default error page, which is in English, is
  never shown. The router is created once in
  `main`; a language or theme change must never rebuild it or key the tree, which would reset
  every tab's stack.
- Widgets take colours from `Theme.of(context)`, never from `AppColors`: `ColorScheme` roles, and
  the `AppExtraColors` theme extension for colours outside them (brand, summer and winter season).
- Widgets hold no business logic and make no network calls. Presentation mappings (a colour or icon
  for a model value) live in `presentation/` extensions, not on models.
- Errors: a sealed `Result`/`AppException`, not exceptions thrown through blocs.
- Global error handling goes through `FlutterError.onError` (left at Flutter's default, which
  presents the error) and `PlatformDispatcher.instance.onError` — **not** `runZonedGuarded`.
- No flavors and no `bootstrap()` file: there is one backend.

## API facts

Checked against the live API on 2026-09-26 unless marked as carried over from the iOS project.

- **Four response envelopes, not one.** Paginated lists: `{data, links, meta}`. Single resources and
  `attraction-types`: `{data}`. `attractions/map`: a **bare JSON array**. `auth/me`: `{user}`
  (carried over). Picking the wrong one fails at runtime, not at compile time.
- **Send `Accept: application/json` on every request.** Without it, an unauthenticated call to a
  protected route returns **500 `text/html`** instead of **401 `application/json`** (verified on
  `auth/me`), which makes 401 handling unreachable.
- **`ApiConfig.baseUrl` ends with `/`.** Dio concatenates it with the path and then collapses `//`,
  so `/trips` and `trips` both request `…/v1/trips`; without the slash, `trips` would request
  `…/v1trips`.
- Errors come as `{message, error_code}` (`message` follows `locale`); a 401 carries only
  `message`. A 5xx may be `text/html`, so nothing may assume an error body is JSON.
- Every 2xx response is `application/json` (checked 2026-10-02), so a non-JSON 2xx comes from
  something in between, such as a captive portal, and `ApiClient` reports it as a
  `NetworkException`.
- Content endpoints take `locale=ru|be`. `locale=en` is accepted but returns the Russian payload
  byte for byte. A language switch must **refetch** content, because the locale is baked into
  responses already held in state.
- Timestamps are ISO 8601 with fractional seconds: `2026-02-06T17:17:43.000000Z`.
- `per_page` is capped at 100.
- `latitude`/`longitude` are **strings** in `attractions` but **numbers** in `attractions/map`.
- `external_links` is `[]` on every trip today; the iOS app also met `[{url, label}]` and a
  `{"map": …, "link": …}` object (carried over). Parse all three.
- Carried over from iOS: `trips/{id}/cars` returns a slimmer car shape than `cars`;
  `TripAttraction.id` is the trip-attraction row id, not the attraction id; an attraction type with
  `sort_order >= 100` is an amenity; `attraction-types` returns Russian names even for `locale=be`;
  `auth/me` and `user/cars` are the only endpoints that need auth.
- Before writing a decode type for a new endpoint, look at the real payload:

  ```bash
  curl -s 'https://api.viadrouniki.by/v1/<path>?locale=ru' | head -c 400
  ```
