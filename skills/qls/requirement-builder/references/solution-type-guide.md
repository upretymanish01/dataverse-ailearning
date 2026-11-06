# Solution type guide

Use this to recommend how a requirement should be built in Dynamics 365 / Power Platform. It's a guide, not a rulebook: platform features change, so check MS Learn when a decision depends on specific behaviour, and cite the page.

## Decision questions

Answer these from the requirement record first. They rule options in or out quickly.

| # | Question | From | If yes |
| --- | --- | --- | --- |
| Q1 | Must it happen **before or as part of the save**, or be able to **block** the save? | BR-V2, BR-R3 | Business rule (simple) or plug-in. Not a cloud flow — flows run after the save, asynchronously. |
| Q2 | Must it apply **however the data changes** (form, import, API, integration)? | BR-V3 | Server-side: business rule with Entity scope, plug-in, cloud flow, formula/calculated column. Not form JavaScript alone. |
| Q3 | Is it only about the **form experience** (show/hide, required, defaults, guidance while editing)? | BR-R2 | Business rule or form JavaScript. |
| Q4 | Is the result a **value derived from other values** with no side effects? | BR-R3 | Formula column or calculated/rollup column, not a process. |
| Q5 | Does it **call an external system** or service? | BR-R6 | Cloud flow (asynchronous) or plug-in (synchronous). |
| Q6 | Does it run **on a schedule** or after a **long wait**? | BR-R1 | Cloud flow. |
| Q7 | Does a **person approve or act** mid-process? | BR-R7 | Cloud flow (approvals) or a business process flow for guided stages. |
| Q8 | Is it **high volume** or a **bulk** operation? | BR-V1 | Check limits; consider bulk operations in a flow, a plug-in, or a dataflow for large data loads. |
| Q9 | Is it on the **portal** (Power Pages)? | BR-S3 | Portal-side logic plus server-side enforcement for anything that must hold. |

## Options

| Type | Good for | Watch out for |
| --- | --- | --- |
| **Cloud flow** (Power Automate) | Asynchronous work after a change; integrations; notifications; approvals; schedules; multi-step orchestration | Runs after the save, so it can't block it; a short delay; request limits; needs error handling and an owner. Build with `/qls-flow-builder`. |
| **Business rule** | Simple conditions: set or clear values, required/recommended, show/hide, validation messages. Entity scope also runs on the server. | Limited logic (no loops, no related-record updates, no external calls). Show/hide and some actions only apply on forms. |
| **Formula column** (Power Fx) | Values derived from the row and related rows | Read-only; check current function and type support. |
| **Calculated / rollup column** | Calculated: derived values. Rollup: aggregates over related rows | Rollups recalculate asynchronously on a schedule, so they aren't instant. |
| **Plug-in** (C#) | Synchronous logic inside the transaction; blocking saves; complex validation; high-volume or performance-critical server logic | Pro-code: needs a developer, build pipeline and tests. Sync plug-ins slow the save if heavy. |
| **Form JavaScript** (web resource) | Form behaviour beyond business rules; ribbon buttons; calling a flow or API from a button | Only runs on the form — not for imports, API or integrations. |
| **Business process flow** | Guiding users through stages and steps | Guidance, not automation; pair with a flow for automated steps. |
| **Dataflow** | Large-scale data load and transformation | Not event-driven per record. |

Classic background workflows: Microsoft recommends cloud flows instead for new automation. Don't propose new classic workflows without a stated reason.

## Combinations

Many requirements need more than one type. Common QLS patterns:

- Validation on the form **and** enforcement on the server: business rule (Entity scope) or plug-in, plus form JavaScript only for UX.
- Button on a form that starts a process: form JavaScript calls a cloud flow (see Q1 naming in the flow standards: `Child` or HTTP).
- Change to a member record that updates an external system: cloud flow triggered by the Dataverse change, with filtering on the trigger.

## Writing the recommendation

Record in BR-T1:

- **Recommended:** the type(s), mapped to the rules each one covers (e.g. "Cloud flow — BR-R3.1 to BR-R3.4").
- **Why:** the decision questions that drove it.
- **Rejected:** each alternative considered and the reason.
- **Risks:** trade-offs the user is accepting.
