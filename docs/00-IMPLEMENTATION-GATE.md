# Phase I Implementation Gate

Այս ֆայլը պարտադիր pre-code ստուգում է մարդկանց և coding agent-ների համար։ Այն չի ընդլայնում պայմանագիրը։

## 1. Stop rule

Feature կամ business rule կարելի է իրականացնել միայն եթե այն traceable է՝

1. ստորագրված ՏԱ-ի Phase I բաժիններ 5–16-ին, կամ
2. Պատվիրատուի հաստատված Phase I պարզաբանմանը, որը ներառված է ստորագրվող baseline-ում, կամ
3. այդ պահանջը իրականացնող `Approved`/`Accepted` տեխնիկական որոշմանը։

Եթե traceability-ն չկա, հակասական է կամ պահանջում է բժշկական/ֆինանսական semantics հորինել, գործակալը **կանգ է առնում և պահանջում է որոշում**։ Vision-ը, `Proposed` ADR-ը, fit-gap-ը, archive-ը և library candidate-ը scope կամ implementation authorization չեն։

## 2. Mandatory foundation

- Clinical source of truth-ը OpenMRS Patient, Person, Visit, Encounter, Obs, Order և Concept մոդելներն են։ Առանձին Spring/JPA patient/visit/order model չի ստեղծվում։
- Phase I authentication-ը native OpenMRS է։ External IdP, Keycloak և SSO connector չեն իրականացվում առանց գրավոր scope change-ի։
- D-008-ը բացահայտ թույլատրում է **միայն մեկ pilot OMOD + O3 extension compatibility PoC**։ Սա բացառություն է Proposed-ի ընդհանուր արգելքից և չի թույլատրում ոչ մի business module կամ ամբողջ repository skeleton գեներացնել։
- Մինչ pilot-ի արդյունքը չեն pin արվում distribution/OpenMRS release-ը, JVM-ը, DB engine-ը և community/O3 module versions-ը, և ամբողջ repository skeleton-ը չի գեներացվում։
- OpenMRS core fork և direct SQL դեպի OpenMRS core կամ այլ module-ի tables արգելված են։

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

Առանձին `audit` business module չի ենթադրվում։ Audit-ը cross-cutting capability է՝ ADM ownership/governance-ով։ Physical code split-ը որոշվում է pilot-ից հետո։

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

**D-008 pilot exception.** Compatibility pilot-ի թույլատրող աղբյուրը հենց D-008-ն է։ Pilot-ը business requirement կամ REG–ADM module չէ, ուստի դրա համար ՏԱ requirement ID և business owning module չեն պահանջվում։ Այն պետք է անվանվի հստակ `pilot`, չպարունակի patient/clinical/finance business logic կամ production schema, և ապացուցի միայն OMOD build/install/lifecycle/API ու minimal O3 extension wiring-ը։ Pilot-ից business code չի շարունակվում, մինչև արդյունքը չի վերանայվել և ADR-0002-ը չի ընդունվել կամ մերժվել։

Pilot-ի միակ կառուցվածքային հրահանգը [pilot compatibility spec](./pilot/COMPATIBILITY-POC.md)-ն է, ոչ `03-STRUCTURE.md`-ի business module skeleton-ը։
