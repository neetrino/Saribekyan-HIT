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

Development authority-ն սահմանված է repository-level `AGENTS.md`-ում։ [00-IMPLEMENTATION-GATE.md](./00-IMPLEMENTATION-GATE.md)-ը readiness/ambiguity guidance է և pre-code stop/go թույլտվություն չի պահանջում։

## Նախագծի հաստատված հիմքը

- Նախագծի չափը՝ **Size C**։
- Հիմնական բժշկական հարթակը՝ **OpenMRS**։
- Custom backend development-ի հիմնական լեզուն՝ **Java**։
- Փուլ I-ի գործառութային baseline-ը և բացառումները՝ տեխնիկական առաջադրանք v1.3-ի բաժիններ 5–16։ Repository owner-ը development-ը թույլատրել է այդ canonical baseline-ի հիման վրա։ Signature verification-ը, TASK-GO-ն և implementation-gate verdict-ը business task-ի մեկնարկի prerequisites չեն. իրական բաց business semantics-ը կանգնեցնում է միայն իրենից կախված slice-ը։
- Ընդունված և repository-ում կիրառվող runtime pin-ն է՝ **OpenMRS Reference Application 3.7.1**, **OpenMRS Platform 2.8.8**, **Java 21**։ OMOD/O3 package-ների կոնկրետ տարբերակների source of truth-ը distribution manifest/build configuration-ն է։ Նոր stack migration-ը կամ pin-ի փոփոխությունը պահանջում է առանձին տեխնիկական որոշում և compatibility verification։

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
├── 02-...                            # intentionally unused; numbering preserves historical document references
├── 03-STRUCTURE.md                   # repository և module file boundaries
├── 04-API.md                         # Java/REST/FHIR/custom API conventions
├── 05-DATABASE.md                    # persistence ownership և migration rules
├── 06-SECURITY-AND-PRIVACY.md        # security, privacy, authorization և audit baseline
├── 07-INTEGRATIONS.md                # API/integration boundaries և future connectors
├── 08-TESTING-AND-UAT.md             # test layers, Playwright և UAT evidence baseline
├── 09-OPERATIONS-AND-RELEASE.md      # reproducible runtime, release, backup և rollback baseline
├── architecture/                     # Architecture Decision Records և ինդեքս
├── modules/                          # module template և իրական as-built module records
├── pilot/                            # documentation-only. այստեղ միայն D-008 spec-ն է, ոչ PoC workspace/source/build
├── techHistory/phase-1/              # ստորագրման համար նախատեսված նյութեր
├── phase-scope/                      # source audit և պայմանագրային սահմանների ապացույցներ
└── requirements/
    ├── README.md                     # պահանջների կառավարման կանոններ
    ├── GLOSSARY.md                   # հիմնական տերմիններ
    ├── OPENMRS-FIT-GAP.md            # պաշտոնական աղբյուրներով fit-gap assessment
    ├── MODULE-SOURCE-MATRIX.md       # OpenMRS/custom լուծումների թեկնածու mapping
    ├── WORKFLOW-TRANSITIONS.md       # requirement-scoped workflow readiness/blockers
    ├── PERMISSION-MATRIX.md          # permission readiness/blockers
    ├── REPORT-DEFINITIONS.md         # report definitions և բաց formula semantics
    └── PHASE-1-TRACEABILITY.md       # ՏԱ պահանջների traceability հիմք
```

`02-...` փաստաթուղթ չկա դիտավորյալ. համարակալումը չի վերադասավորվել, որպեսզի հին հղումները և արդեն օգտագործվող 03–09 հասցեները չկոտրվեն։ Agent orchestration-ի canonical մուտքը `governance/AGENT-ORCHESTRATION.md` է, իսկ գործող module record-ը՝ `modules/SARIBEKYAN-OMOD.md`։

Multi-agent աշխատանքի դերերը, routing-ը, handoff contract-ը, Playwright QA-ն և completion rule-ը սահմանված են [Agent orchestration](./governance/AGENT-ORCHESTRATION.md)-ում։ Երկար կամ high-risk task-երի համար կիրառվում է [orchestration run record template](./governance/ORCHESTRATION-RUN-TEMPLATE.md)-ը։

Phase I-ի յոթ functional group-երի dependency-ordered իրականացումը սահմանված է [phased implementation plan](./governance/PHASED-IMPLEMENTATION-PLAN.md)-ում։ Orchestrator-ի ընթացիկ phase-ը և evidence state-ը պահվում են [PHASE-STATUS.yaml](./governance/PHASE-STATUS.yaml)-ում։

Այս ծառը միայն `docs/` documentation tree-ն է։ D-008-ի runtime/source workspace-ը դրա child-ը չէ. այն կարող է ստեղծվել միայն repository root-ի `pilot/openmrs-compatibility/` հասցեում։ `docs/pilot/openmrs-compatibility/`-ը արգելված duplicate workspace է։

Testing/UAT baseline-ը, operations/release baseline-ը և առաջին իրական module record-ը արդեն առկա են։ Դրանց evidence-ը լրացվում է implementation-ի հետ միասին և completion claim չի ստեղծում առանց իրական test/runtime արդյունքի։

## Փուլային documentation workflow

| Փուլ | Արդյունք | Կարգավիճակ |
|---|---|---|
| 1. Scope baseline | Brief, glossary, source matrix, traceability հիմք | Documentation artifact պատրաստ է, contract-ը դեռ ստորագրված չէ |
| 2. Technology decisions | TECH_CARD, OpenMRS fit-gap, տեխնոլոգիական ADR-ներ | Runtime baseline-ը ընդունված է. feature-specific բաց որոշումները նշված են առանձին |
| 3. Architecture | System context, components, security և integrations | Գործող հիմքը as-built է, իսկ չիրականացված feature-specific ընտրությունները մնում են Proposed |
| 4. Detailed design | Repository structure, API, database և module contracts | Իրականացվում է owner-authorized scope-ի հետ միասին. բաց որոշումը կանգնեցնում է միայն կախված slice-ը |
| 5. Delivery controls | Testing, UAT, operations, progress և release controls | Baseline առկա է, execution evidence-ը շարունակվում է |
| 6. Consistency audit | Փաստաթղթերի և ՏԱ-ի traceability review | Validator ակտիվ է, requirement evidence-ը թարմացվում է փուլ առ փուլ |

## External client and legal readiness

`32_Client_Clarifications_Resolution_Phase_1_HY.md` և `33_Client_Post_Signing_Inputs_Phase_1_HY.md` retained `NON_AUTHORIZING` drafts են։ Դրանք scope source կդառնան միայն իրական client approval evidence-ով և չեն արգելափակում canonical Phase I-ի owner-authorized development-ը։

`SIGNATURE-STATUS.yaml`-ի իրավական փաստերը մնում են անփոփոխ՝ ներկայացված լուսանկարը պայմանագրի էջ 9-ն է, ոչ ՏԱ §21, `business_source_authorized: false`, parity-ն `NOT_ASSESSED` է, իսկ DOCX/PDF-ը `STALE_REGENERATE_REQUIRED` են։ Այս վիճակը signing readiness է, ոչ coding gate։

## Փոփոխությունների կանոն

- Պայմանագրային scope-ը չի փոխվում architecture կամ implementation փաստաթղթով։
- Նոր մոդուլը, արտաքին ինտեգրումը կամ workflow-ի ընդլայնումը պահանջում է change request։
- Խոշոր տեխնիկական որոշումը գրանցվում է ADR-ով։
- `Proposed` feature-specific որոշումը վերջնական architecture չի սահմանում, բայց unrelated owner-authorized development-ը չի կանգնեցնում։ D-008-ը սահմանափակ disposable PoC profile է, ոչ global coding exception կամ business module tree-ի աղբյուր։
- As-built փաստաթղթերը թարմացվում են implementation-ի հետ միասին։
- Coding task-ը սկսվում է `AGENTS.md`-ի owner authorization-ով։ Agent-ը կարդում է կիրառելի canonical requirement-ը և մեկուսացնում միայն իրական բաց business dependency-ն. implementation-gate verdict կամ TASK-GO չի սպասում։
- Contract signature status-ը coding agent-ը չի կեղծում։ Architecture/TECH_CARD as-built status-ը թարմացվում է իրական repository/runtime evidence-ով, իսկ TASK-GO-ն մնում է optional անկախ review՝ ըստ [governance README](./governance/README.md)-ի։
