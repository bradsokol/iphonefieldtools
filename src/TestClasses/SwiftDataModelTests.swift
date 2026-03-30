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
import Testing

@testable import Field_Tools

@Suite("SwiftData Model Tests")
struct SwiftDataModelTests {

    private func makeContainer() throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: Camera.self, CoC.self, Lens.self,
            configurations: configuration
        )
    }

    // MARK: - Camera + CoC round-trip

    @Test("Camera round-trip with CoC")
    func cameraRoundTrip() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let coc = CoC(name: "Nikon DX", value: 0.02)
        let camera = Camera(name: "Nikon D500", index: 0)
        camera.coc = coc

        context.insert(camera)
        try context.save()

        let descriptor = FetchDescriptor<Camera>()
        let cameras = try context.fetch(descriptor)
        let fetched = try #require(cameras.first)
        #expect(fetched.name == "Nikon D500")
        #expect(fetched.index == 0)
        #expect(fetched.coc?.name == "Nikon DX")
        #expect(fetched.coc?.value == 0.02)
    }

    // MARK: - Lens round-trip

    @Test("Lens round-trip")
    func lensRoundTrip() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let lens = Lens(name: "24-70mm f/2.8", index: 0)
        lens.minimumFocalLength = 24
        lens.maximumFocalLength = 70
        lens.minimumAperture = 22
        lens.maximumAperture = 2.8

        context.insert(lens)
        try context.save()

        let descriptor = FetchDescriptor<Lens>()
        let lenses = try context.fetch(descriptor)
        let fetched = try #require(lenses.first)
        #expect(fetched.name == "24-70mm f/2.8")
        #expect(fetched.minimumFocalLength == 24)
        #expect(fetched.maximumFocalLength == 70)
        #expect(fetched.minimumAperture == 22)
        #expect(fetched.maximumAperture == 2.8)
        #expect(fetched.isZoom == true)
    }

    @Test("Prime lens is not zoom")
    func primeLensIsNotZoom() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let lens = Lens(name: "50mm f/1.4", index: 0)
        context.insert(lens)
        try context.save()

        let descriptor = FetchDescriptor<Lens>()
        let lenses = try context.fetch(descriptor)
        let fetched = try #require(lenses.first)
        #expect(fetched.isZoom == false)
    }

    // MARK: - Cascade delete

    @Test("Deleting camera cascades to CoC")
    func cascadeDelete() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let coc = CoC(name: "Canon APS-C", value: 0.019)
        let camera = Camera(name: "Canon R7", index: 0)
        camera.coc = coc

        context.insert(camera)
        try context.save()

        context.delete(camera)
        try context.save()

        let cocDescriptor = FetchDescriptor<CoC>()
        let remaining = try context.fetch(cocDescriptor)
        #expect(remaining.isEmpty)
    }

    // MARK: - Default values

    @Test("Camera defaults")
    func cameraDefaults() {
        let camera = Camera(name: "Test")
        #expect(camera.index == 0)
        #expect(camera.coc == nil)
    }

    @Test("CoC defaults")
    func cocDefaults() {
        let coc = CoC(name: "Test")
        #expect(coc.value == 0.019)
        #expect(coc.camera == nil)
    }

    @Test("Lens defaults")
    func lensDefaults() {
        let lens = Lens(name: "Test")
        #expect(lens.index == 0)
        #expect(lens.minimumFocalLength == 50)
        #expect(lens.maximumFocalLength == 50)
        #expect(lens.minimumAperture == 32)
        #expect(lens.maximumAperture == 1.4)
        #expect(lens.isZoom == false)
    }
}

@Suite("CoC Preset Tests")
struct CoCPresetTests {

    @Test("Preset count matches plist")
    func presetCount() {
        #expect(CoCPreset.all.count == 25)
    }

    @Test("Presets are sorted alphabetically")
    func presetsSorted() {
        let names = CoCPreset.all.map(\.name)
        #expect(names == names.sorted())
    }

    @Test("Known preset value: Canon APS-C")
    func canonAPSCValue() {
        let preset = CoCPreset.all.first { $0.name == "Canon APS-C" }
        #expect(preset?.value == 0.019)
    }

    @Test("Known preset value: Nikon FX")
    func nikonFXValue() {
        let preset = CoCPreset.all.first { $0.name == "Nikon FX" }
        #expect(preset?.value == 0.03)
    }
}
