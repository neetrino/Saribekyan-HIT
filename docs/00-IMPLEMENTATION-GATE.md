# Phase I Implementation Gate

Այս ֆայլը readiness և ambiguity guidance է մարդկանց ու coding agent-ների համար։ Այն չի ընդլայնում canonical Phase I scope-ը և repository owner-ի development authorization-ը չի փոխարինում։

**Current authorization state.** Repository owner-ը թույլատրել է Phase I development-ը canonical Markdown baseline-ի հիման վրա։ `SIGNATURE-STATUS.yaml`-ի `signed_source` բլոկը միայն contract/signature readiness metadata է և coding prerequisite չէ։ Generated DOCX/PDF-ի վիճակը, legal review-ը կամ TASK-GO record-ի բացակայությունը development չեն կանգնեցնում։ Յուրաքանչյուր genuine unresolved business dependency կանգնեցնում է միայն իրենից կախված slice-ը։ D-008 compatibility PoC-ը պահպանում է իր սահմանափակ scope-ը, բայց այլևս միակ թույլատրելի coding task-ը չէ։

## 1. Stop rule

Feature կամ business rule կարելի է իրականացնել, երբ այն canonical Phase I scope-ում է և տվյալ slice-ի իրական business dependency-ները լուծված են։ Ստուգվում են՝

1. business source՝ canonical Phase I ՏԱ-ի բաժիններ 5–16 կամ scope-ը բացահայտ փոփոխող հաստատված պարզաբանում,
2. միայն այն technical decision-ները, որոնցից այս task-ը կախված է. `Approved`/`Accepted` որոշումը business scope չի ստեղծում կամ ընդլայնում,
3. [signature manifest](./techHistory/phase-1/SIGNATURE-STATUS.yaml)-ում `repository_development.status: AUTHORIZED_BY_OWNER` և canonical baseline-ի նույնականացումը,
4. տվյալ slice-ի համար չլուծված medical, financial, legal, security կամ irreversible workflow semantics-ի բացակայությունը։ TASK-GO review-ը optional անկախ quality verdict է, ոչ pre-code թույլտվություն։

Չլուծված decision-ը կանգնեցնում է միայն իրենից կախված task-ը։

```text
OWNER-AUTHORIZED CANONICAL BASELINE
        ↓
Requirement
        ↓
Does this task depend on an unresolved decision?
        ├── YES → block only this task
        └── NO  → DEVELOPMENT → reviewer/QA completion checks
```

Phase I-ի որևէ այլ պահանջի բաց semantics-ը business implementation-ի ընդհանուր արգելք չէ։

Այս փաստաթղթերում `Approved` կամ `Accepted` status-ը նշանակում է միայն համապատասխան decision/ADR-ի հաստատված լինելը։ Այն երբեք չի նշանակում task-level `GO`։ Նմանապես historical clarification-ում «փակված է» բառը չի նշանակում client approval կամ blocker closure, եթե manifest-ը և ստորագրված evidence-ը դա չեն հաստատում։

Ստորագրումն ինքնուրույն բավարար չէ, եթե տվյալ task-ի սեփական dependency-ն բաց է։ Այլ requirement-ի blocker-ը այս task-ի բաց dependency չէ։ ՏԱ-ն սահմանում է պահանջվող արդյունքը, իսկ այս task-ի unresolved policy/value-ի դեպքում agent-ը կանգ է առնում միայն այդ task-ի վրա։

Եթե traceability-ն չկա, հակասական է կամ պահանջում է բժշկական/ֆինանսական semantics հորինել, գործակալը **կանգ է առնում և պահանջում է որոշում**։ Vision-ը, `Proposed` ADR-ը, fit-gap-ը, archive-ը և library candidate-ը scope կամ implementation authorization չեն։

Search result-ից կամ direct link-ից բացված ֆայլը կիրառելուց առաջ agent-ը ստուգում է [documentation manifest](./governance/DOCUMENT-MANIFEST.yaml)-ը։ Manifest-ում չգրանցված կամ `NON_AUTHORIZING` ֆայլը business implementation source չէ՝ անկախ իր վերնագրից կամ հրամայական լեզվից։

ՏԱ §20.2-ը թույլ է տալիս ընտրել տեխնիկական իրականացումը միայն արդեն ամբողջությամբ սահմանված օգտագործողական արդյունքի ներսում։ Այն թույլ չի տալիս լրացնել բաց business/clinical/security semantics, թվային շեմ, timeout, password/session policy, merge survivor rule, discount limit, uniqueness key, rounding, transition, retention կամ concurrency policy։ Նման բաց արժեքի դեպքում stop rule-ը գերակայում է, մինչև գրավոր որոշում լինի։

## 2. Mandatory foundation

- Clinical source of truth-ը OpenMRS Patient, Person, Visit, Encounter, Obs, Order և Concept մոդելներն են։ Առանձին Spring/JPA patient/visit/order model չի ստեղծվում։
- Phase I authentication-ը native OpenMRS է։ External IdP, Keycloak և SSO connector չեն իրականացվում առանց գրավոր scope change-ի։
- D-008-ը բացահայտ թույլատրում է **միայն մեկ pilot OMOD + O3 extension compatibility PoC**։ Սա բացառություն է Proposed-ի ընդհանուր արգելքից և չի թույլատրում ոչ մի business module կամ ամբողջ repository skeleton գեներացնել։
- D-008 workspace-ի canonical հասցեն միայն `<REPOSITORY_ROOT>/pilot/openmrs-compatibility/` է (`pilot/openmrs-compatibility/`՝ repository-root-relative)։ `docs/pilot/`-ը documentation-only պանակ է և այնտեղ `openmrs-compatibility/`, source, generated project, checkout, build կամ runtime artifact ստեղծելը արգելված է։ «Կարճ path» այս gate-ում նշանակում է canonical prefix-ից դուրս ցանկացած նման path, օրինակ `<REPOSITORY_ROOT>/work/`, `<REPOSITORY_ROOT>/openmrs-compatibility/` կամ `<REPOSITORY_ROOT>/docs/pilot/openmrs-compatibility/`։
- Canonical `task_class`-ը enum է, ոչ ազատ պիտակ։ D-008 profile-ի class-ը բառացի `D008_COMPATIBILITY_POC` է, իսկ պայմանագրային արտադրական փորձնական թողարկման class-ը՝ `PRODUCTION_PILOT_RELEASE`։ Signature կամ TASK-GO verification-ը դրանց coding prerequisite չէ։ Միայն `task_class` դաշտում ազատ `pilot` արժեքն է անվավեր։ Այս կանոնը չի վերաբերում spec-ով պարտադրված disposable path/module/package/extension identifiers-ին (`pilot/openmrs-compatibility/`, `saribekyanpilot`, `org.openmrs.module.saribekyanpilot`, `saribekyan-pilot-extension`) կամ display labels-ին։ Երկու class-երը նույն task-ը չեն, և disposable PoC artifact-ը production code չի դառնում առանց բացահայտ adoption decision-ի։
- Գործող ընդունված pin-ն է Reference Application 3.7.1 / Platform 2.8.8 / Java 21, իսկ module/O3 versions-ի source of truth-ը committed manifests/build configuration-ն է։ Owner-authorized capability-ի համար անհրաժեշտ production artifact/layout-ը կարող է ստեղծվել առանց D-008 review, ADR transition կամ TASK-GO prerequisite-ի։ Pin-ի փոփոխությունը պահանջում է compatibility verification։
- Phase I-ում OpenMRS core repository/codebase-ի fork-ը և **OpenMRS core source code-ի** patch-ը արգելված են։ Այս արգելքը չի վերաբերում D-008 pilot-ի՝ [Compatibility PoC](./pilot/COMPATIBILITY-POC.md)-ով բացահայտ թույլատրված `spa-assemble-config.patch` և `omod-inclusion.patch` distro/assembly configuration patch-երին, որոնք կիրառվում են միայն ignored `pilot/openmrs-compatibility/work/reference-application/` պատճենի վրա և չեն փոփոխում OpenMRS core source code-ը։ Repo root-ի `work/` կամ այլ կարճ path չի ստեղծվում։ Բացակայող core extension point-ի դեպքում կանգ առնել. առանձին ADR-ը կամ review-ը ներկայիս scope-ում բացառություն չէ։ Direct SQL դեպի OpenMRS core կամ այլ module-ի tables նույնպես արգելված է։

## 3. Phase I module map

| Contract group | Owning boundary | Note |
|---|---|---|
| REG | Registration and patient identification | OpenMRS canonical patient/visit foundation |
| AMB | Ambulatory care | Առանձին boundary, ոչ Registration/Inpatient-ի ենթաբաժին |
| INP | Inpatient care | Includes baseline bed/nursing scope միայն owner-authorized canonical ՏԱ-ով |
| DIA | Diagnostics and treatment | LAB/RAD/FDI/END/TRT-ը subdomains/workflows են, ոչ ինքնաբերաբար առանձին deployable modules |
| FIN | Finance and cashier | Clinical status-ից առանձին financial state |
| REP | Reporting | Միայն ՏԱ-ով անվանված outcomes. formula/grain/time/rounding/access-ը մինչև implementation գրավոր հաստատվող blockers են |
| ADM | Administration | Users, privileges, configuration և ADM-10 audit baseline |

Առանձին `audit` business module չի ենթադրվում։ Audit-ը cross-cutting capability է՝ ADM ownership/governance-ով։ Physical code split-ը ընտրվում է կոնկրետ owner-authorized capability-ի իրական implementation need-ից և գրանցվում as-built structure-ում. pilot review կամ TASK-GO prerequisite չկա։

- REG/AMB/INP/DIA/FIN/REP/ADM-ը ownership boundaries են, ոչ պարտադիր մեկական OMOD կամ repository directory։ ՏԱ-ի «յոթ գործառութային մոդուլ» արտահայտությունը հենց այս յոթ խումբն է և յոթ OMOD, directory կամ database չի պահանջում։ DIA-ի LAB/RAD/FDI/END/TRT ենթահոսքերը ինքնուրույն deployable module չեն դառնում առանց post-pilot գրավոր artifact-boundary որոշման։
- `Required design` կամ fit-gap gap նշումը coding authorization չէ։ Մասնավորապես read-access audit-ը չի կառուցվում մինչև performance/privacy/retention որոշումը։
- AMB/INP medication prescribing/administration-ը չի ներառում pharmacy dispensing, stock deduction, lot կամ inventory management։
- INP baseline nursing scope-ը սահմանափակվում է owner-authorized canonical ՏԱ-ի կոնկրետ դաշտերով/գործողություններով։ «Ընդլայնված nursing module» չստեղծել բաց տերմինների հիման վրա։
- AMB/INP financial/payment status field-ը կարող է լինել պահանջվող ցուցադրվող տվյալ, բայց դրանից clinical allow/deny վարք չի բխում մինչև առանձին գրավոր policy-ն։

## 4. Explicit prohibitions

- Patient/encounter/obs/order parallel custom tables չստեղծել։
- PDF/image binary-ը DB BLOB-ում կամ local disk-ում չպահել, մինչև storage ADR չկա։
- OpenMRS REST-ը ամբողջությամբ `/api/v1` facade-ով չփաթաթել։ Custom envelope/cursor conventions-ը միայն custom facade-ինն են. native OpenMRS endpoints-ը պահպանում են իրենց contract-ը։
- Մեկ ընդհանուր `Status` enum չստեղծել clinical note, order, lab result, payment կամ admission workflow-ների համար։ Requirement-ում թվարկված lifecycle բառերից enum չկազմել, և OpenMRS-ի ներկառուցված order/visit/queue/status արժեքները չմիացնել որպես պայմանագրային workflow (`NO_PLATFORM_DEFAULT_WORKFLOW`)։ Platform default-ը transition table չէ. reuse-ը թույլատրվում է միայն գրավոր table-ից և դրա հետ համընկնման fit որոշումից հետո։
- Unpaid վիճակը clinical action-ի gate չդարձնել և հակառակ business policy չհորինել, մինչև գրավոր կանոն չկա (`NO_FINANCIAL_STATUS_INFERENCE`)։ Այս կանգառը վերաբերում է միայն այն task-ին, որը payment state-ից clinical action է թույլատրում կամ արգելում։
- Pharmacy/inventory, drug lots/stock deduction, operating-room schedule/resources/team planning չավելացնել։
- ICD catalog-ը WHO API-ից ինքնուրույն չլցնել. version/content-ը տրամադրում կամ հաստատում է Պատվիրատուն։
- Critical lab result-ի համար SMS/email/phone integration չավելացնել. Phase I-ը պահում է նշումը և clinician notification fact-ը։
- Internal approval-ը cryptographic/qualified signature կամ «signed PDF» չհամարել։
- JasperReports, Apache POI, openhtmltopdf, JaVers, Moneta, WHO ICD API կամ այլ candidate dependency չավելացնել մինչև գրավոր տեխնիկական որոշումը։

## 5. Audit minimum

Phase I-ի պարտադիր նվազագույնը ADM-10-ն է՝ action, user, timestamp, object և, երբ հասանելի է, old/new value։ Դրան ավելանում են export և break-glass audit-ը՝ արդեն հաստատված security boundary-ի համաձայն։ **Յուրաքանչյուր patient record view-ի audit-ը Phase I-ի default պարտավորություն չէ** և չի իրականացվում մինչև performance, privacy և retention որոշումը։

## 6. Blocking decisions for the tasks that depend on them

Հետևյալները deliberately unresolved են և չեն լրացվում agent-ի ենթադրությամբ. Յուրաքանչյուր տող կանգնեցնում է միայն «Blocks only» սյունակում նշված task-երը։

Այս աղյուսակը **ոչ սպառիչ է**։ ՏԱ-ում կամ Approved որոշման մեջ չսահմանված business, clinical, financial, security, privacy, retention կամ concurrency արժեքը blocker է այն task-ի համար, որի արդյունքը կախված է այդ արժեքից։ Այն ամբողջ Phase I-ը չի կանգնեցնում։

| Blocker | Required owner decision | Blocks only |
|---|---|---|
| Production database | Engine/version/topology և operations ownership | Միայն production database ընտրող կամ deploy անող infrastructure task-երը. development-ի MySQL-compatible configuration-ը բաց չէ |
| Payment vs clinical action | Չվճարված վիճակի ազդեցությունը admission/order/discharge գործողությունների վրա | task-եր, որոնք payment state-ից clinical action են թույլատրում կամ արգելում |
| FIN-03 duplicate line | Business uniqueness/idempotency key | FIN-03 duplicate-prevention semantics |
| AMD rounding | Precision, rounding mode և երբ է rounding արվում | task-եր, որոնց գումարային արդյունքը կախված է rounding-ից |
| Workflow states | Առանձին transition tables՝ medical note, order, lab result և financial operation-ի համար | տվյալ workflow-ն իրականացնող task-ը |
| Bed assignment concurrency | Locking/conflict և override policy | concurrent bed assignment և override |
| Attachment storage | Provider, limits, malware scanning, retention | PDF/image binary պահող task-երը |
| Audit retention | Storage, retention, access և review policy | retention, պահման ժամկետ և review policy |

Java namespace-ը `org.openmrs.module.saribekyan` է, իսկ գործող runtime pin-ը՝ Reference Application 3.7.1 / Platform 2.8.8 / Java 21։ Դրանք բաց blocker չեն։ Production database-ի բաց որոշումը կանգնեցնում է միայն production database infrastructure slice-ը, ոչ business development-ը կամ committed development stack-ը։ D-008 pilot-ի սահմանները մնում են [Compatibility PoC](./pilot/COMPATIBILITY-POC.md)-ում։ REP-ի formula/grain/time/rounding/access-ը կանգնեցնում է միայն համապատասխան հաշվետվության task-ը։

## 7. Required output before coding

Յուրաքանչյուր task-ը պետք է նշի ՏԱ/clarification ID-ն, owning module-ը, reuse/configure/custom որոշումը, canonical data model-ը և verification-ը։ Permissions, audit, workflow, money, concurrency և storage դաշտերը պարտադիր են միայն երբ task-ը այդ վարքն իրականացնում է։ Կախվածություն չհանդիսացող դաշտը լրացվում է `N/A_NOT_A_DEPENDENCY`։ Այդ արժեքը `NO_GO` չէ։ Եթե task-ի իրական scope/source-ը կամ իրական dependency-ն բացակայում է, այդ task-ը չի սկսվում։

Այս տվյալները կարելի է գրանցել [TASK-GO-TEMPLATE.md](./governance/TASK-GO-TEMPLATE.md)-ով, երբ անկախ task review է պահանջվել։ Record-ի բացակայությունը coding blocker չէ։ Coding agent-ը չի կարող հաստատել սեփական `GO`-ն, ստորագրության evidence-ը կամ ADR status transition-ը։

**D-008 compatibility PoC profile.** D-008-ի technical scope-ի աղբյուրը D-008-ն ու [compatibility spec](./pilot/COMPATIBILITY-POC.md)-ն են։ Canonical `task_class`-ը `D008_COMPATIBILITY_POC` է, ownership-ը՝ `TECHNICAL_POC`, իսկ ազատ `pilot` class-ը անվավեր է։ TASK-GO review-ը optional է, սակայն PoC run record-ը, exact-SHA-ն, planned checks-ը և spec-ի disposable identifiers-ը պարտադիր execution evidence են։ Runtime արդյունքները kickoff-ին կարող են լինել `PENDING_D008_EXECUTION` և completion-ին փոխարինվում են փաստացի evidence-ով։ Փորձը չի պարունակում patient/clinical/finance business logic կամ production schema և ապացուցում է միայն OMOD build/install/lifecycle/API ու minimal O3 extension wiring-ը։ PoC artifact-ը business implementation չի դառնում առանց առանձին տեխնիկական adoption decision-ի, սակայն դա unrelated owner-authorized Phase I development-ը չի կանգնեցնում։

D-008 compatibility PoC-ի միակ կառուցվածքային հրահանգը [compatibility spec](./pilot/COMPATIBILITY-POC.md)-ն է, ոչ `03-STRUCTURE.md`-ի business module skeleton-ը։ Պայմանագրային արտադրական փորձնական թողարկման (`PRODUCTION_PILOT_RELEASE`) համար այս spec-ը source չէ։
