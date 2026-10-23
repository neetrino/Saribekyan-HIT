# ADR-0001: OpenMRS as the clinical platform foundation

- Status: `GOVERNING_CANONICAL_MODEL_NO_SKELETON`
- Date: 2026-10-19
- Decision ID: D-002/D-003
- Decision owner: Project architecture owner
- Approval evidence: legacy internal decision index only; independent approver record is not attached and `DECISIONS.md` is not evidence
- Implementation authority: Owner-authorized canonical Phase I requirements; TASK-GO is optional review

## Context

Փուլ I-ը պահանջում է միասնական patient registry, visit/encounter history, clinical forms, observations, orders, inpatient/outpatient workflows, roles և API հիմք։ Դրանք զրոյից կառուցելը մեծացնում է բժշկական տվյալների մոդելի, interoperability-ի և ժամանակացույցի ռիսկը։

## Decision

OpenMRS-ը օգտագործվում է որպես HIS-ի clinical platform հիմք, իսկ custom backend development-ի հիմնական լեզուն Java-ն է։ Այս ADR-ը չի ընդունում production OMOD/O3 artifact strategy-ն կամ module tree-ը. extension/package մեխանիզմի ընտրությունը մնում է ADR-0002-ի `Proposed` մաս և ներկայում թույլատրված է միայն D-008 compatibility PoC-ի սահմաններում։

Այս որոշումը չի հաստատում որևէ կոնկրետ OpenMRS release կամ community module version։ Դրանք ընտրվում և pin են արվում միայն հաջող D-008 compatibility PoC-ի immutable evidence review/go որոշումից հետո։ Fit-gap assessment-ը բավարար չէ։

## Consequences

- Patient, Visit, Encounter, Observation, Order, Concept և OpenMRS այլ canonical models-ը նախընտրելի source of truth են։
- Custom schema-ն չի կրկնօրինակում OpenMRS Patient/Person/Visit/Encounter/Obs/Order/Concept clinical entities-ը։ Նոր ADR-ը այս Phase I արգելքից բացառություն ստեղծելու իրավունք չունի. բացառությունը պահանջում է նոր գրավոր scope/change request և governing gate-ի փոփոխություն։
- Distribution composition-ը դառնում է version-controlled deliverable։
- Team-ին անհրաժեշտ է OpenMRS Java/module և O3 ecosystem expertise։
- Upgrade compatibility-ն դառնում է CI/release պարտադիր ստուգում։
- OpenMRS-ի MPL 2.0 + Healthcare Disclaimer և բոլոր երրորդ կողմերի licenses-ը պետք է մտնեն legal/license review-ի մեջ։

## Rejected alternative

Ամբողջ HIS-ը զրոյից անկախ Java application-ով կառուցելը չի ընտրվել՝ clinical platform scope-ի կրկնակի իրականացման և չորսամսյա pilot deadline-ի բարձր ռիսկի պատճառով։
