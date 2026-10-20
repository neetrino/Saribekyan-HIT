# ADR-0002: Extend OpenMRS through modules and O3 extensions

- Status: Proposed — OMOD/O3 extension strategy and pilot PoC only. The no-fork rule below is an Approved Phase I boundary and is not proposed.
- Date: 2026-10-19
- Decision owner: Project architecture owner
- Acceptance approver/date/evidence: TBD — coding agent may not fill or self-approve
- Implementation authority: D-008 PoC only until independent acceptance and task go record

## Context

Նախագիծը պահանջում է հայկական clinical workflows, finance, reporting, audit և documents, որոնք ամբողջությամբ չեն փակվում OpenMRS-ի մեկ պատրաստի distribution-ով։ Միաժամանակ OpenMRS core-ի ուղղակի փոփոխումը դժվարացնում է upgrades-ը և security fixes-ը։

## Approved Phase I boundary

Այս բաժինը D-004-ն է։ Այն կախված չէ ստորև բերված Proposed ռազմավարության ընդունումից։

- Phase I-ում չfork անել և չpatch անել OpenMRS core-ը՝ անկախ public extension point-ի առկայությունից։ Բացակայող extension point-ը կանգ առնելու պատճառ է, ոչ core-ը փոխելու թույլտվություն։
- Առանձին ADR-ը, upstream status-ը կամ upgrade plan-ը ներկայիս scope-ի ներսում core patch-ի բացառություն չեն ստեղծում։ Ապագա core փոփոխությունը կարող է քննարկվել միայն նոր գրավոր scope/change request-ի հաստատումից հետո՝ առանձին ADR-ով և upgrade-impact review-ով։

Այստեղ `core patch`-ը OpenMRS core source code-ի փոփոխությունն է։ D-008 compatibility spec-ի reviewable distro/assembly configuration patch-երը core patch չեն և թույլատրված են միայն ignored work copy-ի ու այդ spec-ի սահմաններում։

## Proposed decision

- Backend custom capabilities-ը կառուցել Java OMOD modules-ով։
- Frontend custom capabilities-ը կառուցել O3 frontend modules, routes, extensions և workspaces-ով։
- Metadata, concepts, forms, locations, roles և configuration-ը պահել version-controlled distribution content-ում։

Այս ADR-ի Proposed մասը ամբողջ repository/module tree-ը կառուցելու թույլտվություն չէ։ Մինչ acceptance-ը թույլատրված հաջորդ քայլը միայն մեկ pilot OMOD + O3 extension compatibility PoC-ն է՝ [implementation gate](../00-IMPLEMENTATION-GATE.md)-ի սահմաններով։ Եթե Proposed որոշումը մերժվի, մերժումը business module-ի այլ ճարտարապետություն չի թույլատրում։ Փոխարինող փաթեթավորում այս ADR-ում չկա, և ագենտը այն չի հորինում։

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

PoC-ի հաջողությունը միայն acceptance proposal է։ Status transition-ը կատարում է decision owner-ից անկախ նշանակված approver-ը՝ review record-ի հղումով։ Առանց approver/date/evidence-ի `Accepted` բառի ձեռքով ավելացումը անվավեր է։
