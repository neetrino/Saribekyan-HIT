# Phase I Implementation Gate

Այս ֆայլը պարտադիր pre-code ստուգում է մարդկանց և coding agent-ների համար։ Այն չի ընդլայնում պայմանագիրը և ստորագրված business scope-ը չի փոխում։

**Current authorization state.** Business coding-ը ամբողջ Phase I-ի համար միացված կամ անջատված չէ։ Յուրաքանչյուր task ստուգվում է իր dependency-ներով։ `SIGNATURE-STATUS.yaml`-ի `signed_source` բլոկը business source-ի verification-ն է։ Generated DOCX/PDF-ի `STALE_REGENERATE_REQUIRED` վիճակը և իրավական review-ը development չեն կանգնեցնում։ Մեկ այլ requirement-ի չլուծված semantics-ը նույնպես չի կանգնեցնում։ D-008 compatibility PoC-ը մնում է առանձին coding բացառություն, քանի դեռ business source-ը verified չէ։

## 1. Stop rule

Feature կամ business rule կարելի է իրականացնել միայն եթե **այդ task-ի** համար միաժամանակ առկա են՝

1. business source՝ ստորագրված ՏԱ-ի Phase I բաժիններ 5–16 կամ նույն ստորագրված scope-ի ներսում Պատվիրատուի հաստատված Phase I պարզաբանում,
2. միայն այն technical decision-ները, որոնցից այս task-ը կախված է. `Approved`/`Accepted` որոշումը business scope չի ստեղծում կամ ընդլայնում,
3. [signature manifest](./techHistory/phase-1/SIGNATURE-STATUS.yaml)-ում `signed_source.status: SIGNED_VERIFIED`, `parity_with_canonical: MATCH` և `business_source_authorized: true`,
4. [task go record](./governance/TASK-GO-TEMPLATE.md)-ի լրացված պատճեն՝ անկախ reviewer-ի `GO` որոշմամբ։

Չլուծված decision-ը կանգնեցնում է միայն իրենից կախված task-ը։

```text
SIGNED BUSINESS SPEC
        ↓
Requirement
        ↓
Does this task depend on an unresolved decision?
        ├── YES → block only this task
        └── NO  → Task-Go review → GO → DEVELOPMENT
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
- Canonical `task_class`-ը enum է, ոչ ազատ պիտակ։ D-008 բացառության միակ class-ը բառացի `D008_COMPATIBILITY_POC` է։ Պայմանագրային արտադրական փորձնական թողարկման class-ը `PRODUCTION_PILOT_RELEASE` է և մինչև ստորագրումն ու business gate-ը coding authorization չէ։ Միայն `task_class` դաշտում ազատ `pilot` արժեքն է անվավեր և `NO_GO`։ Այս արգելքը չի վերաբերում spec-ով պարտադրված disposable path/module/package/extension identifiers-ին (`pilot/openmrs-compatibility/`, `saribekyanpilot`, `org.openmrs.module.saribekyanpilot`, `saribekyan-pilot-extension`) կամ display labels-ին։ Երկու class-երը չեն կարող նույն task-ը լինել, և առաջինի artifact/code-ը երկրորդում չի շարունակվում առանց առանձին production go-ի։
- Pilot run-ի ավարտը ինքնուրույն pin կամ repository skeleton ստեղծելու թույլտվություն չէ։ Distribution/OpenMRS release-ը, JVM-ը, DB engine-ը և community/O3 module versions-ը pin չեն արվում, իսկ production/business skeleton-ը չի գեներացվում, մինչև pilot evidence-ը չի վերանայվել, առանձին review/go որոշում չի գրանցվել և ADR-0002-ը չի ընդունվել կամ մերժվել։
- Phase I-ում OpenMRS core repository/codebase-ի fork-ը և **OpenMRS core source code-ի** patch-ը արգելված են։ Այս արգելքը չի վերաբերում D-008 pilot-ի՝ [Compatibility PoC](./pilot/COMPATIBILITY-POC.md)-ով բացահայտ թույլատրված `spa-assemble-config.patch` և `omod-inclusion.patch` distro/assembly configuration patch-երին, որոնք կիրառվում են միայն ignored `pilot/openmrs-compatibility/work/reference-application/` պատճենի վրա և չեն փոփոխում OpenMRS core source code-ը։ Repo root-ի `work/` կամ այլ կարճ path չի ստեղծվում։ Բացակայող core extension point-ի դեպքում կանգ առնել. առանձին ADR-ը կամ review-ը ներկայիս scope-ում բացառություն չէ։ Direct SQL դեպի OpenMRS core կամ այլ module-ի tables նույնպես արգելված է։

## 3. Phase I module map

| Contract group | Owning boundary | Note |
|---|---|---|
| REG | Registration and patient identification | OpenMRS canonical patient/visit foundation |
| AMB | Ambulatory care | Առանձին boundary, ոչ Registration/Inpatient-ի ենթաբաժին |
| INP | Inpatient care | Includes baseline bed/nursing scope միայն ՏԱ-ով |
| DIA | Diagnostics and treatment | LAB/RAD/FDI/END/TRT-ը subdomains/workflows են, ոչ ինքնաբերաբար առանձին deployable modules |
| FIN | Finance and cashier | Clinical status-ից առանձին financial state |
| REP | Reporting | Միայն ՏԱ-ով անվանված outcomes. formula/grain/time/rounding/access-ը մինչև implementation գրավոր հաստատվող blockers են |
| ADM | Administration | Users, privileges, configuration և ADM-10 audit baseline |

Առանձին `audit` business module չի ենթադրվում։ Audit-ը cross-cutting capability է՝ ADM ownership/governance-ով։ Physical code split-ը որոշվում է միայն pilot evidence review/go-ից և համապատասխան artifact-boundary որոշումից հետո։

- REG/AMB/INP/DIA/FIN/REP/ADM-ը ownership boundaries են, ոչ պարտադիր մեկական OMOD կամ repository directory։ ՏԱ-ի «յոթ գործառութային մոդուլ» արտահայտությունը հենց այս յոթ խումբն է և յոթ OMOD, directory կամ database չի պահանջում։ DIA-ի LAB/RAD/FDI/END/TRT ենթահոսքերը ինքնուրույն deployable module չեն դառնում առանց post-pilot գրավոր artifact-boundary որոշման։
- `Required design` կամ fit-gap gap նշումը coding authorization չէ։ Մասնավորապես read-access audit-ը չի կառուցվում մինչև performance/privacy/retention որոշումը։
- AMB/INP medication prescribing/administration-ը չի ներառում pharmacy dispensing, stock deduction, lot կամ inventory management։
- INP baseline nursing scope-ը սահմանափակվում է ստորագրված ՏԱ-ի կոնկրետ դաշտերով/գործողություններով։ «Ընդլայնված nursing module» չստեղծել բաց տերմինների հիման վրա։
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
| Java package prefix | Հաստատված reverse-domain namespace | production Java package ստեղծող task-երը |
| Pilot stack | OpenMRS distribution/release, JVM, DB և exact module versions | production distribution/version pin անող task-երը |
| Payment vs clinical action | Չվճարված վիճակի ազդեցությունը admission/order/discharge գործողությունների վրա | task-եր, որոնք payment state-ից clinical action են թույլատրում կամ արգելում |
| FIN-03 duplicate line | Business uniqueness/idempotency key | FIN-03 duplicate-prevention semantics |
| AMD rounding | Precision, rounding mode և երբ է rounding արվում | task-եր, որոնց գումարային արդյունքը կախված է rounding-ից |
| Workflow states | Առանձին transition tables՝ medical note, order, lab result և financial operation-ի համար | տվյալ workflow-ն իրականացնող task-ը |
| Bed assignment concurrency | Locking/conflict և override policy | concurrent bed assignment և override |
| Attachment storage | Provider, limits, malware scanning, retention | PDF/image binary պահող task-երը |
| Audit retention | Storage, retention, access և review policy | retention, պահման ժամկետ և review policy |

Այս աղյուսակի production package/stack blockers-ը չեն արգելում D-008 pilot-ը և չեն արգելում այն business task-ը, որը production package չի ստեղծում և production stack չի pin անում։ Pilot-ի temporary namespace-ը, exact candidate commit ընտրելու կարգը և minimal layout-ը սահմանված են [Compatibility PoC](./pilot/COMPATIBILITY-POC.md)-ում։ REP-ի formula/grain/time/rounding/access-ը կանգնեցնում է միայն համապատասխան հաշվետվության task-ը։

## 7. Required output before coding

Յուրաքանչյուր task-ը պետք է նշի ՏԱ/clarification ID-ն, owning module-ը, reuse/configure/custom որոշումը, canonical data model-ը և verification-ը։ Permissions, audit, workflow, money, concurrency և storage դաշտերը պարտադիր են միայն երբ task-ը այդ վարքն իրականացնում է։ Կախվածություն չհանդիսացող դաշտը լրացվում է `N/A_NOT_A_DEPENDENCY`։ Այդ արժեքը `NO_GO` չէ։ Եթե task-ի իրական scope/source-ը կամ իրական dependency-ն բացակայում է, այդ task-ը չի սկսվում։

Այս տվյալները գրանցվում են [TASK-GO-TEMPLATE.md](./governance/TASK-GO-TEMPLATE.md)-ի համաձայն։ Coding agent-ը կարող է պատրաստել record-ը, բայց չի կարող հաստատել սեփական `GO`-ն, ստորագրության evidence-ը կամ ADR status transition-ը։

**D-008 compatibility PoC exception.** Թույլատրող աղբյուրը հենց D-008-ն է։ Canonical `task_class`-ը պարտադիր `D008_COMPATIBILITY_POC` է, իսկ ownership classification-ը՝ `TECHNICAL_POC`։ Ազատ `pilot` task class չի օգտագործվում։ Սա business requirement կամ REG–ADM module չէ, ուստի TASK-GO record-ը լրացվում է `TASK-GO-TEMPLATE.md`-ի ամբողջական `N/A_D008` profile-ով։ D-008 pre-code `GO`-ի համար ստորագրված contract և Accepted ADR չեն պահանջվում. source evidence-ը D-008-ն ու compatibility spec-ն են, իսկ PoC-ը հենց ADR-0002-ի հետագա որոշման evidence-ն է։ Pre-code պարտադիր են exact-SHA approval-ը, existing privilege-ի inspection/ընտրությունը կամ spec-ով թույլատրելի pre-code failure-ը, concrete affected paths-ը, planned automated check IDs-ը և ստեղծված run-record path-ը՝ լրացված kickoff fields-ով։ HTTP արդյունքները, build/load արդյունքը, resolved runtime versions-ը, teardown-ը և clean rerun-ը **pre-code GO prerequisites չեն**. kickoff պահին դրանց արժեքը բառացի `PENDING_D008_EXECUTION` է և փոխարինվում է փաստացի evidence-ով post-run completion review-ում։ Այդ արդյունքային դաշտերում `TBD` չի օգտագործվում։ Workspace-ը, backend module ID-ն, Java package-ը, frontend extension-ը և probe URL-ը պարտադիր վերցվում են [compatibility spec](./pilot/COMPATIBILITY-POC.md)-ի Temporary identifiers բաժնից։ Փորձը չպետք է պարունակի patient/clinical/finance business logic կամ production schema և ապացուցում է միայն OMOD build/install/lifecycle/API ու minimal O3 extension wiring-ը։ PoC-ից business code չի շարունակվում, մինչև completion evidence-ը չի վերանայվել և ADR-0002-ը չի ընդունվել կամ մերժվել։

D-008 compatibility PoC-ի միակ կառուցվածքային հրահանգը [compatibility spec](./pilot/COMPATIBILITY-POC.md)-ն է, ոչ `03-STRUCTURE.md`-ի business module skeleton-ը։ Պայմանագրային արտադրական փորձնական թողարկման (`PRODUCTION_PILOT_RELEASE`) համար այս spec-ը source չէ։
