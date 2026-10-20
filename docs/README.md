# Saribekyan HIS documentation

Այս պանակը Սարիբեկյան համալսարանական բժշկական համալիրի միասնական բժշկական տեղեկատվական համակարգի նախագծային փաստաթղթերի հիմնական մուտքի կետն է։

## Փաստաթղթերի առաջնահերթություն

Հակասության դեպքում կիրառվում է հետևյալ հերթականությունը.

1. ստորագրված պայմանագիր և դրա ստորագրված փոփոխություններ,
2. ստորագրված Փուլ I-ի տեխնիկական առաջադրանք,
3. Պատվիրատուի հաստատված գրավոր պարզաբանումներ,
4. նախագծային ADR-ներ և հաստատված `TECH_CARD.md`,
5. ընթացիկ implementation/as-built փաստաթղթեր,
6. սկզբնական ամբողջական vision փաստաթուղթ,
7. աշխատանքային վերլուծություններ և տեխնիկական առաջարկներ։

`Phase_1_Technical_Specification_HY.md` v1.3-ը Փուլ I-ի **ստորագրման համար պատրաստված draft contractual baseline-ն է**։ Այն գործող ստորագրված scope չի համարվում, մինչև ստորագրման ապացույցը repository-ում չգրանցվի։ Մինչ այդ business implementation-ը փակ է, իսկ D-008 compatibility PoC-ն միակ coding բացառությունն է։ Սկզբնական `...ՏԵՂԵԿԱՏՎԱԿԱՆ.docx.md` փաստաթուղթը նկարագրում է ամբողջ երկարաժամկետ տեսլականը և չի կարող ինքնուրույն ընդլայնել Փուլ I-ի ծավալը կամ coding authorization տալ։

Կոդից առաջ կիրառվող stop/go կանոնները կենտրոնացված են [00-IMPLEMENTATION-GATE.md](./00-IMPLEMENTATION-GATE.md)-ում և repository-level `AGENTS.md`-ում։

## Նախագծի հաստատված հիմքը

- Նախագծի չափը՝ **Size C**։
- Հիմնական բժշկական հարթակը՝ **OpenMRS**։
- Custom backend development-ի հիմնական լեզուն՝ **Java**։
- Ստորագրման ենթակա Փուլ I-ի փակ գործառութային baseline-ը և բացառումները՝ draft տեխնիկական առաջադրանքի բաժիններ 5–16։ Դրանք business coding authorization կդառնան միայն ստորագրումից հետո։
- OpenMRS distribution/platform/JVM/DB-ի և OMOD/O3 package-ների exact տարբերակները կարող են pin արվել միայն հաջող D-008 compatibility PoC-ի immutable evidence-ից և գրանցված review/go որոշումից հետո։ Fit-gap փաստաթուղթը միայն assessment է և ինքնուրույն pin կամ implementation authorization չի տալիս։

## Կառուցվածք

```text
docs/
├── 00-IMPLEMENTATION-GATE.md         # պարտադիր stop/go կանոններ կոդից առաջ
├── README.md                         # փաստաթղթերի քարտեզ և governance
├── BRIEF.md                          # արտադրանքի և Փուլ I-ի համառոտ նկարագիր
├── TECH_CARD.md                      # հաստատված և բաց տեխնիկական որոշումներ
├── DECISIONS.md                      # որոշումների ինդեքս
├── 01-ARCHITECTURE.md                # system context, components և architectural rules
├── 03-STRUCTURE.md                   # repository և module file boundaries
├── 04-API.md                         # Java/REST/FHIR/custom API conventions
├── 05-DATABASE.md                    # persistence ownership և migration rules
├── 06-SECURITY-AND-PRIVACY.md        # security, privacy, authorization և audit baseline
├── 07-INTEGRATIONS.md                # API/integration boundaries և future connectors
├── architecture/                     # Architecture Decision Records և ինդեքս
├── modules/                          # module design template և հետագա records
├── pilot/                            # D-008 compatibility PoC-ի միակ թույլատրելի spec-ը
├── contract/phase-1/                 # ստորագրման համար նախատեսված նյութեր
├── phase-scope/                      # source audit և պայմանագրային սահմանների ապացույցներ
└── requirements/
    ├── README.md                     # պահանջների կառավարման կանոններ
    ├── GLOSSARY.md                   # հիմնական տերմիններ
    ├── OPENMRS-FIT-GAP.md            # պաշտոնական աղբյուրներով fit-gap assessment
    ├── MODULE-SOURCE-MATRIX.md       # OpenMRS/custom լուծումների թեկնածու mapping
    └── PHASE-1-TRACEABILITY.md       # ՏԱ պահանջների traceability հիմք
```

Հաջորդ documentation փուլերում այս design baseline-ը կլրացվի testing, UAT, operations, release և իրական module records-ով։

## Փուլային documentation workflow

| Փուլ | Արդյունք | Կարգավիճակ |
|---|---|---|
| 1. Scope baseline | Brief, glossary, source matrix, traceability հիմք | Documentation artifact պատրաստ է, contract-ը դեռ ստորագրված չէ |
| 2. Technology decisions | TECH_CARD, OpenMRS fit-gap, տեխնոլոգիական ADR-ներ | Documentation artifact պատրաստ է, Proposed/PoC որոշումները բաց են |
| 3. Architecture | System context, components, security և integrations | Target design artifact պատրաստ է, Proposed/PoC որոշումները բաց են |
| 4. Detailed design | Repository structure, API, database և module contracts | Business implementation-ից առաջ հաստատման ենթակա. D-008 compatibility pilot-ը թույլատրված է հիմա |
| 5. Delivery controls | Testing, UAT, operations, progress և release controls | Սպասվող |
| 6. Consistency audit | Փաստաթղթերի և ՏԱ-ի վերջնական traceability review | Սպասվող |

## Փոփոխությունների կանոն

- Պայմանագրային scope-ը չի փոխվում architecture կամ implementation փաստաթղթով։
- Նոր մոդուլը, արտաքին ինտեգրումը կամ workflow-ի ընդլայնումը պահանջում է change request։
- Խոշոր տեխնիկական որոշումը գրանցվում է ADR-ով։
- `Proposed` որոշումը implementation-ի թույլտվություն չէ մինչև հաստատվելը։ Միակ բացառությունը D-008-ն է, որը թույլ է տալիս միայն մեկ pilot OMOD/O3 compatibility PoC, ոչ business module և ոչ ամբողջ repository skeleton։
- As-built փաստաթղթերը թարմացվում են implementation-ի հետ միասին։
- Coding task-ը չի սկսվում մինչև [implementation gate](./00-IMPLEMENTATION-GATE.md)-ով scope/source և բաց blockers-ը ստուգելը։
