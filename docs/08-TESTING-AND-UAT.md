# Testing and UAT baseline

## Status

`ACTIVE_DELIVERY_BASELINE`. Այս փաստաթուղթը owner-authorized Phase I implementation-ի verification կանոնն է։ Signature verification կամ TASK-GO prerequisite չկա։ Թեստավորման բաց evidence-ը կանգնեցնում է միայն այն slice-ի completion/release claim-ը, որի համար այդ evidence-ը պահանջվում է։

## Test layers

| Layer | Minimum evidence |
|---|---|
| Java/module | Maven compile և կիրառելի unit/integration tests |
| Distribution | Clean build, OMOD inclusion, application startup և health check |
| Frontend configuration | JSON/config validation և O3 shell load առանց fatal console error-ի |
| Browser flow | Playwright՝ user-visible happy path, validation, permission boundary և կարևոր regression |
| UAT | Requirement ID, role, preconditions, քայլեր, expected result և captured result |

Թեստը հղվում է requirement ID-ին և ստուգված commit/diff-ին։ Մեկ feature-ի failing test-ը unrelated feature-ի development-ը չի կանգնեցնում, բայց այդ feature-ը չի հայտարարվում complete։

## Current REG-02 verification state

Committed evidence՝

- `openmrs-distro-referenceapplication/frontend/config-core_demo.json` — date-of-birth field և telephone person-attribute configuration,
- `openmrs-distro-referenceapplication/frontend/startup.sh` — telephone attribute value-ի փոխանցում գործող O3 patient-search query-ին։

Դեռ պահանջվում է՝

1. Playwright test՝ existing patient-ի telephone value-ով որոնման համար,
2. Playwright test՝ միայն date of birth-ով որոնման համար,
3. fresh-database test՝ telephone attribute type-ի `searchable=true` reproducible bootstrap/migration-ի համար,
4. negative test՝ չհամընկնող հեռախոս/ծննդյան ամսաթիվ։

Այս բացերը REG-02-ը պահում են partial վիճակում և չեն չեղարկում արդեն ընդունված O3 configuration-ը։

## Completion evidence

Feature completion record-ը ներառում է test command-ը, exit code-ը, Playwright report/screenshot կամ trace-ը, environment/runtime versions-ը և known residual risks-ը։ QA-ն չի փոխում business requirement-ը. անհամապատասխանությունը վերադարձնում է implementation-ին։
