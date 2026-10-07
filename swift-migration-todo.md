# Swift Migration To-Do

## Calculator screen code review follow-ups

Raised by the `swiftui-pro` review on 2026-10-06, after the calculator screen was
matched to `main`. None of these were introduced by that work.

### VoiceOver does not identify the result values

In Near+Far, `ResultView` exposes three separate, unlabelled distances
("4.9 ft", "21.4 ft", "26.2 ft") with nothing to say which is the near limit, the
far limit or the depth of field. `main` labelled them.

**To do:** combine the range into one accessibility element whose label names
each value, and label the single-value result by distance type (hyperfocal, near
or far). Needs new localised strings.

### Subject distance range menu is below the minimum tap target

The range menu ("Mid-range") under the subject distance slider is about 16pt
tall, well under the 44pt minimum. Raising it to 44pt adds height to the row, so
the layout spacing needs adjusting at the same time.

### Aperture slider uses `Binding(get:set:)`

`ApertureSliderView` builds a manual binding because the slider works in `Float`
while `UserSettings.apertureIndex` is an `Int`. Removing it needs a change in
`CalculatorViewModel`, for example a `Float`-valued property for the slider to
bind to.

### `CalculatorView.swift` holds many types

The file defines about ten private view types (content, controls, result
section, slider row, the three slider views, footer, layout constants, colour
extension). Splitting them into their own files is a separate refactor.
