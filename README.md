# Legacy modernization

A Cursor project skill for reverse engineering a legacy application and replacing it in checked slices. The procedure is the same for each application: record what the system does, choose a target architecture only when none is fixed, implement one feature, then compare behavior.

PHP, Spring Boot, Angular, and OpenUI are one engagement profile. They are not hardcoded as the only legal target.

The skill lives at [`.cursor/skills/legacy-modernization/`](.cursor/skills/legacy-modernization/).

## Invoke it

The skill does not start from a mention of PHP. Name it:

```text
Use the legacy-modernization skill in analyze mode.
```

Run one mode per turn.

| Mode | Starts when | Result |
| --- | --- | --- |
| `analyze` | The governance gate has passed | `documentation/legacy-analysis/` |
| `select` | You have confirmed the analysis | An approved stack, recorded as `target: fixed` |
| `modernize` | Analysis is confirmed and the target is approved | One feature slice in `modernized-application/` |
| `validate` | That slice is implemented | `documentation/validation/<feature>.md` |

## Before a run

Two values are still empty in the skill. Supply them in the engagement file. Do not guess them.

- `{{AI_GOVERNANCE_CONFLUENCE_URL}}` — the agent reads this page and copies its operative rules verbatim before any legacy source is opened.
- `{{DESIGN_SYSTEM_PACKAGE}}` and `{{DESIGN_SYSTEM_CATALOG}}` — required before any UI template when a design system is mandated. The name defaults to OpenUI.

Also set `target` to `fixed` or `open`. A fixed target names the stack. An open target asks the skill for one recommendation and one alternative, then waits for approval.

## What a run produces

When the legacy tree is the workspace root, that root stays read-only. The skill creates the other directories beside it.

```text
workspace/
├── legacy-application/          # read-only
├── modernized-application/
└── documentation/
    ├── legacy-analysis/
    ├── architecture/
    └── validation/
```

Findings are graded `verified`, `inferred`, or `unknown`. Only confirmed rules become acceptance criteria. Fixtures are synthetic. Security notes record weakness class and impact, and insecure legacy behavior is an intentional deviation rather than something to reproduce.

## Layout

```text
.cursor/skills/legacy-modernization/
├── SKILL.md
├── references/
├── templates/
└── scripts/
```

`SKILL.md` is the procedure. The reference files hold the governance gate, the analysis method, the PHP source profile, architecture selection, the design-system map, and verification. The scripts only list files and declared dependencies. They do not install packages and they do not describe architecture.

```bash
.cursor/skills/legacy-modernization/scripts/inventory-files.sh <legacy-root>
.cursor/skills/legacy-modernization/scripts/collect-dependencies.sh <legacy-root>
```

`collect-dependencies.sh` needs `python3`.

## Claude Code

Claude reads the same `SKILL.md`, from `.claude/skills/` rather than `.cursor/skills/`. Link one copy:

```bash
mkdir -p .claude/skills
ln -s ../../.cursor/skills/legacy-modernization .claude/skills/legacy-modernization
```

Start it with `/legacy-modernization`. `disable-model-invocation: true` means Claude will not load the skill on its own.
