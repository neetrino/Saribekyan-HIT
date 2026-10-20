# Task go record

> Պատճենել task-ի հաստատված տեղում։ `TBD`, դատարկ կամ հակասող պարտադիր դաշտը նշանակում է `NO_GO`։ Coding agent-ը չի հաստատում սեփական record-ը։

`N/A`-ն ազատ escape չէ։ Այն թույլատրելի է միայն ստորև կամ կոնկրետ դաշտում նշված profile-ով։ D-008-ի canonical profile-ը `D008_COMPATIBILITY_POC` է՝ լրացուցիչ պարտադիր `RUN-RECORD.md`-ով։ `PRODUCTION_PILOT_RELEASE`-ը business implementation profile է և D-008 բացառությունը չի ժառանգում։

- Record ID: `TBD`
- Task class: `BUSINESS_IMPLEMENTATION` / `D008_COMPATIBILITY_POC` / `PRODUCTION_PILOT_RELEASE` / `DOCUMENTATION_ONLY` (`pilot` alone is invalid; human labels “D-008 compatibility PoC” and “production pilot-release” map to the two exact enum values and are not alternative values)
- Decision: `NO_GO` / `GO`
- Decision date: `TBD`
- Reviewer/approver: `TBD`
- Approval evidence: `TBD`

## Scope source

- Signed artifact hash from `SIGNATURE-STATUS.yaml`: `TBD`
- Requirement ID(s): `TBD`
- Exact contract section/anchor: `TBD`
- Approved client clarification, if any: `N/A` / `TBD`
- Business outcome: `TBD`
- Explicit non-goals: `TBD`

### D-008 field profile

Միայն `Task class: D008_COMPATIBILITY_POC` դեպքում վերևի scope fields-ը լրացվում են այսպես՝

- Signed artifact hash: `N/A_D008`
- Requirement ID(s): `N/A_D008`
- Exact contract section/anchor: `D-008 + docs/pilot/COMPATIBILITY-POC.md`
- Approved client clarification: `N/A_D008`
- Business outcome: `N/A_D008 — non-business compatibility evidence`
- Explicit non-goals: պարտադիր կոնկրետ ցանկ՝ patient/clinical/finance logic, production schema և production artifact promotion-ի արգելքով

Միայն D-008 profile-ի համար մնացած դաշտերի **ամբողջական** mapping-ը հետևյալն է. չթվարկված implicit requirement չկա։

| Template field | Required D-008 value |
|---|---|
| Ownership boundary | `TECHNICAL_POC` |
| Approved artifact/module boundary | `DISPOSABLE_D008_POC` |
| Reuse/configure/extend/custom decision | `N/A_D008_SPEC_PRESCRIBED` |
| Accepted ADR/design evidence | `N/A_D008_PRE_ADR_EVIDENCE`; ADR-0002-ին սպասելը արգելված circular gate է |
| Canonical data model | `N/A_D008_NO_BUSINESS_DATA` |
| API/schema/files affected | պարտադիր կոնկրետ paths + probe endpoint; schema՝ `NONE_D008` |
| Workflow transition record | `N/A_D008` |
| Permission record | պարտադիր existing native privilege ընտրություն կամ spec-ով սահմանված failure evidence |
| Audit classification/retention decision | `N/A_D008_NO_BUSINESS_OR_PATIENT_DATA` |
| Concurrency/idempotency/uniqueness decision | `N/A_D008` |
| Money precision/rounding decision | `N/A_D008` |
| Attachment/storage decision | `N/A_D008` |
| Other open values | `NONE_D008` միայն exact-SHA approval-ից և run-record prerequisites-ից հետո |
| D-008 compatibility run record path | պարտադիր կոնկրետ `<REPOSITORY_ROOT>/pilot/openmrs-compatibility/RUN-RECORD.md` |
| Automated test IDs | pre-code պարտադիր կոնկրետ planned PoC check IDs; արդյունքները post-run են |
| UAT scenario IDs | `N/A_D008_NON_BUSINESS` |
| Security/performance evidence | kickoff՝ `PENDING_D008_EXECUTION` + planned auth assertions; post-run՝ փաստացի `200/401` և կիրառելի `403` evidence; performance՝ `N/A_D008` |
| Rollback/operational verification | kickoff՝ `PENDING_D008_EXECUTION` + teardown/clean-rerun plan; post-run՝ փաստացի teardown + clean-rerun evidence |

## Design and ownership

- Ownership boundary: `TBD`
- Approved artifact/module boundary: `TBD`
- Reuse/configure/extend/custom decision: `TBD`
- Accepted ADR/design evidence: `TBD`
- Canonical data model: `TBD`
- API/schema/files affected: `TBD`

## Required semantics

- Workflow transition record: `N/A` / `TBD`
- Permission record: `TBD`
- Audit classification/retention decision: `TBD`
- Concurrency/idempotency/uniqueness decision: `N/A` / `TBD`
- Money precision/rounding decision: `N/A` / `TBD`
- Attachment/storage decision: `N/A` / `TBD`
- Other open values: `NONE` / `TBD`

## Verification

- D-008 compatibility run record path: `N/A_NON_D008` / `TBD`
- Automated test IDs: `TBD`
- UAT scenario IDs: `TBD`
- Security/performance evidence: `N/A` / `TBD`
- Rollback/operational verification: `N/A` / `TBD`

## Gate result

`BUSINESS_IMPLEMENTATION` և `PRODUCTION_PILOT_RELEASE` class-երի `GO`-ն պահանջում է ստորագրված source artifact և փակ կիրառելի blockers։ `D008_COMPATIBILITY_POC` class-ի pre-code `GO`-ն ստորագրված contract կամ Accepted ADR չի պահանջում. այն թույլատրելի է, երբ record-ը համապատասխանում է D-008 mapping-ին, source-ը նշված է, անկախ reviewer-ը հաստատել է exact SHA-ն ու kickoff record-ը, pre-code fields-ը կոնկրետ են, իսկ միայն execution-ից ստացվող fields-ը նշված են `PENDING_D008_EXECUTION`՝ իրենց test/teardown plan-ով։ Post-run completion review-ի համար `PENDING_D008_EXECUTION` այլևս թույլատրելի չէ. այն փոխարինվում է success/failure evidence-ով։ `DOCUMENTATION_ONLY`-ը coding `GO` չէ։
