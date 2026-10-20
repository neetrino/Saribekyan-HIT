# Documentation governance

Այս պանակը documentation-ի authority, lifecycle և implementation authorization կանոնների canonical մուտքն է։ Այն business scope չի ստեղծում և բաց business semantics չի լրացնում։

## Mandatory reading order for agents

1. repository-level `AGENTS.md`,
2. `../00-IMPLEMENTATION-GATE.md`,
3. `DOCUMENT-MANIFEST.yaml`,
4. կիրառելի signed contract/TA և `../contract/phase-1/SIGNATURE-STATUS.yaml`,
5. requirement-level traceability և task-ի `TASK-GO-RECORD.md`,
6. միայն դրանից հետո՝ Approved/Accepted ADR/design և implementation փաստաթղթեր։

Search result-ից բացված ֆայլը չի կիրառվում, մինչև agent-ը `DOCUMENT-MANIFEST.yaml`-ով չի ստուգել դրա `authority`, `lifecycle` և `agent_usage` արժեքները։ Ֆայլի ներսում հրամայական լեզուն չի բարձրացնում դրա authority-ն։

## Canonical lifecycle values

| Value | Meaning | May authorize business implementation? |
|---|---|---|
| `SIGNED_CONTRACT` | Ստորագրված contract/TA artifact, որի hash-ը գրանցված է signature manifest-ում | Միայն task-level gate-ից հետո |
| `APPROVED_CLIENT_CLARIFICATION` | Լիազորված client approval evidence-ով պարզաբանում | Միայն signed scope-ի ներսում և task-level gate-ից հետո |
| `ACCEPTED_DECISION` | Ստորագրված պահանջի իրականացման հաստատված տեխնիկական որոշում | Ինքնուրույն՝ ոչ |
| `DRAFT_CONTRACT` | Ստորագրման համար պատրաստված, բայց չստորագրված baseline | Ոչ |
| `PROPOSED_DESIGN` | Առաջարկ կամ target design | Ոչ |
| `ASSESSMENT` | Fit-gap կամ այլ գնահատում | Ոչ |
| `HISTORICAL` | Audit/history/archive նյութ | Ոչ |
| `TEMPLATE` | Դատարկ կառավարման կամ design template | Ոչ |
| `AS_BUILT` | Իրական ներդրված վիճակի փաստագրում | Միայն source requirement/go record-ի հետ, ոչ ինքնուրույն |

`Approved`, `Accepted`, `Baseline`, `Closed`, `Target`, `Created`, `Expected` և այլ ազատ բառերը canonical lifecycle չեն։ Եթե manifest-ում canonical value չկա, agent-ը ֆայլը համարում է `NON_AUTHORIZING` և կանգ է առնում implementation-ից առաջ։

## Approval authority

- Contract/TA status-ը փոխվում է միայն կողմերի ստորագրության evidence-ով և `SIGNATURE-STATUS.yaml`-ի թարմացմամբ։
- Client clarification-ը `APPROVED_CLIENT_CLARIFICATION` է միայն լիազորված client approver-ի, ամսաթվի և immutable evidence-ի գրանցումից հետո։
- ADR-ը `Accepted` կարող է դառնալ միայն փաստաթղթում նշված decision owner/approver-ի գրավոր review record-ով։ Coding agent-ը չի կարող սեփական արդյունքի հիման վրա ինքնուրույն բարձրացնել ADR status-ը։
- TECH_CARD-ի `Approved` արժեքը պահանջում է համապատասխան decision/ADR հղում և approver/date։
- Task-level go-ն գրանցում է նշանակված reviewer/owner-ը։ Coding agent-ը կարող է պատրաստել record-ը, բայց չի հաստատում սեփական go-ն։

## Required task record

Յուրաքանչյուր business implementation task repository-ում կամ task description-ում պետք է ունենա `TASK-GO-RECORD.md`-ի լրացված պատճեն։ Բաց կամ `TBD` պարտադիր դաշտը նշանակում է `NO_GO`։ D-008 compatibility PoC-ն օգտագործում է իր spec-ի run record-ը և հստակ `task_class: D008_COMPATIBILITY_POC` արժեքը։

## Validation

Մինչ implementation կամ documentation release-ը ստուգվում են՝

- manifest-ում referenced ֆայլերի գոյությունը,
- Markdown relative links,
- signed artifact hash-ը,
- lifecycle/status-ի թույլատրելի արժեքները,
- requirement-level source/go/blocker դաշտերը,
- ADR approver/date/evidence-ը,
- DOCX/PDF/Markdown parity review-ը կամ բացահայտ `UNVERIFIED` վիճակը։
