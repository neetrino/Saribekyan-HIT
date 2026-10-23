# Security and Privacy

> **Կարգավիճակ:** target security/privacy design և review checklist է, ոչ նոր business scope։ Կիրառելի implementation-ը վերցվում է owner-authorized canonical ՏԱ-ից։ Signature verification-ը, implementation-gate verdict-ը և TASK-GO-ն pre-code prerequisites չեն։ Այս ֆայլը չի թույլատրում հորինել session/password timeout, joiner/mover/leaver workflow, break-glass duration/scope, retention, encryption կամ այլ բաց security/privacy արժեք։ D-008 compatibility PoC-ի security սահմանը կարգավորվում է միայն PoC spec-ով։

> **Rule classification:** native OpenMRS authentication/no-external-IdP սահմանը և server-side authorization սկզբունքը governing constraints են։ At-rest encryption, malware scanning, rate limits, centralized alerts, incident runbook և այլ checklist կետերը `PROPOSED_DESIGN` են մինչև source requirement, owner, measurable acceptance և task go record-ը հաստատվեն։

## Scope

Սա Phase I-ի նպատակային security/privacy architecture baseline-ն է, ոչ as-built նկարագիր, implementation հրահանգ կամ իրավաբանական համապատասխանության հավաստագիր։ Retention-ը, իրավական հիմքերը և regulatory controls-ը հաստատում են պատվիրատուի համապատասխան պատասխանատուները։ Պաշտպանվող տվյալներն են patient/clinical/financial data-ն, credentials/sessions/secrets-ը, audit-ը, reports/exports-ը և backups-ը։

## Trust and identity

Browser, proxy, O3/OpenMRS runtime, database, file storage և external integration-ը առանձին trust boundaries են։ Ապագա external identity provider-ը, եթե երբևէ հաստատվի առանձին փուլով, նույնպես առանձին boundary կլինի։ Client input-ը, files-ը, forwarded headers-ը և external payload-ը trusted չեն առանց verification-ի։

- Յուրաքանչյուր աշխատակից ունի անհատական account. shared clinical accounts չեն թույլատրվում։
- Phase I authentication-ը native OpenMRS է։ External IdP/Keycloak integration-ը Phase I-ից դուրս է։
- MFA-ն Phase I-ում պահանջվում է միայն այն դեպքում, երբ ընտրված native OpenMRS լուծումն այն արդեն ապահովում է առանց վճարովի արտաքին integration-ի։ Սեփական TOTP/SMS layer չի կառուցվում, SMS provider չի ավելացվում։
- Հաստատված պահանջ լինելու դեպքում joiner/mover/leaver, session timeout/revocation և service identities-ը պետք է ունենան բացահայտ, թեստավորվող policy։ Այս ֆայլը դրանց թվային արժեքը կամ workflow semantics-ը չի սահմանում։

## Authorization

Որոշումը ներառում է principal-ը, role/privilege-ը, action/resource-ը, location/department/service scope-ը, care relationship-ը և record state-ը։ Default-ը deny է, կանոնը կիրառվում է backend-ում։ Admin լինելը ինքնաբերաբար clinical superuser լինել չէ։

Break-glass-ը target control է՝ պատճառի, սահմանափակ time/scope-ի, առանձին audit event-ի և հետագա review/alert-ի գաղափարով։ Exact duration-ը, scope-ը, eligibility-ն և review/alert workflow-ը տվյալ behavior-ի blockers են մինչև canonical պահանջ կամ Approved որոշում, բայց unrelated development-ը չեն կանգնեցնում։

## Audit baseline

| Event | Minimum evidence |
|---|---|
| Login/logout/failure և native MFA, եթե առկա է | actor, time, result, safe request context |
| Create/update/void/correct/approve | actor, resource, action, controlled diff/reference, time |
| Role/config change | actor, target, old/new value, time |
| Report/export/print | actor, report, filters/scope, result, time |
| Break-glass | actor, scope, reason, start/end, review |
| Integration action | system identity, contract/version, correlation ID, result |

Audit-ում password/token/session secret կամ անհարկի ամբողջ clinical payload չի պահվում։ Այն պաշտպանվում է սովորական update/delete-ից և ունի access, retention ու review policy։ Phase I minimum-ը ADM-10 action/user/time/object/available old-new value-ն է՝ գումարած export և break-glass։ Ամեն դիտման audit-ը performance/privacy/retention որոշումից առաջ չի միացվում։

## Integrity and privacy

- Approved medical record-ը ուղղվում է amendment/correction-ով՝ պահելով նախկին տարբերակը և պատճառը։
- Financial correction-ը traceable reversal/refund է։
- Internal confirmation + audit-ը canonical Phase I requirement է, որի permission/workflow semantics-ը պետք է լուծված լինի տվյալ slice-ի համար. contract signature-ը կամ TASK-GO-ն prerequisite չեն։ Qualified e-signature connector-ը դուրս է scope-ից առանց change request-ի։
- TLS-ը network boundaries-ի governing requirement է, secrets-ը repository/log-ից դուրս են։ DB/files/backups at-rest encryption-ը `PROPOSED_DESIGN` է և չի իրականացվում մինչև provider/scope, key ownership/custody, rotation/recovery և acceptance evidence-ը գրավոր հաստատված չեն։
- Production data-ը non-production-ում միայն approved masking/anonymization-ով։
- Patient search, logs, exports և prints-ը հետևում են data minimization-ին։

## Candidate application and operational controls — approval required

Այս ցուցակը security review prompts է, ոչ միանգամից իրականացվող Phase I checklist։ Յուրաքանչյուր կետ կիրառվում է միայն traceable requirement, threat/risk rationale, owner, configuration values, acceptance test և task go record ունենալու դեպքում։ Agent-ը այս ցանկից dependency, proxy, scanner, rate limiter, encryption կամ incident platform չի ավելացնում։

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

Մինչ production-ը ապացուցվում են denial/scope tests, session revocation, audit completeness, export controls, secrets/dependency scans, restore և break-glass review։ Եթե ընտրված native stack-ը MFA ունի, ստուգվում է նաև դրա configuration-ը։ MFA capability-ի բացակայությունը սեփական կամ արտաքին MFA կառուցելու թույլտվություն չէ։ Բաց են permission/location matrix-ը, audit retention/store-ը, privacy retention-ը, file scanning-ը, encryption key ownership-ը, RPO/RTO-ն և incident owners-ը։
