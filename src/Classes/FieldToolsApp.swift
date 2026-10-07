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

import OSLog
import SwiftData
import SwiftUI

/// App entry point for Field Tools.
@main
struct FieldToolsApp: App {
    @State private var settings: UserSettings

    private let store: StoreState

    init() {
        let location = AppDataLocation.forLaunch()
        _settings = State(initialValue: UserSettings(defaults: location.defaults))
        do {
            store = .ready(try openAppStore(at: location.storeURL))
        } catch {
            logStoreFailure(error)
            store = .unavailable
        }
    }

    var body: some Scene {
        WindowGroup {
            switch store {
            case .ready(let container):
                CalculatorView()
                    .environment(settings)
                    .modelContainer(container)
            case .unavailable:
                StoreUnavailableView()
            }
        }
    }
}

/// Outcome of opening the camera bag store at launch.
private enum StoreState {
    case ready(ModelContainer)
    case unavailable
}

private let storeLogger = Logger(subsystem: "net.sourceforge.iphonefieldtools", category: "store")

/// Records why the camera bag store could not be opened.
///
/// The detail is logged rather than shown. `localizedDescription` on a SwiftData error
/// reports only that the operation could not be completed, while the underlying domain,
/// code and user info identify the actual failure.
private func logStoreFailure(_ error: any Error) {
    let nsError = error as NSError
    let detail = "\(error) domain=\(nsError.domain) code=\(nsError.code) userInfo=\(nsError.userInfo)"
    storeLogger.error("Camera bag store could not be opened. \(detail, privacy: .public)")
}

/// Shown in place of the calculator when the camera bag store cannot be opened.
///
/// No container is attached in this state. Substituting a throwaway in-memory store
/// would present a working-looking app whose edits vanish on the next launch, which is
/// worse than reporting the failure.
struct StoreUnavailableView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Camera Bag Unavailable", systemImage: "exclamationmark.triangle")
        } description: {
            Text("Field Tools could not open your saved cameras and lenses.")
        } actions: {
            Text(
                """
                Your data is still on this device and has not been changed. \
                Updating Field Tools to the latest version may resolve this.
                """
            )
            .font(.footnote)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
    }
}
