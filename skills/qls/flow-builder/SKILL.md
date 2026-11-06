---
name: qls-flow-builder
description: Gather, validate and build a QLS Power Automate cloud flow for Dynamics 365 / Dataverse. Interviews the user against a requirements checklist, refuses to build until every required item is confirmed, validates the requirement against QLS naming and Microsoft best practice, then produces a build spec (or edits an exported solution) and reviews the result. Use when the user wants to create, design, specify, change or review a Power Automate flow for QLS, or says "build me a flow", "flow requirement", "flow spec".
---

# QLS Flow Builder

You build Power Automate cloud flows for QLS in four gated stages. **Never skip a gate.** A flow built on a guessed requirement is worse than no flow.

```text
1. Intake & clarify  ──►  2. Validate requirement  ──►  3. Build  ──►  4. Review build
   (checklist)              (rules V-*)                 (spec / JSON)   (rules B-*)
        ▲                         │
        └──── blocking findings ──┘
```

## Reference files

Load these when the stage needs them; don't paste them to the user.

| File | Use in |
| --- | --- |
| [references/requirements-checklist.md](references/requirements-checklist.md) | Stage 1: every item you must resolve |
| [references/validation-rules.md](references/validation-rules.md) | Stage 2 (V-rules) and Stage 4 (B-rules) |
| [references/flow-build-standards.md](references/flow-build-standards.md) | Stages 2–4: QLS naming, Microsoft guidance, MBA worked example |
| [references/build-spec-template.md](references/build-spec-template.md) | Stage 3: the output format |

## The requirement record

Keep one Markdown file per flow as the single source of truth, so work survives across sessions:

- Default location: `flow-specs/<flow-slug>/requirement.md` in the current working directory. Confirm the location with the user the first time you save.
- If the user points to an existing record, read it and resume at the stage it records.
- Structure: a **Status** line (stage + date), the **Business requirement** path (or "None — skipped for a small change"), then the checklist table (ID, item, status, answer, source), then **Assumptions**, **Validation findings**, **Decisions**, **Change log**.
- Item statuses: `Confirmed` (user stated or approved it), `Assumed` (you proposed it, not yet approved), `Missing`, `N/A` (user confirmed it doesn't apply). Only `Confirmed` and `N/A` count as resolved.

Update the record after every round of answers.

## Stage 1 — Intake and clarify

0. **Start from the business requirement.** Ask whether there's an approved business requirement record from `/qls-requirement-builder` (usually `requirements/<slug>/business-requirement.md`).
   - **If there is:** read it. Check its status is `Approved` and its solution type (BR-T2) includes a cloud flow; if not, stop and send the user back to the requirement builder. Record its path in the requirement record. Pre-fill the checklist items mapped from it (see the mapping table at the top of the checklist) as `Confirmed`, with source `BR-<id>`. Treat its **Technical notes for the build** as leads to confirm, not as confirmed.
   - **If there isn't:** recommend running `/qls-requirement-builder` first. For small, well-understood changes (e.g. adding a column to an existing trigger), the user may skip it; then ask the business items yourself as part of the checklist.
   - **If a technical answer changes the business meaning** (a new rule, a changed scope, a different failure owner), don't patch it here. Tell the user which BR item it affects and send them back to the requirement builder to update and re-approve it.
1. Ask the user to describe the requirement in their own words, or to share a requirement document, ticket or screenshots. Skip this if the business requirement record already covers it. Read everything they give you before asking anything.
2. Map what you learned onto the checklist. Mark each item `Confirmed`, `Assumed`, `Missing` or `N/A`. Conditional items (marked *If…* in the checklist) only apply when their condition is met.
3. Ask about the gaps in **rounds**:
   - At most 5 questions per round, grouped by checklist section, most blocking first (trigger and scope before error emails).
   - Use the AskUserQuestion tool when the answer is a choice among known options (e.g. trigger type, scope, who can trigger an HTTP flow). Put your recommended option first. Ask open questions in plain text.
   - Where you can propose a sensible default from the standards, propose it as `Assumed` and ask the user to confirm, rather than asking an open question.
   - Ask for schema names and **column types**, not just display names. Ask for sample API requests/responses rather than descriptions of them.
4. After each round, show a short status: counts of resolved vs open items, and the list of open item IDs.
5. Spot contradictions and ask about them directly (e.g. "the trigger filter only lets in active members, but the disable case needs inactive ones").
6. Do not move on while any required item is `Missing` or `Assumed`, unless the user explicitly marks it `N/A`.

If the user asks you to "just build it" with gaps open, list the open items and what could go wrong with each, and offer to record explicit assumptions they approve. Approved assumptions become `Confirmed` with source "assumption approved by user".

## Stage 2 — Validate the requirement

1. Run every V-rule in [validation-rules.md](references/validation-rules.md) against the record. Use the MS Learn tools if a rule depends on platform behaviour you're unsure of, and cite the page.
2. Report findings in a table: rule ID, finding, severity (`Blocking` / `Warning` / `Info`), recommended fix.
3. `Blocking` findings send you back to Stage 1 for the affected items. `Warning` findings need a user decision (fix or accept), recorded under **Decisions**.
4. Write a **requirement summary** (one screen: purpose, trigger, logic in plain steps, integrations, error handling, test cases) and ask the user to approve it.

**Build gate.** Proceed to Stage 3 only when all of these are true:

- every applicable checklist item is `Confirmed` or `N/A`;
- no open `Blocking` findings; every `Warning` has a recorded decision;
- the user has explicitly approved the requirement summary in this conversation.

State that the gate passed, and update the record's status line.

## Stage 3 — Build

Ask which output the user wants, recommending A unless they're changing an existing flow:

### A. Build spec (default)

Fill [build-spec-template.md](references/build-spec-template.md) and save it as `flow-specs/<flow-slug>/build-spec.md`. The user builds the flow in the designer from it, so it must be complete enough to follow without guessing:

- every action in order, with its final name, connector/action, every input, expressions written out in full, run-after and settings (secure inputs/outputs, retry, concurrency);
- Dataverse columns by **logical name**; choice values as integers with their labels; lookups bound as `<entitysetname>(<guid>)` on the navigation property;
- the connection references and environment variables to create first, with schema names, types and per-environment values (secrets: name only, never the value).

### B. Edit an exported solution (existing flows only)

Use only when the user gives you an **unmanaged** solution .zip exported from Dev and wants an existing flow changed.

1. Extract it into a new empty folder in the scratchpad. Find the flow in `Workflows/*.json`; the logic is under `properties.definition`.
2. Change only what the approved requirement needs. Keep action names in line with the spec. Never put secret values in the JSON.
3. Check the JSON parses, then re-zip with entries at the root of the archive and **forward-slash** paths. On Windows PowerShell 5.1, don't use `Compress-Archive`, which writes backslash paths; use `System.IO.Compression.ZipFile` and set each entry name with `/`.
4. Give the user the zip path and tell them to import it into **Dev** only, then test.

Don't use B to add new flows (that also needs `customizations.xml` and `solution.xml` changes); produce a build spec instead.

### Not available

Don't import, export or deploy solutions yourself, and don't install tools (such as the Power Platform CLI) to do so. If the user wants that, tell them what's missing and stop.

## Stage 4 — Review the build

1. Run every B-rule in [validation-rules.md](references/validation-rules.md) against the build spec or edited JSON.
2. If the user built the flow from the spec, ask for screenshots or the flow's exported JSON and review those against the spec too.
3. Report findings in the same table format as Stage 2. Fix what you can in the spec; list what the user must fix in the designer.
4. Turn the confirmed test cases into a test plan (steps, data to set up, expected result, where to look: run history, the record, the external system).
5. Update the record: status `Built — reviewed`, findings, and a change-log line.

## Rules that apply at every stage

- QLS convention wins over Microsoft guidance where they differ (see the standards file), unless the user decides otherwise; record such decisions.
- Never ask for, store or print secret values. Refer to secrets by environment-variable name.
- Don't invent schema names, choice values, API fields or URLs. If you don't have them, they're `Missing`.
- When the requirement changes after the build gate, go back to the stage the change affects, and re-run the validation rules that touch the changed items.
