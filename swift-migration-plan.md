# Migration Plan: Objective-C/UIKit/Core Data to Swift/SwiftUI/SwiftData

## Context

Field Tools is a depth-of-field calculator for photographers, currently built
with Objective-C, UIKit, Core Data, and storyboards/XIBs. The goal is a full
migration to Swift 6.2, SwiftUI, and SwiftData targeting iOS 18. The migration
proceeds in phases so each step can be validated and rolled back independently.

All Swift code uses approachable concurrency (`swift(ApproachableConcurrency)`).

**Ship note:** When we release the migrated version, update the App Store
description to reflect that the minimum supported data format is the Core Data
version (v2.3+). Legacy migration code (v1.0-2.2) is being removed.

---

## Standard Validation (applies to every phase)

Every phase must pass these checks before it is considered complete:

- Build succeeds
- All tests pass
- SwiftLint: zero warnings and errors
- Code review performed using relevant skills (swiftui-pro, swiftdata-pro,
  swift-testing-pro, swift-concurrency-pro as applicable)

Phase-specific validation is listed in addition to these.

---

## Phase 0: Preparatory Cleanup

**Goal:** Remove dead code to shrink the migration surface.

### 0.1 Delete legacy migration chain

Remove NSCoding-based classes and all `migrateDefaultsFrom*` methods:

- `src/Classes/Camera.h/.m` (NSCoding legacy, not the Swift file)
- `src/Classes/CameraBag.h/.m` (NSCoding legacy)
- `src/Classes/CoC.h/.m` (NSCoding legacy)
- `src/Classes/Lens.h/.m` (NSCoding legacy)
- All `migrateDefaultsFrom10/20/21/22/23` methods in `FieldToolsAppDelegate.m`
- `relocateCameraBag` method and archive path statics in
  `FieldToolsAppDelegate.m`
- Migration flag keys (`FTMigratedFrom10Key` etc.) from `UserDefaults.h/.m`

### 0.2 Delete MPCoachMarks

- Remove `MPCoachMarks.h/.m` and its call site (`configureCoachMarks` in
  `MainViewController.m`)
- Replacement via TipKit is in Phase 6

### Phase-specific validation

- Existing ObjC app still runs

---

## Phase 1: Pure Swift Business Logic

**Goal:** Port all calculation and formatting logic to Swift as pure value
types. No UI or persistence dependencies. Immediately testable.

### 1.1 DepthOfFieldCalculator

- New file: `src/Classes/DepthOfFieldCalculator.swift`
- Swift struct with static methods: `hyperfocalDistance`, `nearLimit`,
  `farLimit`
- Port the `trueApertures` dictionary as a static `[Float: Float]`
- Direct 1:1 formula port from `DepthOfFieldCalculator.m`

### 1.2 DistanceFormatter

- New file: `src/Classes/DistanceFormatter.swift`
- Swift struct (not NSFormatter subclass)
- `enum DistanceUnits: Int, CaseIterable, Codable` with `.feet`,
  `.feetAndInches`, `.meters`, `.centimeters`
- Port formatting logic from `DistanceFormatter.m`

### 1.3 SubjectDistanceRange

- New file: `src/Classes/SubjectDistanceRange.swift`
- `enum SubjectDistanceRange: Int, CaseIterable, Codable` with `.macro`,
  `.close`, `.mid`, `.far`
- Each case provides `minimumDistance` and `maximumDistance` computed properties
- Replaces the entire policy class hierarchy (10 ObjC files) with a single enum

### 1.4 Aperture

- New file: `src/Classes/Aperture.swift`
- Static array of third-stop f-stop values (from `initApertures` in
  `MainViewController.m`)
- Helper to find nearest aperture index

### 1.5 Tests

- Port assertions from `DepthOfFieldCalculatorTests.m`,
  `DistanceFormatterTests.m`, `LinearSubjectDistanceSliderPolicyTests.m` to
  Swift Testing
- Both ObjC and Swift test suites run in parallel until Phase 4

### Phase-specific validation

- All new Swift tests pass
- All old ObjC tests still pass

---

## Phase 2: SwiftData Models

**Goal:** Establish SwiftData as the persistence layer, reading the existing
Core Data SQLite store directly.

### 2.1 Why no migration service is needed

The xcdatamodel entity names are `Camera`, `CoC`, `Lens` (matching the Swift
`@Model` class names). The `representedClassName` values (`FTCamera` etc.) are
ObjC class mappings only — they don't affect SQLite entity names. Since entity
names and attribute names match, SwiftData can open the existing
`FieldTools.sqlite` store directly.

**Correction (verified 2026-10-05):** an earlier version of this section claimed
`usedWithSwiftData="YES"` was already set on the xcdatamodel. It is not — the
attribute appears nowhere in `FieldTools.xcdatamodel/contents`. The conclusion
still holds, but for the other reasons above, not that one. This is now
verified rather than assumed; see the validation below.

### 2.2 Fix SwiftData model definitions

**`Camera.swift`:**

```swift
@Model
public final class Camera {
    var index: Int = 0
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \CoC.camera)
    var coc: CoC?

    public init(name: String, index: Int = 0) {
        self.name = name
        self.index = index
    }
}
```

**`CoC.swift`** — make `camera` optional to break circular init dependency:

```swift
@Model
public final class CoC {
    var name: String
    var value: Float = 0.019
    var camera: Camera?

    public init(name: String, value: Float = 0.019) {
        self.name = name
        self.value = value
    }
}
```

**`Lens.swift`** — add `isZoom` computed property:

```swift
@Model
public final class Lens {
    var index: Int = 0
    var name: String
    var minimumFocalLength: Int = 50
    var maximumFocalLength: Int = 50
    var minimumAperture: Float = 32
    var maximumAperture: Float = 1.4

    public init(name: String, index: Int = 0) {
        self.name = name
        self.index = index
    }

    var isZoom: Bool { minimumFocalLength != maximumFocalLength }
}
```

Notes:
- `index` field is kept (matches existing Core Data attribute name, used for
  user-controlled ordering)
- `Camera.coc` is optional with cascade delete; `CoC.camera` is an optional
  back-reference
- Int32 widened to Int for idiomatic Swift (SwiftData handles the mapping)

### 2.3 ModelContainer configuration

Point SwiftData at the existing store URL:

```swift
let url = /* Documents directory */ .appending(path: "FieldTools.sqlite")
let config = ModelConfiguration(url: url)
let container = try ModelContainer(for: Camera.self, CoC.self, Lens.self,
                                   configurations: config)
```

### 2.4 CoC presets

- New file: `src/Classes/Model/CoCPreset.swift`
- Static array of preset names and values, derived from `en.lproj/CoC.plist`

### 2.5 UserSettings

- New file: `src/Classes/UserSettings.swift`
- `@Observable` class wrapping all UserDefaults keys. Each setting is a stored
  property loaded from `UserDefaults` in `init` and written back in `didSet`
- Same string keys as existing `UserDefaults.h` for backward compatibility
- Replaces scattered NSUserDefaults reads throughout codebase

### Phase-specific validation

- App launches and reads existing cameras/lenses from the Core Data store via
  SwiftData
- Round-trip test: create, save, re-read SwiftData objects

**Verified 2026-10-05.** `LegacyStoreCompatibilityTests` builds a store through
Core Data using the app's own compiled `FieldTools.momd`, then opens that file
with the app's SwiftData configuration. It covers camera order, the camera-to-CoC
relationship, the Float CoC value, and the Int32-to-Int focal length widening.
The suite was falsified once (an expectation flipped to a wrong camera name) to
confirm the assertions are load-bearing.

End-to-end: a pristine legacy store (three cameras, two lenses, no SwiftData
indexes) placed in the simulator's Documents directory. The app launched showing
`Nikon D300 – 24-70mm f/2.8` with the aperture range f/2.8-f/22 taken from the
stored lens, no store errors logged. Afterwards the store held exactly the three
legacy cameras, SwiftData having additively created its own indexes.

The fallback migration service in the Risk Areas table is therefore not needed.

**Seeding can mask this.** `seedDefaultsIfNeeded` inserts a sample camera and
lens into an empty store, so a store that silently failed to load would still
present a working app. Any future re-verification must assert on the real camera
names, never merely that the list is non-empty. One test pins this directly:
seeding must insert nothing into a populated legacy store.

### Deletable after this phase

- `FTCameraBag.h/.m`, all `FT*.h/.m` and `_FT*.h/.m` model files
- `UserDefaults.h/.m` — **carried 2026-10-05.** `UserSettings` now exposes
  `legacyCoachMarksShown`, a read-only read of the stored key `"CoachMarksShown"`,
  covered by `LegacyCoachMarksFlagTests`. The Objective-C constant is still
  declared in `UserDefaults.h/.m` but has no reader or writer, so it goes with
  those files in the Phase 3 deletion pass.

---

## Phase 3: SwiftUI Views

**Goal:** Replace all UIKit views with SwiftUI. Built and previewed
independently, then swapped in as the app entry point.

### 3.1 App entry point

- New file: `src/FieldToolsApp.swift`
- `@main struct FieldToolsApp: App` with `.modelContainer` (configured per 2.3)
- Inject `UserSettings` into environment

### 3.2 CalculatorView (replaces MainViewController)

- New file: `src/Classes/CalculatorView.swift`
- `@Observable class CalculatorViewModel`: holds current aperture, focal
  length, subject distance, selected camera/lens, computed DoF results
- Standard SwiftUI `Slider` for aperture, focal length, subject distance
  (custom scrubbing slider deferred to Phase 5)
- `Picker` with `.segmented` style for distance type
- `ResultView` (SwiftUI) for displaying results
- Navigation to SettingsView

### 3.3 ResultView (SwiftUI)

- New file: `src/Classes/ResultView.swift`
- Two modes: single value (hyperfocal/far) and range (near + far + difference)
- Uses `DistanceFormatter` from Phase 1

### 3.4 SettingsView (replaces FlipsideViewController)

- New file: `src/Classes/SettingsView.swift`
- `NavigationStack` with `List`: Cameras, Lenses, Units sections
- `@Query(sort: \Camera.index)` and `@Query(sort: \Lens.index)`
- Edit mode for add/delete/reorder (drag reorder updates `index`)
- NavigationLink to CameraEditView, LensEditView

### 3.5 CameraEditView (replaces CameraViewController + CoCViewController + CustomCoCViewController)

- New file: `src/Classes/CameraEditView.swift`
- Three ObjC view controllers collapse into one SwiftUI view
- TextField for name, Picker/List for CoC preset, option for custom CoC value

### 3.6 LensEditView (replaces LensViewController)

- New file: `src/Classes/LensEditView.swift`
- TextFields for name, min/max focal length, min/max aperture

### 3.7 Notification elimination

All 15 NSNotificationCenter notifications are replaced by:

- `@Observable` + `@Query` reactivity (model edits auto-refresh views)
- `@Observable` stored properties in `UserSettings` (preference changes
  auto-propagate)

**Correction 2026-10-07.** This section originally said `@AppStorage`. That is a
SwiftUI view property wrapper and does not drive observation inside an
`@Observable` class. The first implementation instead used computed properties
reading `UserDefaults` directly, which `@Observable` does not track either: the
sliders wrote their values but nothing redrew. Settings must be stored properties
so the macro instruments them; `UserSettingsTests` checks every setting notifies
observers.

### Phase-specific validation

- SwiftUI previews render for each view
- Full app runs end-to-end in SwiftUI
- Calculations match ObjC version exactly
- Settings persist across launches

**Ordering defect found and fixed 2026-10-05.** `SettingsView` deleted through
the `ModelContext` and then reindexed by enumerating its `@Query` array. That
array is a value snapshot and does not lose the deleted models, so the survivors
kept their original indices and the list was left with a gap. The next added
camera took `cameras.count` as its index and collided with an existing one,
giving two models the same index and an undefined order between them.

The fix extracts the logic into `ModelOrdering`, which computes the survivors
itself. Reintroducing the old reindex makes five of the new tests fail, with the
gap visible in the failure output.

### Deletable after this phase

**Done 2026-10-05.** Zero Objective-C files compile in either target. The list
below is kept as the record of what went.

**Gotcha for later phases:** editing `project.pbxproj` outside Xcode while the
project is open leaves Xcode's *test enumeration* stale, even though builds pick
the changes up. The test list kept reporting deleted Objective-C tests as "not
run" through a DerivedData clear and several rebuilds; closing and reopening the
workspace fixed it at once. Build and run results stayed accurate throughout —
only enumeration was wrong.

All remaining ObjC source files:

- All ViewControllers (`MainViewController`, `FlipsideViewController`,
  `CameraViewController`, `LensViewController`, `CoCViewController`,
  `CustomCoCViewController`, `SubjectDistanceRangesViewController`)
- All TableView delegates/data sources (8 files)
- All slider classes (`OBSlider`, `FocalLengthSlider`, `SubjectDistanceSlider`)
- All policy classes (10 files)
- `ResultView.h/.m`, `DistanceRange.h/.m`, `DistanceFormatter.h/.m`,
  `DepthOfFieldCalculator.h/.m`
- `FieldToolsAppDelegate.h/.m`, `main.m`, `Notifications.h`
- `FieldTools-Bridging-Header.h`, `FieldTools_Prefix.pch`
- All `.xib` files (6) and `Main.storyboard`
- `LaunchScreen.storyboard` (replaced by SwiftUI launch behavior or new
  storyboard if needed)

---

## Phase 4: Test Migration and Project Cleanup

**Goal:** All-Swift test suite, clean Xcode project.

### 4.1 Port remaining ObjC tests to Swift Testing

- Verify all ObjC test cases have Swift equivalents
- ~~Port `FTCameraBagTests` as SwiftData integration tests~~ **Done
  2026-10-05**, pulled forward because the deletion pass cannot remove
  `FTCameraBag` until its ordering rules are covered elsewhere. The logic moved
  into `SettingsView` during Phase 3 and was untested there; it is now
  `ModelOrdering`, covered by `ModelOrderingTests`.
- Check `Field_Tools_Tests.m` for anything not yet covered

**Sequencing note.** Phase 3 deletes the `FT*` models while Phase 4 deletes the
Objective-C tests, but `FTCameraBagTests`, `DepthOfFieldCalculatorTests`,
`DistanceFormatterTests` and `LinearSubjectDistanceSliderPolicyTests` all test
code Phase 3 removes. Each must be deleted in the same commit as its subject,
not deferred to Phase 4.

### 4.2 Delete ObjC test files

### 4.3 Clean up Xcode project

- Remove all ObjC file references from project.pbxproj
- Remove bridging header from build settings
- Remove ObjC build settings and prefix header
- Update deployment target to iOS 18
- Enable strict concurrency checking

### 4.4 Convert Localizable.strings to String Catalog (.xcstrings)

### Phase-specific validation

- Zero ObjC source files
- All tests pass (Swift Testing only)
- App runs correctly on iOS 18

---

## Phase 5: Custom Scrubbing Slider

**Goal:** Restore the variable-speed scrubbing UX from OBSlider as a pure
SwiftUI component.

### 5.1 Build ScrubSlider

- New file: `src/Classes/ScrubSlider.swift`
- Custom SwiftUI view using `DragGesture`
- Vertical distance from slider track reduces scrubbing speed (replicating
  OBSlider behavior)
- Configurable scrubbing speed tiers

### 5.2 Replace standard Sliders

- Swap `Slider` for `ScrubSlider` in CalculatorView (aperture, focal length,
  subject distance)
- `FocalLengthSlider` and `SubjectDistanceSlider` specializations become
  configuration presets on ScrubSlider

### Phase-specific validation

- Scrubbing behavior matches or improves on OBSlider
- All calculation results unchanged

---

## Phase 6: TipKit Onboarding

**Goal:** Replace MPCoachMarks (deleted in Phase 0) with TipKit tips.

### 6.1 Define tips

Tips should mirror the original coach marks. The original coach marks pointed
to these UI elements (from `MainViewController.m` `configureCoachMarks`):

- Camera/lens selection button — explain how to switch cameras and lenses
- Aperture slider — explain aperture control
- Focal length slider — explain focal length control
- Subject distance slider — explain subject distance control
- Distance type segmented control — explain the calculation modes
- Result view — explain how to read the results

### 6.2 Implement with TipKit

- Use `.popoverTip()` modifier on each target view in CalculatorView
- Configure tip display rules (show once, sequential order)
- Add a "Reset Tips" option in SettingsView

### 6.3 Suppressing tips for users upgrading from coach marks

TipKit owns its own display state — datastore, display counts, rule
evaluation, invalidation. Do **not** gate tips on a UserDefaults flag: that
creates a second source of truth alongside TipKit's, and the two will drift
(a tip invalidated in TipKit's store but with the flag unset, or the reverse).
"Show once" is `MaxDisplayCount(1)` or `invalidate(reason:)`, not a bool.

There is exactly one job TipKit cannot do for itself: knowing that a user
already saw the old MPCoachMarks. On upgrade TipKit's datastore is empty, so
without an external signal every existing user is shown the tips again.

`FTCoachMarksShown` (stored key `"CoachMarksShown"`) is that signal, and it is
correctly shaped for it *because* Phase 0 removed every writer:

- existing users who saw the coach marks → `true`
- everyone else, including all new installs → key absent → `false`

Keep it strictly read-only. Consume it once at startup and let TipKit own
everything afterwards:

```swift
if settings.legacyCoachMarksShown {
    calculatorTip.invalidate(reason: .actionPerformed)
}
```

Resurrecting it as a live read/write flag destroys the property that makes it
useful.

Notes:

- ~~**Move it before deleting `UserDefaults.h/.m`.**~~ Done 2026-10-05:
  `UserSettings.legacyCoachMarksShown`, read-only, no registered default, so an
  absent key reads as `false`.
- **Preserve the raw string exactly:** `"CoachMarksShown"`. The constant name
  (`FTCoachMarksShown`) and the stored key differ. Getting this wrong silently
  loses the signal for every existing user, with no error to catch it.
  `LegacyCoachMarksFlagTests` pins the spelling: one test sets
  `"FTCoachMarksShown"` and asserts the flag stays `false`. Both key tests were
  confirmed to fail when the key was deliberately mis-spelled.
- **Give it an expiry.** Once the install base has moved past the TipKit
  release, the flag and its read site are dead weight and should be removed.
- **Verify first:** this design assumes TipKit's datastore survives app
  updates. If it does not, tips re-show on every update and the approach needs
  rethinking. Confirm before building on it.

### Phase-specific validation

- Tips display on first launch
- Tips dismiss correctly and don't re-appear
- Reset option works
- Upgrading from a build where `CoachMarksShown` is `true` shows no tips
- Fresh install (key absent) shows tips normally
- The flag is read but never written

---

## Risk Areas

| Risk | Mitigation |
|------|-----------|
| SwiftData can't read existing Core Data store | Entity and attribute names match; `usedWithSwiftData` is set. If it fails, fall back to a one-time migration service reading the old store via `NSPersistentContainer` |
| Circular Camera-CoC relationship in SwiftData | CoC.camera is optional; Camera owns CoC with cascade delete |
| OBSlider removal temporarily degrades UX | Standard Slider used in Phase 3; custom scrubbing slider built in Phase 5 |
| Int32-to-Int type widening causes store mismatch | SwiftData handles Int/Int32 mapping transparently; verify in Phase 2 validation |

## Phase Dependencies

```
Phase 0 (Cleanup) ─────┐
                        ├─> Phase 2 (SwiftData) ─> Phase 3 (SwiftUI) ─> Phase 4 (Cleanup)
Phase 1 (Business Logic)┘                                   |
                                                             ├─> Phase 5 (Scrub Slider)
                                                             └─> Phase 6 (TipKit)
```

Phases 0 and 1 can run in parallel (different files). Phase 2 needs Phase 1
types. Phase 3 needs both 1 and 2. Phases 4, 5, and 6 are independent of each
other but all require Phase 3.
