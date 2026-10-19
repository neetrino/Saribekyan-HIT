# Security and Privacy

## Scope

Սա Phase I-ի security/privacy architecture baseline-ն է, ոչ իրավաբանական համապատասխանության հավաստագիր։ Retention-ը, իրավական հիմքերը և regulatory controls-ը հաստատում են պատվիրատուի համապատասխան պատասխանատուները։ Պաշտպանվող տվյալներն են patient/clinical/financial data-ն, credentials/sessions/secrets-ը, audit-ը, reports/exports-ը և backups-ը։

## Trust and identity

Browser, proxy, O3/OpenMRS runtime, identity provider, database, file storage և external integration-ը առանձին trust boundaries են։ Client input-ը, files-ը, forwarded headers-ը և external payload-ը trusted չեն առանց verification-ի։

- Յուրաքանչյուր աշխատակից ունի անհատական account. shared clinical accounts չեն թույլատրվում։
- Native OpenMRS կամ external IdP տարբերակը PoC-ից հետո է հաստատվում։ IdP-ն չի վերացնում OpenMRS user/role/privilege lifecycle-ը։
- Privileged access-ի համար MFA-ն baseline պահանջ է։
- Joiner/mover/leaver, session timeout/revocation և service identities-ը պետք է լինեն բացահայտ և թեստավորված։

## Authorization

Որոշումը ներառում է principal-ը, role/privilege-ը, action/resource-ը, location/department/service scope-ը, care relationship-ը և record state-ը։ Default-ը deny է, կանոնը կիրառվում է backend-ում։ Admin լինելը ինքնաբերաբար clinical superuser լինել չէ։

Break-glass access-ը պահանջում է պատճառ, սահմանափակ time/scope, առանձին audit event և հետագա review/alert։

## Audit baseline

| Event | Minimum evidence |
|---|---|
| Login/logout/failure/MFA | actor, time, result, safe request context |
| Patient record read | actor, patient, purpose/context, time |
| Create/update/void/correct/approve | actor, resource, action, controlled diff/reference, time |
| Role/config change | actor, target, old/new value, time |
| Report/export/print | actor, report, filters/scope, result, time |
| Break-glass | actor, scope, reason, start/end, review |
| Integration action | system identity, contract/version, correlation ID, result |

Audit-ում password/token/session secret կամ անհարկի ամբողջ clinical payload չի պահվում։ Այն պաշտպանվում է սովորական update/delete-ից և ունի access, retention ու review policy։ OpenMRS-ի առկա history/audit հնարավորությունները առանձին PoC են պահանջում sensitive reads, exports, break-glass և custom domains-ի համար։

## Integrity and privacy

- Approved medical record-ը ուղղվում է amendment/correction-ով՝ պահելով նախկին տարբերակը և պատճառը։
- Financial correction-ը traceable reversal/refund է։
- Internal confirmation + audit-ը Phase I baseline-ն է. qualified e-signature connector-ը դուրս է scope-ից առանց change request-ի։
- TLS network boundaries-ում, at-rest encryption DB/files/backups-ի համար, secrets-ը՝ repository/log-ից դուրս։
- Production data-ը non-production-ում միայն approved masking/anonymization-ով։
- Patient search, logs, exports և prints-ը հետևում են data minimization-ին։

## Application and operational controls

- server-side schema/semantic validation և parameterized persistence,
- CSRF protection session cookie-ի դեպքում, strict CORS/trusted proxy,
- rate/abuse limits login, search, export և integrations-ի համար,
- stable error codes, correlation ID, sanitized responses,
- upload size/type validation և malware-scanning strategy,
- separate environment credentials, least-privilege runtime/DB users,
- centralized logs/alerts, dependency/security scanning,
- patch/update process, backup schedule և restore drill,
- incident runbook՝ containment, evidence, notification և recovery քայլերով։

## Acceptance evidence and open decisions

Մինչ production-ը ապացուցվում են denial/scope tests, session revocation, privileged MFA, audit completeness, export controls, secrets/dependency scans, restore և break-glass review։ Բաց են identity provider-ը, permission/location matrix-ը, audit retention/store-ը, privacy retention-ը, file scanning-ը, encryption key ownership-ը, RPO/RTO-ն և incident owners-ը։
