# ADR-0001: OpenMRS as the clinical platform foundation

- Status: Accepted
- Date: 2026-10-19

## Context

Փուլ I-ը պահանջում է միասնական patient registry, visit/encounter history, clinical forms, observations, orders, inpatient/outpatient workflows, roles և API հիմք։ Դրանք զրոյից կառուցելը մեծացնում է բժշկական տվյալների մոդելի, interoperability-ի և ժամանակացույցի ռիսկը։

## Decision

OpenMRS-ը օգտագործվում է որպես HIS-ի clinical platform հիմք։ Custom backend development-ի հիմնական լեզուն Java-ն է և իրականացվում է OpenMRS-ի extension/module մեխանիզմներով։

Այս որոշումը չի հաստատում որևէ կոնկրետ OpenMRS release կամ community module version։ Դրանք ընտրվում և pin են արվում միայն հաջող D-008 compatibility PoC-ի immutable evidence review/go որոշումից հետո։ Fit-gap assessment-ը բավարար չէ։

## Consequences

- Patient, Visit, Encounter, Observation, Order, Concept և OpenMRS այլ canonical models-ը նախընտրելի source of truth են։
- Custom schema-ն չի կրկնօրինակում OpenMRS clinical entity-ն առանց հիմնավորված ADR-ի։
- Distribution composition-ը դառնում է version-controlled deliverable։
- Team-ին անհրաժեշտ է OpenMRS Java/module և O3 ecosystem expertise։
- Upgrade compatibility-ն դառնում է CI/release պարտադիր ստուգում։
- OpenMRS-ի MPL 2.0 + Healthcare Disclaimer և բոլոր երրորդ կողմերի licenses-ը պետք է մտնեն legal/license review-ի մեջ։

## Rejected alternative

Ամբողջ HIS-ը զրոյից անկախ Java application-ով կառուցելը չի ընտրվել՝ clinical platform scope-ի կրկնակի իրականացման և չորսամսյա pilot deadline-ի բարձր ռիսկի պատճառով։
