# ADR-0003: Identity and OpenMRS authorization boundary

- Status: Accepted for Phase I
- Date: 2026-10-19
- Decision ID: D-007
- Decision owner: Project architecture owner
- Approval evidence: `../DECISIONS.md` repository decision index; business scope still requires signed TA
- Implementation authority: None without requirement-level task go record

## Context

ՏԱ-ն նկարագրում է user lifecycle, roles, granular permissions, inactivity control, պայմանական native MFA capability, department/location/patient-care scope և break-glass։ Exact timeout-ը, password/session թվերը և break-glass semantics-ը բաց blockers են և այս ADR-ով չեն լրացվում։ OpenMRS authorization-ը հիմնված է persisted users, roles և privileges-ի վրա։ External IdP/Keycloak-ը Phase I-ից դուրս future alternative է, ոչ գործող ընտրություն։

## Options

### A. Native OpenMRS authentication

Ավելի քիչ բաղադրիչներ և պարզ user lifecycle։ Native capability-ի բացակայությունը Phase I-ում սեփական MFA/session շերտ կամ external IdP կառուցելու թույլտվություն չի տալիս։

### B. External IdP/Keycloak (rejected for Phase I; future change request only)

Ավելի ուժեղ identity/MFA հնարավորություններ, բայց առաջացնում է OpenMRS և IdP user/role synchronization, logout/revocation և availability boundary։

## Decision criteria

- O3 և REST/FHIR login flow,
- MFA բարձր արտոնություններով օգտատերերի համար,
- account disable/revocation latency,
- OpenMRS role/privilege synchronization,
- service accounts և integration authentication,
- IdP outage behavior,
- audit actor identity,
- operational complexity և supportability։

## Decision

Phase I-ում օգտագործվում է native OpenMRS authentication-ը և OpenMRS persisted users/roles/privileges-ը։ ՏԱ-ի սահմանով արտաքին identity provider integration-ը Phase I-ում ներառված չէ։ Keycloak/SSO dependency, connector կամ dual-user synchronization չի կառուցվում առանց պայմանագրային change request-ի։

MFA-ն իրականացվում է միայն ընտրված native լուծման փաստացի աջակցվող հնարավորության սահմաններում և չի արդարացնում արտաքին վճարովի integration-ի ինքնուրույն ավելացումը։
