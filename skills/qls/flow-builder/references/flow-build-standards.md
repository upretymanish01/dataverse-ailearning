# QLS Flow Build Standards — Naming, Structure and Microsoft Best Practice

Purpose: the reference that Stage 1 (Standards and solution structure) of the planned QLS flow-build skill will load and apply. Combines the QLS naming convention supplied by QLS, Microsoft's official Power Automate guidance, and an inventory of the existing **QLS MBA Integration** solution as the worked example.

Where QLS convention and Microsoft guidance differ, **QLS convention wins** unless QLS decides otherwise.

Microsoft guidance last checked against learn.microsoft.com: 6 November 2026.

## 1. QLS naming convention (as supplied by QLS)

### 1.1 Forms, views, snippets, templates

| Surface | Format | Separator |
| --- | --- | --- |
| Portal | `Entity Name (subtype if applicable) - Process` — process is blank (for create), Edit or View | hyphen |
| CE (model-driven) | `Entity Name (subtype if applicable) : Process` — process is blank (for create), Edit or View | colon |

- Views surfaced on the Portal: no entity names or technical words (e.g. don't include "Active"); word them so they mean something to an end user.
- **No vendor names or prefixes** in names (e.g. not `KPMG/QLS/Script/Renewal/CustomButtons`). Record that detail in the code's header comment instead:

```liquid
{% comment %}
  Entity:       Content Snippet
  Record Name:  Home - Renewal Links (Student)   (previously: KPMG/QLS/Script/Renewal/CustomButtons)
  Purpose:      Contains the code snippet for renewal options for logged in user
  ==========================================================================================
  Date          Ticket   Author       Description
  ------------------------------------------------------------------------------------------
  2021                   KPMG         Initial Version.
  10/11/2021    3086     G.D.Jones    Removed hardcoded number of days for renewals buttons.
  07/03/2022    3483     B.B.King     Added Default Renewal Period.
  ==========================================================================================
{% endcomment %}
```

### 1.2 Power Automate flow names

Goal: make it easy to find every automation that is triggered by, or affects, a table.

Structure, in order:

1. **Table name**
2. **Sub-category** in brackets (e.g. application type) — only if the flow processes just some record types
3. **What triggers it:** `Create`; `Update (Field List)`; `Schedule (time/interval)`; `On Demand` (manual in Power Automate); `Child` (called from a parent flow or a CE JavaScript button)
4. Optionally ` - ` and a few words on what the flow does. Put the fuller explanation in the flow's **Description**.

Patterns:

- `Table Name: Create - What Flow Does`
- `Table (SubCategory): Create, Update (Fields) - What Flow Does`
- `Table: Schedule (1hr) - What Flow Does`
- `Table (SubCategory): On Demand - What Flow Does`
- `Table: Child - What Flow Does`

QLS examples:

- `Application: Create`
- `Application: Update (Status) - Set Processing Fields`
- `Subscription (PC): Create, Update (Supervision)`
- `Application (PC): Schedule (12:05) - Create Renewal Applications`
- `Portal Application Transaction Request: On Demand - Create Order`
- `Application: Child - PII Paid`
- `Application: HTTP (Post) Cancel` *(HTTP is used in this example but isn't in the trigger list above — see open question Q1)*

### 1.3 QLS flow build rules

- Rename every step to say what it does.
- Name variables.
- Use environment variables instead of hard-coded values.
- Word condition names for the **Yes** path.
- Add to existing flows where possible rather than creating new ones. *(Microsoft recommends small, modular child flows instead — see 2.1. The skill follows the QLS rule but should split into a child flow when there's a clear reason: logic reused by more than one flow, a caller that needs a response within 120 s, or concurrency control that should be isolated.)*

## 2. Microsoft best practice (official guidance)

Summarised from learn.microsoft.com; source per point. Caveats at the end of this section.

### 2.1 Building the flow

- **Descriptive names, never defaults**; camelCase or underscores to separate words; optional type prefixes (Microsoft's examples: `Trg_`, `Act_`, `Var_`); document conventions in a shared style guide. QLS's existing `var` + camelCase pattern (e.g. `varQLSMemberNumber`) is consistent with this. — [Naming conventions](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/use-consistent-naming-conventions)
- **Notes on actions** ("comment your flows") explaining purpose and logic. — [Naming conventions](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/use-consistent-naming-conventions)
- **Scopes** to group and collapse related actions. — [Create scopes](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/create-scopes)
- **Try / Catch scopes**: main actions in a Try scope; a Catch scope set via *Configure run after* to run when Try fails or times out. In Catch, filter `result()` to find the failed action, log it and notify; use `workflow()` to build a link to the failed run. Use **Terminate (Failed)** with a status and message on critical errors. No "Finally" scope is described. — [Error handling](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/error-handling)
  - *QLS practice (inference, not stated by Microsoft):* end the Catch scope with Terminate (Failed). Otherwise a Catch that completes cleanly makes the whole run show as *Succeeded* and the failure is hidden in run history.
- **Avoid anti-patterns**: guard against flows re-triggering themselves (trigger conditions, or Terminate when already processed); avoid nested For each loops (use OData expand instead); move large data transformations to dataflows; don't loop over large record sets — use batch requests or, for Dataverse, **bulk operations** (`CreateMultiple`, `UpdateMultiple`), which count as one operation. — [Avoid anti-patterns](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/avoid-anti-patterns)
- **Child flows** for reusable logic. — [Reusable code](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/create-reusable-code), [Create child flows](https://learn.microsoft.com/en-us/power-automate/create-child-flows)
  - Create the parent and all child flows **directly in the same solution** (importing an existing flow into it can give unexpected results).
  - The child uses the **Manually trigger a flow** trigger and returns data with **Respond to a Power App or flow** (or **Response**).
  - The child must use **embedded connections** ("Use this connection", not "Provided by run-only user") for anything other than built-in and Dataverse actions.
  - The child must respond within **120 s** or the caller times out; for long-running work use an **asynchronous response**. — [Asynchronous responses](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/asychronous-flow-pattern)
  - Call children with **Run a child flow**, not an HTTP call to the child's URL — HTTP URLs don't follow the solution to another environment.
- **No hard-coding**, especially secrets (they appear in exports and run history). Turn on **Secure inputs/outputs** on sensitive actions. — [Generic config](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/keep-flow-configuration-generic), [Secure inputs/outputs](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/use-secure-inputs-outputs-triggers)
- **HTTP request triggers**: set *Who can trigger the flow* deliberately — **Any user in my tenant** or **Specific users in my tenant** (users or service principal object IDs) require a Microsoft Entra ID token; **Anyone** is the legacy setting where the URL itself is the only credential. — [OAuth for HTTP triggers](https://learn.microsoft.com/en-us/power-automate/oauth-authentication)
- **HTTP trigger URL changes**: URLs on `logic.azure.com` stopped working on **30 November 2025**; flows show a new URL, which can exceed 255 characters. From **2 June 2026** the URL path can also include a scale-unit identifier (`/direct/cu/20/workflows/...`); the old form still works. Anything that stores or calls a flow URL must use the current one. — [Trigger troubleshooting](https://learn.microsoft.com/en-us/troubleshoot/power-platform/power-automate/flow-run-issues/triggers-troubleshoot)

### 2.2 Dataverse triggers

- **Select columns** limits Update triggers to listed columns. The flow fires when a listed column is *included* in the update, even if the value didn't change. — [Dataverse trigger](https://learn.microsoft.com/en-us/power-automate/dataverse/create-update-delete-trigger)
  - **Lookup columns aren't supported** — changes to a listed lookup don't trigger the flow. Use only scalar columns (text, number, date/time, choice).
  - Never list columns that are always sent on update (e.g. the primary key), or every update fires the flow.
  - Applies to Update only; not supported on virtual tables.
- **Filter rows**: an OData expression on the Dataverse trigger (e.g. `statuscode eq 1`), evaluated after the change is saved; write it without `$filter=`. — [Dataverse trigger](https://learn.microsoft.com/en-us/power-automate/dataverse/create-update-delete-trigger)
- **Trigger conditions**: expressions in the trigger's Settings. Filter on the trigger (Filter rows or trigger conditions) rather than with a Condition inside the flow, so unneeded runs never start and don't consume requests. — [Optimise triggers](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/optimize-power-automate-triggers), [Understand limits](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/understand-limits)
- **Scope** (User / Business Unit / Parent: Child business unit / Organization) and **Run as** (Flow owner default / Row owner / Modifying user) — choose deliberately. Run as needs the flow owner to hold **Act on Behalf of Another User** (`prvActOnBehalfOfAnotherUser`); if a team owns the row, Row owner falls back to the flow owner. — [Dataverse trigger](https://learn.microsoft.com/en-us/power-automate/dataverse/create-update-delete-trigger)

### 2.3 Solutions and ALM

- **Solution-aware flows with connection references**; only solution-aware flows can use environment variables. Edit only in Dev; deploy **managed** to Test/Prod, ideally via Power Platform pipelines. — [Solution-aware flows](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/understand-benefits-solution-aware-flows)
- **Connection references** with descriptive display names, created/added in the flow's own solution. — [Connection references](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/create-connection-reference)
- **Environment variables** with description and sensible default. **Secrets in Azure Key Vault** via the Secret type: secret variables aren't offered in dynamic content, so read them with Dataverse *Perform an unbound action* → `RetrieveEnvironmentVariableSecretValue` (using the variable's unique name), with Secure outputs on that action and Secure inputs/outputs on actions that use the value. — [Env vars](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/use-environment-variables), [Key Vault secrets](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/environmentvariables-azure-key-vault-secrets)
- **Own publisher and prefix** set before creating components (QLS uses `qls_`). — [Solution concepts](https://learn.microsoft.com/en-us/power-platform/alm/solution-concepts-alm)
- **Add only the table components you changed** (columns, forms, views), not the whole table, to avoid extra layers overriding other customisations. — [Segmented solutions](https://learn.microsoft.com/en-us/power-platform/alm/segmented-solutions-alm)

### 2.4 Ownership, limits, monitoring

- **Service principal owns critical or long-running flows**; user accounts only for interactive, user-specific flows. Add co-owners only when needed; otherwise share with **run-only** permissions. — [Access to flows](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/understand-access-to-flows), [Service principal support](https://learn.microsoft.com/en-us/power-automate/service-principal-support)
- **Retries**: exponential, and only where needed (each retry is a request). The default policy depends on the flow's performance profile — **Low**: up to 2 retries at about 5–10 minute intervals; **Medium/High**: up to 12 retries at exponential intervals from 7 s up to about 1 hour. Custom policies allow up to 90 attempts, with delays of 5 s to 1 day. Synchronous outbound HTTP timeout is 120 s. — [Limits and config](https://learn.microsoft.com/en-us/power-automate/limits-and-config), [Error handling](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/error-handling)
- **Concurrency**: trigger concurrency control is off by default; leave it off unless needed. If it is needed, put the affected actions in a small child flow and apply it there. Once on, it can't be turned off in place (the limits page says delete and re-add the trigger; the guidance page says create a new flow). — [Optimise triggers](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/optimize-power-automate-triggers), [Limits and config](https://learn.microsoft.com/en-us/power-automate/limits-and-config)
- **Request limits**: every trigger and action counts, including Initialize variable, Compose and scopes, and every loop iteration, retry and page of pagination; skipped actions don't count. A flow throttled for **14 consecutive days is suspended** and its owner notified. Remedies: assign a **Process licence** (250,000 actions per 24 h; up to 10 can be stacked on one flow) or reduce requests. Dataverse service protection limits are separate (429 + `Retry-After`) and a Process licence doesn't raise them. — [Understand limits](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/understand-limits), [Dataverse API limits](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/api-limits)
- **Monitoring**: Automation center, FlowRun table, Application Insights for failure alerts. — [Monitoring](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/monitoring-and-alerting), [App Insights](https://learn.microsoft.com/en-us/power-platform/admin/app-insights-cloud-flow)

Caveats:

- Request-limit figures are in a Microsoft transition period and may change.
- Retry status codes (408/429/5xx) are documented for Logic Apps and not confirmed on a Power Automate page.
- Application Insights export for Power Automate is **public preview**, available only in **Managed Environments**, and its telemetry isn't lossless — run history in Power Automate remains the complete record.

## 3. Existing solution inventory — QLS MBA Integration (from QLS screenshots)

Publisher prefix `qls_`. 13 objects. Owner shown on all flows and environment variables: a named user (Manish Uprety). Flows last modified 2–3 months ago, all **On**.

| Type | Display name | Schema/name |
| --- | --- | --- |
| Cloud flow | FOR TEST Only - Retrieve MBA Account Details During Testing | — |
| Cloud flow | Individual (MBA): HTTP - Manual Reprovisioning of an MBA Account | — |
| Cloud flow | Individual (MBA): Update (First Name, Last Name, Username, Preferred Mobile) Update MBA Details | — |
| Cloud flow | Individual (MBA): HTTP - Generate Redirect URL (myQLS) | — |
| Cloud flow | Individual (MBA): Update (Current Membership Type, Status Reason) Create MBA Account or Update Stat… (name truncated in screenshot) | — |
| Table | Individual | `contact` (Managed: Yes, Customised: Yes) |
| Env variable | MBA Allowed Security Roles | `qls_mbaallowedsecurityroles` |
| Env variable | MBA Client ID | `qls_mbaclientid` |
| Env variable | MBA Client Secret | `qls_mbaclientsecret` |
| Env variable | MBA Environment URL | `qls_mbaenvironmenturl` |
| Env variable | MBA Manual Reprovisioning Flow URL | `qls_mbamanualreprovisioningflowurl` |
| Env variable | MBA SSO Environment URL | `qls_mbassoenvironmenturl` |
| Web resource (JScript) | Member Benefits Australia | `qls_mbaintegration` |

### 3.1 Worked example — the lifecycle flow

`Individual (MBA): Update (Current Membership Type, Status Reason) …`

- **Trigger:** Dataverse *When a row is added, modified or deleted* — renamed "When Individual Current Membership Type or Status Update"; Change type Modified; Table Individuals; Scope Organization; Select columns `qls_currentmembershiptype, statuscode`; Filter rows empty. Trigger note: "Full Membership, Honorary Membership, Associate Membership or Student Membership".
- **Steps:** initialise `varReference`, `varRequestBody`, `varMethod`, `varQLSMemberNumber` → Get Individual Details → set `varQLSMemberNumber`, `varReference` → Condition "Check Valid for MBA Account Creation" → **Switch** on `varMethod`.
- **Switch cases:** Create MBA Account (`create`: Compose - Create Body → Scope - Try Create Request → Scope - Catch Create Request, run-after on failure), Enable MBA Account, Disabled MBA Account, Default (empty). Enable/Disable cases were collapsed, so their contents weren't visible.

### 3.2 Observations against the standards (to confirm with QLS — not conclusions)

| # | Observation | Standard | Status |
| --- | --- | --- | --- |
| O1 | Two flow names have no ` - ` before the "what it does" part (the two `Update (…)` flows). | QLS 1.2 | Confirm |
| O2 | HTTP-triggered flows use `HTTP - …`; the QLS example uses `HTTP (Post) …`, and HTTP isn't in the trigger list. | QLS 1.2 | Q1 |
| O3 | "FOR TEST Only …" flow doesn't follow the convention and sits in the solution that would deploy to Prod. | QLS 1.2; MS ALM | Confirm |
| O4 | The Switch step is still named "Switch"; case names mix "Enable" / "Disabled". | QLS 1.3 | Confirm |
| O5 | Lifecycle trigger has no Filter rows / trigger condition; filtering appears to happen inside the flow. Note: a filter limited to the four qualifying membership types would miss the *disable* events, so any trigger filter must be designed against the enable/disable rules. | MS 2.2 | Design question |
| O6 | No Connection references category appears in the solution's object list. | MS 2.3 | Confirm (may live in another solution) |
| O7 | `MBA Client Secret` is an environment variable; its type (Text vs Secret/Key Vault) isn't visible. | MS 2.3 | Confirm |
| O8 | All flows owned by a named user account. | MS 2.4 | Confirm intended prod owner |
| O9 | The Individual (`contact`) table is in the solution; not visible whether only changed components or the whole table were added. | MS 2.3 | Confirm |
| O10 | `MBA Manual Reprovisioning Flow URL` stores an HTTP trigger URL (which carries a signature). Check: (a) the *Who can trigger the flow* setting on both HTTP flows; (b) the variable holds the **new** trigger URL in every environment, since `logic.azure.com` URLs stopped working on 30 November 2025; (c) whatever reads it handles URLs longer than 255 characters. | MS 2.1 (HTTP triggers, URL changes) | Confirm |
| O11 | The lifecycle flow's Select columns includes `qls_currentmembershiptype`. If that column is a **lookup** (e.g. to a membership-type table), changes to it won't trigger the flow — only `statuscode` changes would. | MS 2.2 (Select columns) | **Confirm column type** |
| O12 | The Catch scope's last action isn't visible; if it doesn't end with Terminate (Failed), failed create requests show as *Succeeded* runs. | MS 2.1 (error handling) | Confirm |

## 4. Open questions for QLS

- **Q1.** For HTTP-triggered flows, which pattern is the standard: `Table: HTTP (Post) - What Flow Does`, or `Table: HTTP - What Flow Does`? The written convention already lists `Child` for flows called from a CE JavaScript button — should the two MBA HTTP flows be named `Child`? And which *Who can trigger the flow* setting should they use (a tenant-only setting means the calling JavaScript must send an Entra ID token)?
- **Q2.** Variable naming: is `var` + camelCase (e.g. `varQLSMemberNumber`) the QLS standard? It isn't in the written convention.
- **Q3.** Solution structure: one solution per integration (as with QLS MBA Integration), or a shared base plus per-integration solutions? Managed in Test/Prod?
- **Q4.** Do the QLS rules on code header comments (1.1) also apply to flows — e.g. a fixed format for the flow Description (purpose, ticket, author, change history)?
- **Q5.** When should a flow be split into a child flow despite the "add to existing flows" rule (1.3)?
