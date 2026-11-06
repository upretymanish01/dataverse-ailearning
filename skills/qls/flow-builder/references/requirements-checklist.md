# Flow requirements checklist

Every item must be `Confirmed` or `N/A` before the build gate. Items marked *If…* apply only when the condition is true; otherwise mark them `N/A`. "Ask" gives a starting question; adapt it to what you already know.

## Pre-fill from an approved business requirement

When an approved record from `/qls-requirement-builder` exists, these items come from it. Mark them `Confirmed` with the BR source and don't ask them again. Items not listed here are technical and always asked.

| Flow item | From business requirement | Note |
| --- | --- | --- |
| A1 | BR-P1, BR-P2 | |
| A2 | BR-S1, BR-S2, BR-S3 | |
| A3 | BR-R4 | |
| A4 | BR-P6, BR-P3 | |
| D1 | BR-R2 | Plain-language steps; the technical steps come from the build |
| D2 | BR-R3 | Each BR-R3.x rule must map to a decision or step |
| E1 | BR-R6 | System name only; URLs and environment variables are still asked |
| G1, G2 | BR-N2 | Business owner of failures; the notification mechanism is still asked |
| G5 | BR-N3 | |
| H1, H4 | BR-V1, BR-V2 | |
| I1 | BR-C1 | Which actions need Secure inputs/outputs is still decided here |
| J1, J3 | BR-A1, BR-A2 | Each AC becomes at least one test case |

If the business requirement says BR-V2 is "before the record saves", or BR-V3 is "only on the form", a cloud flow is the wrong tool: stop and send the user back to the requirement builder.

## A. Purpose and scope

| ID | Item | Ask |
| --- | --- | --- |
| A1 | Business purpose: what event happens and what must be true afterwards | "What should have happened once this flow finishes?" |
| A2 | Records in scope and explicitly out of scope (types, statuses, sub-categories) | "Which records should it act on, and which must it ignore?" |
| A3 | Edge cases: re-runs, already-processed records, values changing back, deletes | "What should happen if it runs twice for the same record?" |
| A4 | Ticket / work item number and requester | — |
| A5 | Existing flow to extend vs new flow (QLS rule: add to existing where possible) | "Is there a flow on this table that this belongs in?" |

## B. Trigger

| ID | Item | Ask |
| --- | --- | --- |
| B1 | Trigger type: Dataverse (Create/Update/Delete), Schedule, On Demand, Child, HTTP | — (use AskUserQuestion) |
| B2 | *If Dataverse:* table (logical name), change type(s) | |
| B3 | *If Dataverse Update:* Select columns — logical names **and column types** (no lookups) | "Which column changes should start it? Is any of them a lookup?" |
| B4 | *If Dataverse:* row filter / trigger condition, designed to let in every case the logic handles (including "undo" cases like disable) | |
| B5 | *If Dataverse:* Scope and Run as (defaults: Organization, Flow owner) | |
| B6 | *If Schedule:* frequency, start time, **time zone** | |
| B7 | *If Child:* caller(s), inputs (name, type, required), outputs, must it respond within 120 s | |
| B8 | *If HTTP:* caller, method, request body schema, response, *Who can trigger the flow* setting and how the caller authenticates | |

## C. Data

| ID | Item | Ask |
| --- | --- | --- |
| C1 | Every table read or written, with logical and entity-set names | |
| C2 | Every column read or written: logical name, type, and for choices the integer values and labels | "Can you share the column list or a screenshot of the columns?" |
| C3 | Relationships to follow (lookup → navigation property) | |
| C4 | Does the flow write to the table that triggers it? Which columns? | Self-trigger risk |

## D. Logic

| ID | Item | Ask |
| --- | --- | --- |
| D1 | Steps in plain language, in order | |
| D2 | Every decision: condition, Yes path, No path | |
| D3 | Calculations and formats (dates, time zones, number formats, string building) | |
| D4 | Loops: what is iterated, expected item count | |

## E. External integration (*If the flow calls an external API*)

| ID | Item | Ask |
| --- | --- | --- |
| E1 | System name, base URL per environment (as environment variables) | |
| E2 | Each endpoint: method, path, purpose | |
| E3 | Authentication: type, where credentials live (Key Vault secret env var), token endpoint | |
| E4 | Sample request and response for each call, including an error response | "Can you paste a real (redacted) request and response?" |
| E5 | Which errors to retry, which to stop on; idempotency (is a repeat call safe?) | |
| E6 | Rate limits or timeouts on the external side | |

## F. Solution and environment

| ID | Item | Ask |
| --- | --- | --- |
| F1 | Solution name and publisher prefix (`qls_`) | |
| F2 | Connection references: existing to reuse, new to create | |
| F3 | Environment variables: existing to reuse, new to create (name, type, default, per-environment values) | |
| F4 | Environments (Dev / Test / Prod) and deployment route | |
| F5 | Production owner (service principal or named account) | |

## G. Errors and monitoring

| ID | Item | Ask |
| --- | --- | --- |
| G1 | What counts as a failure | |
| G2 | Who is notified, how (email, Teams, record), with what details (run link, record link, error) | |
| G3 | Where errors are logged (if anywhere beyond run history) | |
| G4 | Should a handled failure still mark the run as Failed (default: yes) | |
| G5 | Recovery: how a failed record gets reprocessed | |

## H. Volume and timing

| ID | Item | Ask |
| --- | --- | --- |
| H1 | Expected runs per day, and peaks (e.g. renewal season, bulk imports) | |
| H2 | Largest batch / loop size | |
| H3 | Does order matter, or must runs for one record not overlap (concurrency) | |
| H4 | Latency expectation (seconds, minutes, overnight) | |

## I. Security

| ID | Item | Ask |
| --- | --- | --- |
| I1 | Sensitive data handled (personal data, credentials, tokens) and which actions need Secure inputs/outputs | |
| I2 | *If HTTP or JavaScript caller:* who may call it, and how the URL is stored and protected | |

## J. Testing and acceptance

| ID | Item | Ask |
| --- | --- | --- |
| J1 | Test cases: setup, action, expected result — at least one per decision path and one failure case | |
| J2 | Test data available in Dev/Test | |
| J3 | Who signs off | |

## K. Naming and documentation

| ID | Item | Ask |
| --- | --- | --- |
| K1 | Flow name per QLS 1.2 (propose it; user confirms) | |
| K2 | Flow Description text (purpose, ticket, author) | |
