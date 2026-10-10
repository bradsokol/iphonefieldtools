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
import OSLog
import SwiftData

private let saveLogger = Logger(subsystem: "net.sourceforge.iphonefieldtools", category: "store")

extension ModelContext {

    /// Writes pending changes to the store now instead of waiting for autosave.
    ///
    /// Autosave runs at times SwiftData chooses, so a change made just before the app is
    /// terminated can be lost. Saving explicitly after each user edit closes that window.
    ///
    /// A failure is logged rather than thrown. The changes stay in the context, and there
    /// is nothing more useful the caller could do with them.
    func saveLoggingFailure() {
        do {
            try save()
        } catch {
            let nsError = error as NSError
            let detail = "\(error) domain=\(nsError.domain) code=\(nsError.code) userInfo=\(nsError.userInfo)"
            saveLogger.error("Camera bag changes could not be saved. \(detail, privacy: .public)")
        }
    }
}
