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
import Testing

@testable import Field_Tools

/// Ordering and selection rules for the camera and lens lists.
///
/// These carry over the index assertions from the Objective-C `FTCameraBagTests`, which
/// covered the only logic in `FTCameraBag` that the SwiftData models do not provide for
/// themselves. The ordering moved out of the camera bag and into the settings screen during
/// the migration, which is how it came to be untested.
@Suite("Model Ordering")
struct ModelOrderingTests {

    private func makeContext() throws -> ModelContext {
        let container = try ModelContainer(
            for: Camera.self, CoC.self, Lens.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }

    @discardableResult
    private func makeCameras(_ names: [String], in context: ModelContext) -> [Camera] {
        let cameras = names.enumerated().map { Camera(name: $0.element, index: $0.offset) }
        for camera in cameras {
            context.insert(camera)
        }
        return cameras
    }

    private func makeLenses(_ names: [String], in context: ModelContext) -> [Lens] {
        let lenses = names.enumerated().map { Lens(name: $0.element, index: $0.offset) }
        for lens in lenses {
            context.insert(lens)
        }
        return lenses
    }

    // MARK: - Appending

    @Test("A new camera is appended after the last index")
    func nextIndexAppends() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1", "Camera 2"], in: context)

        #expect(ModelOrdering.nextIndex(after: cameras) == 2)
    }

    @Test("The first camera in an empty bag takes index 0")
    func nextIndexOnEmptyBag() {
        #expect(ModelOrdering.nextIndex(after: [Camera]()) == 0)
    }

    @Test("A gap in the indices still yields an unused index")
    func nextIndexSkipsGaps() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1", "Camera 2"], in: context)
        cameras[1].index = 5

        #expect(ModelOrdering.nextIndex(after: cameras) == 6)
    }

    // MARK: - Deleting

    @Test("Deleting a camera renumbers the ones after it")
    func deletingAdjustsIndices() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1", "Camera 2", "Camera 3"], in: context)

        ModelOrdering.delete(at: [1], from: cameras, selection: 0, in: context)

        #expect(try context.fetchCount(FetchDescriptor<Camera>()) == 2)
        #expect(cameras[0].index == 0)
        #expect(cameras[2].index == 1)
    }

    @Test("Deleting leaves no index unused, so the next camera does not collide")
    func deletingLeavesNoGap() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1", "Camera 2", "Camera 3"], in: context)

        ModelOrdering.delete(at: [1], from: cameras, selection: 0, in: context)
        let survivors = try context.fetch(
            FetchDescriptor<Camera>(sortBy: [SortDescriptor(\.index)])
        )

        #expect(survivors.map(\.index) == [0, 1])
        #expect(ModelOrdering.nextIndex(after: survivors) == 2)
        #expect(survivors.map(\.index).contains(ModelOrdering.nextIndex(after: survivors)) == false)
    }

    @Test("Deleting several cameras at once renumbers the survivors contiguously")
    func deletingSeveralAdjustsIndices() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1", "Camera 2", "Camera 3", "Camera 4"], in: context)

        ModelOrdering.delete(at: [0, 2], from: cameras, selection: 0, in: context)

        #expect(cameras[1].index == 0)
        #expect(cameras[3].index == 1)
        #expect(try context.fetchCount(FetchDescriptor<Camera>()) == 2)
    }

    @Test("The last camera is never deleted")
    func lastCameraSurvives() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1"], in: context)

        ModelOrdering.delete(at: [0], from: cameras, selection: 0, in: context)

        #expect(try context.fetchCount(FetchDescriptor<Camera>()) == 1)
    }

    // MARK: - Moving

    @Test("Moving a camera down the list adjusts indices")
    func movingDownAdjustsIndices() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1", "Camera 2", "Camera 3"], in: context)

        ModelOrdering.move(from: [0], to: 3, in: cameras, selection: 0)

        #expect(cameras[0].index == 2)
        #expect(cameras[1].index == 0)
        #expect(cameras[2].index == 1)
    }

    @Test("Moving a camera up the list adjusts indices")
    func movingUpAdjustsIndices() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1", "Camera 2", "Camera 3"], in: context)

        ModelOrdering.move(from: [2], to: 0, in: cameras, selection: 0)

        #expect(cameras[0].index == 1)
        #expect(cameras[1].index == 2)
        #expect(cameras[2].index == 0)
    }

    // MARK: - Selection

    @Test("Deleting a camera before the selected one keeps the same camera selected")
    func deletingBeforeSelectionFollowsIt() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1", "Camera 2", "Camera 3"], in: context)

        let selection = ModelOrdering.delete(at: [0], from: cameras, selection: 2, in: context)

        #expect(selection == 1)
        #expect(cameras[2].index == 1)
    }

    @Test("Deleting a camera after the selected one leaves the selection alone")
    func deletingAfterSelectionLeavesIt() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1", "Camera 2", "Camera 3"], in: context)

        let selection = ModelOrdering.delete(at: [2], from: cameras, selection: 0, in: context)

        #expect(selection == 0)
    }

    @Test("Deleting the selected camera clamps the selection into the survivors")
    func deletingSelectionClamps() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1", "Camera 2", "Camera 3"], in: context)

        let selection = ModelOrdering.delete(at: [2], from: cameras, selection: 2, in: context)

        #expect(selection == 1)
    }

    @Test("Moving the selected camera keeps it selected at its new position")
    func movingSelectionFollowsIt() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1", "Camera 2", "Camera 3"], in: context)

        let selection = ModelOrdering.move(from: [0], to: 3, in: cameras, selection: 0)

        #expect(selection == 2)
    }

    @Test("Moving another camera past the selected one moves the selection with it")
    func movingPastSelectionAdjustsIt() throws {
        let context = try makeContext()
        let cameras = makeCameras(["Camera 1", "Camera 2", "Camera 3"], in: context)

        let selection = ModelOrdering.move(from: [0], to: 3, in: cameras, selection: 1)

        #expect(selection == 0)
    }

    // MARK: - Lenses

    @Test("Lenses are ordered by the same rules as cameras")
    func lensesReorderToo() throws {
        let context = try makeContext()
        let lenses = makeLenses(["Lens 1", "Lens 2", "Lens 3"], in: context)

        ModelOrdering.move(from: [2], to: 0, in: lenses, selection: 0)
        #expect(lenses.map(\.index) == [1, 2, 0])

        let reordered = try context.fetch(
            FetchDescriptor<Lens>(sortBy: [SortDescriptor(\.index)])
        )
        #expect(reordered.map(\.name) == ["Lens 3", "Lens 1", "Lens 2"])

        ModelOrdering.delete(at: [0], from: reordered, selection: 0, in: context)
        #expect(try context.fetchCount(FetchDescriptor<Lens>()) == 2)
        #expect(lenses[0].index == 0)
        #expect(lenses[1].index == 1)
    }

    @Test("A new lens is appended after the last index")
    func lensNextIndex() throws {
        let context = try makeContext()
        let lenses = makeLenses(["Lens 1", "Lens 2"], in: context)

        #expect(ModelOrdering.nextIndex(after: lenses) == 2)
    }
}
