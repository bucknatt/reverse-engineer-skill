---
name: legacy-modernization
description: >-
  Reverse engineers a legacy application, selects a target architecture when
  none is fixed, and modernizes it in validated slices under enterprise AI
  governance. Use when the user asks to analyze, modernize, port, reverse
  engineer, or validate a legacy app, including PHP, Spring Boot, Angular, or
  OpenUI.
disable-model-invocation: true
---

# Legacy modernization

Govern, reconstruct behavior, choose an architecture only when it is still open, implement one feature slice, validate that slice. PHP, Spring Boot, Angular, and OpenUI are an engagement profile. They are not the only legal target.

Unresolved until the user supplies them:

- `{{DESIGN_SYSTEM_NAME}}` defaults to the name OpenUI. `{{DESIGN_SYSTEM_PACKAGE}}` and `{{DESIGN_SYSTEM_CATALOG}}` stay empty.
- `{{AI_GOVERNANCE_CONFLUENCE_URL}}` stays empty until the user provides it.

## Modes

| Mode | Starts only when | Writes |
| --- | --- | --- |
| `analyze` | Governance gate passed | `documentation/legacy-analysis/` |
| `select` | User confirmed the analysis | `documentation/architecture/05-architecture.md` or `05-options.md` |
| `modernize` | Analysis confirmed and target approved | One slice in `modernized-application/` |
| `validate` | That slice is implemented | `documentation/validation/<feature>.md` |

Refuse `modernize` without a confirmed analysis and an approved target. Refuse `validate` without an implemented slice. Do not combine modes in one turn.

Copy this checklist into the reply and keep it current:

```
Modernization:
- [ ] Governance gate passed
- [ ] analyze written and user confirmed
- [ ] select approved (target: fixed recorded)
- [ ] Slice named: ________
- [ ] Slice implemented inside its boundary
- [ ] validate recorded for that slice
```

## Workspace

```
workspace/
├── legacy-application/          # read-only
├── modernized-application/      # approved stack only
└── documentation/
    ├── legacy-analysis/
    ├── architecture/
    └── validation/
```

If the legacy tree is the workspace root, that root stays read-only. Create the other directories beside it. Never edit files under the legacy tree. During implementation, add a missing citation to an analysis file and do not rediscover the system.

## Rules

1. Pass the governance gate before reading legacy source into the model. Read [references/governance-gate.md](references/governance-gate.md) and write `documentation/legacy-analysis/00-engagement.md` from [templates/engagement.md](templates/engagement.md).
2. Grade every finding `verified` (code, test, or runtime), `inferred` (reading, not confirmed), or `unknown`. Cite file and line. `inferred` and `unknown` are not acceptance criteria until the user confirms them.
3. Record accidental structure as structure. It is not a requirement.
4. Fixtures are synthetic. A named extract is allowed only when the recorded governance rules allow that extract.
5. Security notes record weakness class, impact, and whether to fix rather than port. Do not write exploit steps, payloads, or proof-of-concept requests.
6. Recommend no stack outside the enterprise approved list. When that list is empty and no design system is mandated, stop and ask. This skill has no fallback stack.
7. Map UI only to catalogued components of the mandated design system. A missing component is a `gap`.
8. Re-read only the legacy files cited for the current slice.
9. Keep slice diffs small. Commit only when the user asks.
10. The modernization is done only when the parity report says so. An in-scope `gap` or `unverified-runtime` feature blocks that claim.

## Mode `analyze`

Read [references/reverse-engineering.md](references/reverse-engineering.md). Run [scripts/inventory-files.sh](scripts/inventory-files.sh) and [scripts/collect-dependencies.sh](scripts/collect-dependencies.sh). They print facts. They do not label architecture.

Apply a source profile. PHP uses [references/php-source-profile.md](references/php-source-profile.md). Any other source uses the same headings with the tools that exist. Record a missing tool. Do not pretend a PHP check ran.

Write under `documentation/legacy-analysis/` using the templates:

- [templates/project-overview.md](templates/project-overview.md) → `project-overview.md`
- `architecture.md` — request path, where rules live, how data is reached, as-is dependency graph from this code
- [templates/feature-inventory.md](templates/feature-inventory.md) → `feature-inventory.md`
- [templates/database-schema.md](templates/database-schema.md) → `database-schema.md`
- [templates/business-rules.md](templates/business-rules.md) → `business-rules.md`
- `user-flows.md` — steps for each in-scope flow
- `security-notes.md` — class, impact, fix-rather-than-port
- `04-oracle.md` — synthetic request and response pairs, or `unverified-runtime`

Stop for user review. Do not select or modernize in that turn.

## Mode `select`

Read [references/architecture-selection.md](references/architecture-selection.md).

When `target: fixed`, write the named stack to `documentation/architecture/05-architecture.md` with the constraints it satisfies. Do not add alternatives.

When `target: open`, write `documentation/architecture/05-options.md` from [templates/architecture-options.md](templates/architecture-options.md): one recommendation and one surviving alternative. Stop until the user approves one. Record approval in the engagement file as `target: fixed` plus the chosen names.

Spring Boot, Angular, and OpenUI are chosen only when the engagement file fixes them or they remain after the hard constraints.

## Mode `modernize`

Use the approved architecture. Define module boundaries from business capabilities, the API contracts for this slice, and the auth equivalent of the legacy mechanism. Stop for confirmation before any auth code.

Read [references/design-system.md](references/design-system.md). When a design system is mandated, stop before any UI template while `{{DESIGN_SYSTEM_PACKAGE}}` or `{{DESIGN_SYSTEM_CATALOG}}` is empty. Write `documentation/architecture/07-design-system-map.md` from [templates/design-system-map.md](templates/design-system-map.md).

Write `documentation/architecture/06-slice-plan.md`. Order slices so later features depend on earlier ones. Auth and the shell are first only when later features cannot be checked without them.

For the one named slice:

1. Load that feature’s inventory, rules, and oracle rows.
2. Re-read only the cited legacy files.
3. Add a failing test from those rows.
4. Implement server and persistence to satisfy the test.
5. Implement the UI from the design-system map.
6. Leave every other slice untouched. Leave the legacy tree untouched.

## Mode `validate`

Read [references/verification.md](references/verification.md). Behavioral equivalence is the bar: same inputs and state produce the same outcomes.

Use the test runner of the approved stack. Write `documentation/validation/<feature>.md` from [templates/slice-verification.md](templates/slice-verification.md). Update `documentation/architecture/03-traceability.md` from [templates/traceability.md](templates/traceability.md). Status is `verified` or `gap`.

When no in-scope feature remains, write `documentation/validation/08-parity-report.md`.

## Done

Done means every in-scope feature has a status, every critical verified rule is accounted for, required tests pass, intentional deviations are listed, and leftovers are explicit.

## Files

- [references/governance-gate.md](references/governance-gate.md)
- [references/reverse-engineering.md](references/reverse-engineering.md)
- [references/php-source-profile.md](references/php-source-profile.md)
- [references/architecture-selection.md](references/architecture-selection.md)
- [references/design-system.md](references/design-system.md)
- [references/verification.md](references/verification.md)
- [templates/engagement.md](templates/engagement.md)
- [templates/project-overview.md](templates/project-overview.md)
- [templates/feature-inventory.md](templates/feature-inventory.md)
- [templates/business-rules.md](templates/business-rules.md)
- [templates/database-schema.md](templates/database-schema.md)
- [templates/architecture-options.md](templates/architecture-options.md)
- [templates/traceability.md](templates/traceability.md)
- [templates/design-system-map.md](templates/design-system-map.md)
- [templates/slice-verification.md](templates/slice-verification.md)
- [scripts/inventory-files.sh](scripts/inventory-files.sh)
- [scripts/collect-dependencies.sh](scripts/collect-dependencies.sh)
