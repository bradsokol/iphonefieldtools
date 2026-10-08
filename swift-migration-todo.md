# Swift Migration To-Do

## VoiceOver may misread result units

Found 2026-10-07 while labelling the calculator result for VoiceOver. Not yet
checked on a device or in the Accessibility Inspector.

The result's VoiceOver value reuses the on-screen text from `DistanceFormatter`.
Feet and inches values such as `4' 6½"` are likely to be read as apostrophes and
quote marks, and the "ft" and "m" abbreviations may be spelled out rather than
spoken as units.

**To do:** listen to each unit with VoiceOver. If any are misread, add a spoken
format to `DistanceFormatter` (for example with `Measurement` and a long unit
style) and use it in `accessibilityRange(near:far:)` and the single result value.

## Calculator screen code review follow-ups

Raised by the `swiftui-pro` review on 2026-10-06, after the calculator screen was
matched to `main`. None of these were introduced by that work.

### Aperture slider uses `Binding(get:set:)`

`ApertureSliderView` builds a manual binding because the slider works in `Float`
while `UserSettings.apertureIndex` is an `Int`. Removing it needs a change in
`CalculatorViewModel`, for example a `Float`-valued property for the slider to
bind to.

### `CalculatorView.swift` holds many types

The file defines about ten private view types (content, controls, result
section, slider row, the three slider views, footer, layout constants, colour
extension). Splitting them into their own files is a separate refactor.
