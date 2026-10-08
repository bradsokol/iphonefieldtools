# Accessibility To-Do

Accessibility work, including VoiceOver, tracked separately from the Swift
migration.

## VoiceOver reads calculator values incorrectly

Found 2026-10-08 by dumping each element's accessibility label and value from a
UI test, in all four units. What VoiceOver actually speaks has not been checked
by ear.

### Sliders announce internal values

SwiftUI's `Slider` reports its bound value unless given an accessibility value,
and `LabeledSliderRow` does not set one:

| Slider | VoiceOver value | Shown on screen |
|---|---|---|
| Aperture | `18` | f/8 (18 is the index into `Aperture.values`) |
| Distance to subject | `2.5` in every unit | 8.2 ft, 250 cm, etc. (the value in metres) |
| Focal length | `24` | 24 mm (no unit) |

Each row is also read in pieces: the title ("Aperture:"), the readout ("f/8")
and the slider are separate elements.

### Units may be misread

The result's VoiceOver value and the slider readouts reuse the on-screen text
from `DistanceFormatter`, for example:

- Feet: `Near limit 4.9 ft, far limit 26.2 ft, depth of field 21.4 ft`
- Feet and inches: `Near limit 4' 10¼", far limit 26' 3", depth of field 21' 4¾"`
- Metres and centimetres: `1.5 m`, `148 cm`
- Other readouts: `f/8`, `24 mm`

Feet and inches may be read as apostrophes and quote marks, abbreviations may be
spelled letter by letter, and `f/8` may be read as "f slash 8".

### Result may still be split in Near+Far

`ResultView` combines its contents into one element, but the UI test still
finds the three Near+Far distances as separate text elements. This may be how
XCUITest reports them rather than what VoiceOver does.

**To do:**

1. Make each slider row one element ("Aperture, f/8, adjustable") whose value
   matches the readout.
2. Add a spoken format with units in words ("4 feet 10¼ inches", "1.5 metres",
   "f 8"), for distances using `Measurement` with a long unit style in
   `DistanceFormatter`, and use it for the sliders and the result.
3. Cover the spoken strings with unit and UI tests, then listen once with
   VoiceOver to confirm them, including whether the Near+Far result is one stop.
