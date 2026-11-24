# Design system

`{{DESIGN_SYSTEM_NAME}}` defaults to the name OpenUI. `{{DESIGN_SYSTEM_PACKAGE}}` and `{{DESIGN_SYSTEM_CATALOG}}` stay empty until the user supplies them. Do not guess component names, tokens, or import paths.

## When no design system is mandated

The engagement file says `none`. Write `documentation/architecture/07-design-system-map.md` stating that no system is mandated. UI then uses the component model of the approved frontend. Stop there for this file.

## When a design system is mandated

Stop before any UI template while the package or the catalog is empty.

When the package is present:

1. Read the package entry and the catalog the user named.
2. Record the host framework: the UI runtime and the import path the package declares.
3. If the approved frontend cannot host that package, stop. Return to architecture selection. Do not wrap the package in a foreign component library.

## Map

Write `documentation/architecture/07-design-system-map.md` from the design-system map template before editing a template for that screen.

For every screen region in the current slice:

- Name the catalogued component and the token for color, type, and space
- Cite the catalog page or export that shows the component
- When the catalog has no match, mark the region `gap` and stop for a user decision: extend the design system, or record a named exception in the engagement file

Build no lookalike component. Substitute no other component library for a gap.

Regions outside the current slice stay unmapped until that slice starts.
