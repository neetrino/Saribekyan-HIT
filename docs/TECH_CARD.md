# Technical Decision Card: Saribekyan HIS

## Status legend

Այս legend-ը համադրվում է `governance/README.md`-ի canonical lifecycle-ին։ Ազատ status բառը coding authorization չէ։ `Approved`/`Accepted` row-ը պարտադիր պետք է ունենա decision ID, approver/date/evidence. այդ metadata-ի բացակայության դեպքում agent-ը այն կիրառում է միայն guardrail/context-ի համար և business code չի սկսում։

`SIGNATURE_IS_LEGAL_METADATA_NOT_CODING_GATE`: owner-authorized canonical Markdown-ը development baseline-ն է։

### Legacy row status → agent action

| TECH_CARD status | Canonical interpretation | Agent action |
|---|---|---|
| Approved | `APPROVED_CONSTRAINT` | Սահմանը կամ ուղղությունը պահել. նոր business scope չստեղծել |
| APPROVED_CONSTRAINT / GOVERNING_CANONICAL_MODEL_NO_SKELETON | նույն canonical literal-ը | Constraint/ownership guardrail է. ինքնուրույն dependency, Maven/OMOD tree կամ skeleton չի սահմանում |
| GOVERNING_GUARDRAIL | canonical literal | Պարտադիր արգելք/սահման է authorized implementation-ի ընթացքում |
| PROPOSED_DESIGN | canonical literal | Candidate է. չի ստեղծում նոր scope և կանգնեցնում է միայն այն behavior-ը, որի համար ընտրությունը իսկապես անհրաժեշտ է |
| BLOCKED | canonical literal | Կանգնեցնել միայն այս decision-ից կախված task-ը և պահանջել փակող evidence |
| D008_POC_ONLY | canonical literal | Միայն `D008_COMPATIBILITY_POC` profile, ոչ business code |
| Accepted | `ACCEPTED_DECISION` | Կիրառելի տեխնիկական որոշում է իր evidence-ի սահմաններում, ոչ նոր business scope |
| ACCEPTED_AS_BUILT | canonical literal | Repository/runtime evidence-ով գործող և ընդունված տեխնիկական ընտրություն է |
| ACCEPTED_AS_BUILT_PARTIAL | canonical literal | Նշված capability-ն իրական է և պահպանվում է, բայց requirement-ի մնացած acceptance/evidence-ը շարունակում է բաց մնալ |
| Draft contract baseline | `OWNER_AUTHORIZED_BASELINE` | Owner-authorized business baseline է. signature status-ը իրավական metadata է |
| Approved baseline | `GOVERNING_GUARDRAIL` | Ownership map է. module tree կամ code չսկսել |
| D-008 PoC profile | `D008_POC_ONLY` | Միայն disposable compatibility PoC-ի scope-ն է սահմանում. business development-ի global gate չէ |
| Approved Phase I boundary / Approved scope / Approved constraint | `GOVERNING_GUARDRAIL` | Պահպանել արգելքը/սահմանը, բայց code չսկսել |
| Approved direction / Approved principle / Approved / partially open | `APPROVED_CONSTRAINT` | Design constraint է canonical requirement-ի համար. բաց մասը blocker է միայն իրենից կախված task-ի համար |
| Contract baseline / Conditional contract requirement | `OWNER_AUTHORIZED_BASELINE` | Development baseline է. signature verification-ը իրավական metadata է |
| Proposed / Proposed baseline / Required design / Custom design required | `PROPOSED_DESIGN` | Չհորինել candidate-ից նոր scope. կոնկրետ capability-ի համար ընտրել ամենապարզ maintainable լուծումը և գրանցել evidence-ը |
| PoC required / Proposed + PoC required | `PROPOSED_DESIGN` | Validation-ը պահանջվում է dependent adoption/release claim-ի համար, ոչ unrelated development-ը սկսելու համար |
| Proposed / blocked | `BLOCKED` | Կանգնեցնել միայն կախված task-ը |
| Change request required / Out of Phase I | `OUT_OF_SCOPE` | Չիրականացնել առանց repository owner-ի բացահայտ scope change-ի. contract signature-ը coding prerequisite չէ |
| Deferred / Open / TBD | `BLOCKED` | Կանգնեցնել միայն այն task-ը, որի արդյունքը կախված է այս արժեքից |

Վերևի mapping-ում չգտնված ցանկացած status, այդ թվում `Approved direction / open detail` տիպի չթվարկված համակցությունը, `BLOCKED` է։ `Approved` և `Accepted` արդեն mapping-ում են և business code չեն թույլատրում։

| Status | Meaning |
|---|---|
| Draft contract baseline | Owner-authorized canonical Markdown development baseline. ստորագրության վիճակը միայն իրավական readiness metadata է |
| Approved | Ուղղություն կամ սահման իր նկարագրության մեջ. չի ստեղծում նոր business scope |
| Accepted | Հաստատված տեխնիկական ուղղություն է իր evidence-ի սահմաններում. TASK-GO prerequisite չէ |
| ACCEPTED_AS_BUILT | Repository/runtime evidence-ով հաստատված գործող տեխնիկական ընտրություն |
| ACCEPTED_AS_BUILT_PARTIAL | Գործող capability-ի ընդունված մասնակի վիճակ. չի նշանակում ամբողջ requirement-ի completion |
| Approved Phase I boundary / Approved scope / Approved constraint | Փուլ I-ի պարտադիր սահման կամ արգելք, ոչ ամբողջ տեխնոլոգիական ռազմավարության ընդունում |
| Approved direction | Հաստատված ուղղություն, որի exact product/version/layout-ը կարող է դեռ բաց լինել |
| Proposed | Ուժեղ թեկնածու, որը պահանջում է տեխնիկական հաստատում |
| Proposed baseline | Նախնական design assumption, ոչ implementation authorization |
| PoC required | Որոշումից առաջ անհրաժեշտ է փորձնական իրականացում |
| Custom design required / Required design | Պահանջի համար design-ը անհրաժեշտ է, բայց դեռ ընդունված կամ կառուցելու թույլատրված չէ |
| Contract baseline / Conditional contract requirement | Owner-authorized canonical baseline-ից եկող պայման. signature կամ implementation gate coding prerequisite չեն |
| Deferred | Այս documentation փուլում չի որոշվում |
| Out of Phase I | Փուլ I-ի պայմանագրային ծավալից դուրս է |

Այլ փաստաթղթերի «ավարտված», «created», «expected» կամ «target only» բառերը նկարագրում են documentation artifact-ի վիճակը և նոր scope չեն ստեղծում։ Coding authorization-ը տրված է repository-level `AGENTS.md`-ով, իսկ [implementation gate](./00-IMPLEMENTATION-GATE.md)-ը readiness/ambiguity guidance է։

## 1. Foundation

| Decision | Value | Status | Notes |
|---|---|---|---|
| Project size | Size C | APPROVED_CONSTRAINT | Դասակարգում է governance/quality կարիքները. module tree չի սահմանում |
| Clinical platform | OpenMRS | GOVERNING_CANONICAL_MODEL_NO_SKELETON | Պացիենտ, visit, encounter, obs, order և clinical terminology ownership guardrail է. distribution/OMOD tree չի թույլատրում |
| Backend language | Java | APPROVED_CONSTRAINT | Թույլատրված custom backend-ի լեզվի constraint է. ինքնուրույն module count չի սահմանում |
| Delivery scope | Phase I technical specification v1.3 | OWNER_AUTHORIZED_BASELINE | Signature verification-ը և TASK-GO-ն coding prerequisites չեն. բաց business semantics-ը կանգնեցնում է միայն կախված slice-ը |
| Architecture approach | OpenMRS Reference Application distribution + supported modules | ACCEPTED_AS_BUILT | Գործող repository/runtime կառուցվածքն է՝ առանց OpenMRS core fork-ի |

## 2. OpenMRS distribution

| Decision | Value | Status | Acceptance condition |
|---|---|---|---|
| Starting distribution | OpenMRS Reference Application 3.7.1 | ACCEPTED_AS_BUILT | `openmrs-distro-referenceapplication/pom.xml` և Docker Compose image tags |
| OpenMRS Platform version | 2.8.8 | ACCEPTED_AS_BUILT | `openmrs-distro-referenceapplication/distro/pom.xml`-ի `openmrs.version` |
| Backend modules | Distribution manifest-ում pinned versions | ACCEPTED_AS_BUILT | Source of truth՝ distro POM/build output; փոփոխությունը պահանջում է compatibility verification |
| Frontend modules | Reference Application 3.7.1 build/configuration-ում pinned versions | ACCEPTED_AS_BUILT | Source of truth՝ frontend build/config և distribution image |
| Metadata/configuration | Version-controlled distribution content | ACCEPTED_AS_BUILT | Concepts, forms, locations, roles և configuration-ը պահվում են reproducible distribution content-ում |
| Core modification | Phase I-ում OpenMRS core fork/patch արգելված է | Approved Phase I boundary | ADR կամ review-ը ներկայիս scope-ում բացառություն չէ։ D-008-ի `spa-assemble-config.patch` և `omod-inclusion.patch` միայն ignored `pilot/openmrs-compatibility/work/reference-application/` distro copy-ի configuration/assembly patch-եր են, ոչ core source patch, և թույլատրված են միայն PoC spec-ի սահմաններով |

## 3. Backend

| Area | Decision | Status |
|---|---|---|
| Runtime | OpenMRS Java backend/module runtime | GOVERNING_CANONICAL_MODEL_NO_SKELETON |
| Custom server capabilities | Java OMOD modules | ACCEPTED_AS_BUILT |
| Business boundaries | REG registration, AMB ambulatory, INP inpatient, DIA diagnostics/treatment, FIN finance, REP reporting, ADM administration | GOVERNING_GUARDRAIL — ownership only; no OMOD/package/directory count |
| Database access | OpenMRS service/API layer, custom module DAOs միայն module-owned data-ի համար | Proposed |
| Schema migrations | OpenMRS/Liquibase module migrations | Proposed |
| Background work | Exact mechanism TBD | Deferred |
| Dependency/build tool | Maven OpenMRS module/distribution build | ACCEPTED_AS_BUILT |
| JVM version | Java 21 | ACCEPTED_AS_BUILT |

Գործող ընդունված stack baseline-ն է Reference Application 3.7.1 + Platform 2.8.8 + Java 21։ Evidence-ը repository-ի distro POM-երը, Docker image configuration-ը և module compiler release-ն են։ Այս pin-ի փոփոխությունը սովորական feature implementation չէ և պահանջում է առանձին compatibility review։

## 4. Frontend

| Area | Decision | Status |
|---|---|---|
| Shell | OpenMRS O3 app shell | ACCEPTED_AS_BUILT |
| Reused UI | O3 patient management/chart և O3 patient-search app; այլ modules՝ ըստ feature fit-ի | ACCEPTED_AS_BUILT_PARTIAL — patient-search configuration committed; մնացած feature fit-ը requirement-scoped է |
| Custom UI | O3 frontend modules, extensions, pages և workspaces | Proposed |
| Framework | O3-ի կողմից աջակցվող React ecosystem | Proposed |
| Localization | Հայերեն պարտադիր, լրացուցիչ լեզուները՝ առանձին որոշմամբ | Approved / partially open |
| Design system | O3 shared framework/components-ի reuse | Proposed |

Custom frontend-ը չի ստեղծում երկրորդ անկախ SPA, եթե պահանջը հնարավոր է անվտանգ իրականացնել O3 route/extension/workspace model-ով։

## 5. Clinical data and forms

| Area | Decision | Status |
|---|---|---|
| Patient/visit/encounter/obs/order | OpenMRS canonical models | GOVERNING_CANONICAL_MODEL_NO_SKELETON |
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
| DB engine candidate | Production engine/version decision TBD; current development distro uses its configured MySQL-compatible database | BLOCKED_FOR_DEPENDENT_INFRASTRUCTURE_ONLY |
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
| Report/PDF renderer | NONE SELECTED; options moved to `technology-options/TECHNOLOGY-CANDIDATES.md` | Deferred |
| Spreadsheet library | NONE SELECTED; options moved to `technology-options/TECHNOLOGY-CANDIDATES.md` | Deferred |

Այս թեկնածուներից ոչ մեկը dependency ավելացնելու թույլտվություն չէ։ Ընտրությունը պահանջում է PoC/գրավոր տեխնիկական որոշում։

ՏԱ-ի փակ report register-ը պետք է ունենա report-by-report proof։ Միայն Reporting Module-ի առկայությունը REP-07-ի ընդունման ապացույց չէ։

## 10. Finance

OpenMRS 3 Billing module-ը ընդունվում է որպես գնահատման հիմք, ոչ ամբողջական լուծում։ Առանձին fit-gap/PoC է պահանջվում `FIN-01–15`-ի համար, հատկապես՝ payer split, prepayment, partial payment, refund, debt, cashier shift, immutable reversal և audit պահանջների շուրջ։

| Candidate | Status |
|---|---|
| OpenMRS Billing frontend/backend modules | PoC required |
| Finance backend artifact | BLOCKED — OMOD/service/package չի ընտրվում, մինչև accepted FIN fit և artifact-boundary որոշումը չապացուցեն անհրաժեշտությունը |
| Money library | NONE SELECTED; options moved to `technology-options/TECHNOLOGY-CANDIDATES.md` | Deferred |

AMD-ի precision և rounding rule-ը business blocker է. Moneta-ի առկայությունը այդ կանոնը չի որոշում։

## 11. Audit, security and privacy

| Area | Decision | Status |
|---|---|---|
| Clinical change history | OpenMRS platform audit/version capabilities + gap analysis | PoC required |
| Custom entity audit | Custom immutable audit design | Required design |
| Audit/diff library | NONE SELECTED; options moved to `technology-options/TECHNOLOGY-CANDIDATES.md` | Deferred |
| Read/access audit | Phase I default չէ; պահանջում է առանձին Approved requirement, privacy/performance/retention design | Proposed / blocked |
| Encryption in transit | TLS production-ում | Contract baseline |
| Secrets | Environment/secret manager, ոչ repository | Approved principle |
| Patient safety | Clinical validation և fail-safe behavior | Approved principle |

Audit Log Web/Envers capability-ն ինքնուրույն չի ապացուցում medical audit ամբողջ պահանջը, հատկապես read access, break-glass և external export դեպքերի համար։

## 12. Delivery and quality

Այս աղյուսակը production delivery-ի acceptance checklist է։ TASK-GO-ն կամ signature verification-ը դրա prerequisite չեն։ Այն չի ստեղծում նոր business scope, իսկ չլուծված կետը կանգնեցնում է միայն իրենից կախված delivery outcome-ը։

| Area | Required production outcome | Current authority/status |
|---|---|---|
| Version pinning | Reference Application 3.7.1, Platform 2.8.8, Java 21; OMOD/O3 versions from manifests | ACCEPTED_AS_BUILT; փոփոխությունը պահանջում է compatibility review |
| CI | Build, unit, integration, security/dependency և distribution smoke tests՝ changed artifacts-ի համար | APPROVED_CONSTRAINT |
| Clinical workflows | Automated integration + role-based UAT՝ implemented requirement-ի համար | APPROVED_CONSTRAINT |
| Upgrade safety | Clean distribution rebuild և migration rehearsal՝ stack/migration change-ի համար | APPROVED_CONSTRAINT |
| Traceability | ՏԱ ID → design → code → test → UAT evidence | GOVERNING_GUARDRAIL; code authorization չէ |
| Documentation | Architecture, DB, API, deployment, operations և user guides՝ behavior change-ի հետ համաժամեցված | APPROVED_CONSTRAINT; դատարկ skeleton չի պահանջում |

## 13. Remaining stack and feature decisions

Գործող distribution/platform/JVM pin-ն արդեն ընդունված as-built հիմք է։ Ստորև նշված բաց կետերը global development gate չեն. յուրաքանչյուրը լուծվում է այն feature-ի կամ փոփոխության ժամանակ, որն իրականում դրանից կախված է։ D-008-ի պատմական սահմանները նկարագրված են [COMPATIBILITY-POC.md](./pilot/COMPATIBILITY-POC.md)-ում։

1. **Resolved:** Reference Application 3.7.1։
2. **Resolved for Platform/JVM:** Platform 2.8.8 և Java 21։ DB engine/version-ի production compatibility-ն մնում է առանձին infrastructure decision։
3. **Resolved for current build:** backend և O3 module versions-ը վերցվում են committed distribution manifests/build configuration-ից։ Նրանց փոփոխությունը պահանջում է compatibility verification։
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
