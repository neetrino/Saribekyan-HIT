# Integrations Architecture

> **Կարգավիճակ:** target integration design և future connector checklist է, ոչ նոր scope։ Phase I-ում կառուցվում են owner-authorized canonical ՏԱ-ի traceable interface/report/export ID-ները։ Signature verification-ը և TASK-GO-ն prerequisites չեն։ «API/integration foundation» արտահայտությունը չի թույլատրում ընդհանուր `/api/v1` facade, connector, queue կամ adapter ստեղծել առանց հաստատված use case-ի։ D-008 compatibility PoC-ի probe-ը կարգավորվում է միայն PoC spec-ով։

> **Rule classification:** Phase I connector exclusions-ը governing scope boundary են։ Adapter/retry/idempotency/gateway/FHIR և operational checklist կետերը `PROPOSED_DESIGN` են մինչև կոնկրետ connector use case/change request-ը և կիրառելի design-ը հաստատված չեն։ TASK-GO-ն optional review է։

## Phase I boundary

Phase I-ի նպատակային սահմանում կա integration-ready architecture և ստորագրված պայմանագրով ID-ավորված reports/file exports։ Սա ինքնուրույն deliverable կամ coding task չէ։ ARMED, LIS, PACS/DICOM, devices, accounting, POS/payment, SMS/email և qualified e-signature connector-ները դուրս են Phase I-ից առանց հաստատված change request-ի։

## Interface layers

| Layer | Purpose |
|---|---|
| OpenMRS Java service API | Server-side module collaboration |
| OpenMRS REST | O3/internal web use cases, երբ semantic fit կա |
| FHIR R4/FHIR2 | Հաստատված interoperability resources/use cases |
| Custom endpoint/facade | Միայն canonical/approved use case-ի և կիրառելի accepted design-ի դեպքում. shared layer չէ |
| Controlled files | Contract reports, finance exports և approved initial import |

FHIR endpoint-ի առկայությունը դեռ չի ապացուցում workflow interoperability. mapping, terminology, lifecycle և profile-ը հաստատվում են use case առ use case։

## Principles

1. External system-ը DB-ին ուղղակի չի միանում։
2. Յուրաքանչյուր interface ունի owner, version և data contract։
3. Machine identity-ն least-privilege է, credential rotation/revocation-ով։
4. Inbound request-ն ունի authentication, validation, replay/idempotency և audit controls։
5. Outbound delivery-ն ունի timeout, retry, terminal failure և reconciliation։
6. Correlation ID-ն կապում է փորձերը՝ առանց secrets/clinical payload log անելու։
7. External failure-ը չի ստեղծում կիսատ clinical/financial state։
8. Breaking change-ը պահանջում է նոր version և consumer migration window։

```mermaid
flowchart LR
  Need[Canonical or approved connector use case] --> Decision{Accepted per-use-case design?}
  Decision -->|No| Stop[NO_GO]
  Decision -->|Yes| Native{Native OpenMRS interface fits?}
  Native -->|Yes| Reuse[Use and document native contract]
  Native -->|No| Custom[Build only the approved custom contract]
```

Սա decision flow է, ոչ component/deployment diagram։ Այն չի սահմանում Gateway, adapter, queue, retry service կամ shared integration layer։ Retry/idempotency/reconciliation-ը որոշվում են առանձին approved connector-ի համար և ընդհանուր infrastructure չեն դառնում։

## Required integration record

Յուրաքանչյուր connector-ի համար պարտադիր են business/technical owners, direction/trigger, minimum dataset/purpose, identifier mapping, contract/version, authentication, authorization scope, idempotency, timeout/retry, reconciliation, audit/privacy, sandbox/certification, availability և recurring costs։

## Candidate register

| Candidate | Phase I state | Required future proof |
|---|---|---|
| ARMED | Connector out of scope | Contract/accesses/mapping/certification |
| LIS | Out of scope | Order/result IDs, corrections, reconciliation |
| PACS/DICOM | Out of scope | Order/study/report mapping; images outside HIS DB |
| Devices | Out of scope | Device identity, units, context, human verification |
| Accounting | Only approved exports | Immutable references and reconciliation |
| Payments | Out of scope | Idempotent payment/refund callbacks |
| SMS/email | Out of scope | Consent, templates, delivery state, PHI minimization |
| Qualified e-signature | Out of scope | Trust/certificate/evidence retention |
| WHO ICD API | Չհաստատված future candidate | Phase I version/content-ը տալիս կամ հաստատում է Պատվիրատուն. API sync չի կառուցվում ինքնուրույն |

## Data migration and API governance

Approved initial import-ը պահանջում է source inventory, mapping, dry run, rejects, reconciliation totals, approval և rerun/rollback procedure։ Այն չի շրջանցում canonical IDs կամ provenance-ը։

Միայն հաստատված custom external interface-ն է versioned և machine-readable՝ իր առանձին contract-ով։ Native OpenMRS Java/REST/FHIR interface-ները պահպանում են իրենց սեփական contract-ը։ Repository-wide error envelope, correlation header կամ pagination/filtering/sorting convention չկա և չի ստեղծվում «integration-ready» լինելու պատճառով։ Դրանք սահմանվում են միայն կոնկրետ approved custom interface-ի համար։ Secrets-ը query string-ում կամ log-ում չեն հայտնվում։

Connector ակտիվացնելուց առաջ պարտադիր են approved use case, data-owner/privacy review, test environment, mapping/idempotency/failure tests, monitoring, operational owner, rollback switch և թարմացված documentation։ Background delivery mechanism-ը, gateway-ը, FHIR profiles-ը, retention-ը և connector SLA-ները դեռ բաց որոշումներ են։
