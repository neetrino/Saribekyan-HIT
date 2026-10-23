# ADR-0002: Extend OpenMRS through modules and O3 extensions

- Status: Accepted as-built — OMOD backend and O3 extension strategy are present in the working repository/runtime. The no-fork rule below remains an Approved Phase I boundary.
- Date: 2026-10-19
- Decision owner: Project architecture owner
- Acceptance evidence: repository owner-authorized implementation; `openmrs-module-saribekyan/`, `openmrs-distro-referenceapplication/`, Reference Application 3.7.1 / Platform 2.8.8 / Java 21 build configuration
- Implementation authority: owner-authorized Phase I development; this ADR governs only slices dependent on its extension-strategy decision

## Context

Նախագիծը պահանջում է հայկական clinical workflows, finance, reporting, audit և documents, որոնք ամբողջությամբ չեն փակվում OpenMRS-ի մեկ պատրաստի distribution-ով։ Միաժամանակ OpenMRS core-ի ուղղակի փոփոխումը դժվարացնում է upgrades-ը և security fixes-ը։

## Approved Phase I boundary

Այս բաժինը D-004-ն է և շարունակում է գործել ընդունված extension strategy-ի հետ միասին։

- Phase I-ում չfork անել և չpatch անել OpenMRS core-ը՝ անկախ public extension point-ի առկայությունից։ Բացակայող extension point-ը կանգ առնելու պատճառ է, ոչ core-ը փոխելու թույլտվություն։
- Առանձին ADR-ը, upstream status-ը կամ upgrade plan-ը ներկայիս scope-ի ներսում core patch-ի բացառություն չեն ստեղծում։ Ապագա core փոփոխությունը կարող է քննարկվել միայն նոր գրավոր scope/change request-ի հաստատումից հետո՝ առանձին ADR-ով և upgrade-impact review-ով։

Այստեղ `core patch`-ը OpenMRS core source code-ի փոփոխությունն է։ D-008 compatibility spec-ի reviewable distro/assembly configuration patch-երը core patch չեն և թույլատրված են միայն ignored work copy-ի ու այդ spec-ի սահմաններում։

## Accepted decision

- Backend custom capabilities-ը կառուցել Java OMOD modules-ով։
- Frontend custom capabilities-ը կառուցել O3 frontend modules, routes, extensions և workspaces-ով։
- Metadata, concepts, forms, locations, roles և configuration-ը պահել version-controlled distribution content-ում։

Այս որոշումը հաստատում է գործող extension mechanism-ը, բայց requirement ownership group-երից ինքնաբերաբար module count կամ ամբողջ business module tree չի ստեղծում։ Նոր module-ը ստեղծվում է միայն կոնկրետ Phase I capability-ի անհրաժեշտությունից։ D-008 PoC-ը պահվում է որպես պատմական compatibility evidence, ոչ development-ի միակ թույլատրելի քայլ։

## Module boundary rule

Յուրաքանչյուր **production business custom module** պետք է ունենա՝

- հստակ business ownership,
- public Java/API contract,
- սեփական Liquibase changesets միայն եթե ունի module-owned schema,
- privilege և audit mapping,
- compatibility tests ընտրված distribution-ի հետ,
- uninstall/upgrade/data-retention սահմանված վարք։

## Continuing validation

Ընդունված as-built ռազմավարությունը չի ապացուցում յուրաքանչյուր ապագա module-ի migration, module-owned schema, business ownership, privilege կամ audit mapping-ը։ Դրանք ստուգվում են համապատասխան feature slice-ի implementation և review-ի ժամանակ։ Stack/module version-ի փոփոխությունը պահանջում է clean build, load/start և frontend wiring compatibility verification։ [COMPATIBILITY-POC.md](../pilot/COMPATIBILITY-POC.md)-ն մնում է պատմական PoC procedure/evidence contract։
