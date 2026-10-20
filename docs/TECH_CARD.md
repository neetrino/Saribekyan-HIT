# Technical Decision Card: Saribekyan HIS

## Status legend

| Status | Meaning |
|---|---|
| Draft contract baseline | Ստորագրման համար պատրաստված, բայց դեռ coding authorization չտվող contractual baseline |
| Approved | Նախագծի հաստատված որոշում՝ իր նկարագրված սահմաններում |
| Accepted | ADR-ի ընդունված architecture decision. չի հաստատում իր scope-ից դուրս business պահանջ |
| Approved Phase I boundary / Approved scope / Approved constraint | Փուլ I-ի պարտադիր սահման կամ արգելք, ոչ ամբողջ տեխնոլոգիական ռազմավարության ընդունում |
| Approved direction | Հաստատված ուղղություն, որի exact product/version/layout-ը կարող է դեռ բաց լինել |
| Proposed | Ուժեղ թեկնածու, որը պահանջում է տեխնիկական հաստատում |
| Proposed baseline | Նախնական design assumption, ոչ implementation authorization |
| PoC required | Որոշումից առաջ անհրաժեշտ է փորձնական իրականացում |
| Custom design required / Required design | Պահանջի համար design-ը անհրաժեշտ է, բայց դեռ ընդունված կամ կառուցելու թույլատրված չէ |
| Contract baseline / Conditional contract requirement | Draft/ստորագրված ՏԱ-ից եկող պայման՝ կիրառելի միայն contract status-ի և gate-ի համաձայն |
| Deferred | Այս documentation փուլում չի որոշվում |
| Out of Phase I | Փուլ I-ի պայմանագրային ծավալից դուրս է |

Այլ փաստաթղթերի «ավարտված», «created», «expected» կամ «target only» բառերը նկարագրում են documentation artifact-ի վիճակը, ոչ որոշման approval-ը և ոչ coding authorization-ը։ Coding authorization-ը որոշվում է միայն [implementation gate](./00-IMPLEMENTATION-GATE.md)-ով։

## 1. Foundation

| Decision | Value | Status | Notes |
|---|---|---|---|
| Project size | Size C | Approved | Բազմամոդուլ բժշկական համակարգ, երկարաժամկետ զարգացում և բարձր անվտանգության պահանջներ |
| Clinical platform | OpenMRS | Approved | Պացիենտ, visit, encounter, obs, order և clinical terminology հիմք |
| Backend language | Java | Approved | Custom backend development-ը կատարվում է Java-ով |
| Delivery scope | Phase I contract specification v1.3՝ ստորագրման համար | Draft contract baseline | Մինչ ստորագրման ապացույցը business coding authorization չէ. D-008 PoC-ն միակ բացառությունն է |
| Architecture approach | OpenMRS distribution + modules | Proposed | Core fork-ից խուսափելու և upgrade path-ը պահպանելու սկզբունք |

## 2. OpenMRS distribution

| Decision | Value | Status | Acceptance condition |
|---|---|---|---|
| Starting distribution | OpenMRS 3 Reference Application derivative | Proposed | Exact candidate-ը հաստատվում է միայն հաջող D-008 compatibility PoC-ի evidence review/go որոշումից հետո; fit-gap assessment-ը բավարար չէ |
| OpenMRS Platform version | Exact version TBD | PoC required | Պետք է pin անել մեկ release line, ոչ `latest`/`next` |
| Backend modules | Exact versions TBD | PoC required | Compatibility matrix + automated smoke tests |
| Frontend modules | Exact versions TBD | PoC required | `spa-assemble-config.json`-ում exact versions |
| Metadata/configuration | Version-controlled distribution content | Proposed | Concepts, forms, locations, roles և configuration-ը reproducible են |
| Core modification | Phase I-ում OpenMRS core fork/patch արգելված է | Approved Phase I boundary | ADR կամ review-ը ներկայիս scope-ում բացառություն չէ։ D-008-ի `spa-assemble-config.patch` և `omod-inclusion.patch` միայն ignored `pilot/openmrs-compatibility/work/reference-application/` distro copy-ի configuration/assembly patch-եր են, ոչ core source patch, և թույլատրված են միայն PoC spec-ի սահմաններով |

## 3. Backend

| Area | Decision | Status |
|---|---|---|
| Runtime | OpenMRS Java backend/module runtime | Approved direction |
| Custom server capabilities | Java OMOD modules | Proposed |
| Business boundaries | REG registration, AMB ambulatory, INP inpatient, DIA diagnostics/treatment, FIN finance, REP reporting, ADM administration | Approved Phase I ownership map |
| Database access | OpenMRS service/API layer, custom module DAOs միայն module-owned data-ի համար | Proposed |
| Schema migrations | OpenMRS/Liquibase module migrations | Proposed |
| Background work | Exact mechanism TBD | Deferred |
| Dependency/build tool | Maven-compatible OpenMRS module builds | Proposed |
| JVM version | Distribution compatibility review-ից հետո | PoC required |

Repository-ում հիշատակված որևէ կոնկրետ Platform/JVM զույգ ինքնաբերաբար baseline չէ։ Exact Platform և Java/JVM տարբերակները վերցվում են D-008 pilot-ի ընտրված exact commit-ից և հաստատվում են compatibility evidence-ով. մինչ այդ agent-ը version չի pin անում։

## 4. Frontend

| Area | Decision | Status |
|---|---|---|
| Shell | OpenMRS O3 app shell | Proposed |
| Reused UI | O3 patient management, chart, forms և այլ համապատասխան modules | Proposed / PoC required |
| Custom UI | O3 frontend modules, extensions, pages և workspaces | Proposed |
| Framework | O3-ի կողմից աջակցվող React ecosystem | Proposed |
| Localization | Հայերեն պարտադիր, լրացուցիչ լեզուները՝ առանձին որոշմամբ | Approved / partially open |
| Design system | O3 shared framework/components-ի reuse | Proposed |

Custom frontend-ը չի ստեղծում երկրորդ անկախ SPA, եթե պահանջը հնարավոր է անվտանգ իրականացնել O3 route/extension/workspace model-ով։

## 5. Clinical data and forms

| Area | Decision | Status |
|---|---|---|
| Patient/visit/encounter/obs/order | OpenMRS canonical models | Approved direction |
| Clinical forms | O3 Form Builder + React Form Engine candidate | Proposed |
| Form schemas | Version control + controlled publish process | Proposed |
| Terminology | OpenMRS concepts; ICD source/version TBD | Approved direction / open detail |
| External ICD API | Phase I-ից դուրս. WHO ICD API-ն միայն future candidate է | Change request required |
| Attachments | OpenMRS-compatible storage abstraction/design TBD | PoC required |

Form schema validation-ը բավարար չէ․ յուրաքանչյուր clinical form պետք է փորձարկվի ընտրված runtime renderer-ով և version-ով։

## 6. Database and storage

| Area | Decision | Status |
|---|---|---|
| Primary database | Distribution-supported relational database | Approved constraint |
| Initial candidate | MariaDB՝ Reference Application baseline-ի պատճառով | Proposed |
| Custom tables | Միայն այն domain-ների համար, որոնք OpenMRS canonical model-ը չի ծածկում | Proposed |
| Files/documents | Storage strategy TBD | Deferred |
| Backup/restore | Automated baseline + documented restore test | Contract baseline |
| Historical migration | Չկա, միայն հաստատված initial data import | Approved scope |

PostgreSQL-ը կամ այլ database-ը չի ընտրվում միայն ընդհանուր նախասիրությամբ․ այն պետք է պաշտոնապես աջակցվի ընտրված OpenMRS distribution/module stack-ի կողմից։

## 7. Identity and authorization

| Area | Decision | Status |
|---|---|---|
| Authorization source | OpenMRS persisted users, roles և privileges | Approved Phase I boundary |
| Authentication | Native OpenMRS authentication Phase I-ում | Approved Phase I boundary |
| External IdP / Keycloak | Phase I-ից դուրս | Change request required |
| MFA | Միայն ընտրված native OpenMRS լուծման ներկառուցված հնարավորության դեպքում, առանց վճարովի արտաքին integration-ի | Conditional contract requirement |
| Scope controls | Location/department/service/patient-care context | Custom design required |
| Break-glass | Reason + time limit + separate audit | Custom design required |

External IdP/Keycloak-ը Phase I dependency չէ։ Եթե ապագա փուլում ավելացվի, առանձին պետք է ապացուցվեն user lifecycle-ը, OpenMRS role synchronization-ը, logout/revocation-ը, service accounts-ը և outage behavior-ը։

## 8. API and integrations

| Area | Decision | Status |
|---|---|---|
| Internal Java API | OpenMRS service layer | Proposed baseline |
| General web API | OpenMRS REST where appropriate | Proposed |
| Healthcare interoperability | FHIR R4/FHIR2 module where supported | Proposed / PoC required |
| Custom public API | Versioned facade միայն համաձայնեցված use case-ների համար | Proposed |
| ARMED | Architecture-ready, connector-ը Phase I-ից դուրս | Approved scope |
| LIS/PACS/devices/payments | Phase I-ից դուրս, եթե change request չկա | Approved scope |

FHIR resource-ի գոյությունը չի նշանակում, որ տվյալ business workflow-ի ամբողջ lifecycle-ը աջակցվում է։ Օրինակ՝ ServiceRequest status mapping-ը պահանջում է առանձին validation։

## 9. Reporting and documents

| Candidate | Purpose | Status |
|---|---|---|
| OpenMRS Reporting Module | Dataset/report հիմք | PoC required |
| Custom dashboards | REP-01–06 գործառնական ցուցանիշներ | Proposed |
| JasperReports | PDF/structured report rendering թեկնածու | Proposed |
| Apache POI | Excel import/export թեկնածու | Proposed |
| openhtmltopdf | Հայերեն փաստաթղթերի PDF թեկնածու | Proposed |

Այս թեկնածուներից ոչ մեկը dependency ավելացնելու թույլտվություն չէ։ Ընտրությունը պահանջում է PoC/գրավոր տեխնիկական որոշում։

ՏԱ-ի փակ report register-ը պետք է ունենա report-by-report proof։ Միայն Reporting Module-ի առկայությունը REP-07-ի ընդունման ապացույց չէ։

## 10. Finance

OpenMRS 3 Billing module-ը ընդունվում է որպես գնահատման հիմք, ոչ ամբողջական լուծում։ Առանձին fit-gap/PoC է պահանջվում `FIN-01–15`-ի համար, հատկապես՝ payer split, prepayment, partial payment, refund, debt, cashier shift, immutable reversal և audit պահանջների շուրջ։

| Candidate | Status |
|---|---|
| OpenMRS Billing frontend/backend modules | PoC required |
| Custom Java finance OMOD | Expected, սահմանը՝ fit-gap-ից հետո |
| Moneta/JSR 354 | Proposed |

AMD-ի precision և rounding rule-ը business blocker է. Moneta-ի առկայությունը այդ կանոնը չի որոշում։

## 11. Audit, security and privacy

| Area | Decision | Status |
|---|---|---|
| Clinical change history | OpenMRS platform audit/version capabilities + gap analysis | PoC required |
| Custom entity audit | Custom immutable audit design | Required design |
| JaVers | Թեկնածու, ոչ canonical որոշում | Proposed |
| Read/access audit | Առանձին requirement և design | Required design |
| Encryption in transit | TLS production-ում | Contract baseline |
| Secrets | Environment/secret manager, ոչ repository | Approved principle |
| Patient safety | Clinical validation և fail-safe behavior | Approved principle |

Audit Log Web/Envers capability-ն ինքնուրույն չի ապացուցում medical audit ամբողջ պահանջը, հատկապես read access, break-glass և external export դեպքերի համար։

## 12. Delivery and quality

| Area | Required baseline |
|---|---|
| Version pinning | Platform, OMOD և O3 package exact versions |
| CI | Build, unit, integration, security/dependency և distribution smoke tests |
| Clinical workflows | Automated integration + role-based UAT |
| Upgrade safety | Clean distribution rebuild և migration rehearsal |
| Traceability | ՏԱ ID → design → code → test → UAT evidence |
| Documentation | Architecture, DB, API, deployment, operations և user guides |

## 13. Decisions required before business implementation

Այս ցանկը D-008 compatibility pilot-ը չի արգելում։ Pilot-ը հատուկ թույլատրված է, որպեսզի 1–4 կետերի exact candidate versions-ը և compatibility evidence-ը ստացվեն։ Pilot-ի սահմանները, disposable namespace-ը և exact-commit selection-ը սահմանված են [COMPATIBILITY-POC.md](./pilot/COMPATIBILITY-POC.md)-ում։ Ստորև բերված որոշումները պարտադիր են REG–ADM business implementation-ից առաջ։

1. Reference Application-ից մեկնարկելու exact release-ը։
2. Platform/JVM/DB engine և DB version compatibility matrix-ը։ Matrix-ը չի կանխորոշում MariaDB-ն կամ այլ շարժիչ. engine/version-ը հաստատվում են միայն հաջող D-008 evidence-ի review/go որոշմամբ։
3. Պարտադիր backend և O3 modules-ի exact versions-ը։
4. Ստուգել ընտրված native OpenMRS release-ի session controls-ը և արդյոք այն ներկառուցված MFA ունի։ Եթե չունի, դա արձանագրվում է որպես unavailable՝ առանց սեփական TOTP/SMS կամ external IdP կառուցելու։
5. Finance persistence և billing extension boundary-ն։
6. Reporting/document generation stack-ը։
7. Attachment/object storage-ը։
8. Audit architecture-ը և retention-ը։
9. ICD version/localization/source-ը։
10. Production hosting, RPO/RTO և monitoring baseline-ը։

## 14. Primary references

- OpenMRS O3 documentation: <https://o3-docs.openmrs.org/>
- OpenMRS Reference Application distribution: <https://github.com/openmrs/openmrs-distro-referenceapplication>
- OpenMRS Core releases: <https://github.com/openmrs/openmrs-core/releases>
- OpenMRS FHIR implementation guide: <https://fhir.openmrs.org/>
- OpenMRS licensing: <https://openmrs.org/license/>
