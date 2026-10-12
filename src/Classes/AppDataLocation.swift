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

/// Where the app keeps its camera bag store and preferences.
struct AppDataLocation {
    /// The camera bag store file.
    let storeURL: URL
    /// The preferences read and written by ``UserSettings``.
    let defaults: UserDefaults
    /// Where TipKit keeps its state, or `nil` for TipKit's default location.
    var tipsDatastoreURL: URL?

    /// The user's own camera bag and preferences.
    static var standard: AppDataLocation {
        AppDataLocation(storeURL: defaultStoreURL, defaults: .standard)
    }

    /// The location for this launch.
    ///
    /// Debug builds launched with `-UITestState fresh` or `-UITestState keep` use a
    /// separate store and preferences, so UI tests never read or change the user's data.
    /// `fresh` erases them first; `keep` reuses them, so a test can relaunch the app and
    /// check what persisted. Every other launch uses ``standard``.
    static func forLaunch() -> AppDataLocation {
        #if DEBUG
        if let uiTestState = UITestState.current,
           let location = uiTest(state: uiTestState) {
            return location
        }
        #endif
        return .standard
    }
}

#if DEBUG
/// How a UI test launch treats its separate store and preferences.
enum UITestState: String {
    /// Erase the UI test store and preferences before launching.
    case fresh
    /// Reuse the UI test store and preferences from the previous launch.
    case keep

    /// The launch argument, without its leading hyphen, that selects a state.
    static let argumentKey = "UITestState"

    /// The state this launch asked for, or `nil` when it is not a UI test launch.
    static var current: UITestState? {
        UserDefaults.standard.string(forKey: argumentKey).flatMap(UITestState.init(rawValue:))
    }

    /// Whether this is a UI test launch that hides onboarding tips, as every UI test
    /// launch does unless it passes `-UITestShowsTips YES`.
    static var hidesTips: Bool {
        current != nil && !UserDefaults.standard.bool(forKey: "UITestShowsTips")
    }
}

private extension AppDataLocation {
    static let uiTestSuiteName = "net.sourceforge.iphonefieldtools.uitests"

    static func uiTest(state: UITestState) -> AppDataLocation? {
        guard let defaults = UserDefaults(suiteName: uiTestSuiteName) else { return nil }
        let directory = URL.applicationSupportDirectory.appending(path: "UITests")
        let storeURL = directory.appending(path: "FieldTools.sqlite")
        if state == .fresh {
            defaults.removePersistentDomain(forName: uiTestSuiteName)
            try? FileManager.default.removeItem(at: directory)
        }
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let tipsURL = directory.appending(path: "Tips")
        try? FileManager.default.createDirectory(at: tipsURL, withIntermediateDirectories: true)
        return AppDataLocation(storeURL: storeURL, defaults: defaults, tipsDatastoreURL: tipsURL)
    }
}
#endif
