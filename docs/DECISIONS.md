# Project Decisions

> Այս index-ը navigation summary է, ոչ approval evidence, business scope կամ task go record։ ADR-ի և այս index-ի փոխադարձ հղումները անկախ հաստատում չեն։ `Approved`/`Accepted` technical decision-ը կիրառվում է միայն իր սահմաններում և չի կարող ինքնուրույն ստեղծել business requirement։ Status transition/approver կանոնները՝ `governance/README.md`։

Այս ֆայլը բարձր մակարդակի որոշումների ինդեքսն է։ Մանրամասն պատճառաբանությունը պահվում է `architecture/ADR-*.md` ֆայլերում։

Architecture baseline-ը՝ [01-ARCHITECTURE.md](./01-ARCHITECTURE.md), security/privacy սահմանները՝ [06-SECURITY-AND-PRIVACY.md](./06-SECURITY-AND-PRIVACY.md), integration սահմանները՝ [07-INTEGRATIONS.md](./07-INTEGRATIONS.md)։ Այս հղումները որոշումների status չեն փոխում։

| ID | Decision | Status | Record |
|---|---|---|---|
| D-001 | Նախագիծը դասակարգվում է Size C | `APPROVED_CONSTRAINT` | `BRIEF.md` |
| D-002 | Clinical platform-ի հիմքը OpenMRS-ն է | `GOVERNING_CANONICAL_MODEL_NO_SKELETON` | `architecture/ADR-0001-openmrs-foundation.md` |
| D-003 | Custom backend development-ի լեզուն Java-ն է | `APPROVED_CONSTRAINT` | `architecture/ADR-0001-openmrs-foundation.md` |
| D-004 | Phase I-ում OpenMRS core fork/patch արգելված է. բացակայող extension point-ի դեպքում կանգ առնել | `GOVERNING_GUARDRAIL` | `architecture/ADR-0002-extension-strategy.md` |
| D-005 | Custom backend-ը կառուցվում է OMOD-ներով, UI-ն՝ O3 extension model-ով | `ACCEPTED_AS_BUILT` | `architecture/ADR-0002-extension-strategy.md`, repository module/frontend structure |
| D-006 | Գործող runtime pin-ն է Reference Application 3.7.1, OpenMRS Platform 2.8.8 և Java 21. OMOD/O3 versions-ի source of truth-ը committed distribution manifests/build configuration-ն է | `ACCEPTED_AS_BUILT` | `TECH_CARD.md`, `openmrs-distro-referenceapplication/pom.xml`, `openmrs-distro-referenceapplication/distro/pom.xml`, `openmrs-distro-referenceapplication/Dockerfile`, `openmrs-module-saribekyan/pom.xml` |
| D-007 | Phase I authentication-ը native OpenMRS է. external IdP/Keycloak-ը Phase I-ից դուրս է | `GOVERNING_GUARDRAIL` | `architecture/ADR-0003-identity-boundary.md` |
| D-008 | Disposable OMOD/O3 compatibility PoC-ն սահմանափակ technical profile է և business development-ի միակ թույլատրելի task-ը չէ | `D008_POC_ONLY` | `00-IMPLEMENTATION-GATE.md` |
| D-009 | Phase I-ի 7 ownership boundaries-ն են REG, AMB, INP, DIA, FIN, REP, ADM. Audit-ը cross-cutting է | `GOVERNING_GUARDRAIL` | `00-IMPLEMENTATION-GATE.md` |
| D-010 | Production DB engine/version compatibility-ն մնում է infrastructure decision և չի չեղարկում ընդունված distribution/platform/JVM pin-ը | `BLOCKED_FOR_DEPENDENT_INFRASTRUCTURE_ONLY` | `TECH_CARD.md` |
