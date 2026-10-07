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

#if DEBUG
import SwiftData
import SwiftUI

/// Supplies previews with an in-memory camera bag holding the first-launch sample camera
/// and lens, and preferences that are discarded with the preview.
struct PreviewSampleData: PreviewModifier {
    /// The store and preferences shared by every preview that uses this modifier.
    struct Context {
        let container: ModelContainer
        let settings: UserSettings
    }

    static func makeSharedContext() throws -> Context {
        let container = try ModelContainer(
            for: Camera.self, CoC.self, Lens.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        try seedDefaultsIfNeeded(in: container.mainContext)
        let suiteName = "PreviewSampleData"
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        defaults.removePersistentDomain(forName: suiteName)
        return Context(container: container, settings: UserSettings(defaults: defaults))
    }

    func body(content: Content, context: Context) -> some View {
        content
            .modelContainer(context.container)
            .environment(context.settings)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    /// Runs the preview against ``PreviewSampleData``.
    static var sampleData: Self { .modifier(PreviewSampleData()) }
}
#endif
