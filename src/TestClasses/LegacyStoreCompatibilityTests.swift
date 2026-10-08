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

import CoreData
import Foundation
import SwiftData
import Testing

@testable import Field_Tools

/// Anchors `Bundle(for:)` on the test bundle so the shipped Core Data model can be located.
private final class BundleMarker {}

/// Builds a Core Data store matching what a shipped v2.3 release left on disk.
///
/// The store is written through Core Data using the app's own compiled `FieldTools.momd`,
/// so the schema under test is the shipped schema rather than a hand-transcribed copy of it.
/// Entity classes are remapped to `NSManagedObject` so the fixture does not depend on the
/// `FT*` Objective-C model classes, which the migration deletes.
private struct LegacyStoreFixture {

    /// A camera, its circle of confusion, and their ordering, as the shipped app stored them.
    struct CameraSpec {
        var name: String
        var index: Int32
        var cocName: String
        var cocValue: Float
    }

    /// A lens as the shipped app stored it.
    struct LensSpec {
        var name: String
        var index: Int32
        var minimumFocalLength: Int32
        var maximumFocalLength: Int32
        var minimumAperture: Float
        var maximumAperture: Float
    }

    /// Loads the shipped model, with every entity backed by `NSManagedObject`.
    static func shippedModel() throws -> NSManagedObjectModel {
        let bundle = Bundle(for: BundleMarker.self)
        let url = try #require(
            bundle.url(forResource: "FieldTools", withExtension: "momd"),
            "FieldTools.momd is missing from the test bundle"
        )
        let model = try #require(
            NSManagedObjectModel(contentsOf: url),
            "FieldTools.momd could not be loaded"
        )
        for entity in model.entities {
            entity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        }
        return model
    }

    /// Writes a legacy store at `url` and closes it so nothing is left in the write-ahead log.
    static func write(cameras: [CameraSpec], lenses: [LensSpec], to url: URL) throws {
        let model = try shippedModel()
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        let store = try coordinator.addPersistentStore(
            type: .sqlite,
            at: url
        )

        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator

        try context.performAndWait {
            for spec in cameras {
                let camera = NSEntityDescription.insertNewObject(forEntityName: "Camera", into: context)
                camera.setValue(spec.name, forKey: "name")
                camera.setValue(spec.index, forKey: "index")

                let coc = NSEntityDescription.insertNewObject(forEntityName: "CoC", into: context)
                coc.setValue(spec.cocName, forKey: "name")
                coc.setValue(spec.cocValue, forKey: "value")

                camera.setValue(coc, forKey: "coc")
            }

            for spec in lenses {
                let lens = NSEntityDescription.insertNewObject(forEntityName: "Lens", into: context)
                lens.setValue(spec.name, forKey: "name")
                lens.setValue(spec.index, forKey: "index")
                lens.setValue(spec.minimumFocalLength, forKey: "minimumFocalLength")
                lens.setValue(spec.maximumFocalLength, forKey: "maximumFocalLength")
                lens.setValue(spec.minimumAperture, forKey: "minimumAperture")
                lens.setValue(spec.maximumAperture, forKey: "maximumAperture")
            }

            try context.save()
        }

        try coordinator.remove(store)
    }
}

/// A temporary directory that holds one store for the lifetime of a single test.
private struct StoreDirectory: ~Copyable {
    let storeURL: URL
    private let directory: URL

    init() throws {
        directory = URL.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        storeURL = directory.appending(path: "FieldTools.sqlite")
    }

    deinit {
        try? FileManager.default.removeItem(at: directory)
    }
}

@Suite("Legacy Core Data Store Compatibility")
struct LegacyStoreCompatibilityTests {

    private static let cameras: [LegacyStoreFixture.CameraSpec] = [
        .init(name: "Nikon D300", index: 0, cocName: "Nikon DX", cocValue: 0.02),
        .init(name: "Canon 5D Mark III", index: 1, cocName: "Canon Full Frame", cocValue: 0.03),
        .init(name: "Olympus OM-D", index: 2, cocName: "Four Thirds", cocValue: 0.015),
    ]

    private static let lenses: [LegacyStoreFixture.LensSpec] = [
        .init(
            name: "24-70mm f/2.8",
            index: 0,
            minimumFocalLength: 24,
            maximumFocalLength: 70,
            minimumAperture: 22,
            maximumAperture: 2.8
        ),
        .init(
            name: "50mm f/1.4",
            index: 1,
            minimumFocalLength: 50,
            maximumFocalLength: 50,
            minimumAperture: 16,
            maximumAperture: 1.4
        ),
    ]

    /// Opens a store written by Core Data using the app's SwiftData configuration.
    private func openWithSwiftData(at url: URL) throws -> ModelContainer {
        try ModelContainer(
            for: Camera.self, CoC.self, Lens.self,
            configurations: ModelConfiguration(url: url)
        )
    }

    private func makeLegacyStore(_ directory: borrowing StoreDirectory) throws {
        try LegacyStoreFixture.write(
            cameras: Self.cameras,
            lenses: Self.lenses,
            to: directory.storeURL
        )
    }

    // MARK: - Cameras

    @Test("SwiftData reads cameras written by Core Data, in stored order")
    func readsLegacyCameras() throws {
        let directory = try StoreDirectory()
        try makeLegacyStore(directory)

        let container = try openWithSwiftData(at: directory.storeURL)
        let context = ModelContext(container)
        let fetched = try context.fetch(FetchDescriptor<Camera>(sortBy: [SortDescriptor(\.index)]))

        #expect(fetched.count == 3)
        #expect(fetched.map(\.name) == ["Nikon D300", "Canon 5D Mark III", "Olympus OM-D"])
        #expect(fetched.map(\.index) == [0, 1, 2])
    }

    @Test("SwiftData reads the camera-to-CoC relationship and its Float value")
    func readsLegacyCoC() throws {
        let directory = try StoreDirectory()
        try makeLegacyStore(directory)

        let container = try openWithSwiftData(at: directory.storeURL)
        let context = ModelContext(container)
        let fetched = try context.fetch(FetchDescriptor<Camera>(sortBy: [SortDescriptor(\.index)]))

        let nikon = try #require(fetched.first)
        #expect(nikon.coc?.name == "Nikon DX")
        #expect(nikon.coc?.value == 0.02)
        #expect(nikon.coc?.camera?.name == "Nikon D300")

        #expect(fetched.map { $0.coc?.name } == ["Nikon DX", "Canon Full Frame", "Four Thirds"])
        #expect(fetched.allSatisfy { $0.coc != nil })
    }

    // MARK: - Lenses

    @Test("SwiftData reads lenses, widening the stored Int32 focal lengths to Int")
    func readsLegacyLenses() throws {
        let directory = try StoreDirectory()
        try makeLegacyStore(directory)

        let container = try openWithSwiftData(at: directory.storeURL)
        let context = ModelContext(container)
        let fetched = try context.fetch(FetchDescriptor<Lens>(sortBy: [SortDescriptor(\.index)]))

        #expect(fetched.count == 2)

        let zoom = try #require(fetched.first)
        #expect(zoom.name == "24-70mm f/2.8")
        #expect(zoom.minimumFocalLength == 24)
        #expect(zoom.maximumFocalLength == 70)
        #expect(zoom.minimumAperture == 22)
        #expect(zoom.maximumAperture == 2.8)
        #expect(zoom.isZoom)

        let prime = try #require(fetched.last)
        #expect(prime.name == "50mm f/1.4")
        #expect(prime.minimumFocalLength == 50)
        #expect(prime.isZoom == false)
    }

    // MARK: - Seeding must not mask a failed read

    @Test("Seeding inserts nothing into a populated legacy store")
    func seedingLeavesLegacyDataAlone() throws {
        let directory = try StoreDirectory()
        try makeLegacyStore(directory)

        let container = try openWithSwiftData(at: directory.storeURL)
        let context = ModelContext(container)
        try seedDefaultsIfNeeded(in: context)

        let cameras = try context.fetch(FetchDescriptor<Camera>(sortBy: [SortDescriptor(\.index)]))
        let lenses = try context.fetch(FetchDescriptor<Lens>(sortBy: [SortDescriptor(\.index)]))

        #expect(cameras.count == 3)
        #expect(lenses.count == 2)
        #expect(cameras.contains { $0.name == "Sample camera" } == false)
        #expect(lenses.contains { $0.name == "Sample lens" } == false)
    }

    // MARK: - Writing back

    @Test("A legacy store survives a SwiftData write and reopen")
    func writesBackToLegacyStore() throws {
        let directory = try StoreDirectory()
        try makeLegacyStore(directory)

        let container = try openWithSwiftData(at: directory.storeURL)
        let context = ModelContext(container)
        let added = Camera(name: "Fujifilm X-T5", index: 3)
        added.coc = CoC(name: "Fuji APS-C", value: 0.02)
        context.insert(added)
        try context.save()

        let reopened = try openWithSwiftData(at: directory.storeURL)
        let reopenedContext = ModelContext(reopened)
        let fetched = try reopenedContext.fetch(
            FetchDescriptor<Camera>(sortBy: [SortDescriptor(\.index)])
        )

        #expect(fetched.map(\.name) == [
            "Nikon D300", "Canon 5D Mark III", "Olympus OM-D", "Fujifilm X-T5",
        ])
        #expect(fetched.last?.coc?.name == "Fuji APS-C")
    }
}
