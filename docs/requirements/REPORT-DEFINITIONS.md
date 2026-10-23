# Report definition register

> **Status: BLOCKER REGISTER / report list is closed, calculations are not yet approved։** ՏԱ §6-ը սահմանում է թույլատրելի information outcomes-ը, բայց այս ֆայլը նոր report չի ավելացնում։ Հաշվետվության անունից բանաձև չի բխում (`NO_FORMULA_FROM_REPORT_LABEL`)։ Բանաձև, grain կամ rounding չհաստատված լինելու դեպքում `NO_GO` է միայն այդ հաշվետվության task-ը։

Անվանված outcome-ը պարտադիր ապագա արդյունք է, ոչ հաշվարկի թույլտվություն։ `TBD/BLOCKED` row-ի համար agent-ը SQL, average denominator, time window, inclusion/exclusion կամ placeholder implementation չի գրում։ Փակուղու լուծումը owner-ի գրավոր definition-ն է և golden example-ը **մինչև code**, ոչ «ողջամիտ» default-ը։

| Requirement | Contract source | Grain/time semantics | Formula/filters | Currency/rounding | Columns/export/layout | Access | Golden example | Status |
|---|---|---|---|---|---|---|---|---|
| REP-01 | ՏԱ §5.6 / REP-01 only | TBD | TBD | N/A/TBD | TBD | TBD | TBD | BLOCKED |
| REP-02 | ՏԱ §5.6 / REP-02 only | TBD | TBD | N/A/TBD | TBD | TBD | TBD | BLOCKED |
| REP-03 | ՏԱ §5.6 / REP-03 only | TBD | TBD | N/A/TBD | TBD | TBD | TBD | BLOCKED |
| REP-04 | ՏԱ §5.6 / REP-04 only | TBD | TBD | TBD | TBD | TBD | TBD | BLOCKED |
| REP-05 | ՏԱ §5.6 / REP-05 only | TBD | TBD | TBD | TBD | TBD | TBD | BLOCKED |
| REP-06 | ՏԱ §5.6 / REP-06 only | TBD | TBD | N/A/TBD | TBD | TBD | TBD | BLOCKED |
| REP-07 | ՏԱ §5.6 / REP-07 + §6 | TBD | TBD | TBD | TBD | TBD | TBD | BLOCKED |

Մի քանի contract outcome կարող են նույն view/report-ում համադրվել միայն approved definition-ով։ Նոր outcome-ը change request է։ Յուրաքանչյուր approved row պետք է ունենա source transactions-ի reconciliation test և expected-result dataset։

## Outcome map — still blocked

Այս քարտեզը բանաձև, grain կամ իրականացում չի տալիս։ Բոլոր տողերը մնում են `BLOCKED`։

ՏԱ §6-ի տեղեկատվական արդյունքները պատկանում են միայն `REP-07` report/export catalog-ին։ `REP-01`–`REP-06`-ը ՏԱ §5.6-ի իրենց նախադասությամբ առանձին operational views են և **չեն map արվում §6 տողերին**։ Նույն UI-ում երկուսի համադրումը առանձին approved composition decision է, ոչ այս register-ի default։ `REP-01`–`REP-06` view-ից §6 outcome հաշվարկել չի թույլատրվում։

`REP-02`-ի սեփական operational view-ը սահմանվում է միայն `REP-02` պահանջով, իսկ դրա grain/formula/time semantics-ը դեռ `TBD` է։ §6.4-ի 1–4 կետերը `REP-07`-ի առանձին outcomes են և `REP-02`-ի համար ոչ ամբողջական, ոչ մասնակի բանաձև, աղբյուր կամ mapping չեն (`NO_PARTIAL_MAPPING_FROM_SECTION_6_4_TO_REP_02`)։ Նույն տարանջատումը կիրառվում է `REP-03`–`REP-06`-ի սեփական նպատակների նկատմամբ։ Ոչ outcome-ը կարելի է դուրս թողնել, ոչ հաշվարկ հորինել, ոչ էլ երկու կատալոգները լռելյայն կապել։

| Contract outcome group | REP row | Still blocked |
|---|---|---|
| ՏԱ §6.2, կետեր 1–10 | REP-07 | grain, formula, filters, layout, access |
| ՏԱ §6.3, կետեր 1–13 | REP-07 | նույնը, գումարած currency/rounding |
| ՏԱ §6.4, կետեր 1–4 | REP-07 only | grain, formula, filters, layout, access |
| ՏԱ §6.4, կետեր 5–9 | REP-07 only | grain, formula, filters, layout, access |
| ՏԱ §5.6 REP-04 | REP-04 only | diagnostic operational-view semantics; §6.2 mapping չկա |
| ՏԱ §5.6 REP-05 | REP-05 only | օրվա operational summary-ի բանաձևը TBD է; §6.3 mapping չկա |
| ՏԱ §5.6 REP-06 | REP-06 | ծանուցման շեմերը TBD են. սա նոր հաշվետվությունների կատալոգ չէ |
| ՏԱ §6.5, կետեր 1–10 | REP-07 | ադմինիստրատիվ/անվտանգության արդյունքներ. access-ը TBD է |

Պատմական `22_Phase_1_Report_Register.md`-ի 52 տողերից ոչ մեկը implementation source կամ backlog չէ. կոնկրետ անվանումը authority չի բարձրացնում։ C.10–C.19 կետերը §6.2 և §6.3 կրկնություններ են, ոչ լրացուցիչ պայմանագրային արդյունքներ։ §6.4-ի պայմանագրային ցանկը 9 արդյունք է՝ 4 ամբուլատոր և 5 ստացիոնար։

PDF/Excel-ը acceptance output formats են, ոչ dependency authorization։ JasperReports, openhtmltopdf, Apache POI կամ այլ library չի ավելացվում մինչև առանձին accepted technology decision-ը։ Մինչ այդ export implementation-ը `BLOCKED` է, նույնիսկ եթե format-ը ՏԱ-ում պարտադիր է։
