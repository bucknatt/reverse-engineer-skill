# Verification

Behavioral equivalence is the bar. The same inputs and the same state produce the same outcomes. A screen or endpoint that merely exists does not pass a slice.

Run this mode only after the named slice is implemented. Use the test runner recorded in the approved architecture. Do not hardcode a Spring, Angular, PHP, or other command when the approved stack names a different runner.

Fixtures stay synthetic. Use an isolated database. A named extract is allowed only when the engagement file records that the governance rules allow it.

## Three checks

### Characterization

Compare the slice to `documentation/legacy-analysis/04-oracle.md`. Where a row is `unverified-runtime`, compare to the verified feature-inventory and business-rule rows for that feature and keep the status `unverified-runtime`. Do not rewrite the oracle so that it matches the new implementation.

### Integration

Exercise the slice’s API, store, and permissions on the isolated synthetic database. Assert the reads and writes named in the feature inventory.

### Regression

Re-run the known scenarios for this slice after the change. A scenario from another slice is out of scope.

## Intentional deviations

Do not reproduce these legacy behaviors when a security note says to fix them:

- Injection flaws
- Broken access control
- Weak credential storage

For each fix, record the legacy outcome, the new outcome, and a test that asserts the new outcome. Record class and impact only. Do not write exploit steps, payloads, or proof-of-concept requests.

Any other behavior change is a defect unless the user has approved it in the engagement file.

## Traceability

Update `documentation/architecture/03-traceability.md` from the traceability template. One row per feature: legacy source, feature, new endpoint, UI route, design-system components, status. Status is `verified` or `gap`.

Write `documentation/validation/<feature>.md` from the slice-verification template. The next slice starts only after this file exists.

## Parity report

When no in-scope feature remains, write `documentation/validation/08-parity-report.md`:

- Every in-scope feature and its status
- Critical verified rules and where they are implemented or listed as a gap
- Tests run and their results
- Intentional deviations
- Leftover `gap` and `unverified-runtime` rows

The program is done only when every in-scope feature has a status, every critical verified rule is accounted for, the required tests pass, intentional deviations are listed, and leftovers are explicit. An in-scope `gap` or `unverified-runtime` feature blocks a claim that the modernization is complete.
