---
name: qls-delivery-checklist
description: Create or update a QLS project delivery checklist (step-by-step plan with owners and timeline) to share with a project manager, as a staged table and PDF.
---

# QLS delivery checklist

A delivery checklist is a short, dated, step-by-step plan that Manish shares with the project manager. It lists what will be done, by whom and when — not how it is built.

## 1. Brief first (ask before drafting)

Ask in one AskUserQuestion call, unless already answered:
- Audience (default: project manager)
- Output (default: chat table, then PDF when final)
- Level of detail (default: steps only; technical fields only where the user names them)
- Fixed points: target date, people/owners, environments (Test, PACK, Production), external dependencies (e.g. ITOPS, vendor)

## 2. Content rules

- Include ONLY what the user has decided or what is in the source they gave. Never add steps, columns, rules or dates of your own.
- Put your own ideas in a separate short list headed "Suggestions – keep or drop?" below the checklist. Add them only after the user says yes.
- Do not carry over items from an older plan without asking whether they still apply.
- Do not name implementation technology (language, libraries, tools) unless the user does — how it is built is the developer's call.
- If an instruction is ambiguous (e.g. on/off, which day), ask one short question instead of guessing.
- No peer review, sign-off, SharePoint or status steps unless the user asks for them.

## 3. Format

- Title: "<Project> – Delivery Checklist".
- First line: a dependency note, e.g. "This timeline can be achieved with timely support from ITOPS (…) and <vendor> (…). A delay from either moves the dates below by the same amount."
- Group steps into stages. Heading: "Stage N – <name> (<date range>)".
- One table per stage with exactly these columns: `# | Step | Owner | Timeline`. No Status column.
- Number steps continuously across stages (1, 2, 3 …).
- Timeline uses short dates: "Wed 18 Nov", "Thu 19 Nov, afternoon", "Wed 18 – Thu 19 Nov midday".
- Field lists (e.g. flat-file columns) go as a short bullet list under the step that agrees them.
- Typical stage order for QLS integrations: Unblock → Work while waiting on dependencies → Build and local test → Test in Test → PACK (deploy, post-deployment steps, smoke test) → Review and Production deployment → Production run (with a buffer day) → Go-live and close. Use only the stages that apply.
- State flow/automation on/off per environment explicitly (e.g. PACK flows ON for smoke testing; Production flows OFF until the one-off run completes).

## 4. Making changes

- For each change, show only the affected rows/stage and say what changed in one line.
- Regenerate the full checklist only when the user asks.
- Keep one source of truth (the latest full checklist in chat, or the user's chosen doc). Don't edit other copies unless asked.

## 5. Final output

- When the user asks for a PDF: A4, QLS colours from the `qls-doc-standard` skill (headings #2D1B4E, accent #6B3FD4, table borders #BFB3D6, shaded box #EFEAF7), dependency note in a shaded box at the top, one table per stage, page numbers in the footer.
- Render it with Microsoft Word — nothing to install. Write the checklist as HTML in the scratchpad, then run the converter from the delivery-plan skill:

  ```powershell
  & "<repo>/skills/qls/delivery-plan/references/word/convert-to-word.ps1" -Html "<scratch>/checklist.html" -Docx "<scratch>/checklist.docx" -Pdf "<target>.pdf" -HeaderTitle "<Project> – Delivery Checklist"
  ```

  Pass full paths. Read the PDF and check every page (footer "Page X of Y", no stranded headings, no clipped tables) before delivering. If Word isn't available, stop and tell the user; don't install anything.
- Name the file `QLS – <Project> – Delivery Checklist vX.Y.pdf` and offer once to save it, with the key decisions, next to the project's requirement.

## Related skill

For the full builder's plan — every step spelled out with data rules, payloads and decision tables, for the person doing the work — use `qls-delivery-plan`. This checklist is the project manager's view: what, who and when.
