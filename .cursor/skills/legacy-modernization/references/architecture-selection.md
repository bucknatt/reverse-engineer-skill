# Architecture selection

Run this only after the user has confirmed the analysis. Read the engagement file and the verified findings. Hard constraints eliminate options before any preference.

## Order of constraints

1. Enterprise approved-stack list from the engagement file. A stack outside that list is not recommended. An empty list eliminates nothing and is recorded as empty.
2. Mandated design system. When `{{DESIGN_SYSTEM_PACKAGE}}` is present, read the catalog’s host framework from that package (the import path and the UI runtime it declares). A frontend that cannot consume that system is eliminated. When a design system is mandated and the package or catalog is still empty, stop before the frontend choice. Backend selection may continue, and the frontend line stays `blocked: design-system package missing`.
3. Data that must stay. Keep the current database unless the engagement file states a constraint that requires a new store. A schema change is its own later slice, not part of the stack recommendation.
4. Independent lifecycle. Recommend one deployable, with modules split by business capability from the feature inventory. Recommend a separate deployable only where a verified finding shows that lifecycle and the approved list allows it.

## When `target: fixed`

Write `documentation/architecture/05-architecture.md`:

- Named stack from the engagement file
- Which constraints that stack satisfies, each cited from the engagement file or a verified finding
- Module boundaries by business capability
- API style implied by the approved stack
- Auth mechanism found in the legacy analysis, and the equivalent in the approved stack, marked as a proposal that waits for confirmation
- How parity will be tested with that stack’s test runner

Do not add alternatives. Spring Boot, Angular, and OpenUI appear here when the engagement file names them. Do not add them because they are familiar.

## When `target: open`

Write `documentation/architecture/05-options.md` from the architecture-options template.

Include:

- Constraints taken from the engagement file and from verified findings, each cited
- One recommended option and one alternative that also survives the hard constraints
- For each option: behavior fit, design-system fit, data-migration cost, operational fit, how parity will be tested
- The legacy facts that drove the recommendation, cited
- A same-platform modernization (current language, current generation of its framework) when the approved list allows it and no mandated UI stack requires a rewrite
- A cross-platform rewrite when the approved list or the design-system host framework cannot be met on the legacy platform

If the approved list is empty and no design system is mandated, stop and ask the user. Do not fill the gap with a preferred stack.

## Approval

Stop until the user approves one option. Record the approval in the engagement file as `target: fixed` plus the chosen names. Implementation of that choice is a `modernize` run, not a continuation of this mode.
