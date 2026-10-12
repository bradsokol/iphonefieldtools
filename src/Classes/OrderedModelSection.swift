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
import SwiftUI

/// A user-ordered list of cameras or lenses on the settings screen, with selection, add,
/// delete, and reorder.
///
/// The selected model is checked, and each row pushes the ``SettingsDestination`` that
/// `destination` gives for its model. Every change is saved immediately.
struct OrderedModelSection<Model: IndexedModel>: View {
    let title: String
    let addTitle: String
    /// The models in display order, as fetched by the parent's `@Query`.
    let models: [Model]
    /// Position of the selected model in `models`.
    @Binding var selection: Int
    /// Creates the model appended by the add button, given its index.
    let makeModel: (Int) -> Model
    let destination: (Model) -> SettingsDestination

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Section(title) {
            ForEach(Array(models.enumerated()), id: \.element.id) { index, model in
                NavigationLink(value: destination(model)) {
                    HStack {
                        Text(model.name)
                        Spacer()
                        if index == selection {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                        }
                    }
                }
            }
            .onDelete(perform: delete)
            .onMove(perform: move)

            Button(addTitle, action: add)
        }
    }

    private func add() {
        modelContext.insert(makeModel(ModelOrdering.nextIndex(after: models)))
        modelContext.saveLoggingFailure()
    }

    private func delete(at offsets: IndexSet) {
        selection = ModelOrdering.delete(at: offsets, from: models, selection: selection, in: modelContext)
        modelContext.saveLoggingFailure()
    }

    private func move(from source: IndexSet, to destination: Int) {
        selection = ModelOrdering.move(from: source, to: destination, in: models, selection: selection)
        modelContext.saveLoggingFailure()
    }
}
