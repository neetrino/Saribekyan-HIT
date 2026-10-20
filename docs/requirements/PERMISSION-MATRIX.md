# Permission and access decision register

> **Status: BLOCKER REGISTER։** Role անունը կամ UI visibility-ն authorization rule չէ։ Չլրացված permission row-ը `deny/no-go` design state է և agent-ին չի թույլատրում սեփական policy հորինել։

ՏԱ `ADM-03`-ի 18 դերանունները սկզբնական կատալոգ են, ոչ իրավունքների մատրիցա։ Քանի դեռ ստորևի տողը `BLOCKED` է, ագենտը privilege չի ստեղծում, դերը գործողության չի կապում և պաշտոնի անունից policy չի դուրս բերում։ Դատարկ կամ `BLOCKED` տողը deny/no-go է։

| Capability | Requirement IDs | Required dimensions | Missing decisions | Approval evidence | Status |
|---|---|---|---|---|---|
| Patient search/view | REG/AMB/INP, ADM-03–06 | role, location, department/service, care context | actor-resource-action matrix; existence hiding; sensitive reads | TBD | BLOCKED |
| Clinical create/edit/approve/correct | AMB/INP/DIA, ADM-09–11 | role, record state, care context | exact privileges and separation of duties | TBD | BLOCKED |
| Finance operations | FIN-01–15 | role, cashier shift, amount/action | discount/refund/reversal/export authorities | TBD | BLOCKED |
| Reports/export/print | REP-01–07, ADM-10 | role, dataset/filter scope | report-by-report access and export limits | TBD | BLOCKED |
| Administration/configuration | ADM-01–13 | admin domain, location, object type | admin vs clinical superuser separation | TBD | BLOCKED |
| Break-glass | ADM-12 | eligibility, scope, duration, reason, review | all listed values and reviewer/alert workflow | TBD | BLOCKED |

Approved matrix row-ը պարտադիր կապվում է OpenMRS privilege mapping-ին, backend enforcement-ին, audit classification-ին և denial/UAT test IDs-ին։
