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

/// Opens the app's store and seeds the first-launch defaults.
///
/// Only a failure to open the store is propagated. A store that opens but cannot be
/// seeded still leaves the app usable, with no sample camera or lens, so that failure
/// is not treated as fatal.
///
/// - Returns: The container backing the app's camera bag.
/// - Throws: Only when the store itself cannot be opened.
public func openAppStore() throws -> ModelContainer {
    let container = try makeModelContainer()
    try? seedDefaultsIfNeeded(in: ModelContext(container))
    return container
}

/// Creates the app's `ModelContainer`, reading from the existing Core Data SQLite store.
///
/// The store is located at `Documents/FieldTools.sqlite`. Entity and attribute names
/// match between Core Data and SwiftData, so no migration is required.
///
/// - Returns: A configured `ModelContainer` for Camera, CoC, and Lens.
/// - Throws: Any error raised while opening the store.
public func makeModelContainer() throws -> ModelContainer {
    let url = URL.documentsDirectory.appending(path: "FieldTools.sqlite")
    let configuration = ModelConfiguration(url: url)
    return try ModelContainer(
        for: Camera.self, CoC.self, Lens.self,
        configurations: configuration
    )
}

/// Inserts the sample camera, circle of confusion, and lens that a first launch requires.
///
/// The camera and the lens are seeded independently, each only when the store holds none
/// of that model. This matches the behaviour of the Core Data `FTCameraBag` it replaces.
///
/// - Parameter context: The context to insert into. Saved only when something was inserted.
/// - Throws: Any error raised while counting existing models or saving.
public func seedDefaultsIfNeeded(in context: ModelContext) throws {
    var didInsert = false

    if try context.fetchCount(FetchDescriptor<Camera>()) == 0 {
        let camera = Camera(name: "Sample camera")
        camera.coc = CoC(name: "Sample CoC", value: 0.02)
        context.insert(camera)
        didInsert = true
    }

    if try context.fetchCount(FetchDescriptor<Lens>()) == 0 {
        let lens = Lens(name: "Sample lens")
        lens.minimumFocalLength = 24
        lens.maximumFocalLength = 120
        lens.minimumAperture = 22
        lens.maximumAperture = 3.5
        context.insert(lens)
        didInsert = true
    }

    if didInsert {
        try context.save()
    }
}
