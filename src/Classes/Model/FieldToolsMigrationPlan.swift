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

/// The ordered schema versions of the camera bag store and the stages between them.
///
/// There is one version and so no stages. Each new schema version is appended to
/// `schemas` with a stage from the version before it.
enum FieldToolsMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [FieldToolsSchemaV1.self]
    }

    static var stages: [MigrationStage] {
        []
    }
}
