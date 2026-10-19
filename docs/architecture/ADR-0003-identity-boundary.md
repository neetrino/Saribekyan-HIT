# ADR-0003: Identity and OpenMRS authorization boundary

- Status: Accepted for Phase I
- Date: 2026-10-19

## Context

ՏԱ-ն պահանջում է user lifecycle, roles, granular permissions, inactivity timeout, MFA հնարավորություն, department/location/patient-care scope և break-glass։ OpenMRS authorization-ը հիմնված է persisted users, roles և privileges-ի վրա։ External IdP/Keycloak-ը կարող է վերցնել authentication-ը, բայց չի վերացնում OpenMRS authorization state-ը։

## Options

### A. Native OpenMRS authentication

Ավելի քիչ բաղադրիչներ և պարզ user lifecycle, բայց MFA, centralized identity և advanced session controls-ը կարող են լրացուցիչ աշխատանք պահանջել։

### B. External IdP/Keycloak (future scope)

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
