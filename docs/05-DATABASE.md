# Database and Persistence Design

> **Status:** target persistence guidance է, ոչ ինքնուրույն business scope։ Business schema կամ migration ստեղծվում է owner-authorized canonical պահանջից և տվյալ schema-ին իրականում անհրաժեշտ semantics/stack/artifact որոշումներից։ Signature verification-ը և TASK-GO-ն prerequisites չեն։ Pilot evidence-ը պահանջվում է միայն այն տեխնիկական ընտրության համար, որն իսկապես դրանից կախված է։

> **Rule classification:** canonical OpenMRS ownership/no-direct-SQL արգելքները governing constraints են։ Մնացած migration, locking, backup, JSON, indexing և reporting կանոնները `PROPOSED_DESIGN` են մինչև համապատասխան owner-authorized schema slice-ը դրանց կարիքն ունի։ TASK-GO prerequisite չկա։

## Status and ownership

Production DB engine/version-ը դեռ առանձին infrastructure decision է։ Գործող development distribution-ը օգտագործում է committed Docker/distribution configuration-ի MySQL-compatible database-ը։ Սա չի ընտրում վերջնական production engine-ը և չի կանգնեցնում module-owned schema չպահանջող աշխատանքը։

> **Current as-built:** `openmrs-module-saribekyan`-ը module-owned tables կամ Liquibase changesets դեռ չունի։ OpenMRS schema-ն կառավարվում է distribution/platform-ի supported migrations-ով։ Նոր business migration ավելացվում է միայն այն requirement slice-ի հետ, որն իրականում module-owned persistence է պահանջում։

OpenMRS schema-ն canonical clinical store է և կառավարվում է OpenMRS/platform modules-ի supported migrations-ով։ Custom module-ը չի վերաձևավորում core tables-ը և սեփական Liquibase changeset-ներով տնօրինում է միայն module-owned tables-ը։

## Canonical model mapping

| Domain | Canonical owner/model |
|---|---|
| Patient identity/demographics | OpenMRS Patient/Person/Identifier |
| Visit container | OpenMRS Visit՝ միայն ապացուցված semantic fit-ի սահմաններում |
| Clinical interaction | OpenMRS Encounter՝ միայն ապացուցված encounter-type/form mapping-ով |
| Inpatient admission/episode/bed stay | Առանձին fit/design blocker. OpenMRS Visit/Encounter-ից ինքնաբերաբար չի բխում, «extensions» կամ custom `inpatient_case` table default չէ (`NO_VISIT_EQUALS_INPATIENT_CASE`) |
| Clinical facts | Obs/Concept |
| Orders | OpenMRS Order՝ միայն ապացուցված semantic fit-ի սահմաններում |
| Results | Obs/Concept կամ validated module/FHIR-ը միայն candidate mappings են. result model, lifecycle կամ FHIR resource/profile այս տողով չի ընտրվում (`NO_RESULT_MODEL_FROM_CANDIDATE_MAPPING`) |
| Locations/providers/users | OpenMRS canonical models where fit is proven |
| Finance/reporting/audit gaps | Custom module-owned schema only after fit-gap և approved semantics |
| Documents/binaries | Metadata/reference in DB; binary storage strategy TBD |

Physical ERD-ն և exact column catalog-ը ստեղծվում են ընտրված distribution version-ից ու custom module migrations-ից հետո։ Մինչ այդ հորինված ամբողջ OpenMRS schema diagram չի պահվում որպես ճշմարտություն։

## Candidate custom-schema checklist — not a schema recipe

Ստորև կետերը կիրառվում են, երբ կոնկրետ owner-authorized capability-ն իրական module-owned schema է պահանջում։ TASK-GO prerequisite չկա։ Դրանք ինքնուրույն table ստեղծելու պատճառ կամ default column list չեն։ Յուրաքանչյուր field/constraint պահանջում է տվյալ domain-ի source և հիմնավորում։

- Table-ը ունի stable primary key, timestamps, provenance և state/version fields ըստ domain-ի։
- Clinical patient reference-ը օգտագործում է canonical OpenMRS ID-ն և application/service validation-ը։
- Foreign key/unique/check constraints-ը կիրառվում են այնտեղ, որտեղ migration compatibility-ն թույլ է տալիս։
- Status/code-ը uncontrolled free text չէ։
- Money representation-ը պետք է խուսափի binary floating-point-ից, բայց exact DB/Java type-ը, precision-ը և rounding mode-ը չեն ընտրվում մինչև stack compatibility-ն ու AMD business rule-ը գրավոր հաստատվեն։ `HALF_UP` կամ այլ mode ենթադրել չի թույլատրվում։
- Clinical quantity-ն ունի unit/code system։
- Time-ը պահվում է unambiguous instant/offset-ով, իսկ local schedule semantics-ը՝ timezone-ով։
- Sensitive payload-ը JSON blob-ում չի թաքցվում միայն արագության համար։ JSON-ը versioned schema և query/retention հիմնավորում է պահանջում։

Patient, Person, Visit, Encounter, Obs, Order և Concept parallel tables արգելված են։ Inpatient episode-ի gap-ը չի թույլատրում առանց approved model decision-ի ստեղծել parallel `inpatient_case` կամ Visit attribute-ների ենթադրյալ ցանկ։ Attachments-ի binary storage-ը TBD է. մինչև ADR-ը BLOB կամ local filesystem solution չի ընտրվում։ AMD amount-ը floating-point չէ, սակայն precision/rounding mode-ը blocking business decision է։

## Isolation and access

Սա multi-tenant SaaS schema չէ։ Isolation-ը սահմանվում է organization/location/department/service/patient-care context-ով։ Repository/DAO query-ն չի վստահում client-ից եկած scope-ին. այն ստանում է authorized context-ից։ Cross-module direct table access չի թույլատրվում։

## Migrations

- Core/OpenMRS migrations-ը՝ ընտրված distribution-ի մեխանիզմով, custom module schema-ն՝ module Liquibase changesets-ով։
- Կիրառված changeset-ը չի վերագրվում։ Նոր ուղղումը նոր changeset է։
- Production migration-ը forward-only է, backup/restore և rollout plan-ով։
- Destructive/drop/rename/not-null փոփոխությունը պահանջում է data profile, expand/backfill/validate/contract հերթականություն կամ maintenance decision։
- Migration-ը կրկնվում է production-like copy-ի վրա և distribution upgrade rehearsal-ում։
- Rollback-ը միշտ SQL downgrade չէ. հաճախ application rollback + forward data repair է։

## Transactions and concurrency — explicit blockers

Այս բաժինը transaction boundary չի հայտարարում։ Patient merge, clinical approval/correction, financial posting, locking, uniqueness և retry semantics-ը մնում են համապատասխան requirement/workflow registers-ի blockers։ Ստորևը միայն review checklist է approved design-ի համար։

- Approved design-ը պետք է explicit դարձնի միայն իրեն կիրառելի transaction boundary-ն։
- Lost update-ի վտանգ ունեցող row-ը optimistic locking/versioning ունի։
- Unique business invariant-ը միայն նախնական `SELECT`-ով չի պաշտպանվում. DB constraint կամ equivalent serialized strategy է պետք։
- External call-ը DB transaction-ի ներսում երկար չի սպասում։ Async delivery/outbox mechanism-ը առանձին ADR/PoC է, երբ առաջին իրական use case-ը հաստատվի։
- Retryable operation-ը idempotency/reconciliation design ունի։

## Audit, retention and deletion

Clinical/financial փոփոխությունը traceable correction/version է, ոչ hard delete։ OpenMRS void/retire semantics-ը կիրառվում է ըստ supported model-ի։ Custom audit-ը պահում է անհրաժեշտ metadata-ն և controlled diff/reference-ը՝ առանց secrets կամ անհարկի ամբողջ clinical payload-ի։ Retention/anonymization/legal hold ժամկետները դեռ պետք է իրավական հաստատում ստանան։

## Query and reporting rules

- Index-ը հիմնվում է իրական query shape-ի և explain evidence-ի վրա։
- Lists-ը paginated են, որոնումը bounded է, N+1 query-ն կանխվում է։
- Heavy reports-ը transactional DB-ն չպետք է անկառավարելիորեն ծանրաբեռնի։ Read replica/reporting store/job model-ը ընտրելուց առաջ չափում և ADR է պետք։
- Report totals-ը reconciliation test ունեն source transactions-ի հետ։

## Backup, restore and export

Backup-ը ներառում է database-ը, document storage-ը, configuration/metadata-ն և անհրաժեշտ encryption material-ի կառավարվող վերականգնումը։ Պահանջվում են automated backups, access control, off-host copy, checksum/integrity և պարբերական restore test։ RPO/RTO-ն TBD է։ Contract-defined exports-ը չեն հավասարվում ամբողջ database dump-ին։

## Database documentation per module

Յուրաքանչյուր custom module պահում է table/column purpose-ը, constraints, indexes, ownership, PHI classification, retention, migration dependencies, query patterns և ER diagram-ը։ `MODULE-TEMPLATE.md`-ը կապում է դրանք requirement/API/test evidence-ին։

## Open decisions

DB engine/version/topology, identifiers strategy, document storage, audit store, background delivery, reporting isolation, retention և RPO/RTO։
