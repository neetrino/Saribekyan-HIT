# API Design

## API surfaces

| Surface | Consumer | Rule |
|---|---|---|
| Java service API | Backend modules | Առաջնային cross-module contract |
| OpenMRS REST | O3/internal UI | Օգտագործել միայն semantic fit-ի դեպքում |
| FHIR R4/FHIR2 | Healthcare interoperability | Profile/use-case validation-ից հետո |
| Custom `/api/v1/...` facade | Հաստատված custom/external workflows | Narrow, versioned և documented |
| File contract | Approved import/export | Schema, checksum և reconciliation-ով |

OpenMRS API-ն wrapper-ով կրկնել պետք չէ, եթե առկա surface-ը բավարար է։ Ներքին OpenMRS REST endpoint-ը արտաքին public API չի համարվում ինքնաբերաբար։

## Custom facade HTTP contract

Այս և հաջորդ բաժինների envelope/pagination կանոնները վերաբերում են միայն custom versioned facade-ին։ OpenMRS REST/FHIR-ի առկա contract-ը չի վերափաթեթավորվում միայն ձևաչափը միասնական դարձնելու համար։ Native pagination-ը, error semantics-ը և void/retire վարքը պահպանվում են և documented adapter է ստանում միայն կոնկրետ հաստատված use case-ի դեպքում։

- JSON UTF-8, ISO-8601 timestamps with offset/UTC և documented code systems։
- Request-ը ունի կամ ստանում է correlation ID, որը վերադարձվում է response header-ում։ Client-supplied ID-ն validation է անցնում կամ փոխարինվում է։
- Write request-ը server-side schema և semantic validation է անցնում։ Unknown fields-ի policy-ն explicit է։
- Resource identifier-ը opaque stable ID է. database sequence-ը contract չի դառնում առանց հիմնավորման։
- Success response-ը կարող է վերադարձնել resource կամ operation result, բայց մեկ endpoint-ում ձևը կայուն է։
- `204` response-ը body չունի։

## Error envelope

```json
{
  "error": {
    "code": "STABLE_MACHINE_CODE",
    "message": "Safe human-readable message.",
    "correlationId": "...",
    "fields": [{ "path": "field.name", "code": "INVALID" }]
  }
}
```

`fields`-ը optional է։ Response-ը չի ներառում stack trace, SQL, secret կամ unnecessary clinical value։ Suggested status mapping՝ `400` validation, `401` unauthenticated, `403` forbidden, `404` hidden/not found, `409` state conflict/duplicate, `422` semantic clinical rejection, `429` limited, `503` unavailable dependency։ Exact OpenMRS error adaptation-ը pilot-ի մաս է։

## Collection queries

- Custom facade-ում cursor pagination-ը նախընտրելի է փոփոխվող մեծ ցուցակների համար, իսկ offset-ը թույլատրելի է փոքր reference lists-ում։ OpenMRS native endpoint-ի `startIndex`/`limit` contract-ը չի փոխվում։
- `limit`-ն ունի default և maximum։
- Sort fields-ը allowlist են և ունեն stable tie-breaker։
- Filter/search syntax-ը endpoint contract-ում է, raw query կամ arbitrary property path չի ընդունվում։
- Response-ը հստակ տարբերակում է items-ը և next cursor/total availability-ն։ Expensive total count-ը պարտադիր չէ յուրաքանչյուր request-ում։

## Concurrency and state transitions

Clinical/financial resource update-ը պետք է ունենա version/ETag կամ համարժեք optimistic locking, երբ lost update-ը վտանգավոր է։ State transition endpoint-ը ընդունում է նպատակային գործողությունը և պատճառը, ոչ arbitrary status overwrite։ Duplicate-sensitive create/import/integration operations-ը ունեն idempotency key և request fingerprint, երբ retry է սպասվում։

## Security and audit

Յուրաքանչյուր endpoint ունի authentication, required privilege, resource/location/care-context scope և audit classification։ Sensitive resource-ի չթույլատրված որոնումը չպետք է բացահայտի դրա գոյությունը։ Export/print և break-glass operation-ները առանձին permission/audit ունեն։

## Contract lifecycle

- Custom external API-ն փաստագրվում է OpenAPI-ով և contract tests-ով։
- FHIR surface-ը հրապարակում է supported resources/profiles/operations և conformance evidence։
- Breaking change-ը նոր major version կամ migration window է պահանջում։
- Deprecation-ը ունի owner, consumers list, deadline և telemetry։
- Contract-first review-ը ստուգում է PHI minimization, authorization, idempotency և failure semantics-ը։

## Endpoint documentation template

Յուրաքանչյուր operation-ի համար նշվում են requirement ID, owner module, actor/use case, request/response schema, permission/scope, validation, state transition, transactional boundary, audit event, idempotency, errors և automated/UAT tests։

## Phase I boundary

Phase I-ում կառուցվում է համաձայնեցված integration interface-ի API հիմքն ու documentation-ը։ ARMED/LIS/PACS/device/payment connector-ի endpoint-ը չի ավելացվում որպես scope, եթե չկա հաստատված change request։
