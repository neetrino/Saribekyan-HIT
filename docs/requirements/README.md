# Requirements documentation

Այս պանակը կապում է պայմանագրային պահանջները տեխնիկական որոշումների, implementation-ի և ընդունման ապացույցների հետ։

## Կանոններ

Յուրաքանչյուր պահանջ պահպանում է ՏԱ-ի նույնականացուցիչը՝ `REG-01`, `AMB-05`, `FIN-11` և այլն։ Այդ նույն ID-ն հետագայում պետք է օգտագործվի module specification-ում, backlog-ում, API/database design-ում, test case-ում և UAT evidence-ում։

Յուրաքանչյուր պահանջի lifecycle-ը՝

```text
ՏԱ պահանջ
→ business workflow
→ OpenMRS fit-gap
→ architecture/ADR
→ implementation unit
→ automated test
→ UAT scenario
→ acceptance evidence
```

## Status-ներ

| Status | Նշանակություն |
|---|---|
| Contract baseline | Պահանջը ներառված է ստորագրման համար նախատեսված ՏԱ-ում |
| Proposed mapping | Առաջարկված է OpenMRS/module/custom լուծում, բայց դեռ չի հաստատվել |
| Validated fit | Կոնկրետ տարբերակով capability-ն ապացուցվել է documentation/PoC-ով |
| Approved design | Architecture/ADR որոշումը հաստատված է |
| Implemented | Կոդն իրականացված է, բայց ընդունումը կարող է դեռ բաց լինել |
| Verified | Automated և/կամ UAT evidence-ն առկա է |
| Change request | Սկզբնական scope-ից դուրս փոփոխություն է |

## Ֆայլեր

- `PHASE-1-TRACEABILITY.md` — Փուլ I-ի requirement register-ի սկզբնական քարտեզը։
- `OPENMRS-FIT-GAP.md` — պաշտոնական աղբյուրների հիման վրա reuse/configure/custom gap assessment-ը։
- `MODULE-SOURCE-MATRIX.md` — OpenMRS, custom Java և արտաքին բաղադրիչների թեկնածու բաշխումը։
- `GLOSSARY.md` — նախագծում օգտագործվող հիմնական տերմինները։

## Չլուծված տեխնիկական պնդումների կանոն

«OpenMRS-ում պատրաստ է» ձևակերպումը հաստատված է համարվում միայն այն դեպքում, երբ նշված են՝

1. OpenMRS distribution/platform version-ը,
2. module/package-ի ճշգրիտ անվանումն ու version-ը,
3. պահանջը փակող workflow-ն ու սահմանափակումները,
4. պահպանման/upgrade status-ը,
5. PoC կամ test evidence-ը։
