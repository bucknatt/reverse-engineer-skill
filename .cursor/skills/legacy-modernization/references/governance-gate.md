# Governance gate

Read this before any legacy source enters the model. Write `documentation/legacy-analysis/00-engagement.md` from the engagement template. The gate passes only when every item below is true.

## Stop until all are true

1. The user confirms the enterprise may rewrite this application. Record who confirmed and the date.
2. `{{AI_GOVERNANCE_CONFLUENCE_URL}}` is a real URL the user provided. Read that page in this session. Copy its operative rules into the engagement file verbatim: same words, same order. Do not paraphrase, soften, or invent clauses. If the URL is still the placeholder, stop.
3. A later step that would violate a recorded rule stops. The Confluence page may add bans. It may not weaken the structural bans below.
4. Structural bans, always in force:
   - Secrets, credentials, and `.env` contents stay out of prompts, analysis files, and the new repo. A key name may be recorded. A value may not.
   - Production dumps stay out. Fixtures are synthetic.
   - Customer and employee personal data stay out.
   - A named data extract is allowed only when the copied rules explicitly allow that extract.
5. The engagement file sets `target: fixed` or `target: open`.
   - `fixed` names the stack. Use it. Do not add alternatives.
   - `open` means architecture selection recommends a stack and waits for approval.
   - Copy the enterprise approved-stack list when one exists. An empty list is recorded as empty.
6. The design system is named, or the file says `none`. `{{DESIGN_SYSTEM_NAME}}` defaults to the name OpenUI when the user has not named another. `{{DESIGN_SYSTEM_PACKAGE}}` and `{{DESIGN_SYSTEM_CATALOG}}` stay empty until the user supplies them. Do not guess component names. The package is not required to analyze or to select a backend.
7. Approved tools and the human-review points are recorded. Human review is required after analysis, after architecture approval, before auth code, on each design-system gap, and before the parity report claims the program is done.

## While the gate is closed

Do not open legacy source in the model. Do not run the inventory scripts against the legacy tree. Do not create `modernized-application/`.

## After the gate

Analysis and later modes follow the recorded rules. When a rule and a modernization step conflict, the rule wins and the step stops.
