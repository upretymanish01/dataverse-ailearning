# Validation rules

Section numbers (e.g. "Std 2.2") point to [flow-build-standards.md](flow-build-standards.md). Severity is the default; raise it if the specific case is worse.

## V-rules — validate the requirement (Stage 2)

| ID | Check | Severity | Std |
| --- | --- | --- | --- |
| V1 | Every applicable checklist item is `Confirmed` or `N/A`; nothing `Assumed` without approval | Blocking | — |
| V2 | Requirement record has no contradictions (e.g. trigger filter excludes records the logic must handle) | Blocking | — |
| V3 | No **lookup** column in Select columns | Blocking | 2.2 |
| V4 | Select columns doesn't include columns always sent on update (primary key, modifiedon) | Blocking | 2.2 |
| V5 | Self-trigger: if the flow writes to the triggering table, the written columns are outside Select columns, or a trigger condition / Terminate guard stops the loop | Blocking | 2.1 |
| V6 | Filtering is done on the trigger (Filter rows / trigger condition), not in an in-flow Condition, wherever possible | Warning | 2.2 |
| V7 | No hard-coded URLs, IDs, emails or thresholds — each has an environment variable | Blocking | 1.3, 2.3 |
| V8 | Secrets live in Key Vault-backed Secret environment variables; nothing secret in Text variables | Blocking | 2.3 |
| V9 | Every external call has an agreed retry/stop decision and an idempotency answer | Warning | 2.1, 2.4 |
| V10 | HTTP trigger: *Who can trigger the flow* chosen deliberately; `Anyone` needs an explicit, recorded justification | Warning | 2.1 |
| V11 | Flow-to-flow calls use Run a child flow, not HTTP; child responds within 120 s or uses async response | Blocking | 2.1 |
| V12 | Loops: no nested For each; large volumes use bulk/batch operations | Warning | 2.1 |
| V13 | Volume × actions per run is plausible within request limits; flag if a run count or loop size suggests throttling | Warning | 2.4 |
| V14 | Concurrency: only on if H3 requires it, and isolated in a child flow | Warning | 2.4 |
| V15 | Extending an existing flow was considered (QLS 1.3); a new flow has a stated reason | Warning | 1.3 |
| V16 | Flow name follows QLS 1.2 (table, sub-category, trigger, ` - ` what it does) | Warning | 1.2 |
| V17 | Production owner is a service principal, or a named owner is a recorded decision | Warning | 2.4 |
| V18 | Every decision path and at least one failure case has a test case | Blocking | — |

## B-rules — review the build (Stage 4)

| ID | Check | Severity | Std |
| --- | --- | --- | --- |
| B1 | Every step from the approved requirement is present, in order; nothing extra | Blocking | — |
| B2 | No default step names ("Condition", "Switch", "Compose 2"); every step says what it does | Blocking | 1.3 |
| B3 | Conditions are worded for the **Yes** path | Warning | 1.3 |
| B4 | Variables named `var` + camelCase and initialised at the top level | Warning | 1.3, 2.1 |
| B5 | Main logic in a Try scope; Catch scope runs after Try *has failed* / *has timed out* | Blocking | 2.1 |
| B6 | Catch finds the failed action via `result()`, includes a run link from `workflow()`, notifies per G2, and ends with Terminate (Failed) per G4 | Blocking | 2.1 |
| B7 | Secure inputs/outputs on every action handling secrets or sensitive data (I1), including `RetrieveEnvironmentVariableSecretValue` | Blocking | 2.1, 2.3 |
| B8 | Secrets read with Perform an unbound action → `RetrieveEnvironmentVariableSecretValue` | Blocking | 2.3 |
| B9 | Every hard-coded value from V7 is an environment variable reference; environment variables and connection references are in the solution | Blocking | 2.3 |
| B10 | Trigger configuration matches the requirement exactly (table, change type, Select columns, Filter rows, scope, Run as) | Blocking | 2.2 |
| B11 | Dataverse fields use logical names; choices use integers; lookups bound as `<entitysetname>(<guid>)` | Blocking | — |
| B12 | Retry policy set only where V9 agreed it; none on non-idempotent calls without a guard | Warning | 2.4 |
| B13 | Action notes explain non-obvious logic | Info | 2.1 |
| B14 | Flow Description filled in per K2 | Warning | 1.2 |
| B15 | Test plan covers every J1 case | Blocking | — |
