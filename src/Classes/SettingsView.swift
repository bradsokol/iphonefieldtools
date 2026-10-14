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

/// Settings screen for managing lenses, cameras, and distance units, pushed from the
/// calculator.
///
/// The back button is hidden in edit mode, so Done is the only way out of editing.
struct SettingsView: View {
    @Environment(UserSettings.self) private var settings
    @Query(sort: \Camera.index) private var cameras: [Camera]
    @Query(sort: \Lens.index) private var lenses: [Lens]
    @State private var editMode: EditMode = .inactive
    @State private var editSelection: SettingsDestination?
    @State private var openedModel: SettingsDestination?

    var body: some View {
        @Bindable var settings = settings
        List(selection: $editSelection) {
            OrderedModelSection(
                title: NSLocalizedString("LENSES_SECTION_TITLE", comment: "Lenses"),
                addTitle: NSLocalizedString("ADD_LENS", comment: "Add lens"),
                models: lenses,
                selection: $settings.lensIndex,
                makeModel: Self.makeLens,
                destination: SettingsDestination.lens
            )
            OrderedModelSection(
                title: NSLocalizedString("CAMERAS_SECTION_TITLE", comment: "Cameras"),
                addTitle: NSLocalizedString("ADD_CAMERA", comment: "Add camera"),
                models: cameras,
                selection: $settings.cameraIndex,
                makeModel: Self.makeCamera,
                destination: SettingsDestination.camera
            )
            UnitsSection(units: $settings.distanceUnits)
        }
        .sheet(item: $openedModel) { destination in
            NavigationStack {
                switch destination {
                case .lens(let lens): LensEditView(lens: lens)
                case .camera(let camera): CameraEditView(camera: camera)
                }
            }
        }
        .navigationTitle(NSLocalizedString("SETTINGS_TITLE", comment: "Settings"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(editMode.isEditing)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
                    .accessibilityIdentifier("editSettingsButton")
            }
        }
        .environment(\.editMode, $editMode)
        .onChange(of: openedModel) {
            selectOpenedModel()
        }
        .onChange(of: editSelection) {
            openEditSelection()
        }
    }

    /// Opens the edit screen for the row tapped in edit mode.
    ///
    /// Rows that can be deleted or moved ignore taps on their content in edit mode, so
    /// they are opened through the list's selection instead.
    private func openEditSelection() {
        guard let editSelection else { return }
        openedModel = editSelection
        self.editSelection = nil
    }

    /// Selects the camera or lens whose edit screen was just opened.
    private func selectOpenedModel() {
        switch openedModel {
        case .lens(let lens):
            if let index = lenses.firstIndex(of: lens) {
                settings.lensIndex = index
            }
        case .camera(let camera):
            if let index = cameras.firstIndex(of: camera) {
                settings.cameraIndex = index
            }
        case nil:
            break
        }
    }

    private static func makeCamera(index: Int) -> Camera {
        let camera = Camera(
            name: NSLocalizedString("DEFAULT_CAMERA_NAME", comment: "Default camera name"),
            index: index
        )
        camera.coc = CoC(
            name: NSLocalizedString("DEFAULT_COC", comment: "Default CoC"),
            value: 0.03
        )
        return camera
    }

    private static func makeLens(index: Int) -> Lens {
        Lens(
            name: NSLocalizedString("DEFAULT_LENS_NAME", comment: "Default lens name"),
            index: index
        )
    }
}

#if DEBUG
#Preview(traits: .sampleData) {
    NavigationStack {
        SettingsView()
    }
}
#endif
