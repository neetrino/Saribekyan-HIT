# Report definition register

> **Status: BLOCKER REGISTER / report list is closed, calculations are not yet approved։** ՏԱ §6-ը սահմանում է թույլատրելի information outcomes-ը, բայց այս ֆայլը նոր report չի ավելացնում։ Բանաձև, grain կամ rounding չհաստատված լինելու դեպքում implementation-ը `NO_GO` է։

| Requirement | Contract source | Grain/time semantics | Formula/filters | Currency/rounding | Columns/export/layout | Access | Golden example | Status |
|---|---|---|---|---|---|---|---|---|
| REP-01 | ՏԱ §5.6 / REP-01 + §6 | TBD | TBD | N/A/TBD | TBD | TBD | TBD | BLOCKED |
| REP-02 | ՏԱ §5.6 / REP-02 + §6 | TBD | TBD | N/A/TBD | TBD | TBD | TBD | BLOCKED |
| REP-03 | ՏԱ §5.6 / REP-03 + §6 | TBD | TBD | N/A/TBD | TBD | TBD | TBD | BLOCKED |
| REP-04 | ՏԱ §5.6 / REP-04 + §6 | TBD | TBD | TBD | TBD | TBD | TBD | BLOCKED |
| REP-05 | ՏԱ §5.6 / REP-05 + §6 | TBD | TBD | TBD | TBD | TBD | TBD | BLOCKED |
| REP-06 | ՏԱ §5.6 / REP-06 + §6 | TBD | TBD | N/A/TBD | TBD | TBD | TBD | BLOCKED |
| REP-07 | ՏԱ §5.6 / REP-07 + §6 | TBD | TBD | TBD | TBD | TBD | TBD | BLOCKED |

Մի քանի contract outcome կարող են նույն view/report-ում համադրվել միայն approved definition-ով։ Նոր outcome-ը change request է։ Յուրաքանչյուր approved row պետք է ունենա source transactions-ի reconciliation test և expected-result dataset։

## Outcome map — still blocked

Այս քարտեզը բանաձև, grain կամ իրականացում չի տալիս։ Բոլոր տողերը մնում են `BLOCKED`։

ՏԱ §6-ի տեղեկատվական արդյունքները `REP-07`-ի փակ ցանկն են։ `REP-01`–`REP-06`-ը ՏԱ §5.6-ի իրենց նախադասությամբ առանձին գործառնական դիտումներ են։ Դրանք §6-ի տողը երկրորդ հաշվետվություն չեն դարձնում։ `REP-01`-ը կարող է ցույց տալ միայն այն ցուցանիշը, որի բանաձևի տողն արդեն հաստատված է. 42 արդյունքի հաշվարկն այս դիտումով չի թույլատրվում։

| Contract outcome group | REP row | Still blocked |
|---|---|---|
| ՏԱ §6.2, կետեր 1–10 | REP-07 | grain, formula, filters, layout, access |
| ՏԱ §6.3, կետեր 1–13 | REP-07 | նույնը, գումարած currency/rounding |
| ՏԱ §6.4, կետեր 1–4 | REP-02 ընթացիկ դիտում և REP-07 արդյունք | grain, formula, filters, layout, access |
| ՏԱ §6.4, կետեր 5–9 | REP-03 ընթացիկ դիտում և REP-07 արդյունք | grain, formula, filters, layout, access |
| ՏԱ §6.2 որպես ախտորոշիչ ընթացիկ վերահսկում | REP-04 | նոր արդյունք չի ավելացնում §6.2-ից և REP-04-ի նախադասությունից դուրս |
| ՏԱ §5.6 REP-05 և համընկնող §6.3 | REP-05 | օրվա ամփոփման բանաձևը TBD է |
| ՏԱ §5.6 REP-06 | REP-06 | ծանուցման շեմերը TBD են. սա նոր հաշվետվությունների կատալոգ չէ |
| ՏԱ §6.5, կետեր 1–10 | REP-07 | ադմինիստրատիվ/անվտանգության արդյունքներ. access-ը TBD է |

Պատմական `22_Phase_1_Report_Register.md`-ի C.10–C.19 կետերը §6.2 և §6.3 կրկնություններ են, ոչ լրացուցիչ պայմանագրային արդյունքներ։ 52 տողը backlog չէ։ §6.4-ի պայմանագրային ցանկը 9 արդյունք է՝ 4 ամբուլատոր և 5 ստացիոնար։
