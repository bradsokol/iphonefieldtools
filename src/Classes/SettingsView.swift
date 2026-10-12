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

/// Settings screen for managing lenses, cameras, and distance units, in the order the
/// Objective-C app showed them.
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserSettings.self) private var settings
    @Query(sort: \Camera.index) private var cameras: [Camera]
    @Query(sort: \Lens.index) private var lenses: [Lens]

    var body: some View {
        @Bindable var settings = settings
        NavigationStack {
            List {
                OrderedModelSection(
                    title: NSLocalizedString("LENSES_SECTION_TITLE", comment: "Lenses"),
                    addTitle: NSLocalizedString("ADD_LENS", comment: "Add lens"),
                    models: lenses,
                    selection: $settings.lensIndex,
                    makeModel: Self.makeLens
                ) { lens in
                    LensEditView(lens: lens)
                }
                OrderedModelSection(
                    title: NSLocalizedString("CAMERAS_SECTION_TITLE", comment: "Cameras"),
                    addTitle: NSLocalizedString("ADD_CAMERA", comment: "Add camera"),
                    models: cameras,
                    selection: $settings.cameraIndex,
                    makeModel: Self.makeCamera
                ) { camera in
                    CameraEditView(camera: camera)
                }
                UnitsSection(units: $settings.distanceUnits)
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
    SettingsView()
}
#endif
