# Phase I Implementation Gate

Այս ֆայլը պարտադիր pre-code ստուգում է մարդկանց և coding agent-ների համար։ Այն չի ընդլայնում պայմանագիրը։

**Current authorization state.** `contract/phase-1/Phase_1_Technical_Specification_HY.md` v1.3-ի կարգավիճակը «ստորագրման համար» է։ Քանի դեռ ստորագրված տարբերակը կամ ստորագրման հստակ ապացույցը repository-ում գրանցված չէ, ստորև նշված business requirements-ը design/traceability baseline են, ոչ business coding authorization։ Այս պահին միակ coding բացառությունը D-008 compatibility PoC-ն է։

## 1. Stop rule

Feature կամ business rule կարելի է իրականացնել միայն եթե միաժամանակ առկա են՝

1. business source՝ ստորագրված ՏԱ-ի Phase I բաժիններ 5–16 կամ նույն ստորագրված scope-ի ներսում Պատվիրատուի հաստատված Phase I պարզաբանում,
2. անհրաժեշտության դեպքում այդ պահանջի իրականացման `Approved`/`Accepted` տեխնիկական որոշում, որը business scope չի ստեղծում կամ ընդլայնում,
3. [signature manifest](./contract/phase-1/SIGNATURE-STATUS.yaml)-ում `SIGNED_VERIFIED` վիճակ և ստորագրված artifact-ի hash,
4. [task go record](./governance/TASK-GO-TEMPLATE.md)-ի լրացված պատճեն՝ անկախ reviewer-ի `GO` որոշմամբ։

Ստորագրումն ինքնուրույն բավարար չէ, եթե տվյալ task-ի համար այս gate-ում նշված կամ այլ բացահայտ չսահմանված blocker-ը բաց է։ ՏԱ-ն սահմանում է պահանջվող արդյունքը, իսկ unresolved policy/value-ի դեպքում agent-ը կանգ է առնում։

Եթե traceability-ն չկա, հակասական է կամ պահանջում է բժշկական/ֆինանսական semantics հորինել, գործակալը **կանգ է առնում և պահանջում է որոշում**։ Vision-ը, `Proposed` ADR-ը, fit-gap-ը, archive-ը և library candidate-ը scope կամ implementation authorization չեն։

Search result-ից կամ direct link-ից բացված ֆայլը կիրառելուց առաջ agent-ը ստուգում է [documentation manifest](./governance/DOCUMENT-MANIFEST.yaml)-ը։ Manifest-ում չգրանցված կամ `NON_AUTHORIZING` ֆայլը business implementation source չէ՝ անկախ իր վերնագրից կամ հրամայական լեզվից։

ՏԱ §20.2-ը թույլ է տալիս ընտրել տեխնիկական իրականացումը միայն արդեն ամբողջությամբ սահմանված օգտագործողական արդյունքի ներսում։ Այն թույլ չի տալիս լրացնել բաց business/clinical/security semantics, թվային շեմ, timeout, password/session policy, merge survivor rule, discount limit, uniqueness key, rounding, transition, retention կամ concurrency policy։ Նման բաց արժեքի դեպքում stop rule-ը գերակայում է, մինչև գրավոր որոշում լինի։

## 2. Mandatory foundation

- Clinical source of truth-ը OpenMRS Patient, Person, Visit, Encounter, Obs, Order և Concept մոդելներն են։ Առանձին Spring/JPA patient/visit/order model չի ստեղծվում։
- Phase I authentication-ը native OpenMRS է։ External IdP, Keycloak և SSO connector չեն իրականացվում առանց գրավոր scope change-ի։
- D-008-ը բացահայտ թույլատրում է **միայն մեկ pilot OMOD + O3 extension compatibility PoC**։ Սա բացառություն է Proposed-ի ընդհանուր արգելքից և չի թույլատրում ոչ մի business module կամ ամբողջ repository skeleton գեներացնել։
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
| REP | Reporting | Միայն փակ report register և ողջամիտ ճշգրտումներ |
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
- Մեկ ընդհանուր `Status` enum չստեղծել clinical note, order, lab result, payment կամ admission workflow-ների համար։
- Unpaid վիճակը clinical action-ի gate չդարձնել և հակառակ business policy չհորինել, մինչև գրավոր կանոն չկա։
- Pharmacy/inventory, drug lots/stock deduction, operating-room schedule/resources/team planning չավելացնել։
- ICD catalog-ը WHO API-ից ինքնուրույն չլցնել. version/content-ը տրամադրում կամ հաստատում է Պատվիրատուն։
- Critical lab result-ի համար SMS/email/phone integration չավելացնել. Phase I-ը պահում է նշումը և clinician notification fact-ը։
- Internal approval-ը cryptographic/qualified signature կամ «signed PDF» չհամարել։
- JasperReports, Apache POI, openhtmltopdf, JaVers, Moneta, WHO ICD API կամ այլ candidate dependency չավելացնել մինչև գրավոր տեխնիկական որոշումը։

## 5. Audit minimum

Phase I-ի պարտադիր նվազագույնը ADM-10-ն է՝ action, user, timestamp, object և, երբ հասանելի է, old/new value։ Դրան ավելանում են export և break-glass audit-ը՝ արդեն հաստատված security boundary-ի համաձայն։ **Յուրաքանչյուր patient record view-ի audit-ը Phase I-ի default պարտավորություն չէ** և չի իրականացվում մինչև performance, privacy և retention որոշումը։

## 6. Blocking decisions before business implementation

Հետևյալները deliberately unresolved են և չեն լրացվում agent-ի ենթադրությամբ.

Այս աղյուսակը **ոչ սպառիչ է**։ ՏԱ-ում կամ Approved որոշման մեջ չսահմանված ցանկացած business, clinical, financial, security, privacy, retention կամ concurrency արժեք նույնպես blocker է, նույնիսկ եթե ստորև առանձին տողով նշված չէ։

| Blocker | Required owner decision |
|---|---|
| Java package prefix | Հաստատված reverse-domain namespace |
| Pilot stack | OpenMRS distribution/release, JVM, DB և exact module versions |
| Payment vs clinical action | Չվճարված վիճակի ազդեցությունը admission/order/discharge գործողությունների վրա |
| FIN-03 duplicate line | Business uniqueness/idempotency key |
| AMD rounding | Precision, rounding mode և երբ է rounding արվում |
| Workflow states | Առանձին transition tables՝ medical note, order, lab result և financial operation-ի համար |
| Bed assignment concurrency | Locking/conflict և override policy |
| Attachment storage | Provider, limits, malware scanning, retention |
| Audit retention | Storage, retention, access և review policy |

Այս աղյուսակի production package/stack blockers-ը չեն արգելում D-008 pilot-ը։ Pilot-ի temporary namespace-ը, exact candidate commit ընտրելու կարգը և minimal layout-ը սահմանված են [Compatibility PoC](./pilot/COMPATIBILITY-POC.md)-ում։

## 7. Required output before coding

Յուրաքանչյուր task-ը պետք է նշի ՏԱ/clarification ID-ն, owning module-ը, reuse/configure/custom որոշումը, canonical data model-ը, permissions/audit-ը և verification-ը։ Եթե այս դաշտերից scope/source-ը բացակայում է, implementation-ը չի սկսվում։

Այս տվյալները գրանցվում են [TASK-GO-TEMPLATE.md](./governance/TASK-GO-TEMPLATE.md)-ի համաձայն։ Coding agent-ը կարող է պատրաստել record-ը, բայց չի կարող հաստատել սեփական `GO`-ն, ստորագրության evidence-ը կամ ADR status transition-ը։

**D-008 pilot exception.** Compatibility pilot-ի թույլատրող աղբյուրը հենց D-008-ն է։ Pilot-ը business requirement կամ REG–ADM module չէ, ուստի դրա համար ՏԱ requirement ID և business owning module չեն պահանջվում։ Task/ownership classification-ը պետք է լինի հստակ `pilot`. սա artifact-ի անուն չէ։ Workspace-ը, backend module ID-ն, Java package-ը, frontend extension-ը և probe URL-ը պարտադիր վերցվում են [pilot compatibility spec](./pilot/COMPATIBILITY-POC.md)-ի Temporary identifiers բաժնից և չեն վերանվանվում `pilot`։ Փորձը չպետք է պարունակի patient/clinical/finance business logic կամ production schema և ապացուցում է միայն OMOD build/install/lifecycle/API ու minimal O3 extension wiring-ը։ Pilot-ից business code չի շարունակվում, մինչև արդյունքը չի վերանայվել և ADR-0002-ը չի ընդունվել կամ մերժվել։

Pilot-ի միակ կառուցվածքային հրահանգը [pilot compatibility spec](./pilot/COMPATIBILITY-POC.md)-ն է, ոչ `03-STRUCTURE.md`-ի business module skeleton-ը։
