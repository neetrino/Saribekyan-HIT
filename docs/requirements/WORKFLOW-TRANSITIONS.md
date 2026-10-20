# Workflow transition register

> **Status: BLOCKER REGISTER / ոչ workflow specification։** Այս ֆայլը transition չի հորինում։ Մինչ approved row չկա, համապատասխան implementation-ը `NO_GO` է։

| Workflow | Requirement IDs | States known from draft | Missing decision | Owner | Approval evidence | Status |
|---|---|---|---|---|---|---|
| Medical note lifecycle | AMB-13–14, ADM-09–11 | draft/continue/view/internal-approve/correct/close | exact transitions, actors, reasons, reopen/correction effects | Client clinical owner + project owner | TBD | BLOCKED |
| Admission/discharge | INP-01–03, INP-12–13 | admit/transfer/discharge | transition table, cancellation, conflict and correction rules | Client clinical owner | TBD | BLOCKED |
| Diagnostic order/result | DIA-01–04, LAB-01–04, RAD-01–03 | create/accept/perform/not-perform/cancel/result/approve/correct | per-workflow transition/authority table | Client clinical owner | TBD | BLOCKED |
| Financial operation | FIN-03–13 | bill/payment/prepayment/refund/debt/shift | immutable posting/reversal transitions, dedup, allocation and rounding | Client financial owner | TBD | BLOCKED |
| Queue/appointment | REG-04–06 | appointment/visit/queue statuses | exact states, reschedule/cancel/no-show and conflict policy | Client operational owner | TBD | BLOCKED |

Approved transition record-ը պարտադիր սահմանում է source requirement, from/to, actor/permission, preconditions, required reason, concurrency behavior, audit event, downstream effects և UAT examples։
