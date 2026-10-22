# Saribekyan HIS documentation

Այս պանակը Սարիբեկյան համալսարանական բժշկական համալիրի միասնական բժշկական տեղեկատվական համակարգի նախագծային փաստաթղթերի հիմնական մուտքի կետն է։

Agent-ը պարտադիր ստուգում է [documentation manifest](./governance/DOCUMENT-MANIFEST.yaml)-ը։ Search result-ը, ֆայլի անունը, `closed`/`baseline` բառը կամ հրամայական ձևակերպումը ինքնուրույն authority չեն սահմանում։ Ստորագրության միակ machine-readable վիճակը [SIGNATURE-STATUS.yaml](./techHistory/phase-1/SIGNATURE-STATUS.yaml)-ում է։

## Փաստաթղթերի առաջնահերթություն

Հակասության դեպքում կիրառվում է հետևյալ հերթականությունը.

> Այս ցանկը սահմանում է բովանդակային/պայմանագրային աղբյուրների առաջնահերթությունը, ոչ coding go/no-go-ն։ [00-IMPLEMENTATION-GATE.md](./00-IMPLEMENTATION-GATE.md)-ը և repository-level `AGENTS.md`-ը պարտադիր applicability/stop checks են **ցանկացած** աղբյուրից առաջ և հետո։ Նույնիսկ ստորագրված պայմանագիրը կամ ՏԱ-ն agent-ին չի թույլատրում լրացնել այնտեղ չսահմանված թիվ, policy, transition, uniqueness, rounding, retention, concurrency կամ այլ semantics։ Այդ դեպքում կանգ է առնում միայն այդ արժեքից կախված task-ը, մինչև գրավոր որոշումը և իր task-level go-ն։

1. ստորագրված պայմանագիր և դրա ստորագրված փոփոխություններ,
2. ստորագրված Փուլ I-ի տեխնիկական առաջադրանք,
3. Պատվիրատուի հաստատված գրավոր պարզաբանումներ,
4. նախագծային ADR-ներ և հաստատված `TECH_CARD.md`,
5. ընթացիկ implementation/as-built փաստաթղթեր,
6. սկզբնական ամբողջական vision փաստաթուղթ,
7. աշխատանքային վերլուծություններ և տեխնիկական առաջարկներ։

Այս հերթականությունը որոշում է **ինչ արդյունք է պահանջվում**, բայց coding go/no-go չի տալիս։ `AGENTS.md`-ը և [00-IMPLEMENTATION-GATE.md](./00-IMPLEMENTATION-GATE.md)-ը պարտադիր execution control են յուրաքանչյուր code/schema/dependency task-ի համար՝ անկախ աղբյուրի բարձր դիրքից։ Նույնիսկ ստորագրված պայմանագիրը կամ ՏԱ-ն չեն թույլատրում agent-ին հորինել բաց implementation value/policy կամ շրջանցել տվյալ task-ի չփակված dependency-ն։ Gate-ը scope չի փոխում. այն կանգնեցնում է միայն կախված task-ը։ ՏԱ-ի «յոթ գործառութային մոդուլ» արտահայտությունը բաժին 5-ի յոթ գործառութային խումբն է, ոչ թե յոթ OMOD կամ directory։

`Phase_1_Technical_Specification_HY.md` v1.3-ը Փուլ I-ի business source-ի տեքստն է։ Ստորագրված scope-ը չի վերաշարադրվում development-ը բացելու համար։ Business task-ը սկսվում է, երբ `SIGNATURE-STATUS.yaml`-ի signed source-ը verified է, task-ի սեփական decision-ները փակ են և կա task-level `GO`։ Stale DOCX/PDF-ը և այլ requirement-ի բաց հարցը այդ task-ը չեն կանգնեցնում։ Քանի դեռ signed source-ը verified չէ, D-008 compatibility PoC-ն միակ business-ից դուրս coding բացառությունն է։ Ընթացիկ առաջին տարբերակի ծավալը բաժին 5-ի յոթ խումբն է՝ REG, AMB, INP, DIA, FIN, REP, ADM։ Սկզբնական `...ՏԵՂԵԿԱՏՎԱԿԱՆ.docx.md` փաստաթուղթը երկարաժամկետ տեսլական է և Phase II/III-ի հետագա ուղղությունների պատմական նկարագիր. այն չի ընդլայնում Փուլ I-ը, coding authorization չի տալիս, և դրա «առաջին փուլում» ու `V - 1` նշումները այս առաջին տարբերակը չեն։

Կոդից առաջ կիրառվող stop/go կանոնները կենտրոնացված են [00-IMPLEMENTATION-GATE.md](./00-IMPLEMENTATION-GATE.md)-ում և repository-level `AGENTS.md`-ում։

## Նախագծի հաստատված հիմքը

- Նախագծի չափը՝ **Size C**։
- Հիմնական բժշկական հարթակը՝ **OpenMRS**։
- Custom backend development-ի հիմնական լեզուն՝ **Java**։
- Փուլ I-ի փակ գործառութային baseline-ը և բացառումները՝ տեխնիկական առաջադրանք v1.3-ի բաժիններ 5–16։ Ստորագրության verification-ը անհրաժեշտ է business task-ի համար, բայց ինքնուրույն բավարար coding authorization չէ. յուրաքանչյուր task անցնում է implementation gate-ը և պահանջում է միայն իր dependency-ների լուծումը։
- OpenMRS distribution/platform/JVM/DB-ի և OMOD/O3 package-ների exact տարբերակները կարող են pin արվել միայն հաջող D-008 compatibility PoC-ի immutable evidence-ից և գրանցված review/go որոշումից հետո։ Fit-gap փաստաթուղթը միայն assessment է և ինքնուրույն pin կամ implementation authorization չի տալիս։

## Կառուցվածք

```text
docs/
├── 00-IMPLEMENTATION-GATE.md         # պարտադիր stop/go կանոններ կոդից առաջ
├── README.md                         # փաստաթղթերի քարտեզ և governance
├── BRIEF.md                          # արտադրանքի և Փուլ I-ի համառոտ նկարագիր
├── TECH_CARD.md                      # հաստատված և բաց տեխնիկական որոշումներ
├── DECISIONS.md                      # որոշումների ինդեքս
├── governance/                       # authority/status/signature/task-go կանոններ
├── 01-ARCHITECTURE.md                # system context, components և architectural rules
├── 03-STRUCTURE.md                   # repository և module file boundaries
├── 04-API.md                         # Java/REST/FHIR/custom API conventions
├── 05-DATABASE.md                    # persistence ownership և migration rules
├── 06-SECURITY-AND-PRIVACY.md        # security, privacy, authorization և audit baseline
├── 07-INTEGRATIONS.md                # API/integration boundaries և future connectors
├── architecture/                     # Architecture Decision Records և ինդեքս
├── modules/                          # module design template և հետագա records
├── pilot/                            # documentation-only. այստեղ միայն D-008 spec-ն է, ոչ PoC workspace/source/build
├── techHistory/phase-1/              # ստորագրման համար նախատեսված նյութեր
├── phase-scope/                      # source audit և պայմանագրային սահմանների ապացույցներ
└── requirements/
    ├── README.md                     # պահանջների կառավարման կանոններ
    ├── GLOSSARY.md                   # հիմնական տերմիններ
    ├── OPENMRS-FIT-GAP.md            # պաշտոնական աղբյուրներով fit-gap assessment
    ├── MODULE-SOURCE-MATRIX.md       # OpenMRS/custom լուծումների թեկնածու mapping
    └── PHASE-1-TRACEABILITY.md       # ՏԱ պահանջների traceability հիմք
```

Այս ծառը միայն `docs/` documentation tree-ն է։ D-008-ի runtime/source workspace-ը դրա child-ը չէ. այն կարող է ստեղծվել միայն repository root-ի `pilot/openmrs-compatibility/` հասցեում։ `docs/pilot/openmrs-compatibility/`-ը արգելված duplicate workspace է։

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
- Contract/ADR/TECH_CARD status-ը coding agent-ը ինքնուրույն չի բարձրացնում։ Approval authority-ն և task-go record-ը սահմանված են [governance README](./governance/README.md)-ում։
