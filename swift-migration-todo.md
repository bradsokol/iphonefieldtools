# Swift Migration To-Do

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
