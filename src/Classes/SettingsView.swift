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

/// Settings screen for managing cameras, lenses, and distance units.
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(UserSettings.self) private var settings
    @Query(sort: \Camera.index) private var cameras: [Camera]
    @Query(sort: \Lens.index) private var lenses: [Lens]

    var body: some View {
        NavigationStack {
            List {
                CamerasSectionView(
                    cameras: cameras,
                    settings: settings,
                    modelContext: modelContext
                )
                LensesSectionView(
                    lenses: lenses,
                    settings: settings,
                    modelContext: modelContext
                )
                UnitsSectionView(settings: settings)
            }
            .navigationTitle(NSLocalizedString("SETTINGS_TITLE", comment: "Settings"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
        }
    }
}

// MARK: - Cameras section

/// Cameras list with selection, add, delete, and reorder support.
private struct CamerasSectionView: View {
    var cameras: [Camera]
    var settings: UserSettings
    var modelContext: ModelContext

    var body: some View {
        Section(NSLocalizedString("CAMERAS_SECTION_TITLE", comment: "Cameras")) {
            ForEach(cameras) { camera in
                let isSelected = cameras.firstIndex(where: { $0.id == camera.id }) == settings.cameraIndex
                NavigationLink {
                    CameraEditView(camera: camera)
                        .onAppear {
                            selectCamera(camera)
                        }
                } label: {
                    HStack {
                        Text(camera.name)
                        Spacer()
                        if isSelected {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                        }
                    }
                }
            }
            .onDelete(perform: deleteCameras)
            .onMove(perform: moveCameras)

            Button(NSLocalizedString("ADD_CAMERA", comment: "Add camera"), action: addCamera)
        }
    }

    private func selectCamera(_ camera: Camera) {
        if let index = cameras.firstIndex(where: { $0.id == camera.id }) {
            settings.cameraIndex = index
        }
    }

    private func addCamera() {
        let newIndex = ModelOrdering.nextIndex(after: cameras)
        let camera = Camera(
            name: NSLocalizedString("DEFAULT_CAMERA_NAME", comment: "Default camera name"),
            index: newIndex
        )
        let coc = CoC(
            name: NSLocalizedString("DEFAULT_COC", comment: "Default CoC"),
            value: 0.03
        )
        camera.coc = coc
        modelContext.insert(camera)
    }

    private func deleteCameras(at offsets: IndexSet) {
        settings.cameraIndex = ModelOrdering.delete(
            at: offsets,
            from: cameras,
            selection: settings.cameraIndex,
            in: modelContext
        )
    }

    private func moveCameras(from source: IndexSet, to destination: Int) {
        settings.cameraIndex = ModelOrdering.move(
            from: source,
            to: destination,
            in: cameras,
            selection: settings.cameraIndex
        )
    }
}

// MARK: - Lenses section

/// Lenses list with selection, add, delete, and reorder support.
private struct LensesSectionView: View {
    var lenses: [Lens]
    var settings: UserSettings
    var modelContext: ModelContext

    var body: some View {
        Section(NSLocalizedString("LENSES_SECTION_TITLE", comment: "Lenses")) {
            ForEach(lenses) { lens in
                let isSelected = lenses.firstIndex(where: { $0.id == lens.id }) == settings.lensIndex
                NavigationLink {
                    LensEditView(lens: lens)
                        .onAppear {
                            selectLens(lens)
                        }
                } label: {
                    HStack {
                        Text(lens.name)
                        Spacer()
                        if isSelected {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                        }
                    }
                }
            }
            .onDelete(perform: deleteLenses)
            .onMove(perform: moveLenses)

            Button(NSLocalizedString("ADD_LENS", comment: "Add lens"), action: addLens)
        }
    }

    private func selectLens(_ lens: Lens) {
        if let index = lenses.firstIndex(where: { $0.id == lens.id }) {
            settings.lensIndex = index
        }
    }

    private func addLens() {
        let newIndex = ModelOrdering.nextIndex(after: lenses)
        let lens = Lens(
            name: NSLocalizedString("DEFAULT_LENS_NAME", comment: "Default lens name"),
            index: newIndex
        )
        modelContext.insert(lens)
    }

    private func deleteLenses(at offsets: IndexSet) {
        settings.lensIndex = ModelOrdering.delete(
            at: offsets,
            from: lenses,
            selection: settings.lensIndex,
            in: modelContext
        )
    }

    private func moveLenses(from source: IndexSet, to destination: Int) {
        settings.lensIndex = ModelOrdering.move(
            from: source,
            to: destination,
            in: lenses,
            selection: settings.lensIndex
        )
    }
}

// MARK: - Units section

/// Distance units picker.
private struct UnitsSectionView: View {
    var settings: UserSettings

    var body: some View {
        @Bindable var settings = settings
        Section(NSLocalizedString("UNITS_SECTION_TITLE", comment: "Units")) {
            Picker("Units", selection: $settings.distanceUnits) {
                Text(NSLocalizedString("FEET", comment: "Feet")).tag(DistanceUnits.feet)
                Text(NSLocalizedString("FEET_AND_INCHES", comment: "Feet and inches")).tag(DistanceUnits.feetAndInches)
                Text(NSLocalizedString("METRIC_M", comment: "Metres")).tag(DistanceUnits.meters)
                Text(NSLocalizedString("METRIC_CM", comment: "Centimeters")).tag(DistanceUnits.centimeters)
            }
            .pickerStyle(.inline)
            .labelsHidden()
        }
    }
}
