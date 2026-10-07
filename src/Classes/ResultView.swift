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
    /// VoiceOver label naming what the result is.
    var accessibilityLabel: LocalizedStringResource

    @ScaledMetric(relativeTo: .largeTitle) private var boxHeight = 50
    @ScaledMetric(relativeTo: .largeTitle) private var singleFontSize = 48
    @ScaledMetric(relativeTo: .title2) private var rangeFontSize = 24
    @ScaledMetric(relativeTo: .body) private var differenceFontSize = 17

    var body: some View {
        Group {
            if let near, let far {
                RangeResultView(
                    formatter: formatter,
                    near: near,
                    far: far,
                    rangeFontSize: rangeFontSize,
                    differenceFontSize: differenceFontSize
                )
            } else {
                SingleResultView(
                    formatter: formatter,
                    distance: near ?? 0,
                    fontSize: singleFontSize
                )
                .frame(height: boxHeight)
            }
        }
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, minHeight: boxHeight)
        .background {
            RoundedRectangle(cornerRadius: 3)
                .fill(.background)
                .strokeBorder(.quaternary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(accessibilityLabel))
        .accessibilityValue(accessibilityValue)
        .accessibilityIdentifier("result")
    }

    private var accessibilityValue: String {
        if let near, let far {
            formatter.accessibilityRange(near: near, far: far)
        } else {
            formatter.format(near ?? 0)
        }
    }
}

/// Displays a single formatted distance value, right-aligned.
private struct SingleResultView: View {
    var formatter: DistanceFormatter
    var distance: Float
    var fontSize: Double

    var body: some View {
        Text(formatter.format(distance))
            .font(.system(size: fontSize))
            .monospacedDigit()
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

/// Displays near and far limits either side of a dimension arrow, with the
/// difference between them written above the arrow.
private struct RangeResultView: View {
    var formatter: DistanceFormatter
    var near: Float
    var far: Float
    var rangeFontSize: Double
    var differenceFontSize: Double

    private var difference: Float { far - near }

    var body: some View {
        HStack(alignment: .arrowLine, spacing: 2) {
            limit(near)
                .frame(maxWidth: .infinity, alignment: .trailing)
            ZStack(alignment: Alignment(horizontal: .center, vertical: .arrowLine)) {
                Image(.distanceArrows)
                    .opacity(0.5)
                    .accessibilityHidden(true)
                    .alignmentGuide(.arrowLine) { $0[VerticalAlignment.center] }
                differenceLabel
                    .alignmentGuide(.arrowLine) { $0[.bottom] }
            }
            limit(far)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder private var differenceLabel: some View {
        if difference > 0 {
            Text(formatter.format(difference))
                .font(.system(size: differenceFontSize))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }

    private func limit(_ distance: Float) -> some View {
        Text(formatter.format(distance))
            .font(.system(size: rangeFontSize))
            .monospacedDigit()
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .alignmentGuide(.arrowLine) { $0[VerticalAlignment.center] }
    }
}

private extension VerticalAlignment {
    /// The horizontal line of the distance arrow, which the near and far limits centre on
    /// and the difference sits above.
    enum ArrowLine: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }

    static let arrowLine = VerticalAlignment(ArrowLine.self)
}

#Preview("Single") {
    ResultView(formatter: DistanceFormatter(units: .feet, decimalPlaces: 0), near: 3.6,
               accessibilityLabel: DistanceType.hyperfocal.resultAccessibilityLabel)
        .padding(24)
}

#Preview("Range") {
    ResultView(formatter: DistanceFormatter(units: .feet, decimalPlaces: 0), near: 1.5, far: 8,
               accessibilityLabel: DistanceType.nearFar.resultAccessibilityLabel)
        .padding(24)
}

#Preview("Range to infinity") {
    ResultView(formatter: DistanceFormatter(units: .feet, decimalPlaces: 0), near: 1.5, far: -1,
               accessibilityLabel: DistanceType.nearFar.resultAccessibilityLabel)
        .padding(24)
}
