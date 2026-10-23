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
| `developer` | requirement-ից կազմում և իրականացնում է bounded technical slice-ը, գրում automated tests և տալիս stable diff identity | scope չի ընդլայնում, self-review կամ completion չի անում |
| `reviewer` | անկախ diff/code review՝ correctness, scope, architecture և tests | reviewed code-ը չի հեղինակել, review-ի ընթացքում feature չի ավելացնում |
| `qa-playwright` | running system-ի Playwright browser/E2E verification և evidence | product code չի ուղղում՝ failing test-ը թաքցնելու համար |
| `security-privacy-reviewer` | threat/privacy review զգայուն փոփոխությունների համար | business policy չի հորինում և ընդհանուր reviewer-ին չի փոխարինում |

Orchestration-ի կազմը հենց այս հինգ agent role-ն է։ `developer`-ը մեկ bounded task-ի ներսում կատարում է և՛ technical slice design-ը, և՛ implementation-ը։ Մինչև code edit-ը նա run record-ում ամրագրում է outcome-ը, non-goals-ը, affected paths-ը, dependencies-ը և acceptance checks-ը։ Design և implementation միավորելը չի թույլատրում scope ընդլայնել կամ սեփական diff-ը review անել։

Repository-ում պահպանվող `task-go-reviewer`-ը orchestration agent չէ։ Այն միայն ըստ առանձին owner/compliance պահանջի կանչվող optional governance utility է և չի մտնում routing matrix-ի, lifecycle-ի, required agent count-ի կամ completion rule-ի մեջ։

## 3. Orchestration lifecycle

```text
REQUEST
  → INTAKE_AND_CLASSIFICATION
  → CONTEXT_AND_DEPENDENCY_CHECK
  → TECHNICAL_SLICE_READY             (developer)
  → IMPLEMENTATION_IN_PROGRESS         (developer)
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
| Documentation-only | orchestrator, developer, reviewer | none |
| Backend business behavior | orchestrator, developer, reviewer | security/privacy, QA՝ եթե UI կամ end-to-end flow կա |
| Frontend/UI behavior | orchestrator, developer, reviewer, qa-playwright | security/privacy՝ sensitive data/access դեպքում |
| Schema/migration | orchestrator, developer, reviewer | security/privacy; QA՝ user-visible flow դեպքում |
| Authentication/authorization/session | բոլոր հինգ դերերը | լրացուցիչ domain review, եթե business semantics-ը բաց է |
| PHI/patient data, audit, export, upload, attachment, integration | բոլոր հիմնական դերերը + security/privacy | լրացուցիչ domain review, եթե business semantics-ը բաց է |
| Build/CI/dependency-only | orchestrator, developer, reviewer | security/privacy՝ dependency/security surface-ի դեպքում |

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

Չլրացված business dependency-ն developer-ը չի վերածում ենթադրության։ Orchestrator-ը կամ փոքրացնում է slice-ը, կամ նշում է task-ը `BLOCKED`/clarification-required՝ repository-ի գործող authority կանոններին համապատասխան։

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

- `developer`-ը չի կարող լինել իր փոփոխության վերջնական `reviewer` կամ `qa-playwright`։
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

- երկու developer նույն ֆայլերի կամ նույն schema migration chain-ի վրա,
- reviewer-ը սկսել մինչև review identity-ն կայուն է,
- QA-ն PASS տալ այլ build-ի վրա,
- երկու agent միաժամանակ փոխեն նույն task/run record-ը,
- անվտանգության finding-ը փակել միայն developer-ի հայտարարությամբ։

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

Optional governance utility-ի TASK-GO verdict-ը, եթե owner-ը այն առանձին պահանջել է, պահվում է իր task record-ում և չի փոխարինում code review/QA completion evidence-ին։ Այն orchestration lifecycle-ի մաս կամ development prerequisite չէ։

## 13. Run record

Երկար, multi-agent կամ high-risk task-ի համար օգտագործվում է [run record template](./ORCHESTRATION-RUN-TEMPLATE.md)։ Փոքր task-ի դեպքում նույն դաշտերը կարող են պահպանվել task description/handoff-ում՝ առանց նոր ֆայլ ստեղծելու։

Phase I-ի յոթ functional group-երի իրականացման հերթականությունը և phase-level exit criteria-ները սահմանված են [phased implementation plan](./PHASED-IMPLEMENTATION-PLAN.md)-ում, իսկ ընթացիկ process state-ը՝ [phase status register](./PHASE-STATUS.yaml)-ում։

## 14. Async աշխատանք և հաղորդակցություն

Եթե agent platform-ը երաշխավորում է background execution-ը parent turn-ի ավարտից հետո, orchestrator-ը երկարատև task-ը գործարկելուց հետո չպետք է փակ պահի օգտատիրոջ երկխոսությունը։ Գործարկումից անմիջապես հետո նա կարճ հայտնում է՝

- ինչ task է գործարկվել,
- որ agent/model-ին է այն նշանակվել,
- ինչու է ընտրվել այդ agent/model-ը,
- որ run record-ում է գրանցվելու արդյունքը։

Այնուհետև orchestrator-ը կարող է ավարտել ընթացիկ turn-ը, որպեսզի օգտատերը շարունակի քննարկումը։ Յուրաքանչյուր background աշխատանք պետք է ունենա կայուն `task_id`, run record և հետագա արդյունքը ստանալու supported մեխանիզմ։ Եթե platform-ը չի երաշխավորում background execution-ը parent turn-ի ավարտից հետո, orchestrator-ը չի հայտարարում, որ task-ը շարունակում է աշխատել, և օգտագործում է տվյալ միջավայրի supported wait/resume ընթացքը։

## 15. Token և context արդյունավետություն

- Փոքր ուղղման համար չվերագործարկել ծանր կամ լայն context ունեցող agent։
- Փոքր, հստակ փոփոխությունները փոխանցել համապատասխան գործող հինգ agent-ից մեկին՝ նեղ սահմանված առաջադրանքով և նրա owner-locked model-ով։
- Agent-ին չհանձնարարել «ուսումնասիրել ամբողջ project/workspace-ը», երբ բավարար են կոնկրետ ֆայլերը, package-ները կամ module-ները։
- Յուրաքանչյուր agent ստուգում է իր task-ից ազդված package-ները, module-ները և անմիջական dependency-ները։
- Նույն աշխատանքը մի քանի agent-ի չհանձնարարել առանց անկախ review-ի կամ համեմատական հետազոտության հստակ պատճառի։
- Handoff-ում փոխանցել միայն անհրաժեշտ context-ը, source paths-ը, acceptance criteria-ն և առկա evidence-ը։
- Յուրաքանչյուր implementation task-ի ընթացքում կատարել targeted checks։ Ամբողջական lint, test և build կատարել final integration փուլում մեկ անգամ, իսկ բարձր ռիսկային փոփոխության դեպքում՝ նաև այնքան շուտ, որքան անհրաժեշտ է արագ failure հայտնաբերելու համար։

## 16. Model routing

Model assignment-ը repository owner-ի կողմից lock է արված և task-ի ընթացքում չի ընտրվում կամ փոխարինվում։ Պարտադիր mapping-ն է՝

| Agent | Locked model | Reasoning |
|---|---|---|
| `orchestrator` | `Opus 5.5` | platform default |
| `developer` | `Sonnet 5.5` | platform default |
| `reviewer` | `GPT-5.4` | `medium` |
| `qa-playwright` | `Grok 4.7` | platform default |
| `security-privacy-reviewer` | `Opus 5.5` | platform default |

`MODEL_ASSIGNMENTS_OWNER_LOCKED`: agent-ը չի կարող օգտագործել `inherit`, alias, auto-upgrade, downgrade կամ fallback substitution։ Exact model-ի բացակայության դեպքում կանգնում է միայն affected delegation-ը, և orchestrator-ը repository owner-ից խնդրում է նոր model-ի բացահայտ ընտրություն։ Մինչև պատասխանը ուրիշ model չի գործարկվում։

`NEW_SUBAGENT_REQUIRES_OWNER_APPROVAL`: ցանկացած լրացուցիչ subagent/role ստեղծելու, գրանցելու կամ spawn անելուց առաջ orchestrator-ը repository owner-ին ներկայացնում է առաջարկվող role-ը, bounded task-ը, գոյություն ունեցող հինգ agent-ից որևէ մեկով այն չկատարելու պատճառը, թույլատրելի paths-ը և հասանելի model ընտրությունները։ Նոր subagent-ը ստեղծվում է միայն owner-ի հստակ համաձայնությունից հետո և միայն owner-ի ընտրած model-ով։ Task-ի ընդհանուր approval-ը նոր subagent-ի approval չէ։

## 17. Commit policy

Մեկ ավարտված տրամաբանական փուլը համապատասխանում է մեկ conventional commit-ի։ Shared workspace-ում սովորական executor agent-ը ինքնուրույն commit չի ստեղծում, եթե orchestrator-ը նրան բացահայտ չի նշանակել commit owner։ Commit-ը ստեղծում է orchestrator-ը կամ նշանակված integration agent-ը միայն երբ՝

- task-ի targeted checks-ը անցել են,
- պարտադիր reviewer findings-ը փակված են,
- staged diff-ում միայն տվյալ task-ի owned paths-ն են,
- commit message-ը նկարագրում է մեկ տրամաբանական փոփոխություն։

Արգելվում է չկապված փոփոխություն ներառել, push անել առանց օգտատիրոջ բացահայտ հանձնարարության, վերագրել ուրիշի commit-ը, օգտագործել force push/destructive reset/history rewrite կամ required failing checks-ով commit ստեղծել։ Commit SHA-ն և ներառված paths-ը գրանցվում են run record-ում։

## 18. Final integration control

Բոլոր implementation փուլերից հետո orchestrator-ը կամ integration reviewer-ը՝

1. ստուգում է ամբողջ diff-ը և staged/unstaged վիճակը,
2. գտնում է unfinished, placeholder կամ dead հատվածները,
3. ստուգում է conflict-ները և կրկնվող implementation-ը,
4. ստուգում է architecture և module boundaries-ը,
5. ստուգում է imports-ը, types-ը և dependency consistency-ն,
6. կատարում է ամբողջական lint, tests և build,
7. UI փոփոխությունների դեպքում ստուգում է Playwright evidence-ը,
8. հաստատում է, որ ավելորդ ֆայլեր չեն փոփոխվել,
9. արդյունքը համեմատում է սկզբնական requirements-ի և acceptance criteria-ի հետ,
10. գրանցում է residual risks-ը և follow-up task-երը։

Փոքր տեղային rework-ը փոխանցվում է համապատասխան գործող հինգ agent-ից մեկին՝ նրա locked model-ով։ Այլ model կամ նոր subagent օգտագործելու համար նախապես պահանջվում է repository owner-ի բացահայտ համաձայնությունը։ Final status-ը միայն `COMPLETE`, `NEEDS_REWORK` կամ `BLOCKED` է։ `COMPLETE` չի տրվում agent-ի summary-ի հիման վրա՝ առանց վերարտադրելի evidence-ի։

## 19. Առաջնահերթություններ

1. Correctness
2. Reliability
3. Scope preservation
4. Owner-locked agent/model mapping-ի պահպանում
5. Quality
6. Վճարովի token-ների խնայողություն
7. Speed

## 20. Critical owner-decision escalation

`BLOCKED_OWNER_DECISION_REQUIRED` կիրառվում է, երբ canonical documentation-ը չի սահմանում implementation-ին անհրաժեշտ critical ընտրությունը, և ընտրությունը փոխում է user-visible business behavior, medical/clinical կանոն, money/rounding/payment policy, authorization/data visibility, audit/retention/privacy/security policy, irreversible migration, production database/storage/authentication/integration architecture, խոշոր framework/external կամ paid dependency, OpenMRS canonical ownership, workflow state/irreversible transition, incompatible public contract կամ Phase I scope։

Agent-ը չի ընտրում այդ արժեքը framework default-ից, historical source-ից, industry practice-ից կամ սեփական նախընտրությունից։ Նա՝

1. կանգնեցնում է միայն affected slice-ը,
2. շարունակում է անկախ task-երը,
3. run record-ում գրանցում է missing decision-ը և affected requirement/task/files-ը,
4. repository owner-ին ներկայացնում է 2–3 viable option, trade-off-ները և հստակ «recommendation only» առաջարկը,
5. սպասում է owner-ի բացահայտ ընտրությանը,
6. գրանցում է approval evidence-ը և նշանակալի architecture որոշման դեպքում ADR-ը,
7. միայն դրանից հետո վերադարձնում է slice-ը implementation flow։

Owner-ի լռությունը approval չէ։ Սովորական reversible technical detail-ը escalation չէ, եթե այն նոր business, clinical, financial, legal, privacy, security կամ architecture semantics չի ստեղծում։
