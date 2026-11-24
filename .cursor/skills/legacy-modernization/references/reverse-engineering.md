# Reverse engineering

Reconstruct what the running system does. The analysis files are the binding source for later slices. Do not modify the legacy tree.

## Facts first

From the legacy root, run:

```bash
scripts/inventory-files.sh <legacy-root>
scripts/collect-dependencies.sh <legacy-root>
```

Use the script output as counts, entry-point candidates, and manifest names. Do not promote that output into an architecture description. Then apply the source profile named from `SKILL.md`. PHP uses the PHP source profile. Another language uses the same output headings below with the tools present on the machine. Record a missing tool by name. Do not invent a result for it.

## Evidence

Grade every finding:

- `verified` — shown by code, a test, or a runtime observation on synthetic data
- `inferred` — a plausible reading that is not confirmed
- `unknown` — cannot be established

Cite file and line. An `inferred` or `unknown` finding becomes an acceptance criterion only after the user confirms it and the grade changes to `verified`.

Separate two records:

- Observed behavior: trigger, inputs, rules, outputs, persistence, side effects, errors, permissions
- Accidental structure: include order, global state, duplicated queries, folder layout

Accidental structure is not a requirement. Do not port it unless a verified behavior depends on it.

## Documents

Write these under `documentation/legacy-analysis/`.

### project-overview.md

Runtime, entry points, dependencies, configuration mechanism, jobs, uploads, outbound integrations. Each item has a path. Fill the `project-overview` template.

### architecture.md

Reconstruct the request path from this code: entry, where rules live, how the store is reached, and which parts call which. Include a dependency graph whose nodes are directories or modules you actually found. Title it as the as-is graph of this application.

### feature-inventory.md

One section per user-facing feature. Fields: actor, trigger, inputs, validation, rules, reads, writes, permissions, errors, output, source paths. Fill the `feature-inventory` template.

### database-schema.md

Tables or collections, keys, relations, constraints, transactions, and rules that exist only in queries or triggers. Name the statement or migration that shows each rule. Fill the `database-schema` template.

### business-rules.md

Rules gathered from server code, queries, forms, client script, and session handling. One rule per row, with its evidence grade and citation. Fill the `business-rules` template.

### user-flows.md

Numbered steps for each in-scope flow, from actor action to visible outcome. Point at the feature-inventory entry. Mark any step you could not trace as `unknown`.

### security-notes.md

For each weakness: class, impact, the feature it affects, and whether the port must fix it rather than reproduce it. Class and impact only. No exploit steps, payloads, or proof-of-concept requests.

### 04-oracle.md

When the legacy app can run locally on synthetic data, capture for each in-scope feature: request, relevant state, response or visible outcome, and validation messages. When it cannot run, mark the row `unverified-runtime` and point at the verified feature-inventory rows. Do not load production data to enrich the oracle.

## Stop

After the files exist, stop. Ask the user to confirm the analysis. Do not start `select` or `modernize` in the same turn.
