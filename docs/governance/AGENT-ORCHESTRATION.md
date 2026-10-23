# Agent orchestration

Այս փաստաթուղթը սահմանում է repository-ի AI agent-ների աշխատանքային orchestration-ը։ Այն չի ստեղծում business scope, չի փոխարինում տեխնիկական առաջադրանքին և չի բարձրացնում որևէ document/ADR/task-ի authority-ն։ Source authority-ի հարցում կիրառվում են repository-level `AGENTS.md`-ը և համապատասխան governing artifacts-ը։

## 1. Նպատակ

Orchestration-ը պետք է ապահովի՝

- մեկ task-ի հստակ owner և սահմանված scope,
- analysis/design, implementation, review և verification դերերի տարանջատում,
- agent-to-agent փոխանցվող ստուգելի artifact,
- անկախ review,
- browser verification՝ Playwright-ով,
- security/privacy review միայն այն task-երի համար, որոնց ռիսկը դա պահանջում է,
- ավարտի վիճակ, որը հիմնված է evidence-ի, ոչ agent-ի ինքնագնահատականի վրա։

## 2. Դերեր

| Դեր | Պատասխանատվություն | Չի անում |
|---|---|---|
| `orchestrator` | classify, route, sequence, dependency control, evidence aggregation, final status | product code չի գրում և իր ղեկավարած task-ը չի review անում |
| `developer` | requirement-ից կազմում է իրագործելի technical slice, plan, acceptance criteria և affected-area map | production code չի գրում, task-ը չի հաստատում |
| `coder` | իրականացնում է հաստատված slice-ը և գրում համապատասխան automated tests | scope չի ընդլայնում, self-approval չի անում |
| `reviewer` | անկախ diff/code review՝ correctness, scope, architecture և tests | reviewed code-ը չի հեղինակել, review-ի ընթացքում feature չի ավելացնում |
| `qa-playwright` | running system-ի Playwright browser/E2E verification և evidence | product code չի ուղղում՝ failing test-ը թաքցնելու համար |
| `security-privacy-reviewer` | threat/privacy review զգայուն փոփոխությունների համար | business policy չի հորինում և ընդհանուր reviewer-ին չի փոխարինում |
| `task-go-reviewer` | առանձին TASK-GO record-ի governance verdict | implementation/code review/QA չի անում |

`developer` և `coder` դիտավորյալ տարբեր դերեր են։ Developer-ը պատասխանում է «ինչ և ինչ սահմանով կառուցել» հարցին, coder-ը՝ «ինչպես իրականացնել այդ հաստատված slice-ը» հարցին։ Փոքր մեխանիկական task-ի դեպքում orchestrator-ը կարող է developer փուլը կրճատել, բայց չի կարող coder-ին թույլ տալ ինքնուրույն ընդլայնել scope-ը։

## 3. Orchestration lifecycle

```text
REQUEST
  → INTAKE_AND_CLASSIFICATION
  → CONTEXT_AND_DEPENDENCY_CHECK
  → TECHNICAL_SLICE_READY             (developer)
  → IMPLEMENTATION_IN_PROGRESS         (coder)
  → CODE_REVIEW                        (reviewer)
  → SECURITY_PRIVACY_REVIEW_IF_NEEDED  (security-privacy-reviewer)
  → QA_READY
  → PLAYWRIGHT_VERIFICATION_IF_UI       (qa-playwright)
  → EVIDENCE_AGGREGATION               (orchestrator)
  → COMPLETE | BLOCKED | NEEDS_REWORK
```

Դերերի հերթականությունը quality gate է, ոչ անպայման առանձին commit-ների պահանջ։ `reviewer` և `qa-playwright` կարող են զուգահեռ աշխատել միայն այն ժամանակ, երբ երկուսն էլ ստանում են նույն immutable commit/diff identity-ն և running build-ը համապատասխանում է այդ identity-ին։

## 4. Routing matrix

| Փոփոխության տեսակ | Պարտադիր դերեր | Պայմանական դերեր |
|---|---|---|
| Documentation-only | orchestrator, developer կամ coder, reviewer | task-go-reviewer՝ միայն եթե առանձին record է պահանջվում |
| Backend business behavior | orchestrator, developer, coder, reviewer | security/privacy, QA՝ եթե UI կամ end-to-end flow կա |
| Frontend/UI behavior | orchestrator, developer, coder, reviewer, qa-playwright | security/privacy՝ sensitive data/access դեպքում |
| Schema/migration | orchestrator, developer, coder, reviewer | security/privacy; QA՝ user-visible flow դեպքում |
| Authentication/authorization/session | բոլոր հիմնական դերերը | task-go-reviewer՝ որպես առանձին governance verdict |
| PHI/patient data, audit, export, upload, attachment, integration | բոլոր հիմնական դերերը + security/privacy | լրացուցիչ domain review, եթե business semantics-ը բաց է |
| Build/CI/dependency-only | orchestrator, developer, coder, reviewer | security/privacy՝ dependency/security surface-ի դեպքում |

## 5. Task envelope

Orchestrator-ը յուրաքանչյուր delegated task-ի հետ փոխանցում է՝

```yaml
task_id: "<stable id>"
objective: "<one measurable outcome>"
task_class: "<documentation|backend|frontend|schema|security|infrastructure|mixed>"
source_paths:
  - "<repository path and section>"
in_scope:
  - "<explicit behavior>"
out_of_scope:
  - "<adjacent behavior not included>"
affected_areas:
  - "<expected paths/components>"
dependencies:
  resolved: []
  unresolved: []
acceptance_checks:
  - "<observable check>"
required_agents:
  - developer
  - coder
  - reviewer
risk_flags:
  security: false
  privacy_phi: false
  authorization: false
  schema_migration: false
  money: false
  concurrency: false
  external_integration: false
  browser_flow: false
review_identity: "<commit SHA or diff identity; pending before implementation>"
```

Չլրացված business dependency-ն coder-ին չի փոխանցվում որպես ենթադրություն։ Orchestrator-ը կամ փոքրացնում է slice-ը, կամ նշում է task-ը `BLOCKED`/clarification-required՝ repository-ի գործող authority կանոններին համապատասխան։

## 6. Handoff contract

Յուրաքանչյուր agent վերադարձնում է նույն նվազագույն կառուցվածքը.

```yaml
agent: "<agent name>"
task_id: "<id>"
status: "PASS|FAIL|BLOCKED|NEEDS_REWORK"
summary: "<what was concluded or changed>"
changed_paths: []
evidence:
  - "<command/test/file:line/result>"
assumptions: []
risks: []
blockers: []
next_agent: "<role or NONE>"
review_identity: "<commit/diff/build identity>"
```

Summary-only handoff-ը բավարար evidence չէ։ Եթե agent-ը փոփոխել է ֆայլ, `changed_paths`-ը պարտադիր է։ Եթե agent-ը verification է արել, command/check և արդյունքը պարտադիր են։

## 7. Review independence

- `coder`-ը չի կարող լինել իր փոփոխության վերջնական `reviewer` կամ `qa-playwright`։
- `developer`-ը կարող է պատասխանել clarification-ին, բայց չի վերագրում reviewer-ի finding-ը։
- Reviewer-ը ստուգում է իրական diff-ը և cited source-երը, ոչ միայն orchestrator-ի summary-ն։
- QA-ն ստուգում է running build-ը և գրանցում exact URL/scenario/result-ը։ Screenshot-ը միայնակ PASS չէ առանց քայլերի և expected result-ի։
- Review-ից հետո behavior-changing diff-ը invalidates է review/QA evidence-ը։ Orchestrator-ը task-ը վերադարձնում է համապատասխան gate-ին։

## 8. Playwright QA contract

`qa-playwright`-ը կիրառվում է user-visible flow-ի, permission boundary-ի կամ browser regression-ի դեպքում։ Այն պարտադիր գրանցում է՝

1. tested build/commit identity,
2. base URL և environment՝ առանց secrets-ի,
3. preconditions և test data identity,
4. numbered steps,
5. expected/actual result,
6. console errors և failed network requests,
7. screenshot/trace/video paths՝ failure-ի կամ պահանջված evidence-ի դեպքում,
8. cleanup կամ պահպանված test data-ի նշում։

QA-ն չպետք է օգտագործի production patient data։ Synthetic fixtures-ը default են։ PHI պարունակող screenshot/log/network dump-ը artifact չի դառնում։

## 9. Security/privacy review trigger

`security-privacy-reviewer`-ը պարտադիր է, երբ task-ը փոխում է՝

- authentication, session, privilege կամ role behavior,
- patient/clinical/financial տվյալների read/write/search/export/print,
- audit կամ retention behavior,
- attachment/upload/download/storage,
- external integration կամ secret handling,
- schema/migration, որը պարունակում է sensitive data,
- logging/telemetry, որտեղ sensitive payload կարող է հայտնվել,
- browser flow, որտեղ unauthorized existence disclosure հնարավոր է։

Reviewer-ը ստուգում է least privilege, backend enforcement, data minimization, sensitive logging, auditability, failure behavior և test coverage։ Նա չի որոշում նոր retention, clinical կամ financial policy։

## 10. Parallelization

Թույլատրվում է զուգահեռացնել միայն անկախ read-only analysis կամ չհամընկնող file ownership ունեցող subtasks։ Չի թույլատրվում՝

- երկու coder նույն ֆայլերի կամ նույն schema migration chain-ի վրա,
- reviewer-ը սկսել մինչև review identity-ն կայուն է,
- QA-ն PASS տալ այլ build-ի վրա,
- երկու agent միաժամանակ փոխեն նույն task/run record-ը,
- անվտանգության finding-ը փակել միայն coder-ի հայտարարությամբ։

Orchestrator-ը նախապես նշանակում է file ownership-ը և merge order-ը։ Conflict կամ scope overlap-ի դեպքում parallel branch-ը կանգ է առնում։

## 11. Retry, failure և escalation

- Նույն failure-ը առավելագույնը երկու անգամ վերադարձվում է նույն agent role-ին՝ նոր evidence/ուղղմամբ։
- Երրորդ նույն failure-ը դառնում է `BLOCKED` և պահանջում է orchestrator-ի root-cause classification կամ human input։
- Flaky test-ը PASS չէ։ Այն վերարտադրվում է, մեկուսացվում և գրանցվում որպես defect կամ environmental blocker։
- Missing secret/credential/external approval-ի դեպքում agent-ը չի հորինում արժեքը։
- Tool/environment failure-ը տարբերվում է product failure-ից և handoff-ում նշվում է առանձին։

## 12. Completion rule

Orchestrator-ը task-ը `COMPLETE` է նշում միայն երբ՝

- agreed slice-ը իրականացված է,
- reviewer-ը PASS է տվել նույն review identity-ի համար,
- պահանջված security/privacy review-ը PASS է,
- պահանջված Playwright QA-ն PASS է նույն build-ի համար,
- automated checks-ը կատարված են կամ documented applicable reason-ով բացակայում են,
- blockers-ը դատարկ են,
- behavior-changing documentation-ը թարմացված է,
- evidence-ը բավարար է արդյունքը կրկնելու համար։

`task-go-reviewer`-ի verdict-ը պահվում է իր task record-ում և չի փոխարինում վերևի code review/QA completion evidence-ին։ Repository-level կանոնով եթե TASK-GO-ն development prerequisite չէ, orchestration-ը այն չի վերածում թաքնված pre-code blocker-ի։

## 13. Run record

Երկար, multi-agent կամ high-risk task-ի համար օգտագործվում է [run record template](./ORCHESTRATION-RUN-TEMPLATE.md)։ Փոքր task-ի դեպքում նույն դաշտերը կարող են պահպանվել task description/handoff-ում՝ առանց նոր ֆայլ ստեղծելու։

Phase I-ի յոթ functional group-երի իրականացման հերթականությունը և phase-level exit criteria-ները սահմանված են [phased implementation plan](./PHASED-IMPLEMENTATION-PLAN.md)-ում, իսկ ընթացիկ process state-ը՝ [phase status register](./PHASE-STATUS.yaml)-ում։
