# Module: `openmrs-module-saribekyan`

## Status and ownership

- Lifecycle: `AS_BUILT_FOUNDATION`
- Type: `custom`
- Owner: Saribekyan HIS Phase I implementation
- Requirement IDs: none claimed by the current empty activator foundation
- OpenMRS Platform version: `2.8.8`
- Java release: `21`
- Module version: `1.0.0-SNAPSHOT`
- Artifact: Maven multi-module project with `api` and `omod`
- Decision/ADR: D-005 / ADR-0002 (`ACCEPTED_AS_BUILT` extension strategy)
- Open blockers: business services, privileges, schema, workflows and APIs are added only by their implementing requirement slices

## Evidence

- `openmrs-module-saribekyan/pom.xml`
- `openmrs-module-saribekyan/api/pom.xml`
- `openmrs-module-saribekyan/omod/pom.xml`
- `openmrs-module-saribekyan/omod/src/main/resources/config.xml`
- `openmrs-module-saribekyan/omod/src/main/java/org/openmrs/module/saribekyan/SaribekyanActivator.java`
- distribution inclusion through `openmrs-distro-referenceapplication/`

## Purpose and non-goals

Այս artifact-ը Phase I custom Java capabilities-ի ընդունված OMOD foundation-ն է։ Ներկա դատարկ activator-ը որևէ REG/AMB/INP/DIA/FIN/REP/ADM requirement-ի completion չի ապացուցում, և ownership group-երից մեկական module ստեղծելու կանոն չի սահմանում։

OpenMRS Patient/Person/Visit/Encounter/Obs/Order/Concept մոդելների parallel JPA պատճեններ, OpenMRS core patch և core/module tables-ի ad-hoc direct SQL-ը non-goals են։

## Current contracts and data

- Public Java API: none yet
- REST/FHIR/custom endpoint: none yet
- Module-owned tables/Liquibase changesets: none yet
- New privileges: none yet
- Business workflow/status model: none yet

Այս բաժինները թարմացվում են implementation-ի հետ նույն change-ում։ Նոր capability-ն հղվում է իր requirement ID-ին, permissions/audit-ին, tests-ին և իրական data ownership-ին։
