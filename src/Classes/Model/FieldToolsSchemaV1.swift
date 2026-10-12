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

import SwiftData

/// The camera bag schema as first shipped by the SwiftData app, matching the store the
/// Core Data app left on disk.
///
/// This is the baseline every later migration stage starts from. The models are listed
/// in place rather than copied in, because no other version exists yet. Before any model
/// changes, copy the current `Camera`, `CoC` and `Lens` into this enum unchanged, so that
/// this version keeps describing the shipped store, and make the edits in a new version.
enum FieldToolsSchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Camera.self, CoC.self, Lens.self]
    }
}
