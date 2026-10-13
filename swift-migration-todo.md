# Swift Migration To-Do

## CalculatorView

1. Focus Range menu has no title. Should be "Focus Range"

## SettingsView

1. Chevrons are visible for lenses and cameras when not in edit mode. These should only be visible and active in edit mode. When not in edit mode, tapping a lens or camera selects it. When in edit mode, tapping edits it.
1. "Add lens" and "Add camera" are visible when not in edit mode. These should only be visible in edit mode.
1. "Done" button should be a check mark symbol.
1. In edit mode two buttons appear, a check mark and "Done". There should be one button to exit edit mode. Use the ios-design-agent-skill to propose a UI for this modal behaviour.
1. In edit mode, lens and camera selection check marks should not appear.
1. If there is a single camera or single lens, it should not be deletable. There must always be at least one of each.

## CameraEditView

1. Cannot enter upper case characters in the name field, other than the first character.
1. Cancel and Save buttons should appear according to HIG. Should they be an "X" and a checkmark? Should the Save button start grey and change to blue when edits are made?
1. Cancel button should confirm if edits have been made and not saved.

## LensEditView

1. Cannot enter upper case characters in the name field, other than the first character.
1. Cancel and Save buttons should appear according to HIG. Should they be an "X" and a checkmark? Should the Save button start grey and change to blue when edits are made?
1. Cancel button should confirm if edits have been made and not saved.
