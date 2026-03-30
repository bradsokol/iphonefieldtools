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

/// Creates the app's `ModelContainer`, reading from the existing Core Data SQLite store.
///
/// The store is located at `Documents/FieldTools.sqlite`. Entity and attribute names
/// match between Core Data and SwiftData, so no migration is required.
///
/// - Returns: A configured `ModelContainer` for Camera, CoC, and Lens.
public func makeModelContainer() throws -> ModelContainer {
    let url = URL.documentsDirectory.appending(path: "FieldTools.sqlite")
    let configuration = ModelConfiguration(url: url)
    return try ModelContainer(
        for: Camera.self, CoC.self, Lens.self,
        configurations: configuration
    )
}
