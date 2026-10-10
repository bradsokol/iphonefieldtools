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
import RegexBuilder

/// Reads and writes the numbers typed into the camera and lens forms in the user's locale.
///
/// The decimal keypad shows the locale's decimal separator, so a user whose separator is a
/// comma types "0,03". `Float(_:)` only understands a full stop and rejects that input.
enum LocalizedNumber {

    /// Parses `text` as a decimal number written in `locale`.
    ///
    /// The whole string must be a number. Unlike a lenient parse, "2,8x" and, in a locale
    /// whose decimal separator is a comma, "0.03" are rejected rather than read as a prefix
    /// or as a grouping separator.
    static func decimal(from text: String, locale: Locale = .current) -> Double? {
        let number = Regex { Capture(.localizedDouble(locale: locale)) }
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard let match = try? number.wholeMatch(in: trimmed) else { return nil }
        return match.output.1
    }

    /// Parses `text` as a whole number written in `locale`, rejecting any fractional part.
    static func integer(from text: String, locale: Locale = .current) -> Int? {
        guard let value = decimal(from: text, locale: locale),
              value == value.rounded(),
              let integer = Int(exactly: value) else {
            return nil
        }
        return integer
    }

    /// Formats `value` for an editable field in `locale`, without grouping separators.
    static func string(
        _ value: Float,
        precision: NumberFormatStyleConfiguration.Precision,
        locale: Locale = .current
    ) -> String {
        Double(value).formatted(.number.precision(precision).grouping(.never).locale(locale))
    }
}
