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

import Foundation
import SwiftData
import Testing

@testable import Field_Tools

private let unitedStates = Locale(identifier: "en_US")
private let germany = Locale(identifier: "de_DE")

@Suite("Localized number parsing")
struct LocalizedNumberTests {

    @Test(
        "Decimals are read with the locale's separator",
        arguments: [
            ("0.03", unitedStates, 0.03),
            ("0,03", germany, 0.03),
            (" 2,8 ", germany, 2.8),
            (".5", unitedStates, 0.5),
        ]
    )
    func readsLocalizedDecimal(text: String, locale: Locale, expected: Double) throws {
        let value = try #require(LocalizedNumber.decimal(from: text, locale: locale))
        #expect(abs(value - expected) < 1e-9)
    }

    @Test(
        "Text that is not wholly a number in the locale is rejected",
        arguments: [
            ("0,03", unitedStates),
            ("0.03", germany),
            ("2,8x", germany),
            ("abc", unitedStates),
            ("", unitedStates),
        ]
    )
    func rejectsInvalidDecimal(text: String, locale: Locale) {
        #expect(LocalizedNumber.decimal(from: text, locale: locale) == nil)
    }

    @Test("Whole numbers are read, and fractional ones rejected")
    func readsIntegers() {
        #expect(LocalizedNumber.integer(from: "50", locale: germany) == 50)
        #expect(LocalizedNumber.integer(from: "50,5", locale: germany) == nil)
        #expect(LocalizedNumber.integer(from: "24.5", locale: unitedStates) == nil)
    }

    @Test("Formatting uses the locale's decimal separator")
    func formatsForLocale() {
        #expect(LocalizedNumber.string(0.03, precision: .significantDigits(1...4), locale: germany) == "0,03")
        #expect(LocalizedNumber.string(2.8, precision: .fractionLength(1), locale: unitedStates) == "2.8")
    }

    @Test("A formatted value parses back to itself", arguments: [unitedStates, germany])
    func roundTrips(locale: Locale) throws {
        let text = LocalizedNumber.string(0.019, precision: .significantDigits(1...4), locale: locale)
        let value = try #require(LocalizedNumber.decimal(from: text, locale: locale))
        #expect(Float(value) == 0.019)
    }
}

@Suite("Camera form validation")
struct CameraFormValidationTests {

    @Test("A comma-decimal CoC is accepted in a comma-decimal locale")
    func acceptsCommaDecimalCoC() throws {
        let draft = CameraEditView.Draft(name: " Nikon D500 ", cocText: "0,02")
        let values = try CameraEditView.validate(draft, locale: germany)
        #expect(values == CameraEditView.Values(name: "Nikon D500", coc: 0.02))
    }

    @Test("A blank name is rejected")
    func rejectsBlankName() {
        let draft = CameraEditView.Draft(name: "  ", cocText: "0.03")
        #expect(throws: CameraEditView.ValidationError.missingName) {
            try CameraEditView.validate(draft, locale: unitedStates)
        }
    }

    @Test("A CoC outside 0 to 1 mm, or not a number, is rejected", arguments: ["0", "1", "-0.1", "abc"])
    func rejectsInvalidCoC(cocText: String) {
        let draft = CameraEditView.Draft(name: "Camera", cocText: cocText)
        #expect(throws: CameraEditView.ValidationError.invalidCoC) {
            try CameraEditView.validate(draft, locale: unitedStates)
        }
    }
}

@Suite("Lens form validation")
struct LensFormValidationTests {

    private func draft(
        isZoom: Bool = true,
        minFocalLength: String = "24",
        maxFocalLength: String = "70",
        maxAperture: String = "2.8",
        minAperture: String = "22"
    ) -> LensEditView.Draft {
        LensEditView.Draft(
            name: "Lens",
            isZoom: isZoom,
            minFocalLengthText: minFocalLength,
            maxFocalLengthText: maxFocalLength,
            maxApertureText: maxAperture,
            minApertureText: minAperture
        )
    }

    @Test("A comma-decimal aperture is accepted in a comma-decimal locale")
    func acceptsCommaDecimalAperture() throws {
        let values = try LensEditView.validate(draft(maxAperture: "2,8", minAperture: "22"), locale: germany)
        #expect(values == LensEditView.Values(
            name: "Lens",
            minimumFocalLength: 24,
            maximumFocalLength: 70,
            maximumAperture: 2.8,
            minimumAperture: 22
        ))
    }

    @Test("A prime lens takes its maximum focal length from its minimum")
    func primeIgnoresMaximumFocalLength() throws {
        let values = try LensEditView.validate(draft(isZoom: false, maxFocalLength: "abc"), locale: unitedStates)
        #expect(values.maximumFocalLength == 24)
    }

    @Test("A blank name is rejected")
    func rejectsBlankName() {
        var blank = draft()
        blank.name = ""
        #expect(throws: LensEditView.ValidationError.missingName) {
            try LensEditView.validate(blank, locale: unitedStates)
        }
    }

    @Test(
        "Focal lengths that are fractional, out of range or reversed are rejected",
        arguments: [("0", "70"), ("24,5", "70"), ("24", "10000"), ("70", "24")]
    )
    func rejectsBadFocalLength(minimum: String, maximum: String) {
        #expect(throws: LensEditView.ValidationError.badFocalLength) {
            try LensEditView.validate(draft(minFocalLength: minimum, maxFocalLength: maximum), locale: unitedStates)
        }
    }

    @Test(
        "Apertures that are out of range, reversed or written for another locale are rejected",
        arguments: [("0.5", "22"), ("2.8", "101"), ("8", "4"), ("2,8", "22")]
    )
    func rejectsBadAperture(maximum: String, minimum: String) {
        #expect(throws: LensEditView.ValidationError.badAperture) {
            try LensEditView.validate(draft(maxAperture: maximum, minAperture: minimum), locale: unitedStates)
        }
    }
}

@Suite("Explicit save")
struct ExplicitSaveTests {

    @Test("Saved changes are visible to a fresh context on the same store")
    func savePersistsChanges() throws {
        let container = try ModelContainer(
            for: Camera.self, CoC.self, Lens.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = ModelContext(container)
        context.autosaveEnabled = false
        context.insert(Lens(name: "50mm f/1.4", index: 0))

        context.saveLoggingFailure()

        let reader = ModelContext(container)
        let lenses = try reader.fetch(FetchDescriptor<Lens>())
        #expect(lenses.map(\.name) == ["50mm f/1.4"])
    }
}
