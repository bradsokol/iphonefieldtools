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

/// A named model whose position in a user-ordered list is persisted as `index`.
protocol IndexedModel: PersistentModel {
    var name: String { get }
    var index: Int { get set }
}

extension Camera: IndexedModel {}

extension Lens: IndexedModel {}

/// Add, delete, and reorder operations for the user-ordered camera and lens lists.
///
/// These take the model array as a parameter instead of reading it back from the context
/// because a view's `@Query` results are a value snapshot: deleting through the
/// `ModelContext` does not remove anything from that array, so any reindexing driven by it
/// would renumber the deleted models and leave the survivors with their original indices.
/// Each operation therefore computes the surviving order itself.
///
/// Selection is positional, matching the `CameraIndex` and `LensIndex` preferences the
/// Objective-C build wrote. Every operation takes the current selection and returns where
/// it belongs afterwards, so that the selected camera or lens stays selected.
enum ModelOrdering {

    /// The index to give a model appended to the end of `models`.
    ///
    /// Derived from the highest index in use rather than the count, so that a list which
    /// somehow contains a gap still yields an unused index.
    static func nextIndex(after models: [some IndexedModel]) -> Int {
        (models.map(\.index).max() ?? -1) + 1
    }

    /// Deletes the models at `offsets` and renumbers the survivors to be contiguous.
    ///
    /// The last remaining model is never deleted: the app requires at least one camera and
    /// one lens to calculate anything.
    ///
    /// - Returns: The position the selection should move to. If the selected model survived
    ///   it keeps its selection; if it was deleted the selection clamps into the survivors.
    @discardableResult
    static func delete<Model: IndexedModel>(
        at offsets: IndexSet,
        from models: [Model],
        selection: Int,
        in context: ModelContext
    ) -> Int {
        let survivors = models.enumerated()
            .filter { !offsets.contains($0.offset) }
            .map(\.element)

        guard !survivors.isEmpty else { return selection }

        let selected = models.indices.contains(selection) ? models[selection] : nil

        for offset in offsets where models.indices.contains(offset) {
            context.delete(models[offset])
        }
        reindex(survivors)

        guard let selected, let position = survivors.firstIndex(of: selected) else {
            return min(max(selection, 0), survivors.count - 1)
        }
        return position
    }

    /// Reorders `models` and renumbers every model to match its new position.
    ///
    /// `source` and `destination` are SwiftUI's `onMove` offsets, where `destination` is
    /// expressed before the moved models are removed.
    ///
    /// - Returns: The position the selection should move to, following the selected model.
    @discardableResult
    static func move<Model: IndexedModel>(
        from source: IndexSet,
        to destination: Int,
        in models: [Model],
        selection: Int
    ) -> Int {
        let selected = models.indices.contains(selection) ? models[selection] : nil

        var reordered = models
        reordered.move(fromOffsets: source, toOffset: destination)
        reindex(reordered)

        guard let selected, let position = reordered.firstIndex(of: selected) else {
            return selection
        }
        return position
    }

    private static func reindex(_ models: [some IndexedModel]) {
        for (position, model) in models.enumerated() where model.index != position {
            model.index = position
        }
    }
}
