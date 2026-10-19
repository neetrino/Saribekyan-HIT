# Agent instructions

Այս repository-ում որևէ code, schema, dependency կամ business rule փոխելուց առաջ պարտադիր ամբողջությամբ կարդալ `docs/00-IMPLEMENTATION-GATE.md` և task-ին վերաբերող ստորագրված Phase I ՏԱ պահանջները։

## Mandatory stop rule

- Implementation-ը սկսվում է միայն եթե պահանջը traceable է ստորագրված ՏԱ-ի Phase I բաժիններ 5–16-ին, հաստատված client clarification-ին կամ այդ պահանջը իրականացնող `Approved`/`Accepted` որոշմանը։
- Եթե աղբյուրը բացակայում է, հակասում է կամ business semantics-ը որոշված չէ, կանգ առնել և հարցնել։ Չհորինել medical, financial, status, audit, retention կամ concurrency կանոն։
- Root vision փաստաթուղթը, `docs/phase-scope/archive/`, source-audit պատմական ֆայլերը, fit-gap-ը և `Proposed` ADR/technology candidate-ը scope կամ dependency ավելացնելու թույլտվություն չեն։

## Current implementation gate

- Clinical canonical models-ը OpenMRS Patient/Person/Visit/Encounter/Obs/Order/Concept են։ Parallel Spring/JPA clinical model չստեղծել։
- Phase I authentication-ը native OpenMRS է։ Keycloak/external IdP-ը Phase I-ից դուրս է։
- D-008-ը թույլ է տալիս միայն մեկ pilot OMOD/O3 compatibility PoC՝ որպես Proposed-ի սահմանափակ բացառություն։ Այն չի թույլատրում ամբողջ module tree կամ որևէ business module գեներացնել։
- Phase I ownership groups՝ REG, AMB, INP, DIA, FIN, REP, ADM։ Audit-ը cross-cutting ADM capability է, ոչ առանձին scope module։
- OpenMRS core-ը չfork անել, core/այլ module tables-ին direct SQL չգրել։
- Չավելացնել JasperReports, Apache POI, openhtmltopdf, JaVers, Moneta, WHO ICD API կամ այլ candidate dependency առանց հաստատված որոշման։
- Production Java package prefix-ը և production stack versions-ը business implementation blockers են, բայց D-008 pilot-ը դրանցից ազատված է և օգտագործում է `docs/pilot/COMPATIBILITY-POC.md`-ի disposable namespace/exact-commit procedure-ը։ Payment gate-ը, FIN-03 dedup key-ը, AMD rounding-ը և workflow transition tables-ը business blockers են։

Մանրամասն կանոնները և բաց blockers-ը միայն `docs/00-IMPLEMENTATION-GATE.md`-ում են։
