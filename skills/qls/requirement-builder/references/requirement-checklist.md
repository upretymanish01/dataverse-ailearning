# Business requirement checklist

Every applicable item must be `Confirmed` or `N/A` before approval. IDs use the `BR-` prefix so build skills can refer to them. Items marked *If…* apply only when the condition is true.

## BR-P. Problem and context

| ID | Item | Ask |
| --- | --- | --- |
| BR-P1 | Problem statement: who is affected, what goes wrong or is missing today | "What's the problem, and who feels it?" |
| BR-P2 | Desired outcome: what's true when this is solved | "How will you know it's working?" |
| BR-P3 | Stakeholders: requester, business owner, users affected, sign-off | |
| BR-P4 | Current process or workaround, step by step | "How is this handled today?" |
| BR-P5 | Why now: value, deadline, cost of doing nothing | |
| BR-P6 | Ticket / work item number | |

## BR-S. Scope

| ID | Item | Ask |
| --- | --- | --- |
| BR-S1 | What's in scope | |
| BR-S2 | What's explicitly out of scope | "Is there anything people might expect that we're not doing?" |
| BR-S3 | Which records or people it applies to (e.g. member types, statuses), and which it doesn't | |

## BR-R. Rules and behaviour

| ID | Item | Ask |
| --- | --- | --- |
| BR-R1 | The business event that starts it, in plain words (something changes, a time arrives, someone clicks) | "What should make this happen?" |
| BR-R2 | What should happen, step by step, in plain words | "Walk me through one real case." |
| BR-R3 | Business rules and decisions, numbered (`BR-R3.1`, `BR-R3.2`, …) | |
| BR-R4 | Edge cases: repeats, reversals (undo, lapse, cancel), deletions, missing data, records changed by imports or integrations | "What if it happens twice? What if it's undone?" |
| BR-R5 | Information needed, in business terms (e.g. member number, membership type, email) | |
| BR-R6 | *If other systems are involved:* which systems, what is exchanged, who owns them | |
| BR-R7 | Does anyone need to approve or act during the process | |

## BR-N. Notifications and failure

| ID | Item | Ask |
| --- | --- | --- |
| BR-N1 | Who is told when it succeeds, if anyone, and how | |
| BR-N2 | What counts as a failure, and who must be told | |
| BR-N3 | How a failed case gets fixed or re-run, and by whom | |

## BR-V. Volume and timing

| ID | Item | Ask |
| --- | --- | --- |
| BR-V1 | How often it happens: per day, and peaks (renewal season, bulk imports) | |
| BR-V2 | How fast it must happen: before the record saves / within seconds / minutes / overnight | |
| BR-V3 | Must it happen regardless of how the data changes (form, import, integration, API), or only when a user is on the form | |

## BR-C. Constraints

| ID | Item | Ask |
| --- | --- | --- |
| BR-C1 | Privacy and security: personal data involved, who may see or trigger it | |
| BR-C2 | Dependencies: other projects, systems, people, licences | |
| BR-C3 | Deadline | |

## BR-A. Acceptance

| ID | Item | Ask |
| --- | --- | --- |
| BR-A1 | Acceptance criteria in Given / When / Then form: at least one per rule and one per failure case | |
| BR-A2 | Who tests and who signs off | |

## BR-T. Solution type

| ID | Item | Ask |
| --- | --- | --- |
| BR-T1 | Recommended solution type, with reasons and rejected alternatives | Use [solution-type-guide.md](solution-type-guide.md) |
| BR-T2 | User's decision on the solution type | |
