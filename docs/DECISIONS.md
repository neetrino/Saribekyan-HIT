# Project Decisions

Այս ֆայլը բարձր մակարդակի որոշումների ինդեքսն է։ Մանրամասն պատճառաբանությունը պահվում է `architecture/ADR-*.md` ֆայլերում։

Architecture baseline-ը՝ [01-ARCHITECTURE.md](./01-ARCHITECTURE.md), security/privacy սահմանները՝ [06-SECURITY-AND-PRIVACY.md](./06-SECURITY-AND-PRIVACY.md), integration սահմանները՝ [07-INTEGRATIONS.md](./07-INTEGRATIONS.md)։ Այս հղումները որոշումների status չեն փոխում։

| ID | Decision | Status | Record |
|---|---|---|---|
| D-001 | Նախագիծը դասակարգվում է Size C | Approved | `BRIEF.md` |
| D-002 | Clinical platform-ի հիմքը OpenMRS-ն է | Approved | `architecture/ADR-0001-openmrs-foundation.md` |
| D-003 | Custom backend development-ի լեզուն Java-ն է | Approved | `architecture/ADR-0001-openmrs-foundation.md` |
| D-004 | OpenMRS core-ը չի fork արվում սովորական feature development-ի համար | Proposed | `architecture/ADR-0002-extension-strategy.md` |
| D-005 | Custom backend-ը կառուցվում է OMOD-ներով, UI-ն՝ O3 extension model-ով | Proposed | `architecture/ADR-0002-extension-strategy.md` |
| D-006 | Exact distribution/module versions-ը pin են արվելու PoC-ից հետո | Open | `TECH_CARD.md` |
| D-007 | Keycloak-ը թեկնածու է, բայց դեռ հաստատված identity solution չէ | Open | `architecture/ADR-0003-identity-boundary.md` |
