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

import Testing

@testable import Field_Tools

// MARK: - Hyperfocal Distance

@Suite("Hyperfocal distance calculations")
struct HyperfocalDistanceTests {

    let coc: Float = 0.02
    let accuracy: Float = 0.009

    @Test("10mm focal length")
    func focalLength10() {
        let focalLength: Float = 10.0
        assertClose(calc(2.8, focalLength), 1.78)
        assertClose(calc(5.6, focalLength), 0.893)
        assertClose(calc(8.0, focalLength), 0.635)
        assertClose(calc(11.0, focalLength), 0.455)
        assertClose(calc(22.0, focalLength), 0.227)
        assertClose(calc(32.0, focalLength), 0.166)
    }

    @Test("24mm focal length")
    func focalLength24() {
        let focalLength: Float = 24.0
        assertClose(calc(2.8, focalLength), 10.206)
        assertClose(calc(5.6, focalLength), 5.115)
        assertClose(calc(8.0, focalLength), 3.624)
        assertClose(calc(11.0, focalLength), 2.57)
        assertClose(calc(22.0, focalLength), 1.3)
        assertClose(calc(32.0, focalLength), 0.924)
    }

    @Test("50mm focal length")
    func focalLength50() {
        let focalLength: Float = 50.0
        assertClose(calc(2.8, focalLength), 44.244)
        assertClose(calc(5.6, focalLength), 22.147)
        assertClose(calc(8.0, focalLength), 15.675)
        assertClose(calc(11.0, focalLength), 11.099)
        assertClose(calc(22.0, focalLength), 5.574)
        assertClose(calc(32.0, focalLength), 3.956)
    }

    @Test("100mm focal length")
    func focalLength100() {
        let focalLength: Float = 100.0
        assertClose(calc(2.8, focalLength), 176.877)
        assertClose(calc(5.6, focalLength), 88.488)
        assertClose(calc(8.0, focalLength), 62.6)
        assertClose(calc(11.0, focalLength), 44.294)
        assertClose(calc(22.0, focalLength), 22.197)
        assertClose(calc(32.0, focalLength), 15.725)
    }

    @Test("200mm focal length")
    func focalLength200() {
        let focalLength: Float = 200.0
        assertClose(calc(2.8, focalLength), 707.307)
        assertClose(calc(5.6, focalLength), 353.753)
        assertClose(calc(8.0, focalLength), 250.2)
        assertClose(calc(11.0, focalLength), 176.977)
        assertClose(calc(22.0, focalLength), 88.588)
        assertClose(calc(32.0, focalLength), 62.7)
    }

    @Test("400mm focal length")
    func focalLength400() {
        let focalLength: Float = 400.0
        assertClose(calc(2.8, focalLength), 2828.827)
        assertClose(calc(5.6, focalLength), 1414.614)
        assertClose(calc(8.0, focalLength), 1000.4)
        assertClose(calc(11.0, focalLength), 707.507)
        assertClose(calc(22.0, focalLength), 353.953)
        assertClose(calc(32.0, focalLength), 250.4)
    }

    private func calc(_ aperture: Float, _ focalLength: Float) -> Float {
        DepthOfFieldCalculator.hyperfocalDistance(
            aperture: aperture, focalLength: focalLength, circleOfConfusion: coc
        )
    }

    private func assertClose(
        _ result: Float,
        _ expected: Float,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        #expect(
            abs(result - expected) <= accuracy,
            "Expected \(expected) ± \(accuracy), got \(result)",
            sourceLocation: sourceLocation
        )
    }
}

// MARK: - Far Distance

@Suite("Far distance calculations")
struct FarDistanceTests {

    let coc: Float = 0.02
    let accuracy: Float = 0.09

    // MARK: 10mm — all infinity

    @Test("10mm focal length — all infinity")
    func focalLength10() {
        let focalLength: Float = 10.0
        let apertures: [Float] = [2.8, 5.6, 8.0, 11.0, 16.0, 22.0, 32.0]
        let distances: [Float] = [2.0, 5.0, 10.0, 15.0, 25.0, 50.0]
        for subjectDistance in distances {
            for aperture in apertures {
                #expect(
                    calc(aperture, focalLength, subjectDistance) < 0,
                    "Expected infinity for f/\(aperture) at \(subjectDistance)m with 10mm"
                )
            }
        }
    }

    // MARK: 50mm

    @Test("50mm at 2m")
    func focalLength50at2() {
        let focalLength: Float = 50.0
        let subjectDistance: Float = 2.0
        assertClose(calc(2.8, focalLength, subjectDistance), 2.094)
        assertClose(calc(5.6, focalLength, subjectDistance), 2.197)
        assertClose(calc(8.0, focalLength, subjectDistance), 2.294)
        assertClose(calc(11.0, focalLength, subjectDistance), 2.427)
        assertClose(calc(16.0, focalLength, subjectDistance), 2.688)
        assertClose(calc(22.0, focalLength, subjectDistance), 3.086)
        assertClose(calc(32.0, focalLength, subjectDistance), 3.99)
    }

    @Test("50mm at 5m")
    func focalLength50at5() {
        let focalLength: Float = 50.0
        let subjectDistance: Float = 5.0
        assertClose(calc(2.8, focalLength, subjectDistance), 5.631)
        assertClose(calc(5.6, focalLength, subjectDistance), 6.443)
        assertClose(calc(8.0, focalLength, subjectDistance), 7.353)
        assertClose(calc(11.0, focalLength, subjectDistance), 9.058)
        assertClose(calc(16.0, focalLength, subjectDistance), 13.646)
        assertClose(calc(22.0, focalLength, subjectDistance), 48.098)
        #expect(calc(32.0, focalLength, subjectDistance) < 0, "Expected infinity")
    }

    @Test("50mm at 10m")
    func focalLength50at10() {
        let focalLength: Float = 50.0
        let subjectDistance: Float = 10.0
        assertClose(calc(2.8, focalLength, subjectDistance), 12.887)
        assertClose(calc(5.6, focalLength, subjectDistance), 18.116)
        assertClose(calc(8.0, focalLength, subjectDistance), 27.533)
        assertClose(calc(11.0, focalLength, subjectDistance), 100.574)
        for aperture: Float in [16.0, 22.0, 32.0] {
            #expect(calc(aperture, focalLength, subjectDistance) < 0, "Expected infinity for f/\(aperture)")
        }
    }

    @Test("50mm at 15m")
    func focalLength50at15() {
        let focalLength: Float = 50.0
        let subjectDistance: Float = 15.0
        assertClose(calc(2.8, focalLength, subjectDistance), 22.59)
        assertClose(calc(5.6, focalLength, subjectDistance), 46.376)
        assertClose(calc(8.0, focalLength, subjectDistance), 347.222)
        for aperture: Float in [11.0, 16.0, 22.0, 32.0] {
            #expect(calc(aperture, focalLength, subjectDistance) < 0, "Expected infinity for f/\(aperture)")
        }
    }

    @Test("50mm at 25m")
    func focalLength50at25() {
        let focalLength: Float = 50.0
        let subjectDistance: Float = 25.0
        assertClose(calc(2.8, focalLength, subjectDistance), 57.412)
        for aperture: Float in [5.6, 8.0, 11.0, 16.0, 22.0, 32.0] {
            #expect(calc(aperture, focalLength, subjectDistance) < 0, "Expected infinity for f/\(aperture)")
        }
    }

    @Test("50mm at 50m — all infinity")
    func focalLength50at50() {
        let focalLength: Float = 50.0
        let subjectDistance: Float = 50.0
        for aperture: Float in [2.8, 5.6, 8.0, 11.0, 16.0, 22.0, 32.0] {
            #expect(calc(aperture, focalLength, subjectDistance) < 0, "Expected infinity for f/\(aperture)")
        }
    }

    // MARK: 400mm

    @Test("400mm at 2m")
    func focalLength400at2() {
        let focalLength: Float = 400.0
        let subjectDistance: Float = 2.0
        assertClose(calc(2.8, focalLength, subjectDistance), 2.001)
        assertClose(calc(5.6, focalLength, subjectDistance), 2.003)
        assertClose(calc(8.0, focalLength, subjectDistance), 2.004)
        assertClose(calc(11.0, focalLength, subjectDistance), 2.006)
        assertClose(calc(16.0, focalLength, subjectDistance), 2.008)
        assertClose(calc(22.0, focalLength, subjectDistance), 2.011)
        assertClose(calc(32.0, focalLength, subjectDistance), 2.016)
    }

    @Test("400mm at 5m")
    func focalLength400at5() {
        let focalLength: Float = 400.0
        let subjectDistance: Float = 5.0
        assertClose(calc(2.8, focalLength, subjectDistance), 5.009)
        assertClose(calc(5.6, focalLength, subjectDistance), 5.018)
        assertClose(calc(8.0, focalLength, subjectDistance), 5.025)
        assertClose(calc(11.0, focalLength, subjectDistance), 5.035)
        assertClose(calc(16.0, focalLength, subjectDistance), 5.051)
        assertClose(calc(22.0, focalLength, subjectDistance), 5.07)
        assertClose(calc(32.0, focalLength, subjectDistance), 5.102)
    }

    @Test("400mm at 10m")
    func focalLength400at10() {
        let focalLength: Float = 400.0
        let subjectDistance: Float = 10.0
        assertClose(calc(2.8, focalLength, subjectDistance), 10.035)
        assertClose(calc(5.6, focalLength, subjectDistance), 10.07)
        assertClose(calc(8.0, focalLength, subjectDistance), 10.101)
        assertClose(calc(11.0, focalLength, subjectDistance), 10.139)
        assertClose(calc(16.0, focalLength, subjectDistance), 10.204)
        assertClose(calc(22.0, focalLength, subjectDistance), 10.283)
        assertClose(calc(32.0, focalLength, subjectDistance), 10.417)
    }

    @Test("400mm at 15m")
    func focalLength400at15() {
        let focalLength: Float = 400.0
        let subjectDistance: Float = 15.0
        assertClose(calc(2.8, focalLength, subjectDistance), 15.079)
        assertClose(calc(5.6, focalLength, subjectDistance), 15.159)
        assertClose(calc(8.0, focalLength, subjectDistance), 15.228)
        assertClose(calc(11.0, focalLength, subjectDistance), 15.316)
        assertClose(calc(16.0, focalLength, subjectDistance), 15.464)
        assertClose(calc(22.0, focalLength, subjectDistance), 15.645)
        assertClose(calc(32.0, focalLength, subjectDistance), 15.957)
    }

    @Test("400mm at 25m")
    func focalLength400at25() {
        let focalLength: Float = 400.0
        let subjectDistance: Float = 25.0
        assertClose(calc(2.8, focalLength, subjectDistance), 25.221)
        assertClose(calc(5.6, focalLength, subjectDistance), 25.445)
        assertClose(calc(8.0, focalLength, subjectDistance), 25.641)
        assertClose(calc(11.0, focalLength, subjectDistance), 25.89)
        assertClose(calc(16.0, focalLength, subjectDistance), 26.316)
        assertClose(calc(22.0, focalLength, subjectDistance), 26.846)
        assertClose(calc(32.0, focalLength, subjectDistance), 27.778)
    }

    @Test("400mm at 50m")
    func focalLength400at50() {
        let focalLength: Float = 400.0
        let subjectDistance: Float = 50.0
        assertClose(calc(2.8, focalLength, subjectDistance), 50.891)
        assertClose(calc(5.6, focalLength, subjectDistance), 51.813)
        assertClose(calc(8.0, focalLength, subjectDistance), 52.632)
        assertClose(calc(11.0, focalLength, subjectDistance), 53.691)
        assertClose(calc(16.0, focalLength, subjectDistance), 55.556)
        assertClose(calc(22.0, focalLength, subjectDistance), 58.159)
        assertClose(calc(32.0, focalLength, subjectDistance), 62.375)
    }

    private func calc(_ aperture: Float, _ focalLength: Float, _ subjectDistance: Float) -> Float {
        DepthOfFieldCalculator.farLimit(
            aperture: aperture, focalLength: focalLength, circleOfConfusion: coc, subjectDistance: subjectDistance
        )
    }

    private func assertClose(
        _ result: Float,
        _ expected: Float,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        #expect(
            abs(result - expected) <= accuracy,
            "Expected \(expected) ± \(accuracy), got \(result)",
            sourceLocation: sourceLocation
        )
    }
}

// MARK: - Near Distance

@Suite("Near distance calculations")
struct NearDistanceTests {

    let coc: Float = 0.02
    let accuracy: Float = 0.09

    // MARK: 10mm

    @Test("10mm at 2m")
    func fl10at2() {
        let focalLength: Float = 10.0
        let subjectDistance: Float = 2.0
        assertClose(calc(2.8, focalLength, subjectDistance), 0.943)
        assertClose(calc(5.6, focalLength, subjectDistance), 0.617)
        assertClose(calc(8.0, focalLength, subjectDistance), 0.476)
        assertClose(calc(11.0, focalLength, subjectDistance), 0.371)
        assertClose(calc(16.0, focalLength, subjectDistance), 0.271)
        assertClose(calc(22.0, focalLength, subjectDistance), 0.204)
        assertClose(calc(32.0, focalLength, subjectDistance), 0.145)
    }

    @Test("10mm at 5m")
    func fl10at5() {
        let focalLength: Float = 10.0
        let subjectDistance: Float = 5.0
        assertClose(calc(2.8, focalLength, subjectDistance), 1.316)
        assertClose(calc(5.6, focalLength, subjectDistance), 0.758)
        assertClose(calc(8.0, focalLength, subjectDistance), 0.556)
        assertClose(calc(11.0, focalLength, subjectDistance), 0.417)
        assertClose(calc(16.0, focalLength, subjectDistance), 0.295)
        assertClose(calc(22.0, focalLength, subjectDistance), 0.217)
        assertClose(calc(32.0, focalLength, subjectDistance), 0.151)
    }

    @Test("10mm at 10m")
    func fl10at10() {
        let focalLength: Float = 10.0
        let subjectDistance: Float = 10.0
        assertClose(calc(2.8, focalLength, subjectDistance), 1.515)
        assertClose(calc(5.6, focalLength, subjectDistance), 0.82)
        assertClose(calc(8.0, focalLength, subjectDistance), 0.588)
        assertClose(calc(11.0, focalLength, subjectDistance), 0.435)
        assertClose(calc(16.0, focalLength, subjectDistance), 0.304)
        assertClose(calc(22.0, focalLength, subjectDistance), 0.222)
        assertClose(calc(32.0, focalLength, subjectDistance), 0.154)
    }

    @Test("10mm at 15m")
    func fl10at15() {
        let focalLength: Float = 10.0
        let subjectDistance: Float = 15.0
        assertClose(calc(2.8, focalLength, subjectDistance), 1.596)
        assertClose(calc(5.6, focalLength, subjectDistance), 0.843)
        assertClose(calc(8.0, focalLength, subjectDistance), 0.6)
        assertClose(calc(11.0, focalLength, subjectDistance), 0.442)
        assertClose(calc(16.0, focalLength, subjectDistance), 0.307)
        assertClose(calc(22.0, focalLength, subjectDistance), 0.224)
        assertClose(calc(32.0, focalLength, subjectDistance), 0.154)
    }

    @Test("10mm at 25m")
    func fl10at25() {
        let focalLength: Float = 10.0
        let subjectDistance: Float = 25.0
        assertClose(calc(2.8, focalLength, subjectDistance), 1.667)
        assertClose(calc(5.6, focalLength, subjectDistance), 0.862)
        assertClose(calc(8.0, focalLength, subjectDistance), 0.61)
        assertClose(calc(11.0, focalLength, subjectDistance), 0.447)
        assertClose(calc(16.0, focalLength, subjectDistance), 0.309)
        assertClose(calc(22.0, focalLength, subjectDistance), 0.225)
        assertClose(calc(32.0, focalLength, subjectDistance), 0.155)
    }

    @Test("10mm at 50m")
    func fl10at50() {
        let focalLength: Float = 10.0
        let subjectDistance: Float = 50.0
        assertClose(calc(2.8, focalLength, subjectDistance), 1.724)
        assertClose(calc(5.6, focalLength, subjectDistance), 0.877)
        assertClose(calc(8.0, focalLength, subjectDistance), 0.617)
        assertClose(calc(11.0, focalLength, subjectDistance), 0.451)
        assertClose(calc(16.0, focalLength, subjectDistance), 0.311)
        assertClose(calc(22.0, focalLength, subjectDistance), 0.226)
        assertClose(calc(32.0, focalLength, subjectDistance), 0.156)
    }

    // MARK: 50mm

    @Test("50mm at 2m")
    func fl50at2() {
        let focalLength: Float = 50.0
        let subjectDistance: Float = 2.0
        assertClose(calc(2.8, focalLength, subjectDistance), 1.914)
        assertClose(calc(5.6, focalLength, subjectDistance), 1.836)
        assertClose(calc(8.0, focalLength, subjectDistance), 1.773)
        assertClose(calc(11.0, focalLength, subjectDistance), 1.701)
        assertClose(calc(16.0, focalLength, subjectDistance), 1.592)
        assertClose(calc(22.0, focalLength, subjectDistance), 1.479)
        assertClose(calc(32.0, focalLength, subjectDistance), 1.323)
    }

    @Test("50mm at 5m")
    func fl50at5() {
        let focalLength: Float = 50.0
        let subjectDistance: Float = 5.0
        assertClose(calc(2.8, focalLength, subjectDistance), 4.496)
        assertClose(calc(5.6, focalLength, subjectDistance), 4.085)
        assertClose(calc(8.0, focalLength, subjectDistance), 3.788)
        assertClose(calc(11.0, focalLength, subjectDistance), 3.472)
        assertClose(calc(16.0, focalLength, subjectDistance), 3.049)
        assertClose(calc(22.0, focalLength, subjectDistance), 2.66)
        assertClose(calc(32.0, focalLength, subjectDistance), 2.193)
    }

    @Test("50mm at 10m")
    func fl50at10() {
        let focalLength: Float = 50.0
        let subjectDistance: Float = 10.0
        assertClose(calc(2.8, focalLength, subjectDistance), 8.17)
        assertClose(calc(5.6, focalLength, subjectDistance), 6.906)
        assertClose(calc(8.0, focalLength, subjectDistance), 6.098)
        assertClose(calc(11.0, focalLength, subjectDistance), 5.319)
        assertClose(calc(16.0, focalLength, subjectDistance), 4.386)
        assertClose(calc(22.0, focalLength, subjectDistance), 3.623)
        assertClose(calc(32.0, focalLength, subjectDistance), 2.809)
    }

    @Test("50mm at 15m")
    func fl50at15() {
        let focalLength: Float = 50.0
        let subjectDistance: Float = 15.0
        assertClose(calc(2.8, focalLength, subjectDistance), 11.228)
        assertClose(calc(5.6, focalLength, subjectDistance), 8.971)
        assertClose(calc(8.0, focalLength, subjectDistance), 7.653)
        assertClose(calc(11.0, focalLength, subjectDistance), 6.375)
        assertClose(calc(16.0, focalLength, subjectDistance), 5.137)
        assertClose(calc(22.0, focalLength, subjectDistance), 4.121)
        assertClose(calc(32.0, focalLength, subjectDistance), 3.099)
    }

    @Test("50mm at 25m")
    func fl50at25() {
        let focalLength: Float = 50.0
        let subjectDistance: Float = 25.0
        assertClose(calc(2.8, focalLength, subjectDistance), 16.026)
        assertClose(calc(5.6, focalLength, subjectDistance), 11.792)
        assertClose(calc(8.0, focalLength, subjectDistance), 9.615)
        assertClose(calc(11.0, focalLength, subjectDistance), 7.673)
        assertClose(calc(16.0, focalLength, subjectDistance), 5.953)
        assertClose(calc(22.0, focalLength, subjectDistance), 4.532)
        assertClose(calc(32.0, focalLength, subjectDistance), 3.378)
    }

    @Test("50mm at 50m")
    func fl50at50() {
        let focalLength: Float = 50.0
        let subjectDistance: Float = 50.0
        assertClose(calc(2.8, focalLength, subjectDistance), 23.472)
        assertClose(calc(5.6, focalLength, subjectDistance), 15.335)
        assertClose(calc(8.0, focalLength, subjectDistance), 11.905)
        assertClose(calc(11.0, focalLength, subjectDistance), 9.056)
        assertClose(calc(16.0, focalLength, subjectDistance), 6.757)
        assertClose(calc(22.0, focalLength, subjectDistance), 4.979)
        assertClose(calc(32.0, focalLength, subjectDistance), 3.623)
    }

    // MARK: 400mm

    @Test("400mm at 2m")
    func fl400at2() {
        let focalLength: Float = 400.0
        let subjectDistance: Float = 2.0
        assertClose(calc(2.8, focalLength, subjectDistance), 1.999)
        assertClose(calc(5.6, focalLength, subjectDistance), 1.997)
        assertClose(calc(8.0, focalLength, subjectDistance), 1.996)
        assertClose(calc(11.0, focalLength, subjectDistance), 1.995)
        assertClose(calc(16.0, focalLength, subjectDistance), 1.992)
        assertClose(calc(22.0, focalLength, subjectDistance), 1.989)
        assertClose(calc(32.0, focalLength, subjectDistance), 1.984)
    }

    @Test("400mm at 5m")
    func fl400at5() {
        let focalLength: Float = 400.0
        let subjectDistance: Float = 5.0
        assertClose(calc(2.8, focalLength, subjectDistance), 4.991)
        assertClose(calc(5.6, focalLength, subjectDistance), 4.983)
        assertClose(calc(8.0, focalLength, subjectDistance), 4.975)
        assertClose(calc(11.0, focalLength, subjectDistance), 4.966)
        assertClose(calc(16.0, focalLength, subjectDistance), 4.95)
        assertClose(calc(22.0, focalLength, subjectDistance), 4.932)
        assertClose(calc(32.0, focalLength, subjectDistance), 4.902)
    }

    @Test("400mm at 10m")
    func fl400at10() {
        let focalLength: Float = 400.0
        let subjectDistance: Float = 10.0
        assertClose(calc(2.8, focalLength, subjectDistance), 9.965)
        assertClose(calc(5.6, focalLength, subjectDistance), 9.93)
        assertClose(calc(8.0, focalLength, subjectDistance), 9.901)
        assertClose(calc(11.0, focalLength, subjectDistance), 9.864)
        assertClose(calc(16.0, focalLength, subjectDistance), 9.804)
        assertClose(calc(22.0, focalLength, subjectDistance), 9.732)
        assertClose(calc(32.0, focalLength, subjectDistance), 9.615)
    }

    @Test("400mm at 15m")
    func fl400at15() {
        let focalLength: Float = 400.0
        let subjectDistance: Float = 15.0
        assertClose(calc(2.8, focalLength, subjectDistance), 14.922)
        assertClose(calc(5.6, focalLength, subjectDistance), 14.844)
        assertClose(calc(8.0, focalLength, subjectDistance), 14.778)
        assertClose(calc(11.0, focalLength, subjectDistance), 14.697)
        assertClose(calc(16.0, focalLength, subjectDistance), 14.563)
        assertClose(calc(22.0, focalLength, subjectDistance), 14.406)
        assertClose(calc(32.0, focalLength, subjectDistance), 14.151)
    }

    @Test("400mm at 25m")
    func fl400at25() {
        let focalLength: Float = 400.0
        let subjectDistance: Float = 25.0
        assertClose(calc(2.8, focalLength, subjectDistance), 24.783)
        assertClose(calc(5.6, focalLength, subjectDistance), 24.57)
        assertClose(calc(8.0, focalLength, subjectDistance), 24.39)
        assertClose(calc(11.0, focalLength, subjectDistance), 24.169)
        assertClose(calc(16.0, focalLength, subjectDistance), 23.81)
        assertClose(calc(22.0, focalLength, subjectDistance), 23.392)
        assertClose(calc(32.0, focalLength, subjectDistance), 22.727)
    }

    @Test("400mm at 50m")
    func fl400at50() {
        let focalLength: Float = 400.0
        let subjectDistance: Float = 50.0
        assertClose(calc(2.8, focalLength, subjectDistance), 49.14)
        assertClose(calc(5.6, focalLength, subjectDistance), 48.309)
        assertClose(calc(8.0, focalLength, subjectDistance), 47.619)
        assertClose(calc(11.0, focalLength, subjectDistance), 46.784)
        assertClose(calc(16.0, focalLength, subjectDistance), 45.455)
        assertClose(calc(22.0, focalLength, subjectDistance), 43.848)
        assertClose(calc(32.0, focalLength, subjectDistance), 41.667)
    }

    private func calc(_ aperture: Float, _ focalLength: Float, _ subjectDistance: Float) -> Float {
        DepthOfFieldCalculator.nearLimit(
            aperture: aperture, focalLength: focalLength, circleOfConfusion: coc, subjectDistance: subjectDistance
        )
    }

    private func assertClose(
        _ result: Float,
        _ expected: Float,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        #expect(
            abs(result - expected) <= accuracy,
            "Expected \(expected) ± \(accuracy), got \(result)",
            sourceLocation: sourceLocation
        )
    }
}
