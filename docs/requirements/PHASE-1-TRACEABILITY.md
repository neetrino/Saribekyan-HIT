# Phase I requirements traceability

> **Lifecycle՝ requirement-scoped readiness register.** Requirement ID-ն scope-ից դուրս վարք ստեղծելու թույլտվություն չէ։ Մեկ տողի blocker-ը մյուս տողերը չի կանգնեցնում։ Business baseline-ը ՏԱ v1.3-ի canonical Markdown-ն է, որի repository development-ը owner-authorized է։ Signature status-ը contract-readiness metadata է, իսկ task-go record-ը՝ optional review artifact. դրանցից ոչ մեկը pre-code blocker չէ։ IDs/ownership groups-ը deployable artifact count չեն սահմանում։

## Requirement-level register

`Source`-ը stable contract section + row ID է, ոչ փխրուն line number։ `Implementation` սյունակը այս requirement-ի semantics-ն է, ոչ ամբողջ Phase I-ի վիճակը։

`Implementation`-ը ցույց է տալիս՝ պահանջից ինչն է ներկայում իրագործելի։ `Readiness`-ը ցույց է տալիս evidence/blocker-ի ընթացիկ վիճակը և չի վերածվում phase-wide coding gate-ի։ `BLOCKED` տողը կարող է փոքրացվել նոր bounded slice-ի, եթե agent-ը գրանցում է դրա observable outcome-ը և ապացուցում է, որ նշված blocker-ից կախված չէ։

| Implementation | Meaning |
|---|---|
| `READY` | Այս requirement-ի համար գրանցված semantic blocker չկա. implementation-ը կարող է սկսվել owner-authorized scope-ով |
| `PARTIALLY_READY` | Թվարկված ready capability-ն կարող է իրականացվել. blocked capability-ն մնում է կանգնած |
| `BLOCKED` | Կանգնած է միայն այս requirement-ի նշված blocker-ը |

| Readiness | Meaning |
|---|---|
| `READY` | Ամբողջ գրանցված requirement-ը չունի բաց blocker |
| `PARTIAL_BLOCKED` | Աղյուսակում անվանված implemented/ready slice-ը կարող է շարունակվել կամ ստուգվել, իսկ նշված մնացորդը դեռ blocked է |
| `READY_SLICE_WITH_CONCURRENCY_BLOCKER` | Միայն թվարկված catalog/read slice-երն են ready. write/assignment slice-ը կանգնած է concurrency rule-ի վրա |
| `BLOCKED` | Այս պահին bounded ready slice գրանցված չէ. սա unrelated requirements-ի կամ ամբողջ phase-ի blocker չէ |

| Requirement | Source | Ownership | Business source | Implementation | Technical mapping | Design | Blockers | Verification | Readiness |
|---|---|---|---|---|---|---|---|---|
| REG-01 | ՏԱ §5.1 / REG-01 | REG | BASELINE_V1_3 | READY | OpenMRS Patient | Pending | none | Pending | READY |
| REG-02 | ՏԱ §5.1 / REG-02 | REG | BASELINE_V1_3 | PARTIALLY_READY | Accepted O3 patient-search app | `config-core_demo.json` + `startup.sh` | date-of-birth-only runtime proof and fresh-DB telephone `searchable=true` bootstrap remain open | Committed configuration evidence | PARTIAL_BLOCKED |
| REG-03 | ՏԱ §5.1 / REG-03 | REG | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | merge/duplicate policy open | Pending | BLOCKED |
| REG-04 | ՏԱ §5.1 / REG-04 | REG | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | schedule semantics open | Pending | BLOCKED |
| REG-05 | ՏԱ §5.1 / REG-05 | REG | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | schedule semantics open | Pending | BLOCKED |
| REG-06 | ՏԱ §5.1 / REG-06 | REG | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | queue transitions open | Pending | BLOCKED |
| REG-07 | ՏԱ §5.1 / REG-07 | REG | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | permissions open | Pending | BLOCKED |
| REG-08 | ՏԱ §5.1 / REG-08 | REG | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | document contract open | Pending | BLOCKED |
| REG-09 | ՏԱ §5.1 / REG-09 | REG | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | referral/document semantics open | Pending | BLOCKED |
| AMB-01 | ՏԱ §5.2 / AMB-01 | AMB | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | payment display vs gate policy open | Pending | BLOCKED |
| AMB-02 | ՏԱ §5.2 / AMB-02 | AMB | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | form fields/content open | Pending | BLOCKED |
| AMB-03 | ՏԱ §5.2 / AMB-03 | AMB | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | form fields/content open | Pending | BLOCKED |
| AMB-04 | ՏԱ §5.2 / AMB-04 | AMB | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | form fields/content open | Pending | BLOCKED |
| AMB-05 | ՏԱ §5.2 / AMB-05 | AMB | BASELINE_V1_3 | BLOCKED | Pending terminology proof | Pending | ICD source/version open | Pending | BLOCKED |
| AMB-06 | ՏԱ §5.2 / AMB-06 | AMB | BASELINE_V1_3 | BLOCKED | Pending order fit proof | Pending | order transitions open | Pending | BLOCKED |
| AMB-07 | ՏԱ §5.2 / AMB-07 | AMB | BASELINE_V1_3 | BLOCKED | Pending order fit proof | Pending | workflow semantics open | Pending | BLOCKED |
| AMB-08 | ՏԱ §5.2 / AMB-08 | AMB | BASELINE_V1_3 | BLOCKED | Pending order fit proof | Pending | medication semantics open | Pending | BLOCKED |
| AMB-09 | ՏԱ §5.2 / AMB-09 | AMB | BASELINE_V1_3 | BLOCKED | Pending order fit proof | Pending | workflow semantics open | Pending | BLOCKED |
| AMB-10 | ՏԱ §5.2 / AMB-10 | AMB | BASELINE_V1_3 | BLOCKED | Pending form fit proof | Pending | content/permissions open | Pending | BLOCKED |
| AMB-11 | ՏԱ §5.2 / AMB-11 | AMB | BASELINE_V1_3 | BLOCKED | Pending form fit proof | Pending | content/permissions open | Pending | BLOCKED |
| AMB-12 | ՏԱ §5.2 / AMB-12 | AMB | BASELINE_V1_3 | BLOCKED | Pending form fit proof | Pending | content/permissions open | Pending | BLOCKED |
| AMB-13 | ՏԱ §5.2 / AMB-13 | AMB | BASELINE_V1_3 | BLOCKED | Pending lifecycle design | Pending | transition table open | Pending | BLOCKED |
| AMB-14 | ՏԱ §5.2 / AMB-14 | AMB | BASELINE_V1_3 | BLOCKED | Pending document design | Pending | correction/document contract open | Pending | BLOCKED |
| INP-01 | ՏԱ §5.3 / INP-01 | INP | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | payment display vs gate policy open | Pending | BLOCKED |
| INP-02 | ՏԱ §5.3 / INP-02 | INP | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | admission transitions open | Pending | BLOCKED |
| INP-03 | ՏԱ §5.3 / INP-03 | INP | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | admission transitions open | Pending | BLOCKED |
| INP-04 | ՏԱ §5.3 / INP-04 | INP | BASELINE_V1_3 | PARTIALLY_READY | Pending bed fit proof | Pending | blocked: concurrent bed assignment. ready: room catalog, bed catalog, occupancy read | Pending | READY_SLICE_WITH_CONCURRENCY_BLOCKER |
| INP-05 | ՏԱ §5.3 / INP-05 | INP | BASELINE_V1_3 | BLOCKED | Pending form fit proof | Pending | content/permissions open | Pending | BLOCKED |
| INP-06 | ՏԱ §5.3 / INP-06 | INP | BASELINE_V1_3 | BLOCKED | Pending form fit proof | Pending | content/permissions open | Pending | BLOCKED |
| INP-07 | ՏԱ §5.3 / INP-07 | INP | BASELINE_V1_3 | BLOCKED | Pending order fit proof | Pending | order transitions open | Pending | BLOCKED |
| INP-08 | ՏԱ §5.3 / INP-08 | INP | BASELINE_V1_3 | BLOCKED | Pending nursing fit proof | Pending | exact fields/workflow open | Pending | BLOCKED |
| INP-09 | ՏԱ §5.3 / INP-09 | INP | BASELINE_V1_3 | BLOCKED | Pending form fit proof | Pending | content/permissions open | Pending | BLOCKED |
| INP-10 | ՏԱ §5.3 / INP-10 | INP | BASELINE_V1_3 | BLOCKED | Pending form fit proof | Pending | content/permissions open | Pending | BLOCKED |
| INP-11 | ՏԱ §5.3 / INP-11 | INP | BASELINE_V1_3 | BLOCKED | Pending procedure design | Pending | content/approval open | Pending | BLOCKED |
| INP-12 | ՏԱ §5.3 / INP-12 | INP | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | transfer/concurrency open | Pending | BLOCKED |
| INP-13 | ՏԱ §5.3 / INP-13 | INP | BASELINE_V1_3 | BLOCKED | Pending document design | Pending | discharge transition/document open | Pending | BLOCKED |
| DIA-01 | ՏԱ §5.4 / DIA-01 | DIA | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | catalog/status semantics open | Pending | BLOCKED |
| DIA-02 | ՏԱ §5.4 / DIA-02 | DIA | BASELINE_V1_3 | BLOCKED | Pending fit proof | Pending | scheduling semantics open | Pending | BLOCKED |
| DIA-03 | ՏԱ §5.4 / DIA-03 | DIA | BASELINE_V1_3 | BLOCKED | Pending lifecycle design | Pending | transition table open | Pending | BLOCKED |
| DIA-04 | ՏԱ §5.4 / DIA-04 | DIA | BASELINE_V1_3 | BLOCKED | Pending result design | Pending | approval/correction open | Pending | BLOCKED |
| LAB-01 | ՏԱ §5.4 / LAB-01 | DIA | BASELINE_V1_3 | BLOCKED | Pending lab fit proof | Pending | sample lifecycle open | Pending | BLOCKED |
| LAB-02 | ՏԱ §5.4 / LAB-02 | DIA | BASELINE_V1_3 | BLOCKED | Pending lab fit proof | Pending | units/ranges/content open | Pending | BLOCKED |
| LAB-03 | ՏԱ §5.4 / LAB-03 | DIA | BASELINE_V1_3 | BLOCKED | Pending lab fit proof | Pending | result draft/technical-check/professional-approval/correction transition table open | Pending | BLOCKED |
| LAB-04 | ՏԱ §5.4 / LAB-04 | DIA | BASELINE_V1_3 | BLOCKED | Pending lab fit proof | Pending | critical-result threshold source and clinician-notification fact semantics open | Pending | BLOCKED |
| RAD-01 | ՏԱ §5.4 / RAD-01 | DIA | BASELINE_V1_3 | BLOCKED | Pending radiology fit proof | Pending | order/scheduling/execution vs result draft/approval boundary and transitions open | Pending | BLOCKED |
| RAD-02 | ՏԱ §5.4 / RAD-02 | DIA | BASELINE_V1_3 | BLOCKED | Pending radiology fit proof | Pending | PDF/image format, size, storage, scanning, retention and access open | Pending | BLOCKED |
| RAD-03 | ՏԱ §5.4 / RAD-03 | DIA | BASELINE_V1_3 | BLOCKED | Pending radiology fit proof | Pending | client-approved applicable service list and per-service manual workflow open | Pending | BLOCKED |
| FDI-01 | ՏԱ §5.4 / FDI-01 | DIA | BASELINE_V1_3 | BLOCKED | Pending specialty fit proof | Pending | protocol/approval open | Pending | BLOCKED |
| END-01 | ՏԱ §5.4 / END-01 | DIA | BASELINE_V1_3 | BLOCKED | Pending specialty fit proof | Pending | protocol/approval open | Pending | BLOCKED |
| TRT-01 | ՏԱ §5.4 / TRT-01 | DIA | BASELINE_V1_3 | BLOCKED | Pending specialty fit proof | Pending | protocol/approval open | Pending | BLOCKED |
| FIN-01 | ՏԱ §5.5 / FIN-01 | FIN | BASELINE_V1_3 | BLOCKED | Pending billing fit proof | Pending | price history semantics open | Pending | BLOCKED |
| FIN-02 | ՏԱ §5.5 / FIN-02 | FIN | BASELINE_V1_3 | BLOCKED | Pending billing fit proof | Pending | payer/price semantics open | Pending | BLOCKED |
| FIN-03 | ՏԱ §5.5 / FIN-03 | FIN | BASELINE_V1_3 | BLOCKED | Pending billing fit proof | Pending | duplicate-prevention semantics | Pending | BLOCKED |
| FIN-04 | ՏԱ §5.5 / FIN-04 | FIN | BASELINE_V1_3 | BLOCKED | Pending payment fit proof | Pending | payment transitions open | Pending | BLOCKED |
| FIN-05 | ՏԱ §5.5 / FIN-05 | FIN | BASELINE_V1_3 | BLOCKED | Pending payment fit proof | Pending | prepayment receipt/link/use/allocation/balance, reversal, concurrency and rounding open | Pending | BLOCKED |
| FIN-06 | ՏԱ §5.5 / FIN-06 | FIN | BASELINE_V1_3 | BLOCKED | Pending payment fit proof | Pending | partial-payment allocation, unpaid-balance calculation and rounding open | Pending | BLOCKED |
| FIN-07 | ՏԱ §5.5 / FIN-07 | FIN | BASELINE_V1_3 | BLOCKED | Pending payment fit proof | Pending | discount authority/rounding open | Pending | BLOCKED |
| FIN-08 | ՏԱ §5.5 / FIN-08 | FIN | BASELINE_V1_3 | BLOCKED | Pending reversal design | Pending | refund/reversal transitions open | Pending | BLOCKED |
| FIN-09 | ՏԱ §5.5 / FIN-09 | FIN | BASELINE_V1_3 | BLOCKED | Pending debt design | Pending | debt lifecycle open | Pending | BLOCKED |
| FIN-10 | ՏԱ §5.5 / FIN-10 | FIN | BASELINE_V1_3 | BLOCKED | Pending payer design | Pending | share/rounding open | Pending | BLOCKED |
| FIN-11 | ՏԱ §5.5 / FIN-11 | FIN | BASELINE_V1_3 | BLOCKED | Pending cashier design | Pending | shift/reconciliation transitions open | Pending | BLOCKED |
| FIN-12 | ՏԱ §5.5 / FIN-12 | FIN | BASELINE_V1_3 | BLOCKED | Pending document design | Pending | numbering/content open | Pending | BLOCKED |
| FIN-13 | ՏԱ §5.5 / FIN-13 | FIN | BASELINE_V1_3 | BLOCKED | Pending billing design | Pending | clinical/payment separation open | Pending | BLOCKED |
| FIN-14 | ՏԱ §5.5 / FIN-14 | FIN | BASELINE_V1_3 | BLOCKED | Pending export design | Pending | file contract open | Pending | BLOCKED |
| FIN-15 | ՏԱ §5.5 / FIN-15 | FIN | BASELINE_V1_3 | BLOCKED | Pending authorization design | Pending | permission/audit matrix open | Pending | BLOCKED |
| REP-01 | ՏԱ §5.6 / REP-01 | REP | BASELINE_V1_3 | BLOCKED | Pending report design | Pending | metric definitions open | Pending | BLOCKED |
| REP-02 | ՏԱ §5.6 / REP-02 | REP | BASELINE_V1_3 | BLOCKED | Pending report design | Pending | metric definitions open | Pending | BLOCKED |
| REP-03 | ՏԱ §5.6 / REP-03 | REP | BASELINE_V1_3 | BLOCKED | Pending report design | Pending | metric definitions open | Pending | BLOCKED |
| REP-04 | ՏԱ §5.6 / REP-04 | REP | BASELINE_V1_3 | BLOCKED | Pending report design | Pending | metric definitions open | Pending | BLOCKED |
| REP-05 | ՏԱ §5.6 / REP-05 | REP | BASELINE_V1_3 | BLOCKED | Pending report design | Pending | metric definitions open | Pending | BLOCKED |
| REP-06 | ՏԱ §5.6 / REP-06 | REP | BASELINE_V1_3 | BLOCKED | Pending report design | Pending | metric definitions open | Pending | BLOCKED |
| REP-07 | ՏԱ §5.6 / REP-07 + §6 | REP | BASELINE_V1_3 | BLOCKED | Pending report proof | Pending | report register definitions open | Pending | BLOCKED |
| ADM-01 | ՏԱ §5.7 / ADM-01 | ADM | BASELINE_V1_3 | BLOCKED | Pending native fit proof | Pending | account lifecycle open | Pending | BLOCKED |
| ADM-02 | ՏԱ §5.7 / ADM-02 | ADM | BASELINE_V1_3 | BLOCKED | Pending native fit proof | Pending | role catalog open | Pending | BLOCKED |
| ADM-03 | ՏԱ §5.7 / ADM-03 | ADM | BASELINE_V1_3 | BLOCKED | Pending native fit proof | Pending | privilege matrix open | Pending | BLOCKED |
| ADM-04 | ՏԱ §5.7 / ADM-04 | ADM | BASELINE_V1_3 | BLOCKED | Pending native fit proof | Pending | scope matrix open | Pending | BLOCKED |
| ADM-05 | ՏԱ §5.7 / ADM-05 | ADM | BASELINE_V1_3 | BLOCKED | Pending authorization design | Pending | department/location matrix open | Pending | BLOCKED |
| ADM-06 | ՏԱ §5.7 / ADM-06 | ADM | BASELINE_V1_3 | BLOCKED | Pending authorization design | Pending | care-context matrix open | Pending | BLOCKED |
| ADM-07 | ՏԱ §5.7 / ADM-07 | ADM | BASELINE_V1_3 | BLOCKED | Native auth boundary | Pending | session/password policy open | Pending | BLOCKED |
| ADM-08 | ՏԱ §5.7 / ADM-08 | ADM | BASELINE_V1_3 | BLOCKED | Native capability check | Pending | MFA capability unknown | Pending | BLOCKED |
| ADM-09 | ՏԱ §5.7 / ADM-09 | ADM | BASELINE_V1_3 | BLOCKED | Pending audit design | Pending | correction history semantics open | Pending | BLOCKED |
| ADM-10 | ՏԱ §5.7 / ADM-10 | ADM | BASELINE_V1_3 | BLOCKED | Pending audit design | Pending | retention/store/review open | Pending | BLOCKED |
| ADM-11 | ՏԱ §5.7 / ADM-11 | ADM | BASELINE_V1_3 | BLOCKED | Pending approval design | Pending | internal approval semantics open | Pending | BLOCKED |
| ADM-12 | ՏԱ §5.7 / ADM-12 | ADM | BASELINE_V1_3 | BLOCKED | Pending break-glass design | Pending | eligibility/duration/review open | Pending | BLOCKED |
| ADM-13 | ՏԱ §5.7 / ADM-13 | ADM | BASELINE_V1_3 | BLOCKED | Pending configuration fit proof | Pending | configurable-field boundary open | Pending | BLOCKED |

## Cross-cutting register

| Source | Requirement group | Design destination | Lifecycle | Go |
|---|---|---|---|---|
| ՏԱ §6 | Closed list of report outcomes | `REPORT-DEFINITIONS.md` | BASELINE_V1_3 / definitions open | BLOCKED |
| ՏԱ §7 | Form builder, reference data, initial import | Module record + import contract | BASELINE_V1_3 / inputs open | BLOCKED |
| ՏԱ §8 | API basis, exclusions, internal approval | `../04-API.md`, `../07-INTEGRATIONS.md` | PROPOSED_DESIGN | BLOCKED |
| ՏԱ §9 | Data/source-code rights | Delivery/license record | BASELINE_V1_3 | BLOCKED |
| ՏԱ §10 | Architecture/NFR/security/backup | Architecture + approved NFR record | MIXED / measurable values open | BLOCKED |
| ՏԱ §11–12 | Deployment and deliverables | Operations/delivery records | Pending | BLOCKED |
| ՏԱ §13–15 | Pilot, UAT, warranty, inputs | Test/UAT/contract records | §19 values open | BLOCKED |
| ՏԱ §16–18 | Exclusions and scope guardrails | Scope control | BASELINE_V1_3 | BLOCKED |
| ՏԱ §19 | Pre-signing values | Contract owner | blocks only tasks that need the missing value | BLOCKED |

## Update rule

Յուրաքանչյուր row-ի readiness-ը թարմացվում է իրական design/blocker evidence-ով և tests/UAT IDs-ով։ TASK-GO record չի պահանջվում։ `BLOCKED` տողը այլ requirement-ի task-ը չի կանգնեցնում։
