# Documentation governance

Այս պանակը documentation authority, lifecycle և optional review կանոնների canonical մուտքն է։ Այն business scope չի ստեղծում, բաց business semantics չի լրացնում և repository development authorization-ը չի փոխարինում։

## Mandatory reading order for agents

1. repository-level `AGENTS.md`,
2. `../00-IMPLEMENTATION-GATE.md`,
3. `DOCUMENT-MANIFEST.yaml`,
4. owner-authorized canonical TA և `../techHistory/phase-1/SIGNATURE-STATUS.yaml`՝ signature metadata-ն development gate չդարձնելով,
5. requirement-level traceability և, եթե review է պահանջվել, task-ի `TASK-GO-RECORD.md`,
6. կիրառելի Approved/Accepted ADR/design և implementation փաստաթղթեր։

Search result-ից բացված ֆայլը չի կիրառվում, մինչև agent-ը `DOCUMENT-MANIFEST.yaml`-ով չի ստուգել դրա `authority`, `lifecycle` և `agent_usage` արժեքները։ Ֆայլի ներսում հրամայական լեզուն չի բարձրացնում դրա authority-ն։

## Canonical lifecycle values

| Value | Meaning | May authorize business implementation? |
|---|---|---|
| `SIGNED_CONTRACT` | Ստորագրված contract/TA artifact, որի hash-ը գրանցված է signature manifest-ում | Իրավական evidence է, ոչ repository coding gate |
| `APPROVED_CLIENT_CLARIFICATION` | Լիազորված client approval evidence-ով պարզաբանում | Կարող է հստակեցնել scope-ը, բայց task-go չի պահանջում |
| `ACCEPTED_DECISION` | Ստորագրված պահանջի իրականացման հաստատված տեխնիկական որոշում | Ինքնուրույն՝ ոչ |
| `DRAFT_CONTRACT` | Ստորագրման համար պատրաստված, բայց չստորագրված baseline | Ոչ |
| `PROPOSED_DESIGN` | Առաջարկ կամ target design | Ոչ |
| `GOVERNING_GUARDRAIL` | Պարտադիր արգելք կամ ownership սահման, ոչ artifact հրահանգ | Կիրառվում է authorized development-ի ընթացքում |
| `GOVERNING_CANONICAL_MODEL_NO_SKELETON` | Canonical model-ի սահման՝ առանց module/repository skeleton-ի թույլտվության | Ոչ |
| `BLOCKED` | Պահանջվող որոշումը կամ evidence-ը բացակայում է | Ոչ |
| `D008_POC_ONLY` | D-008 disposable compatibility PoC-ի սահմանափակ profile | Միայն D-008 scope-ի համար, ոչ business implementation |
| `ASSESSMENT` | Fit-gap կամ այլ գնահատում | Ոչ |
| `HISTORICAL` | Audit/history/archive նյութ | Ոչ |
| `TEMPLATE` | Դատարկ կառավարման կամ design template | Ոչ |
| `AS_BUILT` | Իրական ներդրված վիճակի փաստագրում | Միայն source requirement/go record-ի հետ, ոչ ինքնուրույն |

`Approved`, `Accepted`, `Approved scope`, `Approved Phase I boundary`, `Baseline`, `Closed`, `Target`, `Created`, `Expected` և այլ ազատ բառերը canonical lifecycle չեն։ Դրանք machine status-ի փոխարեն չեն կիրառվում և երբեք artifact/module count կամ task `GO` չեն սահմանում։ Եթե manifest-ում կամ governing decision register-ում վերևի canonical value չկա, agent-ը ֆայլը համարում է `NON_AUTHORIZING` և կանգ է առնում implementation-ից առաջ։

## Approval authority

- Contract/TA status-ը փոխվում է միայն կողմերի ստորագրության evidence-ով և `SIGNATURE-STATUS.yaml`-ի թարմացմամբ։
- Client clarification-ը `APPROVED_CLIENT_CLARIFICATION` է միայն լիազորված client approver-ի, ամսաթվի և immutable evidence-ի գրանցումից հետո։
- ADR-ը `Accepted` կարող է դառնալ միայն փաստաթղթում նշված decision owner/approver-ի գրավոր review record-ով։ Coding agent-ը չի կարող սեփական արդյունքի հիման վրա ինքնուրույն բարձրացնել ADR status-ը։
- TECH_CARD-ի `Approved` արժեքը պահանջում է համապատասխան decision/ADR հղում և approver/date։
- Task-level go-ն գրանցում է նշանակված reviewer/owner-ը։ Coding agent-ը կարող է պատրաստել record-ը, բայց չի հաստատում սեփական go-ն։

## Optional task review record

`TASK-GO-RECORD.md` ստեղծվում է միայն երբ owner-ը, orchestrator-ը կամ risk policy-ն անկախ task review է պահանջում։ Record-ի բացակայությունը development-ը չի կանգնեցնում։ Եթե review է բացվել, task-ի իրական dependency-ի բաց կամ `TBD` արժեքը այդ review-ի `NO_GO` է։ Reviewer-ը գնահատում է միայն տվյալ task-ի dependency-ները։ D-008-ի run record-ը շարունակում է պարտադիր evidence լինել հենց PoC execution-ի համար, իսկ TASK-GO review-ը optional է։ Ազատ `pilot` class-ը անվավեր է։ `PRODUCTION_PILOT_RELEASE`-ը առանձին business class է և չի օգտագործում D-008 profile-ը։

## Validation

Մինչ implementation կամ documentation release-ը ստուգվում են՝

- manifest-ում referenced ֆայլերի գոյությունը,
- Markdown relative links,
- signed artifact hash-ը,
- lifecycle/status-ի թույլատրելի արժեքները,
- requirement-level source/go/blocker դաշտերը,
- ADR approver/date/evidence-ը,
- DOCX/PDF/Markdown parity review-ը կամ բացահայտ `UNVERIFIED` վիճակը։
