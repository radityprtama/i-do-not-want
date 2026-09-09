# Dialogs, Menus & Custom Widgets

Prefer native elements and established accessible component primitives.

Verify role/state/property and expected keyboard model.

## Checks
- `A11Y-DIALOG-001` HIGH/MEDIUM: modal does not manage/restore focus correctly
  or cannot be dismissed as expected.
- `A11Y-MENU-001` MEDIUM: custom menu has incomplete keyboard behavior.
- `A11Y-TABS-001` MEDIUM: tabs expose incorrect selection/relationship state.
- `A11Y-ARIA-001` MEDIUM: ARIA contradicts real behavior or hides useful content.
- `A11Y-WIDGET-001` HIGH/MEDIUM: custom control is inaccessible to supported
  input methods.

Native semantics are usually safer than recreating controls with ARIA.
