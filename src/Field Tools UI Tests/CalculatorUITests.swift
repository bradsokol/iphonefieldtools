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

/// End-to-end checks of the calculator and settings screens.
///
/// Each test launches the app with `-UITestState`, which gives it a camera bag and
/// preferences of its own, so the data already on the device is never read or changed.
/// A fresh launch starts with the sample camera and the 24–120 mm sample lens at f/8.
@MainActor
final class CalculatorUITests: XCTestCase {

    // MARK: - Tests

    func testMovingTheApertureSliderUpdatesTheValueAndResult() {
        let app = launch(.fresh)
        let before = resultValue(in: app)
        XCTAssertTrue(app.staticTexts["f/8"].exists)

        app.sliders["Aperture:"].adjust(toNormalizedSliderPosition: 1)

        XCTAssertFalse(app.staticTexts["f/8"].exists)
        XCTAssertNotEqual(resultValue(in: app), before)
    }

    func testMovingTheFocalLengthSliderUpdatesTheResult() {
        let app = launch(.fresh)
        let before = resultValue(in: app)

        app.sliders["Focal length:"].adjust(toNormalizedSliderPosition: 1)

        XCTAssertTrue(app.staticTexts["120 mm"].exists)
        XCTAssertNotEqual(resultValue(in: app), before)
    }

    func testMovingTheSubjectDistanceSliderUpdatesTheNearLimit() {
        let app = launch(.fresh)
        app.buttons["Near"].tap()
        let before = resultValue(in: app)

        app.sliders["Distance to subject:"].adjust(toNormalizedSliderPosition: 0.9)

        XCTAssertNotEqual(resultValue(in: app), before)
    }

    func testNearFarResultNamesEachValueForVoiceOver() {
        let app = launch(.fresh)

        app.buttons["Near+Far"].tap()

        let result = resultElement(in: app)
        XCTAssertEqual(result.label, "Depth of field")
        let value = resultValue(in: app)
        XCTAssertTrue(value.hasPrefix("Near limit "), value)
        XCTAssertTrue(value.contains(", far limit "), value)
    }

    func testDistanceTypeAndUnitsPersistAcrossLaunches() {
        let app = launch(.fresh)
        app.buttons["Near+Far"].tap()
        app.buttons["settingsButton"].tap()
        app.buttons["Metres"].tap()
        app.buttons["Done"].tap()
        XCTAssertTrue(resultValue(in: app).contains(" m,"), resultValue(in: app))

        app.terminate()
        let relaunched = launch(.keep)

        XCTAssertEqual(resultElement(in: relaunched).label, "Depth of field")
        XCTAssertTrue(resultValue(in: relaunched).contains(" m,"), resultValue(in: relaunched))
    }

    func testRenamingTheLensUpdatesTheCalculatorFooter() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        app.buttons["Sample lens"].tap()

        let name = app.textFields["Name"]
        XCTAssertTrue(name.waitForExistence(timeout: 5))
        name.tap()
        let current = name.value as? String ?? ""
        name.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count) + "Test lens")
        app.navigationBars.buttons["Save"].tap()
        app.buttons["Done"].tap()

        XCTAssertTrue(app.buttons["settingsButton"].label.contains("Test lens"), app.buttons["settingsButton"].label)
    }

    func testAnInvalidLensKeepsTheEditScreenAndTheUsersInput() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        app.buttons["Sample lens"].tap()

        let name = app.textFields["Name"]
        XCTAssertTrue(name.waitForExistence(timeout: 5))
        name.tap()
        let current = name.value as? String ?? ""
        name.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count))
        app.navigationBars.buttons["Save"].tap()

        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.buttons["OK"].tap()
        XCTAssertTrue(name.exists)

        app.navigationBars.buttons["Cancel"].tap()
        XCTAssertTrue(app.buttons["Sample lens"].waitForExistence(timeout: 5))
    }

    func testSubjectDistanceRangeMenuIsAFullTapTargetAndChangesTheRange() {
        let app = launch(.fresh)
        app.buttons["Near"].tap()

        let menu = app.buttons["Mid-range"]
        XCTAssertGreaterThanOrEqual(menu.frame.height, 44)
        XCTAssertGreaterThanOrEqual(menu.frame.width, 44)

        menu.tap()
        app.buttons["Close range"].tap()

        XCTAssertTrue(app.buttons["Close range"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["Mid-range"].exists)
    }

    // MARK: - Helpers

    private enum UITestState: String {
        case fresh
        case keep
    }

    private func launch(_ state: UITestState) -> XCUIApplication {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["-UITestState", state.rawValue]
        app.launch()
        XCTAssertTrue(resultElement(in: app).waitForExistence(timeout: 10))
        return app
    }

    private func resultElement(in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)["result"]
    }

    private func resultValue(in app: XCUIApplication) -> String {
        resultElement(in: app).value as? String ?? ""
    }
}
