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

Այս status-ները requirement lifecycle metadata են և չեն փոխարինում `TECH_CARD.md`-ի decision legend-ին կամ `00-IMPLEMENTATION-GATE.md`-ի go/no-go կանոնին։ `Validated fit`, `Approved design` կամ `Implemented` կարգավիճակներից ոչ մեկը ինքնուրույն coding/release authorization չէ։ Հակասության դեպքում governing gate-ը և համապատասխան ADR-ի իրական status-ն են գերակա։

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

- `PHASE-1-TRACEABILITY.md` — requirement-level source/design/blocker/go register,
- `WORKFLOW-TRANSITIONS.md` — չփակված transition semantics-ի blocker register,
- `PERMISSION-MATRIX.md` — authorization policy blocker register,
- `REPORT-DEFINITIONS.md` — report metric/acceptance definition blocker register,
- `OPENMRS-FIT-GAP.md` — version-specific evidence պահանջող assessment,
- `MODULE-SOURCE-MATRIX.md` — mapping candidates, ոչ artifact որոշում։

- `GLOSSARY.md` — նախագծում օգտագործվող հիմնական տերմինները։

## Չլուծված տեխնիկական պնդումների կանոն

«OpenMRS-ում պատրաստ է» ձևակերպումը հաստատված է համարվում միայն այն դեպքում, երբ նշված են՝

1. OpenMRS distribution/platform version-ը,
2. module/package-ի ճշգրիտ անվանումն ու version-ը,
3. պահանջը փակող workflow-ն ու սահմանափակումները,
4. պահպանման/upgrade status-ը,
5. PoC կամ test evidence-ը։
