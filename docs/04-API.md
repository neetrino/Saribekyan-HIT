# API Design

> **Status:** target design guidance է, ոչ նոր business scope (`API_CHECKLIST_NOT_FACADE_CONTRACT`)։ Owner-authorized canonical Phase I API requirements-ը կարող են իրականացվել առանց signature/TASK-GO prerequisite-ի։ D-008 probe-ի contract-ը սահմանված է `pilot/COMPATIBILITY-POC.md`-ում։ Ստորև բերվածը candidate interface-ի review checklist է, ոչ custom facade-ի կամ endpoint-ի պատրաստ կանոնների հավաքածու։

> **Rule classification:** այս ֆայլի `պետք է`, `պարտադիր`, status-code, envelope և pagination ձևակերպումները `PROPOSED_DESIGN` են, եթե կոնկրետ endpoint-ի canonical requirement կամ approved design-ը դրանց չի հղվում։ Դրանք ընդհանուր API ստեղծելու հրահանգ չեն։

> **Current as-built:** O3 frontend-ը օգտագործում է OpenMRS-ի native supported API surface-ը։ `openmrs-module-saribekyan`-ը ներկայում custom REST/FHIR/public endpoint չի հայտարարում։ Ստորև target checklist-ը կիրառվում է միայն այն ժամանակ, երբ կոնկրետ Phase I slice-ը նոր endpoint է ավելացնում։

Այս փաստաթուղթը copy-ready `/api/v1`, error envelope, HTTP status կամ pagination contract չի սահմանում։ D-008-ի native OpenMRS probe contract-ը կարգավորվում է միայն իր spec-ով, իսկ «API foundation» ընդհանուր ձևակերպումը custom facade կառուցելու թույլտվություն չի տալիս։

## API surfaces

| Surface | Consumer | Rule |
|---|---|---|
| Java service API | Backend modules | Առաջնային cross-module contract |
| OpenMRS REST | O3/internal UI | Օգտագործել միայն semantic fit-ի դեպքում |
| FHIR R4/FHIR2 | Healthcare interoperability | Profile/use-case validation-ից հետո |
| Candidate custom interface — no implied path/facade | Միայն առանձին հաստատված consumer/use case | Endpoint/path/version/envelope-ը տվյալ design record-ի blocker է |
| File contract | Approved import/export | Schema, checksum և reconciliation-ով |

OpenMRS API-ն wrapper-ով կրկնել պետք չէ, եթե առկա surface-ը բավարար է։ Ներքին OpenMRS REST endpoint-ը արտաքին public API չի համարվում ինքնաբերաբար։

## Candidate custom-interface concerns — not a shared contract

Այս և հաջորդ բաժինները checklist են միայն այն custom interface-ի համար, որն ունի առանձին approved consumer/use case և task `GO`։ Դրանք չեն սահմանում shared facade, `/api/v1` path, versioning layer, adapter, envelope կամ DTO։ OpenMRS REST/FHIR-ի առկա contract-ը չի վերափաթեթավորվում միայն ձևաչափը միասնական դարձնելու համար։ Native pagination-ը, error semantics-ը և void/retire վարքը պահպանվում են. adapter-ը նույնպես ստեղծվում է միայն կոնկրետ հաստատված incompatibility/design decision-ից հետո։

- JSON UTF-8, ISO-8601 timestamps with offset/UTC և documented code systems։
- Correlation ID-ի անհրաժեշտությունը, owner-ը, ընդունվող format-ը և response propagation-ը որոշվում են տվյալ consumer/use case-ի design record-ում. մինչև այդ shared correlation middleware չի ստեղծվում։
- Write request-ը server-side schema և semantic validation է անցնում։ Unknown fields-ի policy-ն explicit է։
- Resource identifier-ը opaque stable ID է. database sequence-ը contract չի դառնում առանց հիմնավորման։
- Success response-ը կարող է վերադարձնել resource կամ operation result, բայց մեկ endpoint-ում ձևը կայուն է։
- Եթե endpoint-specific contract-ը գրավոր ընտրում է HTTP `204`, այն հետևում է HTTP semantics-ին և body չի վերադարձնում. այս կետը որևէ endpoint-ի համար `204` չի ընտրում։

## Error contract — decision required per endpoint

Այս փաստաթուղթը այլևս չի տալիս copy-ready JSON envelope կամ HTTP status mapping։ Յուրաքանչյուր approved custom endpoint-ի design record-ը պետք է առանձին որոշի safe machine code-ը, human message-ը, correlation reference-ը, field errors-ը և HTTP mapping-ը՝ consumer/use case-ի հիման վրա։ Մինչ այդ agent-ը չի ստեղծում shared error DTO, `422` policy կամ OpenMRS error adapter։ Response-ը երբեք չի բացահայտում stack trace, SQL, secret կամ անհարկի clinical value։

## Collection queries — no default pagination contract

Cursor, offset, `startIndex`/`limit`, total count, sort և filter ձևերը endpoint-specific decisions են։ Native OpenMRS endpoint-ի contract-ը չի վերագրվում։ Custom endpoint-ը չի ստեղծվում և shared pagination abstraction չի ավելացվում, մինչև consumer/use case, expected volume, stable ordering և approved contract-ը գրանցված չեն։

## Concurrency and state transitions

Հաստատված custom facade use case-ում clinical/financial resource update-ը պետք է ունենա version/ETag կամ համարժեք optimistic locking, երբ lost update-ը վտանգավոր է։ State transition endpoint-ը ընդունում է միայն գրավոր հաստատված նպատակային գործողությունն ու պատճառը, ոչ arbitrary status overwrite։ Duplicate-sensitive create/import/integration operation-ի transport idempotency-ն նախագծվում է հաստատված retry semantics-ից հետո։ Սա չի սահմանում FIN-03 business uniqueness key-ը և agent-ին չի թույլատրում այն հորինել։

## Security and audit

Յուրաքանչյուր endpoint ունի authentication, required privilege, resource/location/care-context scope և audit classification։ Sensitive resource-ի չթույլատրված որոնումը չպետք է բացահայտի դրա գոյությունը։ Export/print և break-glass operation-ները առանձին permission/audit ունեն։

## Contract lifecycle

- Custom external API-ն փաստագրվում է OpenAPI-ով և contract tests-ով։
- FHIR surface-ը հրապարակում է supported resources/profiles/operations և conformance evidence։
- Breaking change-ը նոր major version կամ migration window է պահանջում։
- Deprecation-ը ունի owner, consumers list, deadline և telemetry։
- Contract-first review-ը ստուգում է PHI minimization, authorization, idempotency և failure semantics-ը։

## Endpoint documentation template

Յուրաքանչյուր operation-ի համար նշվում են requirement ID, owner module, actor/use case, request/response schema, permission/scope, validation, state transition, transactional boundary, audit event, idempotency, errors և automated/UAT tests։

## Phase I boundary

Ստորագրված scope-ից և endpoint-level go որոշումից հետո կարող է կառուցվել համաձայնեցված integration interface-ի անհրաժեշտ API հիմքն ու documentation-ը։ Այս փաստաթուղթը ինքնուրույն `/api/v1` facade կամ endpoint կառուցելու թույլտվություն չէ։ ARMED/LIS/PACS/device/payment connector-ի endpoint-ը չի ավելացվում որպես scope, եթե չկա հաստատված change request։
