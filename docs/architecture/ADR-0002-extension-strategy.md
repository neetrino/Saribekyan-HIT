# ADR-0002: Extend OpenMRS through modules and O3 extensions

- Status: Proposed — pilot PoC only
- Date: 2026-10-19

## Context

Նախագիծը պահանջում է հայկական clinical workflows, finance, reporting, audit և documents, որոնք ամբողջությամբ չեն փակվում OpenMRS-ի մեկ պատրաստի distribution-ով։ Միաժամանակ OpenMRS core-ի ուղղակի փոփոխումը դժվարացնում է upgrades-ը և security fixes-ը։

## Proposed decision

- Backend custom capabilities-ը կառուցել Java OMOD modules-ով։
- Frontend custom capabilities-ը կառուցել O3 frontend modules, routes, extensions և workspaces-ով։
- Metadata, concepts, forms, locations, roles և configuration-ը պահել version-controlled distribution content-ում։
- Չփոփոխել OpenMRS core-ը, եթե նույն արդյունքը հնարավոր է public extension point-ով։
- Core patch-ը թույլատրել միայն առանձին ADR-ով, upstream status-ով և upgrade plan-ով։

Այս ADR-ը ամբողջ repository/module tree-ը կառուցելու թույլտվություն չէ։ Մինչ acceptance-ը թույլատրված հաջորդ քայլը միայն մեկ pilot OMOD + O3 extension compatibility PoC-ն է՝ [implementation gate](../00-IMPLEMENTATION-GATE.md)-ի սահմաններով։

## Module boundary rule

Յուրաքանչյուր custom module պետք է ունենա՝

- հստակ business ownership,
- public Java/API contract,
- սեփական Liquibase changesets միայն module-owned schema-ի համար,
- privilege և audit mapping,
- compatibility tests ընտրված distribution-ի հետ,
- uninstall/upgrade/data-retention սահմանված վարք։

## Validation required

Այս ADR-ը `Accepted` կդառնա միայն այն բանից հետո, երբ մեկ pilot module-ով ապացուցվեն OMOD build/install/migration/API և O3 extension ամբողջական շղթան։
