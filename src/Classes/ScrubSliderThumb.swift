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

import SwiftUI

/// The thumb of a ``ScrubSlider`` in the style of the running version of iOS: a
/// capsule that grows and turns to glass while dragged on iOS 26 and later, and a
/// white disc before that.
struct ScrubSliderThumb: View {
    let metrics: ScrubSliderMetrics
    let isDragging: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if #available(iOS 26, *) {
            Capsule()
                .fill(.white.opacity(isDragging ? 0 : 1))
                .frame(width: metrics.thumbSize.width, height: metrics.thumbSize.height)
                .glassEffect(isDragging ? .regular.interactive() : .identity, in: .capsule)
                .shadow(color: .black.opacity(isDragging ? 0 : 0.12), radius: 6, y: 2)
                .scaleEffect(isDragging && !reduceMotion ? 1.5 : 1)
                .animation(.spring(duration: 0.25), value: isDragging)
        } else {
            Circle()
                .fill(.white)
                .frame(width: metrics.thumbSize.width, height: metrics.thumbSize.height)
                .shadow(color: .black.opacity(0.15), radius: 4, y: 3)
                .shadow(color: .black.opacity(0.16), radius: 0.5, y: 0.5)
        }
    }
}
