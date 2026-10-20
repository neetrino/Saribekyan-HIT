# ADR-0002: Extend OpenMRS through modules and O3 extensions

- Status: Proposed — pilot PoC only
- Date: 2026-10-19

## Context

Նախագիծը պահանջում է հայկական clinical workflows, finance, reporting, audit և documents, որոնք ամբողջությամբ չեն փակվում OpenMRS-ի մեկ պատրաստի distribution-ով։ Միաժամանակ OpenMRS core-ի ուղղակի փոփոխումը դժվարացնում է upgrades-ը և security fixes-ը։

## Proposed decision

- Backend custom capabilities-ը կառուցել Java OMOD modules-ով։
- Frontend custom capabilities-ը կառուցել O3 frontend modules, routes, extensions և workspaces-ով։
- Metadata, concepts, forms, locations, roles և configuration-ը պահել version-controlled distribution content-ում։
- Phase I-ում չfork անել և չpatch անել OpenMRS core-ը՝ անկախ public extension point-ի առկայությունից։ Բացակայող extension point-ը կանգ առնելու պատճառ է, ոչ core-ը փոխելու թույլտվություն։
- Առանձին ADR-ը, upstream status-ը կամ upgrade plan-ը ներկայիս scope-ի ներսում core patch-ի բացառություն չեն ստեղծում։ Ապագա core փոփոխությունը կարող է քննարկվել միայն նոր գրավոր scope/change request-ի հաստատումից հետո՝ առանձին ADR-ով և upgrade-impact review-ով։

Այստեղ `core patch`-ը OpenMRS core source code-ի փոփոխությունն է։ D-008 compatibility spec-ի reviewable distro/assembly configuration patch-երը core patch չեն և թույլատրված են միայն ignored work copy-ի ու այդ spec-ի սահմաններում։

Այս ADR-ը ամբողջ repository/module tree-ը կառուցելու թույլտվություն չէ։ Մինչ acceptance-ը թույլատրված հաջորդ քայլը միայն մեկ pilot OMOD + O3 extension compatibility PoC-ն է՝ [implementation gate](../00-IMPLEMENTATION-GATE.md)-ի սահմաններով։

## Module boundary rule

ADR-ի ընդունումից հետո յուրաքանչյուր **production business custom module** պետք է ունենա՝

- հստակ business ownership,
- public Java/API contract,
- սեփական Liquibase changesets միայն եթե ունի module-owned schema,
- privilege և audit mapping,
- compatibility tests ընտրված distribution-ի հետ,
- uninstall/upgrade/data-retention սահմանված վարք։

## Validation required

Այս ADR-ը `Accepted` կդառնա միայն այն բանից հետո, երբ D-008 disposable pilot-ով ապացուցվեն OMOD build/install/start/API և O3 extension ամբողջական շղթան։ Pilot-ը migration, module-owned schema, business ownership, նոր privilege կամ audit mapping չի ապացուցում և դրանք չի ստեղծում։ Դրանք հետագա production business module-ների կանոններ են։ Pilot-ի acceptance evidence-ը սահմանվում է միայն [COMPATIBILITY-POC.md](../pilot/COMPATIBILITY-POC.md)-ով։
