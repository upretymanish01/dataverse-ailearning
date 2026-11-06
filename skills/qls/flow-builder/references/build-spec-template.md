# Build spec template

Fill every section. Write "None" rather than deleting a section. Expressions go in full, in code formatting, exactly as they'll be typed.

---

# Build spec: `<Flow name per QLS 1.2>`

| | |
| --- | --- |
| Ticket | `<ticket>` |
| Requirement record | `<path to requirement.md>` (approved `<date>`) |
| Solution | `<solution name>` (publisher `qls_`) |
| New or existing flow | New / Extend `<existing flow name>` |
| Description (paste into the flow) | `<purpose, ticket, author>` |

## 1. Create these first

### Connection references

| Display name | Connector | New / existing |
| --- | --- | --- |

### Environment variables

| Display name | Schema name | Type | Default | Dev | Test | Prod |
| --- | --- | --- | --- | --- | --- | --- |

Secret-type variables: name the Key Vault secret only; never the value.

## 2. Trigger

| Setting | Value |
| --- | --- |
| Trigger | |
| Renamed to | |
| Table / change type | |
| Select columns | |
| Filter rows | |
| Trigger conditions | |
| Scope | |
| Run as | |
| Concurrency | Off (default) / On, degree `<n>` because `<H3>` |
| Note | |

## 3. Variables

| Name | Type | Initial value | Purpose |
| --- | --- | --- | --- |

## 4. Actions

One row per action, in order. Indent nested actions by scope/branch using the Path column (e.g. `Try > Yes`).

| # | Path | Name | Connector / action | Inputs (full expressions) | Run after | Settings (secure, retry, timeout) | Note |
| --- | --- | --- | --- | --- | --- | --- | --- |

## 5. Error handling

- Catch scope runs after: `<Try scope name>` has failed, has timed out.
- Failed action: `<Filter array on result('<Try scope name>')>`.
- Run link: `<Compose expression using workflow()>`.
- Notify: `<who, how, message content>`.
- End: Terminate, status Failed, message `<...>`.

## 6. Test plan

| # | Case (J1) | Setup | Action | Expected result | Where to check |
| --- | --- | --- | --- | --- | --- |

## 7. Deployment notes

- Environment variable values to set in Test and Prod.
- Connection references to bind on import.
- Owner to assign in Prod.

## 8. Review results (Stage 4)

| Rule | Result | Note |
| --- | --- | --- |
