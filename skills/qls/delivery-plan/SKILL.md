---
name: qls-delivery-plan
description: Turn an approved (or nearly approved) QLS requirement into an exact, dated delivery plan that someone new to the work can follow step by step, from the first conversation with the other party to go-live, and produce it as a QLS-styled Word document. Mines existing solution exports, flows and config for answers before asking anyone, works back from the deadline, names who does what, and spells out data-handling steps in plain language instead of case numbers. Use when the user asks "how will we deliver this on time", "execution plan", "delivery plan", "exact steps", "runbook for the project", or wants the plan as a Word document.
---

# QLS Delivery Plan

You turn a requirement into a **delivery plan**: numbered steps that someone who has never seen the work could carry out, with dates, owners and the decisions still open. Then you produce it as a Word document in QLS style.

```text
1. Gather  ──►  2. Answer from config  ──►  3. Draft the steps  ──►  4. Review in chat  ──►  5. Word document
   (requirement,     (flows, solution,          (template)               (iterate)              (HTML → Word)
    deadline)         env variables)
```

Sits between the other QLS skills: `/qls-requirement-builder` → **`/qls-delivery-plan`** → `/qls-flow-builder` or the code build.

## Reference files

| File | Use in |
| --- | --- |
| [references/delivery-plan-template.md](references/delivery-plan-template.md) | Stages 3–5: the sections of the plan and the writing rules |
| [references/word/plan-template.html](references/word/plan-template.html) | Stage 5: the styled HTML skeleton to fill |
| [references/word/convert-to-word.ps1](references/word/convert-to-word.ps1) | Stage 5: converts the HTML to .docx (and a PDF to check) with Microsoft Word |

## Stage 1 — Gather

1. Find the requirement. Usually `requirements/<slug>/business-requirement.md`; ask if it isn't obvious. Read all of it: rules, edge cases, constraints, dependencies, open questions, acceptance criteria.
2. Find the **deadline** and today's date. Work out the weekday of each. If the deadline falls on a weekend or public holiday, plan to the last working day before it and say so.
3. Find the people: who builds, who reviews, who tests, who signs off, who on the other side (vendor, partner) is involved. Use only names in the requirement or given by the user. Unknown owners are written as roles (e.g. "Product Owner").
4. If you have no memory of an earlier conversation the user refers to, say so plainly and look for its saved output (requirement change log, plan sections) instead of guessing.

## Stage 2 — Answer questions from config before asking anyone

Before listing a question for an external party, check whether the existing build already answers it. Look in:

- the exported solution: flows (`Workflows/*.json`), environment variable definitions, customizations;
- the requirement's technical notes.

For each question record one of: **answered** (with the file and lines), **settle it ourselves** (a quick test we can run, e.g. one API call from the build machine), or **still need them**. Only "still need them" items go into the conversation step. Typical finds in Power Automate exports:

| Question | Where to look |
| --- | --- |
| Test / staging endpoint | Environment variable default values; HTTP action `uri` |
| Request shape, which fields are sent | HTTP action `body`, `Compose` expressions |
| How the API authenticates | HTTP action body or `authentication` block |
| Retry behaviour | `retryPolicy` on HTTP actions (absent = platform default) |
| Rate limits, IP restrictions | Rarely in config — usually settle by test or ask |

Flag anything risky you see on the way (e.g. a secret in plain text in an export) as a step in the plan, never repeating the secret value.

## Stage 3 — Draft the steps

Use [delivery-plan-template.md](references/delivery-plan-template.md). Key rules:

1. **Unblock stage first:** external conversation (only the "still need them" items), tooling, approvals, authentication, open decisions, ticket.
2. **Work back from the deadline.** Give each stage a date range; build stages before test, test before production, review between production read-only and production change.
3. **One action per numbered step**, numbered continuously across stages (1…n), with the owner.
4. **Plain language over codes.** Where the work sorts records into cases, never list just "case 7". Give a decision table: the situation in words → the action → exactly what goes in each output column, with an example reason text.
5. **Exact data detail:** filters with logical names and values, column order of any file produced, what is called and with what payload, what is written on success and on failure.
6. **Safety and reversibility:** a read-only/compare step before any change, a review step with what reviewers may and may not change, re-run behaviour, and deletion of local copies of personal data.
7. **Gaps the requirement doesn't cover** become "Open decisions" with a proposed answer, never silent assumptions.
8. List the **dates that decide the deadline** (what must be true by when, and what happens if it slips).

## Stage 4 — Review in chat

Show the plan in chat first. Expect the user to iterate ("make it more exact", "someone new must understand this table"). Each time, regenerate the whole plan, not a diff. Don't write files until the user asks for the document.

## Stage 5 — Word document

1. Copy [plan-template.html](references/word/plan-template.html) to the scratchpad, fill it from the agreed plan. Keep the QLS styles; don't add colours.
2. Run the conversion (Windows, Microsoft Word installed — no other software needed):

   ```powershell
   & "<skill>/references/word/convert-to-word.ps1" -Html "<scratch>/plan.html" -Docx "<target>.docx" -Pdf "<scratch>/plan.pdf" -HeaderTitle "<Solution> – Delivery Plan"
   ```

   Pass full paths (resolve 8.3 short paths with `(Get-Item <path>).FullName`).
3. Read the PDF and check every page: footer reads "Page X of Y", no heading stranded at a page bottom, tables not clipped, nothing missing.
4. Save the .docx next to the requirement, named `QLS – <Solution> – Delivery Plan v0.1.docx`. Status Draft; don't upload or share it.
5. If Word isn't available, stop and tell the user. Don't install anything. If Node.js and the `docx` package happen to be present, the `docx` skill is an alternative.

## Rules

- Never invent people, dates, volumes or answers from the other party. Unknown = an open decision or a "still need them" question.
- Never put secret values, real member data or personal contact details in the plan.
- Follow the `qls-doc-standard` skill's styling and writing style: Australian English, dates `10 Nov 2026` in tables.
- If a plan detail changes the requirement (a new rule, a payload decision), offer to update the requirement record too, and show the change before it's committed.
