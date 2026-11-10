# Delivery plan template

The sections every QLS delivery plan has, in this order, and the rules for writing them. The reader is someone who has **never seen the work** and must be able to carry it out from the plan alone.

## Sections

| # | Section | Contents |
| --- | --- | --- |
| — | Document control | Solution, document type, version/status (start at 0.1 Draft), owner, date, delivery target (with weekday; note if the formal deadline falls on a weekend), source (requirement name and last-updated date, solution export name) |
| 1 | Purpose | The outcome in 3–5 bullets, then one paragraph on *how* (e.g. "a one-off console app in two modes: Compare, then Update") |
| 2 | Terms | Every term the steps rely on (files, "eligible", systems, environments), in plain words |
| 3 | Timeline at a glance | Table: # · Stage · Dates · Who · Must be true before moving on |
| 4 | Delivery steps | One sub-heading per stage with its date range; numbered steps continuing across stages |
| 5 | Critical dates and risks | Table: By · What must be done · If it slips |
| 6 | Questions answered from existing config | Table: Question · Answer and how the plan uses it (cite the flow or file) |
| 7 | Open decisions | Table: # · Decision · Proposed · Decided by |
| 8 | Change log | Table: Date · Version · Change · By |

## Standard stages

Adapt names and dates, but keep this order. Drop a stage only if it truly doesn't apply.

1. **Unblock** — conversation with the other party (only questions config can't answer), tooling, approvals, authentication and secrets, open decisions, ticket.
2. **Build — read-only part** (compare, report, dry run).
3. **Build — change part** (update, apply), plus any parallel fixes and peer review.
4. **Test** in Dev/Test against the other party's test environment.
5. **Production read-only run** (deploy with automation off if relevant).
6. **Review** — who reviews what, and exactly what reviewers may change.
7. **Production change run** — including how failures are found, fixed and re-run.
8. **Close** — share results, sign-off, delete local copies of personal data, turn automation on, follow-up run.

## Writing rules

1. **One action per step**, starting with a bold verb phrase: "**Read the MBA sheet.** If any column is missing, stop."
2. **Owner in italics** after the step title when it isn't obvious: *(Manish)*.
3. **No bare codes.** Never "do case 7". Write the situation in words; keep the code only as a cross-reference column if the requirement uses it.
4. **Decision tables for sorting logic.** When records are sorted into outcomes, give two tables:
   - *Safety checks*, in the order they're applied (first match wins): If… · Action · Reason text (example).
   - *Everything else*: Situation · Action · Reason text · each output column group (what's filled, with which value, or "blank").
5. **Files the work produces:** file name pattern, tabs, one header row, no merged cells or formulas, columns in exact order with group names, sort order, and what "blank" means.
6. **External calls:** for each action, the endpoint and exactly which fields are sent, copied from the shape the existing integration already uses where possible.
7. **Writes back to the system:** what's written on success, on failure, and when nothing is written, with logical names on first mention.
8. **Comparison rules** stated once, with examples ("0412 345 678" equals "0412345678").
9. **Every gap is visible:** something the requirement doesn't decide goes into Open decisions with a proposal.
10. **Dates:** `Wed 11 Nov` in steps, `10 Nov 2026` in tables; check weekdays.
11. **No secrets, no real personal data, no personal contact details.**

## Chat version vs Word version

In chat, use Markdown headings, numbered lists and tables. For Word, put the same content into `word/plan-template.html`: `<h1>` for sections, `<h2>` for stages, `<ol start="n">` to keep step numbers continuous across tables, and `class="small"` on tables with five or more columns.
