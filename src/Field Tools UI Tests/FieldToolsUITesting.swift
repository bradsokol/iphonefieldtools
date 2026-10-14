// Copyright 2009-2025 Brad Sokol
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import XCTest

/// Shared launch and navigation helpers for the calculator and settings UI tests.
///
/// Each test launches the app with `-UITestState`, which gives it a camera bag and
/// preferences of its own, so the data already on the device is never read or changed.
/// A fresh launch starts with the sample camera and the 24–120 mm sample lens at f/8.
///
/// A protocol rather than a base class, so that Xcode does not list an empty test class.
@MainActor
protocol FieldToolsUITesting: XCTestCase {}

/// Whether a launch starts from a fresh camera bag and preferences or keeps the last ones.
enum UITestLaunchState: String {
    case fresh
    case keep
}

extension FieldToolsUITesting {

    /// Launches the app and waits for the calculator result to appear.
    func launch(_ state: UITestLaunchState) -> XCUIApplication {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["-UITestState", state.rawValue]
        app.launch()
        XCTAssertTrue(resultElement(in: app).waitForExistence(timeout: 10))
        return app
    }

    /// Returns from settings to the calculator.
    func closeSettings(in app: XCUIApplication) {
        app.navigationBars.buttons["Back"].tap()
    }

    /// The settings row naming `name`.
    ///
    /// A row in edit mode without a checkmark reports its text as "Remove, <name>", so
    /// the text cannot be found by its name alone.
    func row(_ name: String, in app: XCUIApplication) -> XCUIElement {
        app.cells.containing(NSPredicate(format: "label CONTAINS %@", name)).firstMatch
    }

    /// Whether the settings row naming `name` shows the edit-mode delete control.
    func hasDeleteControl(_ name: String, in app: XCUIApplication) -> Bool {
        row(name, in: app).images["minus.circle.fill"].exists
    }

    /// Taps the middle of the settings row naming `name`, clear of the edit-mode controls
    /// at either end.
    func tapRow(_ name: String, in app: XCUIApplication) {
        row(name, in: app).coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    /// The calculator's result, which carries the `result` accessibility identifier.
    func resultElement(in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)["result"]
    }

    /// The calculator's result as VoiceOver reads it.
    func resultValue(in app: XCUIApplication) -> String {
        resultElement(in: app).value as? String ?? ""
    }
}
