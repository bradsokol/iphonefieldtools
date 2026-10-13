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

/// End-to-end checks of the onboarding tips that replace the MPCoachMarks coach marks.
///
/// Launches pass `-UITestShowsTips YES`, since UI test launches otherwise hide all tips.
/// A fresh launch selects the 24–120 mm sample lens and the hyperfocal distance, so the
/// focal length slider is on screen and the subject distance slider is not.
@MainActor
final class OnboardingTipsUITests: XCTestCase {

    private enum TipTitle {
        static let focalLength = "Fine-Tune the Focal Length"
        static let distance = "Fine-Tune the Distance"
        static let cameraBag = "Your Camera Bag"
    }

    /// How long to wait for a tip that should appear, and to confirm one that should not.
    private let timeout: TimeInterval = 10

    // MARK: - Tests

    func testAFreshInstallShowsTheTipsInOrder() {
        let app = launch(.fresh)
        XCTAssertTrue(tip(TipTitle.focalLength, in: app).waitForExistence(timeout: timeout))

        closeTip(in: app)
        XCTAssertTrue(tip(TipTitle.cameraBag, in: app).waitForExistence(timeout: timeout))
    }

    func testTheDistanceTipWaitsForTheDistanceSlider() {
        let app = launch(.fresh)
        closeTip(in: app)
        closeTip(titled: TipTitle.cameraBag, in: app)

        app.buttons["Near"].tap()

        XCTAssertTrue(tip(TipTitle.distance, in: app).waitForExistence(timeout: timeout))
    }

    func testAClosedTipStaysClosedAfterRelaunch() {
        let app = launch(.fresh)
        closeTip(in: app)
        app.terminate()

        let relaunched = launch(.keep)

        XCTAssertTrue(tip(TipTitle.cameraBag, in: relaunched).waitForExistence(timeout: timeout))
        XCTAssertFalse(tip(TipTitle.focalLength, in: relaunched).exists)
    }

    func testOpeningSettingsRetiresTheCameraBagTip() {
        let app = launch(.fresh)
        closeTip(in: app)
        XCTAssertTrue(tip(TipTitle.cameraBag, in: app).waitForExistence(timeout: timeout))

        openSettings(in: app)
        app.navigationBars.buttons["Back"].tap()
        app.terminate()

        let relaunched = launch(.keep)

        XCTAssertFalse(tip(TipTitle.cameraBag, in: relaunched).waitForExistence(timeout: timeout))
    }

    func testAnUpgradeFromTheCoachMarksShowsNoTips() {
        let app = launch(.fresh, extraArguments: ["-CoachMarksShown", "YES"])

        XCTAssertFalse(tip(TipTitle.focalLength, in: app).waitForExistence(timeout: timeout))
        XCTAssertFalse(tip(TipTitle.cameraBag, in: app).exists)
    }

    // MARK: - Helpers

    private enum UITestState: String {
        case fresh
        case keep
    }

    private func launch(_ state: UITestState, extraArguments: [String] = []) -> XCUIApplication {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["-UITestState", state.rawValue, "-UITestShowsTips", "YES"] + extraArguments
        app.launch()
        XCTAssertTrue(app.descendants(matching: .any)["result"].waitForExistence(timeout: 10))
        return app
    }

    private func tip(_ title: String, in app: XCUIApplication) -> XCUIElement {
        app.staticTexts[title]
    }

    /// Taps the footer until settings opens.
    ///
    /// On iPhone a popover tip takes the first tap outside it to dismiss itself, so the
    /// tap meant for the footer beneath the camera bag tip may not reach it.
    private func openSettings(in app: XCUIApplication) {
        let edit = app.buttons["editSettingsButton"]
        app.buttons["settingsButton"].tap()
        if !edit.waitForExistence(timeout: 2) {
            app.buttons["settingsButton"].tap()
        }
        XCTAssertTrue(edit.waitForExistence(timeout: timeout))
    }

    /// Closes the focal length tip, or the tip with `title`, using its close button.
    private func closeTip(titled title: String = TipTitle.focalLength, in app: XCUIApplication) {
        XCTAssertTrue(tip(title, in: app).waitForExistence(timeout: timeout))
        app.buttons["Close"].firstMatch.tap()
        XCTAssertTrue(tip(title, in: app).waitForNonExistence(timeout: timeout))
    }
}
