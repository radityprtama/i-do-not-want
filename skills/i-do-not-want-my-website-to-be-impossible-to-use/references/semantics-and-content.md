# Semantics & Content

Inspect headings, landmarks, links, buttons, images, tables, page title,
language and dynamic status messaging.

## Checks
- `A11Y-SEM-001` MEDIUM: clickable non-interactive element lacks correct
  semantics/keyboard behavior.
- `A11Y-NAME-001` HIGH/MEDIUM: interactive control has no accessible name.
- `A11Y-IMG-001` MEDIUM: meaningful image lacks useful text alternative or
  decorative image is announced unnecessarily.
- `A11Y-HEAD-001` LOW/MEDIUM: heading/landmark structure materially harms
  navigation.
- `A11Y-LINK-001` MEDIUM: link purpose is ambiguous in context.
- `A11Y-STATUS-001` MEDIUM: important async status/error is visual-only.

Do not produce verbose alt text just to satisfy a rule; describe purpose.
