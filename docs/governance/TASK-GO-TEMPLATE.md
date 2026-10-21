# Task go record

> Պատճենել task-ի հաստատված տեղում։ Task-ի իրական dependency-ի վրա `TBD`, դատարկ կամ հակասող արժեքը նշանակում է `NO_GO`։ Այդ task-ին չվերաբերող դաշտը `N/A_NOT_A_DEPENDENCY` է և `NO_GO` չէ։ Coding agent-ը չի հաստատում սեփական record-ը։

Task reviewer-ը գնահատում է միայն scoped task-ի dependency-ները։ Այլ requirement-ի, հետագա slice-ի, module-ի, հաշվետվության, workflow-ի կամ infrastructure-ի բաց decision-ը այս task-ի `GO` որոշման վրա չի ազդում։

`BUSINESS_IMPLEMENTATION` task-ի համար պարտադիր են միայն այն դաշտերը, որոնք այս slice-ի արդյունքի վրա իրականում ազդում են։ ADR, workflow record, permission record, audit decision, concurrency decision, storage decision, UAT scenario, performance evidence կամ rollback procedure պահանջվում է միայն երբ task-ը այդ հարցը ներմուծում կամ դրանից կախված է։ Scoped requirement-ից դուրս բաց decision-ը task-ը չի կանգնեցնում։

`Decision: GO` տողը մենակ բավարար չէ։ `GO` դառնում է միայն երբ պարտադիր դաշտերը կոնկրետ են, `blockers` ցանկը դատարկ է, signed artifact hash-ը `SIGNATURE-STATUS.yaml`-ի իրական hash-ն է, և անկախ reviewer-ը գրել է որոշումը։ Hash, reviewer կամ ADR չհորինել։

`N/A`-ն ազատ escape չէ։ Այն թույլատրելի է միայն ստորև կամ կոնկրետ դաշտում նշված profile-ով։ D-008-ի canonical profile-ը `D008_COMPATIBILITY_POC` է՝ լրացուցիչ պարտադիր `RUN-RECORD.md`-ով։ `PRODUCTION_PILOT_RELEASE`-ը business implementation profile է և D-008 բացառությունը չի ժառանգում։

- Record ID: `TBD`
- Task class: `BUSINESS_IMPLEMENTATION` / `D008_COMPATIBILITY_POC` / `PRODUCTION_PILOT_RELEASE` / `DOCUMENTATION_ONLY` (`pilot` alone is invalid; human labels “D-008 compatibility PoC” and “production pilot-release” map to the two exact enum values and are not alternative values)
- Review checkpoint: `KICKOFF_REVIEW` / `COMPLETION_REVIEW`
- Decision: `NO_GO` / `GO`
- Decision date: `TBD`
- Reviewer/approver: `TBD`
- Approval evidence: `TBD`

## Scoped business slice

Փոքր business task-ի բավարար record-ը այս կտորն է. այն ամբողջ ՏԱ-ի երկրորդ պայմանագիր չէ։ Ստորևի երկար դաշտերը լրացվում են միայն երբ task-ը այդ վարքն իրականացնում է, այլապես `N/A_NOT_A_DEPENDENCY`։ Այս օրինակը հաստատված record չէ. `decision` արժեքը reviewer-ն է փոխում։

```yaml
record_id: TASK-GO-REG-01-001
task_id: REG-01-PATIENT-CREATE
task_class: BUSINESS_IMPLEMENTATION
review_checkpoint: KICKOFF_REVIEW

source:
  signed_artifact_sha256: "<copy from SIGNATURE-STATUS.yaml signed_source.sha256>"
  requirements:
    - REG-01
  contract_anchor: "§5.1 / REG-01"

outcome: >
  Create one patient record with the identity and contact data required by REG-01
  and a unique patient card number.

non_goals:
  - patient merge
  - appointments
  - historical migration
  - external integrations
  - printable forms

dependencies:
  resolved: []
  unresolved_non_blocking: []

blockers: []

affected_files:
  - "<exact repository-relative path>"

verification:
  automated_tests: []
  uat: []

review:
  reviewer: "<independent reviewer>"
  decision: NO_GO
  date: YYYY-MM-DD
  evidence: "<review reference>"
```

`KICKOFF_REVIEW`-ը ստուգում է source-ը, scope-ը, dependency-ները, blockers-ը, planned affected files-ը և verification plan-ը մինչև implementation review verdict-ը։ `COMPLETION_REVIEW`-ը նորից ստուգում է նույն record-ը իրական diff-ի, changed files-ի, tests-ի, acceptance evidence-ի և reviewed commit/diff identity-ի դեմ։ Kickoff `GO`-ն completion evidence չէ, իսկ completion-ից հետո code change-ը պահանջում է նոր completion review։

`unresolved_non_blocking` արժեքը կարող է մնալ բաց և այս task-ը չի կանգնեցնում։ `blockers` ցանկի ցանկացած կետ նշանակում է `NO_GO`։ `N/A_NOT_A_DEPENDENCY` չի կարելի օգտագործել այն դաշտի վրա, որի վարքը task-ը կարդում կամ գրում է։ Եթե permission-ը, քարտի համարի եզակիությունը կամ audit-ը այս slice-ի մաս են, դրանք `resolved` ցանկում կոնկրետ գրավոր որոշում պետք է լինեն. բացակայության դեպքում slice-ը փոքրացվում է, ոչ թե այդ semantics-ը հորինվում։ `BUSINESS_IMPLEMENTATION` `GO`-ն նաև պահանջում է `signed_source.business_source_authorized: true` և `parity_with_canonical: MATCH`։

## Scope source

- Signed artifact hash from `SIGNATURE-STATUS.yaml`: `TBD` (copy the real `signed_source.sha256`; a placeholder is `NO_GO`)
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
- Accepted ADR/design evidence: `N/A_NO_ADR_REQUIRED` / `<ADR-ID>` / `TBD`
- Canonical data model: `TBD`
- API/schema/files affected: `TBD`

## Required semantics

- Workflow transition record: `N/A_NOT_A_DEPENDENCY` / `TBD`
- Permission record: `N/A_NOT_A_DEPENDENCY` / `TBD`
- Audit classification/retention decision: `N/A_NOT_A_DEPENDENCY` / `TBD`
- Concurrency/idempotency/uniqueness decision: `N/A_NOT_A_DEPENDENCY` / `TBD`
- Money precision/rounding decision: `N/A_NOT_A_DEPENDENCY` / `TBD`
- Attachment/storage decision: `N/A_NOT_A_DEPENDENCY` / `TBD`
- Other open values: `NONE` / `N/A_NOT_A_DEPENDENCY` / `TBD`

Պացիենտ ստեղծող slice-ի համար permission-ը, քարտի համարի եզակիությունը և create action-ի audit-ը dependency են. դրանց բաց semantics-ը այդ slice-ը `NO_GO` է պահում։ Finance rounding-ը, bed concurrency-ն, diagnostic workflow-ը և attachment storage-ը այդ slice-ը չեն կանգնեցնում։ Եթե permission-ը, եզակիությունը կամ audit-ը դեռ գրված չեն, task-ը փոքրացվում է մինչև այն slice-ը, որն այդ երեքը չի կատարում։

## Verification

- D-008 compatibility run record path: `N/A_NON_D008` / `TBD`
- Automated test IDs: `N/A_NOT_APPLICABLE` / `<IDs>` / `TBD`
- UAT scenario IDs: `N/A_NOT_APPLICABLE` / `<IDs>` / `TBD`
- Security/performance evidence: `N/A_NOT_A_DEPENDENCY` / `<evidence-plan>` / `TBD`
- Rollback/operational verification: `N/A_NO_RUNTIME_CHANGE` / `<rollback-plan>` / `TBD`

## Gate result

`BUSINESS_IMPLEMENTATION` և `PRODUCTION_PILOT_RELEASE` class-երի `GO`-ն պահանջում է verified signed source, կոնկրետ պարտադիր դաշտեր և դատարկ `blockers` ցանկ։ `N/A_NO_ADR_REQUIRED` բավարար է, երբ slice-ը նոր architecture decision չի ներմուծում։ Այլ requirement-ի բաց decision-ը այս `GO`-ն չի արգելում։ `D008_COMPATIBILITY_POC` class-ի pre-code `GO`-ն ստորագրված contract կամ Accepted ADR չի պահանջում. այն թույլատրելի է, երբ record-ը համապատասխանում է D-008 mapping-ին, source-ը նշված է, անկախ reviewer-ը հաստատել է exact SHA-ն ու kickoff record-ը, pre-code fields-ը կոնկրետ են, իսկ միայն execution-ից ստացվող fields-ը նշված են `PENDING_D008_EXECUTION`՝ իրենց test/teardown plan-ով։ Post-run completion review-ի համար `PENDING_D008_EXECUTION` այլևս թույլատրելի չէ. այն փոխարինվում է success/failure evidence-ով։ `DOCUMENTATION_ONLY`-ը coding `GO` չէ։
