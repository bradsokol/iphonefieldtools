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

/// Displays depth of field calculation results.
///
/// Two modes: a single distance value (hyperfocal, near, or far),
/// or a range showing near limit, far limit, and the difference between them.
struct ResultView: View {
    var formatter: DistanceFormatter
    var near: Float?
    var far: Float?

    @ScaledMetric(relativeTo: .title) private var largeFontSize = 34
    @ScaledMetric(relativeTo: .title2) private var rangeFontSize = 28
    @ScaledMetric(relativeTo: .body) private var smallFontSize = 17

    var body: some View {
        Group {
            if let near, let far {
                RangeResultView(
                    formatter: formatter,
                    near: near,
                    far: far,
                    rangeFontSize: rangeFontSize,
                    smallFontSize: smallFontSize
                )
            } else if let near {
                SingleResultView(
                    formatter: formatter,
                    distance: near,
                    fontSize: largeFontSize
                )
            } else {
                SingleResultView(
                    formatter: formatter,
                    distance: 0,
                    fontSize: largeFontSize
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

/// Displays a single formatted distance value.
private struct SingleResultView: View {
    var formatter: DistanceFormatter
    var distance: Float
    var fontSize: Double

    var body: some View {
        Text(formatter.format(distance))
            .font(.system(size: fontSize, weight: .medium, design: .rounded))
            .monospacedDigit()
    }
}

/// Displays near and far limits with the difference between them.
private struct RangeResultView: View {
    var formatter: DistanceFormatter
    var near: Float
    var far: Float
    var rangeFontSize: Double
    var smallFontSize: Double

    private var difference: Float { far - near }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(formatter.format(near))
                    .font(.system(size: rangeFontSize, weight: .medium, design: .rounded))
                    .monospacedDigit()
                Spacer()
                Image(systemName: "arrow.left.and.right")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                Spacer()
                Text(formatter.format(far))
                    .font(.system(size: rangeFontSize, weight: .medium, design: .rounded))
                    .monospacedDigit()
            }
            if difference > 0 {
                Text(formatter.format(difference))
                    .font(.system(size: smallFontSize, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        }
    }
}
