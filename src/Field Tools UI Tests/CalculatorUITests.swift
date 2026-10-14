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

/// End-to-end checks of the calculator screen.
@MainActor
final class CalculatorUITests: XCTestCase, FieldToolsUITesting {

    // MARK: - Tests

    func testMovingTheApertureSliderUpdatesTheValueAndResult() {
        let app = launch(.fresh)
        let before = resultValue(in: app)
        XCTAssertTrue(app.staticTexts["f/8"].exists)

        drag(app.sliders["Aperture:"], from: StartPosition.aperture, to: 1)

        XCTAssertFalse(app.staticTexts["f/8"].exists)
        XCTAssertNotEqual(resultValue(in: app), before)
    }

    func testMovingTheFocalLengthSliderUpdatesTheResult() {
        let app = launch(.fresh)
        let before = resultValue(in: app)

        drag(app.sliders["Focal length:"], from: StartPosition.focalLength, to: 1)

        XCTAssertTrue(app.staticTexts["120 mm"].exists)
        XCTAssertNotEqual(resultValue(in: app), before)
    }

    func testDraggingAwayFromTheTrackScrubsMoreSlowly() {
        let app = launch(.fresh)

        drag(app.sliders["Focal length:"], from: StartPosition.focalLength, to: 1, endingBelowTrack: 200)

        let minimumLabels = app.staticTexts.matching(identifier: "24 mm")
        let maximumLabels = app.staticTexts.matching(identifier: "120 mm")
        XCTAssertEqual(minimumLabels.count, 1, "The focal length should have moved off 24 mm")
        XCTAssertEqual(maximumLabels.count, 1, "The focal length should have stopped short of 120 mm")
    }

    func testMovingTheSubjectDistanceSliderUpdatesTheNearLimit() {
        let app = launch(.fresh)
        app.buttons["Near"].tap()
        let before = resultValue(in: app)

        drag(app.sliders["Distance to subject:"], from: StartPosition.subjectDistance, to: 0.9)

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
        closeSettings(in: app)
        XCTAssertTrue(resultValue(in: app).contains(" m,"), resultValue(in: app))

        app.terminate()
        let relaunched = launch(.keep)

        XCTAssertEqual(resultElement(in: relaunched).label, "Depth of field")
        XCTAssertTrue(resultValue(in: relaunched).contains(" m,"), resultValue(in: relaunched))
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

    /// Where each thumb sits on a fresh launch, as a fraction of its track.
    private enum StartPosition {
        /// 24 mm on the 24–120 mm sample lens.
        static let focalLength = 0.0
        /// f/8, index 18 of the aperture scale, between f/3.5 (11) and f/22 (27).
        static let aperture = 7.0 / 16.0
        /// 2.5 m, about 8.2 ft, in the 1–275 ft mid range.
        static let subjectDistance = (2.5 * 3.2808 - 1) / 274
    }

    /// Distance from each end of a slider to the thumb's centre at that end.
    ///
    /// Half the thumb's width: 19 points from iOS 26 and 14 before. The 44 point area
    /// that starts a drag absorbs the difference.
    private let thumbInset = 16.0

    /// Presses a slider's thumb and drags it from `start` to `end`, each a fraction of
    /// the track, finishing `endingBelowTrack` points below the track.
    ///
    /// `adjust(toNormalizedSliderPosition:)` cannot drive `ScrubSlider`: the slider it
    /// presents to accessibility is never drawn, so it reports no thumb travel and
    /// XCUITest refuses to synthesise the drag.
    private func drag(_ slider: XCUIElement, from start: Double, to end: Double, endingBelowTrack: Double = 0) {
        let width = slider.frame.width
        func thumbCentre(at fraction: Double) -> XCUICoordinate {
            let x = thumbInset + fraction * (width - 2 * thumbInset)
            return slider.coordinate(withNormalizedOffset: CGVector(dx: x / width, dy: 0.5))
        }
        let destination = thumbCentre(at: end).withOffset(CGVector(dx: 0, dy: endingBelowTrack))
        thumbCentre(at: start).press(forDuration: 0.1, thenDragTo: destination)
    }
}
