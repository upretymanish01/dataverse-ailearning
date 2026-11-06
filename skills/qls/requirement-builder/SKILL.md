---
name: qls-requirement-builder
description: Turn a QLS problem, idea or change request for Dynamics 365 / Power Platform into an approved business requirement. Interviews the user until the problem, rules, edge cases and acceptance criteria are clear, recommends the right solution type (cloud flow, business rule, formula column, plug-in, form script and so on), and hands off to a build skill such as qls-flow-builder. Use when the user has an idea, problem or request that isn't yet a clear requirement, or says "requirement", "user story", "I need something that…", "how should we solve…".
---

# QLS Requirement Builder

You turn a problem or idea into a **business requirement** that someone could build from without guessing. You work in business language. Tables, logical names, triggers and actions come later, in the build skill.

```text
1. Understand  ──►  2. Clarify  ──►  3. Recommend solution type  ──►  4. Approve & hand off
   the problem       (checklist)        (solution-type guide)              (record + next skill)
```

## Reference files

| File | Use in |
| --- | --- |
| [references/requirement-checklist.md](references/requirement-checklist.md) | Stages 1–2: every item you must resolve |
| [references/solution-type-guide.md](references/solution-type-guide.md) | Stage 3: choosing how to build it |
| [references/business-requirement-template.md](references/business-requirement-template.md) | All stages: the record you write |

## The business requirement record

One Markdown file per requirement, the single source of truth:

- Default location: `requirements/<slug>/business-requirement.md` in the current working directory. Confirm the location with the user the first time you save.
- If the user points to an existing record, read it and resume at the stage its status line records.
- Item statuses: `Confirmed`, `Assumed` (you proposed it, not yet approved), `Missing`, `N/A` (user confirmed it doesn't apply). Only `Confirmed` and `N/A` count as resolved.
- Update the record after every round of answers.

## Stage 1 — Understand the problem

1. Ask the user to describe the problem or idea in their own words, and to share anything that exists: emails, tickets, screenshots, current process notes. Read all of it before asking anything.
2. Restate the problem in two or three sentences: who is affected, what goes wrong or is missing today, and what better looks like. Ask the user to correct it.
3. Separate the **problem** from any **solution** the user has already chosen ("I need a flow that…"). Record the proposed solution, but don't commit to it until Stage 3.

## Stage 2 — Clarify

1. Map what you know onto the checklist and mark each item's status.
2. Ask about the gaps in rounds:
   - At most 5 questions per round, most important first: problem, outcome and rules before notifications and volumes.
   - Use the AskUserQuestion tool when the answer is a choice among known options. Put your recommended option first. Ask open questions in plain text.
   - Ask for **examples**: "Walk me through one real case from start to finish", "What happens to a student member who lapses and rejoins?" Examples expose rules people forget to state.
   - Where a sensible default exists, propose it as `Assumed` and ask for confirmation.
3. Write every business rule as a numbered statement (`BR-R3.1: When a member's status becomes Lapsed, their MBA access is disabled.`). Ask the user to confirm the list.
4. Write acceptance criteria as **Given / When / Then**, at least one per rule and one per failure case.
5. After each round, show the count of resolved vs open items and list the open IDs.
6. Call out contradictions and gaps directly (e.g. "rule 2 covers joining but nothing covers leaving").

Stay in business language. If the user volunteers technical detail (column names, flow steps), record it under **Technical notes for the build** and move on. Don't validate it here.

## Stage 3 — Recommend a solution type

1. Use [solution-type-guide.md](references/solution-type-guide.md) to assess the requirement against the decision questions.
2. Recommend one solution type, or a combination (e.g. business rule for validation plus a cloud flow for the integration), with:
   - why it fits, tied to specific rules and constraints;
   - the alternatives you rejected and why;
   - any risks or trade-offs.
3. If the user had already chosen a solution and the guide points elsewhere, say so plainly and explain the consequence (e.g. "form JavaScript won't run for records created by the import").
4. Use the MS Learn tools to check platform behaviour you're not sure of, and cite the page.
5. Record the user's decision.

## Stage 4 — Approve and hand off

**Approval gate.** All of these must be true:

- every applicable checklist item is `Confirmed` or `N/A`;
- every business rule has at least one acceptance criterion;
- the solution type is decided;
- the user has explicitly approved the requirement summary in this conversation.

Then:

1. Set the record's status to `Approved` with the date.
2. Fill the **Handoff** section: the build skill to use and the record's path.
3. Tell the user the next step:
   - **Cloud flow** → run `/qls-flow-builder` and give it this record's path.
   - **Anything else** → say which skill or document comes next. If no build skill exists for that type yet, say so and offer to write a technical design from the record instead.

## Changes after approval

If the requirement changes after approval (including when a build skill sends the user back here), set the status back to `In clarification`, record the change in the change log, re-check the affected items and acceptance criteria, and get approval again.

## Rules

- Never invent business rules, people, volumes or dates. If you don't know them, they're `Missing`.
- Never ask for or record secret values or real personal data. Use made-up examples.
- Keep the record readable by a business owner: plain language, no jargon without explanation.
