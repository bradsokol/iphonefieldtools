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

/// End-to-end checks of the settings screen and the camera and lens edit screens.
@MainActor
final class SettingsUITests: XCTestCase, FieldToolsUITesting {

    func testRenamingTheLensUpdatesTheCalculatorFooter() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        app.buttons["editSettingsButton"].tap()
        tapRow("Sample lens", in: app)

        let name = app.textFields["Name"]
        XCTAssertTrue(name.waitForExistence(timeout: 5))
        name.tap()
        let current = name.value as? String ?? ""
        name.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count) + "Test lens")
        app.navigationBars.buttons["Save"].tap()
        app.buttons["editSettingsButton"].tap()
        closeSettings(in: app)

        XCTAssertTrue(app.buttons["settingsButton"].label.contains("Test lens"), app.buttons["settingsButton"].label)
    }

    func testLensSaveIsEnabledOnlyAfterAnEdit() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        app.buttons["editSettingsButton"].tap()
        tapRow("Sample lens", in: app)

        let save = app.navigationBars.buttons["Save"]
        XCTAssertTrue(save.waitForExistence(timeout: 5))
        XCTAssertFalse(save.isEnabled)

        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("!")

        XCTAssertTrue(save.isEnabled)
    }

    func testCameraSaveIsEnabledOnlyAfterAnEdit() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        app.buttons["editSettingsButton"].tap()
        tapRow("Sample camera", in: app)

        let save = app.navigationBars.buttons["Save"]
        XCTAssertTrue(save.waitForExistence(timeout: 5))
        XCTAssertFalse(save.isEnabled)

        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("!")

        XCTAssertTrue(save.isEnabled)
    }

    func testOpeningALensSelectsItForTheCalculator() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        app.buttons["editSettingsButton"].tap()
        app.buttons["Add lens..."].tap()
        tapRow("My lens", in: app)

        XCTAssertTrue(app.textFields["Name"].waitForExistence(timeout: 5))
        app.navigationBars.buttons["Cancel"].tap()
        app.buttons["editSettingsButton"].tap()
        closeSettings(in: app)

        let footer = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "My lens")).firstMatch
        XCTAssertTrue(footer.waitForExistence(timeout: 5), app.buttons["settingsButton"].label)
    }

    func testTappingALensOutsideEditModeSelectsItWithoutOpeningIt() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        app.buttons["editSettingsButton"].tap()
        app.buttons["Add lens..."].tap()
        app.buttons["editSettingsButton"].tap()

        let lens = app.buttons["My lens"]
        lens.tap()

        XCTAssertFalse(app.textFields["Name"].waitForExistence(timeout: 2))
        XCTAssertTrue(lens.isSelected)
        closeSettings(in: app)

        let footer = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "My lens")).firstMatch
        XCTAssertTrue(footer.waitForExistence(timeout: 5), app.buttons["settingsButton"].label)
    }

    func testAddButtonsAppearOnlyInEditMode() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["editSettingsButton"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["Add lens..."].exists)
        XCTAssertFalse(app.buttons["Add camera..."].exists)

        app.buttons["editSettingsButton"].tap()

        XCTAssertTrue(app.buttons["Add lens..."].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Add camera..."].exists)
    }

    func testEditModeHidesTheLensAndCameraSelectionCheckmarks() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["editSettingsButton"].waitForExistence(timeout: 5))
        let lensCheckmarks = row("Sample lens", in: app).images.matching(identifier: "checkmark")
        let cameraCheckmarks = row("Sample camera", in: app).images.matching(identifier: "checkmark")
        XCTAssertEqual(lensCheckmarks.count, 1)
        XCTAssertEqual(cameraCheckmarks.count, 1)

        app.buttons["editSettingsButton"].tap()

        XCTAssertTrue(app.buttons["Add lens..."].waitForExistence(timeout: 5))
        XCTAssertEqual(lensCheckmarks.count, 0)
        XCTAssertEqual(cameraCheckmarks.count, 0)
    }

    func testTheLastCameraAndLensCannotBeDeleted() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        app.buttons["editSettingsButton"].tap()

        XCTAssertTrue(app.buttons["Add lens..."].waitForExistence(timeout: 5))
        XCTAssertFalse(hasDeleteControl("Sample lens", in: app))
        XCTAssertFalse(hasDeleteControl("Sample camera", in: app))

        app.buttons["Add lens..."].tap()

        XCTAssertTrue(row("My lens", in: app).waitForExistence(timeout: 5))
        XCTAssertTrue(hasDeleteControl("Sample lens", in: app))
        XCTAssertTrue(hasDeleteControl("My lens", in: app))
        XCTAssertFalse(hasDeleteControl("Sample camera", in: app))
    }

    func testALensCanBeDeletedInEditMode() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        app.buttons["editSettingsButton"].tap()
        app.buttons["Add lens..."].tap()
        let lens = row("My lens", in: app)
        XCTAssertTrue(lens.waitForExistence(timeout: 5))

        lens.images["minus.circle.fill"].firstMatch.tap()
        app.buttons["Delete"].tap()

        XCTAssertTrue(lens.waitForNonExistence(timeout: 5))
        XCTAssertTrue(row("Sample lens", in: app).exists)
    }

    func testSwipingALensOutsideEditModeDoesNotOfferDelete() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        app.buttons["editSettingsButton"].tap()
        app.buttons["Add lens..."].tap()
        XCTAssertTrue(row("My lens", in: app).waitForExistence(timeout: 5))
        app.buttons["editSettingsButton"].tap()
        XCTAssertTrue(app.buttons["Add lens..."].waitForNonExistence(timeout: 5))

        row("My lens", in: app).swipeLeft()

        XCTAssertFalse(app.buttons["Delete"].waitForExistence(timeout: 2))
    }

    func testEditModeHidesTheBackButtonSoDoneIsTheOnlyWayOut() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        let back = app.navigationBars.buttons["Back"]
        XCTAssertTrue(back.waitForExistence(timeout: 5))

        app.buttons["editSettingsButton"].tap()
        XCTAssertTrue(back.waitForNonExistence(timeout: 5))

        app.buttons["editSettingsButton"].tap()
        XCTAssertTrue(back.waitForExistence(timeout: 5))
        back.tap()
        XCTAssertTrue(app.buttons["settingsButton"].waitForExistence(timeout: 5))
    }

    func testAnInvalidLensKeepsTheEditScreenAndTheUsersInput() {
        let app = launch(.fresh)
        app.buttons["settingsButton"].tap()
        app.buttons["editSettingsButton"].tap()
        tapRow("Sample lens", in: app)

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
        XCTAssertTrue(row("Sample lens", in: app).waitForExistence(timeout: 5))
    }
}
