---
name: i-do-not-want-my-website-to-be-impossible-to-use
description: Audits a user-facing web interface for accessibility and inclusive-interaction failures involving semantics, accessible names, keyboard/focus behavior, forms, dialogs/widgets, contrast, responsive layout, motion, and assistive-technology testing boundaries. Use before launch or for WCAG-oriented reviews.
license: MIT
---

# I Do Not Want My Website To Be Impossible To Use

Accessibility means users can complete tasks and recover from errors, not that a
scanner printed zero violations.

## Workflow

1. Identify critical user journeys.
2. Read [semantics and content](references/semantics-and-content.md).
3. Read [keyboard and focus](references/keyboard-and-focus.md).
4. If forms exist, read [forms and errors](references/forms-and-errors.md).
5. If dialogs/menus/tabs/custom controls exist, read [widget guidance](references/widgets.md).
6. Read [visual, motion, and responsive guidance](references/visual-motion-and-responsive.md).
7. Read [testing boundaries](references/testing-boundaries.md).

Prefer native HTML semantics before ARIA.

Never claim complete WCAG conformance unless scope and testing evidence
actually support that claim.
