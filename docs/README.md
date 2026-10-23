# Saribekyan HIS documentation

Այս պանակը Սարիբեկյան համալսարանական բժշկական համալիրի միասնական բժշկական տեղեկատվական համակարգի նախագծային փաստաթղթերի հիմնական մուտքի կետն է։

Agent-ը պարտադիր ստուգում է [documentation manifest](./governance/DOCUMENT-MANIFEST.yaml)-ը։ Search result-ը, ֆայլի անունը, `closed`/`baseline` բառը կամ հրամայական ձևակերպումը ինքնուրույն authority չեն սահմանում։ Ստորագրության միակ machine-readable վիճակը [SIGNATURE-STATUS.yaml](./techHistory/phase-1/SIGNATURE-STATUS.yaml)-ում է։

## Փաստաթղթերի առաջնահերթություն

Հակասության դեպքում կիրառվում է հետևյալ հերթականությունը.

> Այս ցանկը սահմանում է բովանդակային աղբյուրների առաջնահերթությունը, ոչ coding go/no-go-ն։ Repository-level `AGENTS.md`-ը development authority-ի գլխավոր կանոնն է, իսկ [00-IMPLEMENTATION-GATE.md](./00-IMPLEMENTATION-GATE.md)-ը readiness/ambiguity guidance է։ Agent-ը չի լրացնում չսահմանված business թիվ, policy, transition, uniqueness, rounding, retention կամ concurrency semantics։ Այդ դեպքում կանգ է առնում միայն այդ արժեքից կախված slice-ը, ոչ ամբողջ development-ը։

1. ստորագրված պայմանագիր և դրա ստորագրված փոփոխություններ,
2. ստորագրված Փուլ I-ի տեխնիկական առաջադրանք,
3. Պատվիրատուի հաստատված գրավոր պարզաբանումներ,
4. նախագծային ADR-ներ և հաստատված `TECH_CARD.md`,
5. ընթացիկ implementation/as-built փաստաթղթեր,
6. սկզբնական ամբողջական vision փաստաթուղթ,
7. աշխատանքային վերլուծություններ և տեխնիկական առաջարկներ։

Այս հերթականությունը որոշում է **ինչ արդյունք է պահանջվում**։ `AGENTS.md`-ը owner authorization-ն է, իսկ gate-ը օգնում է հայտնաբերել միայն տվյալ slice-ին վերաբերող իրական dependency-ն։ Contract signature-ը և TASK-GO-ն repository coding prerequisites չեն։ ՏԱ-ի «յոթ գործառութային մոդուլ» արտահայտությունը բաժին 5-ի յոթ գործառութային խումբն է, ոչ թե յոթ OMOD կամ directory։

`Phase_1_Technical_Specification_HY.md` v1.3-ը owner-authorized Phase I business baseline-ն է։ `SIGNATURE-STATUS.yaml`-ի signed-source դաշտերը legal/readiness metadata են, ոչ development gate։ TASK-GO-ն optional անկախ review է։ Stale DOCX/PDF-ը և այլ requirement-ի բաց հարցը այդ task-ը չեն կանգնեցնում։ D-008 compatibility PoC-ն ունի սահմանափակ technical profile, բայց միակ թույլատրելի coding task-ը չէ։ Ընթացիկ առաջին տարբերակի ծավալը բաժին 5-ի յոթ խումբն է՝ REG, AMB, INP, DIA, FIN, REP, ADM։ Սկզբնական `...ՏԵՂԵԿԱՏՎԱԿԱՆ.docx.md` փաստաթուղթը երկարաժամկետ տեսլական է և չի ընդլայնում Փուլ I-ը։

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
├── 00-IMPLEMENTATION-GATE.md         # readiness և ambiguity guidance
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

Multi-agent աշխատանքի դերերը, routing-ը, handoff contract-ը, Playwright QA-ն և completion rule-ը սահմանված են [Agent orchestration](./governance/AGENT-ORCHESTRATION.md)-ում։ Երկար կամ high-risk task-երի համար կիրառվում է [orchestration run record template](./governance/ORCHESTRATION-RUN-TEMPLATE.md)-ը։

Phase I-ի յոթ functional group-երի dependency-ordered իրականացումը սահմանված է [phased implementation plan](./governance/PHASED-IMPLEMENTATION-PLAN.md)-ում։ Orchestrator-ի ընթացիկ phase-ը և evidence state-ը պահվում են [PHASE-STATUS.yaml](./governance/PHASE-STATUS.yaml)-ում։

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
