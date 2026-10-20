# Project Decisions

Այս ֆայլը բարձր մակարդակի որոշումների ինդեքսն է։ Մանրամասն պատճառաբանությունը պահվում է `architecture/ADR-*.md` ֆայլերում։

Architecture baseline-ը՝ [01-ARCHITECTURE.md](./01-ARCHITECTURE.md), security/privacy սահմանները՝ [06-SECURITY-AND-PRIVACY.md](./06-SECURITY-AND-PRIVACY.md), integration սահմանները՝ [07-INTEGRATIONS.md](./07-INTEGRATIONS.md)։ Այս հղումները որոշումների status չեն փոխում։

| ID | Decision | Status | Record |
|---|---|---|---|
| D-001 | Նախագիծը դասակարգվում է Size C | Approved | `BRIEF.md` |
| D-002 | Clinical platform-ի հիմքը OpenMRS-ն է | Approved | `architecture/ADR-0001-openmrs-foundation.md` |
| D-003 | Custom backend development-ի լեզուն Java-ն է | Approved | `architecture/ADR-0001-openmrs-foundation.md` |
| D-004 | Phase I-ում OpenMRS core fork/patch արգելված է. բացակայող extension point-ի դեպքում կանգ առնել | Approved Phase I boundary | `architecture/ADR-0002-extension-strategy.md` |
| D-005 | Custom backend-ը կառուցվում է OMOD-ներով, UI-ն՝ O3 extension model-ով | Proposed | `architecture/ADR-0002-extension-strategy.md` |
| D-006 | Exact distribution/platform/JVM/DB և OMOD/O3 versions-ը pin են արվելու միայն հաջող D-008 compatibility PoC-ի immutable evidence review/go որոշումից հետո; fit-gap assessment-ը բավարար չէ | Open | `TECH_CARD.md` |
| D-007 | Phase I authentication-ը native OpenMRS է. external IdP/Keycloak-ը Phase I-ից դուրս է | Accepted | `architecture/ADR-0003-identity-boundary.md` |
| D-008 | Առաջին implementation-ը մեկ pilot OMOD/O3 compatibility PoC է | Approved gate | `00-IMPLEMENTATION-GATE.md` |
| D-009 | Phase I-ի 7 ownership boundaries-ն են REG, AMB, INP, DIA, FIN, REP, ADM. Audit-ը cross-cutting է | Approved baseline | `00-IMPLEMENTATION-GATE.md` |
