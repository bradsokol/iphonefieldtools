# Swift Migration To-Do

## Near+Far results differ from the shipping version

Found 2026-10-06 while comparing screenshots of `main` and `swift`.

With the sample camera and lens (24 mm, f/8, subject at 8.2 ft, feet, mid-range),
the Near+Far far limit reads **26.2 ft** on `main` and **26.3 ft** on `swift`.
This fails the Phase 3 validation "Calculations match ObjC version exactly".

**Cause:** `ResultView.m` `setResultNear:far:` on `main` rounds the near and far
limits before formatting them and before computing the difference:

- Feet and inches: nearest quarter inch
- Metres: nearest centimetre for macro/close ranges, otherwise nearest decimetre
- Other units: nearest millimetre for macro/close ranges, otherwise nearest
  centimetre

The SwiftUI path (`CalculatorViewModel` → `ResultView.swift`) formats the raw
values without this rounding.

**To do:** port the rounding, decide where it belongs (view model or
`DistanceFormatter`), and add tests that pin the `main` results for each
units/range combination.
