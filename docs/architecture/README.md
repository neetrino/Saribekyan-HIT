# Architecture records

ADR status transition-ը կարգավորվում է `../governance/README.md`-ով։ Coding agent-ը չի կարող սեփական PoC/result-ի հիման վրա ADR-ը դարձնել `Accepted`։ Յուրաքանչյուր `Accepted` ADR պարտադիր ունի decision owner, approver, approval date և immutable review evidence։ Այդ metadata-ի բացակայության դեպքում ADR-ը պահպանում է միայն իր բացահայտ guardrail-ը և business implementation չի authorise անում։ ADR-ը երբեք business scope չի ստեղծում։

Այս պանակը պահում է համակարգի երկարաժամկետ տեխնիկական որոշումների ADR-ները։ Ընդհանուր կառուցվածքը՝ [01-ARCHITECTURE.md](../01-ARCHITECTURE.md)։

| ADR | Decision | Status |
|---|---|---|
| [ADR-0001](./ADR-0001-openmrs-foundation.md) | OpenMRS clinical foundation | Accepted |
| [ADR-0002](./ADR-0002-extension-strategy.md) | Distribution/modules over core fork | OMOD/O3 strategy is Proposed; no-fork rule is Approved Phase I boundary. D-008 authorizes one pilot PoC only |
| [ADR-0003](./ADR-0003-identity-boundary.md) | Native OpenMRS identity boundary for Phase I | Accepted |

Նոր ADR է պետք, երբ որոշումը փոխում է data ownership-ը, deployment/security boundary-ն, integration contract-ը, availability/scaling model-ը կամ OpenMRS upgrade path-ը։
