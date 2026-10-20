# Phase I requirements traceability

## Նպատակ

Այս register-ը պահպանում է ՏԱ-ի պահանջների նույնականացուցիչները և դրանց հետագա կապը design, implementation, tests և UAT evidence-ի հետ։ Այն չի կրկնում պահանջների ամբողջ իրավական տեքստը։ Իրավական աղբյուրը `../contract/phase-1/Phase_1_Technical_Specification_HY.md`-ն է։

## Traceability register

| Requirement IDs | Մոդուլ | Contract status | Technical mapping | Design | Verification |
|---|---|---|---|---|---|
| REG-01–09 | Գրանցում, նույնականացում և այցեր | Baseline | `OPENMRS-FIT-GAP.md` | Pending | Pending |
| AMB-01–14 | Ամբուլատոր քարտ | Baseline | `OPENMRS-FIT-GAP.md` | Pending | Pending |
| INP-01–13 | Ստացիոնար քարտ | Baseline | `OPENMRS-FIT-GAP.md` | Pending | Pending |
| DIA-01–04 | Ընդհանուր ախտորոշիչ պատվերներ | Baseline | `OPENMRS-FIT-GAP.md` | Pending | Pending |
| LAB-01–04 | Լաբորատոր workflow | Baseline | `OPENMRS-FIT-GAP.md` | Pending | Pending |
| RAD-01–03 | Ճառագայթային workflow | Baseline | `OPENMRS-FIT-GAP.md` | Pending | Pending |
| FDI-01 | Ֆունկցիոնալ ախտորոշում | Baseline | `OPENMRS-FIT-GAP.md` | Pending | Pending |
| END-01 | Էնդոսկոպիա | Baseline | `OPENMRS-FIT-GAP.md` | Pending | Pending |
| TRT-01 | Բուժական/ինտերվենցիոն ծառայություն | Baseline | `OPENMRS-FIT-GAP.md` | Pending | Pending |
| FIN-01–15 | Ֆինանսներ և գանձապահ | Baseline | `OPENMRS-FIT-GAP.md` | Pending | Pending |
| REP-01–07 | Հաշվետվություններ և վերահսկողություն | Baseline | `OPENMRS-FIT-GAP.md` | Pending | Pending |
| ADM-01–13 | Օգտատերեր, իրավունքներ և կառավարում | Baseline | `OPENMRS-FIT-GAP.md` | Pending | Pending |

## Լայնակի պահանջներ

| Աղբյուր | Պահանջների խումբ | Design destination | Կարգավիճակ |
|---|---|---|---|
| ՏԱ §6 | Փակ հաշվետվությունների գրանցամատյան | Reporting module + acceptance tests | Pending |
| ՏԱ §7 | Form builder, reference data և initial import | Forms/reference-data design | Pending |
| ՏԱ §8 | API հիմք, integration exclusions և internal approval | `../04-API.md`, `../07-INTEGRATIONS.md` | Draft design mapping; not coding authorization |
| ՏԱ §9 | Տվյալների և source code-ի իրավունքներ | Delivery/licensing ADR | Pending |
| ՏԱ §10 | Architecture, performance, 24/7 readiness, security, backup | `../01-ARCHITECTURE.md`, `../05-DATABASE.md`, `../06-SECURITY-AND-PRIVACY.md` | Draft design mapping; not coding authorization; measurable NFR values open |
| ՏԱ §11–12 | Deployment և deliverables | Operations/delivery docs | Pending |
| ՏԱ §13–15 | Pilot, acceptance, warranty և կողմերի մուտքեր | Test/UAT/progress docs | Pending |
| ՏԱ §16–18 | Exclusions և հատուկ սահմաններ | Scope guardrails | Baseline recorded |
| ՏԱ §19 | Մինչև ստորագրումը լրացվող արժեքներ | Contract owner | Open until signed |

## Հաջորդ լրացման կանոն

Յուրաքանչյուր իրական module design/implementation-ի ժամանակ ID-ի համար ավելացվելու են՝

- վերջնական reuse/configure/custom որոշումը,
- architecture կամ ADR հղումը,
- owning module/repository-ն,
- API և database contract-ները,
- security/audit պահանջները,
- automated test ID-ն,
- UAT scenario-ն և evidence-ը։
