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

import CoreGraphics

/// Sizes of a ``ScrubSlider``, matching the system slider of the running version of iOS.
struct ScrubSliderMetrics {
    /// Height of the slider.
    let height: Double

    /// Thickness of the track.
    let trackHeight: Double

    /// Size of the thumb at rest.
    let thumbSize: CGSize

    /// Width and height of the area that starts a drag, at least the minimum tap target.
    let hitSize: Double = 44

    /// The sizes for the running version of iOS.
    static var current: ScrubSliderMetrics {
        if #available(iOS 26, *) {
            ScrubSliderMetrics(height: 28, trackHeight: 6, thumbSize: CGSize(width: 38, height: 24))
        } else {
            ScrubSliderMetrics(height: 30, trackHeight: 4, thumbSize: CGSize(width: 28, height: 28))
        }
    }
}
