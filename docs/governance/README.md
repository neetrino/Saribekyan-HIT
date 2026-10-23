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
| `ACCEPTED_AS_BUILT` | Repository/runtime evidence-ով գործող և ընդունված տեխնիկական ընտրություն | Կիրառվում է owner-authorized scope-ի իրականացման մեջ |
| `ACCEPTED_AS_BUILT_PARTIAL` | Գործող capability-ի ընդունված մասնակի վիճակ | Կիրառվում է նկարագրված մասի համար, առանց ամբողջ requirement-ը complete համարելու |
| `AS_BUILT_FOUNDATION` | Repository/runtime-ում փաստացի առկա տեխնիկական հիմք | Կարող է օգտագործվել owner-authorized development-ում, բայց ինքնին business requirement-ի ավարտ չի նշանակում |
| `ACTIVE_DELIVERY_BASELINE` | Գործող testing, operations կամ release գործընթացի baseline, որի evidence-ը լրացվում է փուլային | Կիրառվում է owner-authorized delivery-ում և development blocker չէ |
| `OWNER_AUTHORIZED_BASELINE` | Repository owner-ի կողմից development-ի համար ընտրված canonical business baseline | Այո՝ AGENTS.md-ի սահմաններում |
| `APPROVED_CONSTRAINT` | Ընդունված տեխնիկական constraint, որը նոր business scope չի ստեղծում | Կիրառվում է owner-authorized development-ի ընթացքում |
| `DRAFT_CONTRACT` | Ստորագրման համար պատրաստված, բայց չստորագրված baseline | Ոչ |
| `PROPOSED_DESIGN` | Առաջարկ կամ target design | Ոչ |
| `GOVERNING_GUARDRAIL` | Պարտադիր արգելք կամ ownership սահման, ոչ artifact հրահանգ | Կիրառվում է authorized development-ի ընթացքում |
| `GOVERNING_GUARDRAIL_NO_GO` | Legacy alias of `GOVERNING_GUARDRAIL`; `NO_GO` suffix-ը global coding stop չի նշանակում | Կիրառվում է որպես guardrail, առաջարկվում է migration դեպի canonical literal |
| `GOVERNING_CANONICAL_MODEL_NO_SKELETON` | Canonical model-ի սահման՝ առանց module/repository skeleton-ի թույլտվության | Ոչ |
| `BLOCKED` | Պահանջվող որոշումը կամ evidence-ը բացակայում է | Ոչ |
| `BLOCKED_FOR_DEPENDENT_INFRASTRUCTURE_ONLY` | Infrastructure որոշումը բաց է | Կանգնեցնում է միայն դրանից կախված infrastructure slice-ը |
| `OUT_OF_SCOPE` | Owner-authorized Phase I սահմաններից դուրս capability | Չիրականացնել առանց repository owner-ի բացահայտ scope change-ի |
| `D008_POC_ONLY` | D-008 disposable compatibility PoC-ի սահմանափակ profile | Միայն D-008 scope-ի համար, ոչ business implementation |
| `ASSESSMENT` | Fit-gap կամ այլ գնահատում | Ոչ |
| `HISTORICAL` | Audit/history/archive նյութ | Ոչ |
| `TEMPLATE` | Դատարկ կառավարման կամ design template | Ոչ |
| `AS_BUILT` | Իրական ներդրված վիճակի փաստագրում | Միայն source requirement/go record-ի հետ, ոչ ինքնուրույն |

`Approved`, `Accepted`, `Approved scope`, `Approved Phase I boundary`, `Baseline`, `Closed`, `Target`, `Created`, `Expected` և այլ ազատ բառերը canonical lifecycle չեն։ Դրանք machine status-ի փոխարեն չեն կիրառվում և artifact/module count չեն սահմանում։ Անհայտ status-ից agent-ը նոր scope կամ business semantics չի հորինում, բայց այն unrelated owner-authorized implementation-ը չի կանգնեցնում։ Անհայտ status-ը documentation finding է և պետք է canonical mapping ստանա։

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
