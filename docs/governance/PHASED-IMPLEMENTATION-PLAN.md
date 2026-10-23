# Phase I phased implementation plan

Այս փաստաթուղթը orchestration roadmap է Phase I-ի յոթ գործառութային խմբերի համար։ Այն չի փոխում ՏԱ-ի scope-ը, requirement ID-ների իմաստը կամ source authority-ն։ Գործառութային խմբերը code module/OMOD/database count չեն սահմանում։

## 1. Փուլերի հերթականություն

```text
P0  Platform and delivery foundation
 ↓
P1  ADM — users, roles, authorization, audit and administration
 ↓
P2  REG — patient registration, identity, visits and referrals
 ↓
P3  DIA — diagnostic/treatment orders and results
 ↓
P4  AMB — ambulatory medical record
 ↓
P5  INP — inpatient medical record
 ↓
P6  FIN — billing, payments and cashier
 ↓
P7  REP — operational views, reports and alerts
 ↓
P8  Cross-feature integration, hardening, UAT and release readiness
```

Հերթականության պատճառը՝ ADM-ը տալիս է ընդհանուր access/audit հիմքը, REG-ը՝ canonical patient/visit context-ը, DIA-ն՝ order/result capability-ն, որն օգտագործում են AMB և INP հոսքերը, FIN-ը կապվում է արդեն գոյություն ունեցող clinical դեպքերին, իսկ REP-ը հաշվարկվում է ավարտված source transactions-ից։

## 2. Phase state machine

Յուրաքանչյուր phase ունի միայն հետևյալ orchestration վիճակները՝

```text
NOT_STARTED → READY → IN_PROGRESS → REVIEW → QA → COMPLETE
                           └──────→ PARTIAL_BLOCKED
REVIEW/QA → NEEDS_REWORK → IN_PROGRESS
```

- `COMPLETE` նշանակում է, որ phase-ի բոլոր exit criteria-ները evidence ունեն։
- `PARTIAL_BLOCKED` նշանակում է՝ որոշ անկախ slice-եր ավարտված են, բայց phase-ը չի փակվել։
- Orchestrator-ը default-ով հաջորդ feature phase-ը չի սկսում մինչև նախորդը `COMPLETE` է։
- Բաց dependency-ն չի թույլատրում հորինել rule։ Human owner-ը կարող է առանձին թույլատրել հաջորդ phase-ի dependency-free slice-ը, բայց նախորդ phase-ը դրանից `COMPLETE` չի դառնում։
- Փուլի կարգավիճակը պահվում է [phase status register](./PHASE-STATUS.yaml)-ում։ Միայն orchestrator-ը թարմացնում է այդ process state-ը՝ ընդունված evidence-ից հետո։

## 3. Յուրաքանչյուր phase-ի պարտադիր agent flow

```text
orchestrator
  → developer: phase decomposition, one bounded slice implementation and tests
  → reviewer: independent stable-diff review
  → security-privacy-reviewer: required for sensitive slices
  → qa-playwright: user-visible and permission-sensitive flows
  → orchestrator: phase evidence aggregation and state transition
```

Մեկ developer task-ը չի կարող ամբողջ feature group-ը լինել։ Developer-ը phase-ը բաժանում է vertical slice-երի և իրականացնում է դրանք մեկ առ մեկ. յուրաքանչյուրն ունի մեկ observable outcome, սահմանված non-goals և tests։

## 4. Common Definition of Done

Յուրաքանչյուր feature phase-ի համար պարտադիր են՝

1. Requirement coverage՝ phase-ի բոլոր ID-ները mapped են task/evidence/UAT check-ին։
2. Canonical OpenMRS model/API reuse-ը ստուգված է. parallel Patient/Visit/Encounter/Obs/Order model կամ core patch չկա։
3. Applicable permissions-ը backend-ում enforce են և ունեն allow/deny tests։
4. Applicable writes-ը ունեն audit evidence՝ առանց PHI/secrets leakage-ի։
5. Validation, failure և correction/boundary cases-ը test-ավորված են։
6. Reviewer PASS-ը վերաբերում է նույն immutable diff identity-ին։
7. Playwright PASS-ը վերաբերում է նույն build identity-ին և synthetic data-ին։
8. Security/privacy review PASS կա, երբ trigger-ը կիրառելի է։
9. User-visible behavior-ի և operator/developer workflow-ի documentation-ը թարմացված է։
10. Phase blockers-ը դատարկ են կամ phase-ը մնում է `PARTIAL_BLOCKED`։

## 5. P0 — Platform and delivery foundation

**Նպատակ.** Ստեղծել վերարտադրվող OpenMRS development/runtime և verification հիմք՝ առանց business feature կառուցելու։

**Scope.**

- pinned JDK/Maven/OpenMRS/O3/database versions,
- clean-clone build և Maven wrapper/toolchain,
- custom OMOD-ի supported distro inclusion և lifecycle smoke,
- frontend config/build և LF shell-script policy,
- local synthetic environment,
- unit/integration/Playwright test harness,
- CI checks, logs և non-secret environment configuration,
- orchestration/run-record mechanism։

**Չի ներառում.** REG–ADM business behavior կամ speculative module tree։

**Exit criteria.**

- clean clone-ից մեկ documented flow-ով build և startup,
- backend/database/frontend healthy,
- OMOD load/unload/restart smoke PASS,
- դատարկ Playwright smoke-ը բացում է O3-ն առանց console/network fatal error-ի,
- CI-ն կատարում է build, automated tests և documentation checks,
- exact version/evidence-ը գրանցված է։

## 6. P1 — ADM: administration and cross-cutting controls

**Requirements.** `ADM-01`–`ADM-13`։

**Work packages.**

| Slice | Requirement IDs | Outcome |
|---|---|---|
| ADM-A | ADM-01–02 | Native OpenMRS account and role administration lifecycle |
| ADM-B | ADM-03–06 | Approved role/privilege/scope mapping and clinical-financial separation |
| ADM-C | ADM-07–08 | Authentication/session controls and supported MFA capability decision |
| ADM-D | ADM-09–11 | Internal approval identity/versioning, audit baseline, controlled correction |
| ADM-E | ADM-12 | Break-glass flow, reason, scope and separate audit |
| ADM-F | ADM-13 | Approved configurable metadata boundaries without a generic status engine |

**Dependencies that must not be invented.** Permission matrix, password/session numbers, MFA fit, audit retention/store/review, approval/correction semantics, break-glass eligibility/duration/review և lifecycle-specific configurable states։

**Exit criteria.**

- user/role administration is usable with synthetic accounts,
- every implemented privilege is approved/mapped and backend-enforced,
- clinical and financial capabilities are separable,
- audit/correction primitives are reusable by later phases,
- unauthorized/existence-hiding and audit tests PASS,
- Playwright covers login, account administration, denial and applicable emergency-access path։

## 7. P2 — REG: registration, identity and visits

**Requirements.** `REG-01`–`REG-09`։

**Work packages.**

| Slice | Requirement IDs | Outcome |
|---|---|---|
| REG-A | REG-01–02 | Canonical patient creation and combined search |
| REG-B | REG-03 | Duplicate warning and controlled merge with history |
| REG-C | REG-04–06 | Schedule, appointment and queue as separate approved lifecycles |
| REG-D | REG-07 | Permission-scoped unified patient history shell |
| REG-E | REG-08 | Internal/external referral linked to visit/case |
| REG-F | REG-09 | Approved registration documents, PDF/print output |

**Dependencies.** Identifier uniqueness/format, duplicate/merge survivor policy, schedule/appointment/queue transitions and concurrency, patient search/view access, referral/document contract and approved content։

**Exit criteria.**

- create → search → open patient journey PASS,
- name/date-of-birth/phone/card-number and combined search checks PASS,
- duplicate/merge preserves history and audit when its policy is resolved,
- appointment and queue are not collapsed into one status enum,
- unauthorized patient existence is not disclosed,
- Playwright covers registration, search, reschedule/cancel/queue according to approved transitions։

## 8. P3 — DIA: diagnostic and treatment orders/results

**Requirements.** `DIA-01`–`DIA-04`, `LAB-01`–`LAB-04`, `RAD-01`–`RAD-03`, `FDI-01`, `END-01`, `TRT-01`։ LAB/RAD/FDI/END/TRT-ը DIA traceability subgroups են, ոչ պարտադիր առանձին deployable modules։

**Work packages.**

| Slice | Requirement IDs | Outcome |
|---|---|---|
| DIA-A | DIA-01–03 | Service catalog, scheduling and diagnostic order lifecycle |
| DIA-B | DIA-04 | Shared search/view/link capability without generic result status |
| DIA-C | LAB-01–04 | Specimen, manual result entry, separate result lifecycle and critical fact |
| DIA-D | RAD-01–03 | Separate order/execution and result facets, manual attachment and applicable services |
| DIA-E | FDI-01, END-01, TRT-01 | Manual specialty protocols/results using approved subtype semantics |

**Dependencies.** Separate transition records for order/specimen/result sub-lifecycles, actors/permissions, units/ranges/content, critical thresholds/fact fields, attachment storage/security/retention, applicable radiology service list and subtype protocols։

**Exit criteria.**

- patient/case-linked order → execution/result → approved view journey PASS,
- order and result lifecycle states are separate,
- no generic diagnostic result enum կամ future LIS/PACS adapter is introduced,
- applicable correction/version/audit and denial tests PASS,
- Playwright covers one approved laboratory journey, one radiology journey and one specialty journey using synthetic data։

## 9. P4 — AMB: ambulatory medical record

**Requirements.** `AMB-01`–`AMB-14`։

**Work packages.**

| Slice | Requirement IDs | Outcome |
|---|---|---|
| AMB-A | AMB-01–04 | Ambulatory visit, preliminary assessment, history and examination |
| AMB-B | AMB-05 | Diagnosis recording with approved ICD source/version |
| AMB-C | AMB-06–09 | Diagnostic, consultation, medication and non-medication orders |
| AMB-D | AMB-10–12 | Conclusion, documents, follow-up and prior-case linkage |
| AMB-E | AMB-13–14 | Medical-note lifecycle capabilities and Armenian approved/printable output |

**Dependencies.** Form field/content definitions, ICD content/version, order and consultation semantics, medication fields, document content, medical-note transitions/actors/correction effects, permissions and print contract։ Financial status remains display data unless a separate policy explicitly creates a clinical gate։

**Exit criteria.**

- registration → ambulatory visit → note/order → conclusion journey PASS,
- AMB orders reuse P3 capabilities,
- medical-note actions are not inferred as an enum/linear workflow,
- clinical writes, approval/correction and documents satisfy permission/audit tests,
- Playwright covers initial and repeat visit with synthetic patient data։

## 10. P5 — INP: inpatient medical record

**Requirements.** `INP-01`–`INP-13`։

**Work packages.**

| Slice | Requirement IDs | Outcome |
|---|---|---|
| INP-A | INP-01–03 | Admission case and admission clinical record |
| INP-B | INP-04, INP-12 | Room/bed catalog, occupancy, assignment and transfers |
| INP-C | INP-05–07 | Care plan, daily/on-call/round/consilium documentation |
| INP-D | INP-08–09 | Nursing and medication administration clinical records |
| INP-E | INP-10–11 | Linked diagnostics/consultations and completed procedure documentation |
| INP-F | INP-13 | Discharge summary, completion type and case closure |

**Dependencies.** Admission/discharge/transfer transitions, concurrent bed assignment/conflict/override policy, nursing field set, medication execution semantics, procedure/discharge content and approval, permissions and document contracts։ Payment status does not gate admission/discharge without written policy։

**Exit criteria.**

- admission → bed assignment → clinical/nursing record → transfer/discharge journey PASS,
- concurrent bed assignment conflict is tested,
- nursing medication record does not create pharmacy inventory behavior,
- diagnostics reuse P3 and documents reuse approved cross-cutting capabilities,
- Playwright covers planned admission, transfer and discharge with synthetic data։

## 11. P6 — FIN: billing, payments and cashier

**Requirements.** `FIN-01`–`FIN-15`։

**Work packages.**

| Slice | Requirement IDs | Outcome |
|---|---|---|
| FIN-A | FIN-01–03 | Price history, bill creation and duplicate-line prevention |
| FIN-B | FIN-04–06 | Manual payment posting, prepayment allocation and partial payment |
| FIN-C | FIN-07–10 | Discount, refund/reversal, debt and multi-payer handling |
| FIN-D | FIN-11 | Cashier shift lifecycle and reconciliation |
| FIN-E | FIN-12–14 | Financial documents, clinical/payment separation and structured export |
| FIN-F | FIN-15 | Finance permission and complete audit coverage |

**Dependencies.** Price/payer rules, FIN-03 idempotency key, account/payment/prepayment/refund/debt/shift transitions, AMD precision/rounding, allocation/concurrency, discount authorities, document numbering/content, export contract and finance permission matrix։

**Exit criteria.**

- bill → payment/partial/prepayment → balance journey PASS,
- refund/reversal preserves original transaction,
- concurrent allocation and duplicate-posting cases are tested,
- clinical actions are not silently allowed/denied from payment status,
- finance permission separation and audit PASS,
- Playwright covers cashier shift and representative payment/reversal flows with synthetic amounts։

## 12. P7 — REP: operational monitoring and reports

**Requirements.** `REP-01`–`REP-07` և ՏԱ §6-ի `REP-07` outcomes։

**Work packages.**

| Slice | Requirement IDs | Outcome |
|---|---|---|
| REP-A | REP-01 | Main operational dashboard from approved definitions |
| REP-B | REP-02–05 | Separate ambulatory, inpatient, diagnostic and daily financial operational views |
| REP-C | REP-06 | In-app operational alerts with approved thresholds/state semantics |
| REP-D | REP-07 + §6 | Closed report catalog, filters, export and print |

**Dependencies.** Report-by-report grain, time semantics, formula, filters, rounding, columns/layout, access and golden examples; alert thresholds; export technology decision։ §6 outcomes-ը չեն դառնում REP-01–06-ի formula կամ partial mapping առանց approved composition decision-ի։

**Exit criteria.**

- every implemented metric reconciles to an approved golden dataset,
- operational views and §6 report catalog remain distinct unless explicitly composed,
- role/data-scope access and export limits PASS,
- PDF/Excel/print outputs meet approved contracts,
- Playwright covers dashboard, one operational view, one report filter/export and denial case։

## 13. P8 — Integration, hardening, UAT and release readiness

**Նպատակ.** Յոթ feature phase-երը մեկ համակարգային workflow-ով ստուգել։ Նոր business feature չի ավելացվում։

**Required journeys.**

1. ADM user/privilege → REG patient/visit → DIA order/result → AMB record → FIN bill/payment → REP view/report։
2. REG patient → INP admission/bed/diagnostics → discharge → FIN final account → REP inpatient/financial result։
3. Denial journey՝ unauthorized search/view/edit/export։
4. Correction/audit journey՝ controlled correction preserves original/version/audit։
5. Failure/concurrency journeys՝ duplicate registration/billing, bed conflict, payment allocation conflict և attachment failure, երբ կիրառելի ու approved են։

**Exit criteria.**

- full automated suites green,
- Playwright cross-feature journeys PASS on release candidate,
- security/privacy review of final exposed surface PASS,
- performance/backup/restore/upgrade evidence exists for the agreed environment,
- requirement → task → test → UAT traceability complete for all seven groups,
- known residual risks and client-owned inputs are explicit,
- release candidate identity is frozen and reproducible։

## 14. Orchestrator execution algorithm

Յուրաքանչյուր phase-ի համար orchestrator-ը՝

1. կարդում է այս plan-ը և `PHASE-STATUS.yaml`-ը,
2. հաստատում է predecessor phase state-ը,
3. developer-ին տալիս է միայն տվյալ phase-ի մեկ work package,
4. ստանում է task envelopes և dependency inventory,
5. READY slice-երը հերթով փոխանցում է developer-ին՝ design և implementation-ի համար,
6. յուրաքանչյուր stable diff ուղարկում է reviewer/security/QA համապատասխան routing-ով,
7. failure-ը վերադարձնում է `NEEDS_REWORK`, ոչ թե թաքցնում phase summary-ում,
8. work-package evidence-ը կցում է phase status-ին,
9. phase-ը `COMPLETE` է դարձնում միայն Common DoD և phase exit criteria-ից հետո,
10. միայն դրանից հետո բացում է հաջորդ phase-ը։

Orchestrator-ը չի ստեղծում մեկ task ամբողջ phase-ի կամ requirement range-ի համար, չի նշում requirement-ը done միայն compile-ի հիմքով և չի շրջանցում բաց business semantics-ը technical default-ով։
