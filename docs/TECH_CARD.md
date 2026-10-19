# Technical Decision Card: Saribekyan HIS

## Status legend

| Status | Meaning |
|---|---|
| Approved | Պատվիրատուի/նախագծի կողմից հաստատված հիմք |
| Proposed | Ուժեղ թեկնածու, որը պահանջում է տեխնիկական հաստատում |
| PoC required | Որոշումից առաջ անհրաժեշտ է փորձնական իրականացում |
| Deferred | Այս documentation փուլում չի որոշվում |
| Out of Phase I | Փուլ I-ի պայմանագրային ծավալից դուրս է |

## 1. Foundation

| Decision | Value | Status | Notes |
|---|---|---|---|
| Project size | Size C | Approved | Բազմամոդուլ բժշկական համակարգ, երկարաժամկետ զարգացում և բարձր անվտանգության պահանջներ |
| Clinical platform | OpenMRS | Approved | Պացիենտ, visit, encounter, obs, order և clinical terminology հիմք |
| Backend language | Java | Approved | Custom backend development-ը կատարվում է Java-ով |
| Delivery scope | Phase I contract specification v1.3 | Approved | Scope-ը չի ընդլայնվում architecture/implementation փաստաթղթով |
| Architecture approach | OpenMRS distribution + modules | Proposed | Core fork-ից խուսափելու և upgrade path-ը պահպանելու սկզբունք |

## 2. OpenMRS distribution

| Decision | Value | Status | Acceptance condition |
|---|---|---|---|
| Starting distribution | OpenMRS 3 Reference Application derivative | Proposed | Fit-gap PoC-ն հաստատում է պարտադիր backend/frontend modules-ի համատեղելիությունը |
| OpenMRS Platform version | Exact version TBD | PoC required | Պետք է pin անել մեկ release line, ոչ `latest`/`next` |
| Backend modules | Exact versions TBD | PoC required | Compatibility matrix + automated smoke tests |
| Frontend modules | Exact versions TBD | PoC required | `spa-assemble-config.json`-ում exact versions |
| Metadata/configuration | Version-controlled distribution content | Proposed | Concepts, forms, locations, roles և configuration-ը reproducible են |
| Core modification | Չփոփոխել OpenMRS core-ը | Proposed | Բացառություն՝ միայն առանձին ADR և upgrade-impact review |

## 3. Backend

| Area | Decision | Status |
|---|---|---|
| Runtime | OpenMRS Java backend/module runtime | Approved direction |
| Custom server capabilities | Java OMOD modules | Proposed |
| Business boundaries | Domain-oriented custom modules՝ registration extensions, inpatient, finance, reporting, administration | Proposed |
| Database access | OpenMRS service/API layer, custom module DAOs միայն module-owned data-ի համար | Proposed |
| Schema migrations | OpenMRS/Liquibase module migrations | Proposed |
| Background work | Exact mechanism TBD | Deferred |
| Dependency/build tool | Maven-compatible OpenMRS module builds | Proposed |
| JVM version | Distribution compatibility review-ից հետո | PoC required |

OpenMRS Platform 2.8.0-ը հայտարարում է Java 21 support, բայց Java/JVM տարբերակը չի pin արվում, մինչև ընտրված distribution-ի բոլոր պարտադիր modules-ը չեն անցել compatibility test։

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
| External ICD API | WHO ICD API candidate | PoC required |
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
| Authorization source | OpenMRS persisted users, roles և privileges | Proposed baseline |
| Authentication | Native OpenMRS կամ external IdP pattern | PoC required |
| Keycloak | Թեկնածու, ոչ հաստատված | PoC required |
| MFA | Բարձր արտոնություններով օգտատերերի համար հնարավորություն | Contract baseline |
| Scope controls | Location/department/service/patient-care context | Custom design required |
| Break-glass | Reason + time limit + separate audit | Custom design required |

Keycloak ընտրելու դեպքում պետք է ապացուցել user lifecycle-ը, OpenMRS role synchronization-ը, logout/revocation-ը, service accounts-ը և IdP խափանման վարքը։ Authentication-ը Keycloak տեղափոխելը չի վերացնում OpenMRS authorization model-ը։

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

ՏԱ-ի փակ report register-ը պետք է ունենա report-by-report proof։ Միայն Reporting Module-ի առկայությունը REP-07-ի ընդունման ապացույց չէ։

## 10. Finance

OpenMRS 3 Billing module-ը ընդունվում է որպես գնահատման հիմք, ոչ ամբողջական լուծում։ Առանձին fit-gap/PoC է պահանջվում `FIN-01–15`-ի համար, հատկապես՝ payer split, prepayment, partial payment, refund, debt, cashier shift, immutable reversal և audit պահանջների շուրջ։

| Candidate | Status |
|---|---|
| OpenMRS Billing frontend/backend modules | PoC required |
| Custom Java finance OMOD | Expected, սահմանը՝ fit-gap-ից հետո |
| Moneta/JSR 354 | Proposed |

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

## 13. Decisions required before implementation

1. Reference Application-ից մեկնարկելու exact release-ը։
2. Platform/JVM/MariaDB compatibility matrix-ը։
3. Պարտադիր backend և O3 modules-ի exact versions-ը։
4. Native OpenMRS authentication vs Keycloak/other IdP։
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

