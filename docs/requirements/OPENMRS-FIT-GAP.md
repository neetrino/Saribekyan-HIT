# OpenMRS fit-gap analysis — Phase I

> **Lifecycle: ASSESSMENT / non-authorizing։** Յուրաքանչյուր implementation mapping պետք է գրանցի exact distribution SHA/release, module/package version, evidence URL կամ local snapshot, evidence date, license/maintenance review և executable PoC/test result։ Այդ դաշտերից որևէ մեկի բացակայության դեպքում assessment-ը մնում է `UNVALIDATED`։

## Assessment rule

Հին պիտակները՝ `Strong fit`, `Partial fit`, `Strong/partial fit`, `Gap`, `Gap/partial`, `Partial/gap`, `Candidate fit`, `Gap/unknown`, դուրս են եկել գործածությունից։ Եթե որևէ տող դեռ դրանցից մեկն է օգտագործում, agent-ը այն կարդում է որպես `UNVALIDATED` և դրանից module չի տեղադրում, configure չի անում և custom artifact չի ստեղծում։

| Result | Meaning |
|---|---|
| UNVALIDATED_CANDIDATE_FIT | Historical/product-level evidence suggests a capability; package is not selected or installable yet |
| UNVALIDATED_PARTIAL_FIT | Canonical model կամ candidate module հիշատակված է, բայց exact workflow/version proof չկա |
| UNVALIDATED_GAP | Historical assessment anticipates missing capability; սա custom artifact ստեղծելու որոշում չէ |
| UNKNOWN | Առանց exact version/PoC-ի վստահ եզրակացություն հնարավոր չէ |
| OUT_OF_PHASE_I | Փուլ I-ից դուրս է, եթե չկա signed change request. architecture-ready արտահայտությունը connector չի ստեղծում |

Ոչ մի assessment implementation-ready չի համարվում մինչև exact-version evidence, approved fit decision և task go record-ը։ Ստորև product/module անունները discovery candidates են, ոչ ընտրված stack կամ installation list։ Այս ֆայլի ոչ մի տող module տեղադրելու, configure անելու կամ custom artifact ստեղծելու հրահանգ չէ։

## REG — registration, identity and visits

| IDs | Assessment | Evidence and gap |
|---|---|---|
| REG-01–02 | UNVALIDATED_CANDIDATE_FIT | O3 Patient Registration և Patient Search անունները discovery candidates են։ Չտեղադրել/չconfigure անել մինչև exact version fit proof-ը։ |
| REG-03 | UNVALIDATED_PARTIAL_FIT | OpenMRS patient merge capability-ն թեկնածու հիմք է։ Duplicate/survivor semantics-ը BLOCKED են։ |
| REG-04–05 | UNVALIDATED_PARTIAL_FIT | Appointments անունը discovery candidate է։ Exact package/version և local workflow proof չկան։ |
| REG-06 | UNVALIDATED_CANDIDATE_FIT | Service Queues անունը discovery candidate է։ Status/priority/numbering semantics-ը որոշված չեն։ |
| REG-07 | UNVALIDATED_PARTIAL_FIT | Visit/encounter data-ի candidate հիշատակում կա։ Միասնական պատմության UX-ը և finance/diagnostic միավորումը proof չունեն. այս տողով UI կամ workflow չի նախագծվում։ |
| REG-08–09 | UNVALIDATED_GAP | Referral և հայկական PDF capability-ն proof չունի. custom workflow կամ document generator այս տողով չի ստեղծվում։ |

## AMB — outpatient EMR

| IDs | Assessment | Evidence and gap |
|---|---|---|
| AMB-01–04 | UNVALIDATED_PARTIAL_FIT | Visit, Encounter, Obs և O3 Forms անունները discovery candidates են։ Հայերեն forms-ը և workflow-ն proof չունեն. module չտեղադրել և form builder չկառուցել։ |
| AMB-05 | UNVALIDATED_PARTIAL_FIT | OpenMRS concept model-ը candidate է։ ICD version, Armenian localization և update policy բաց են. catalog այս տողով չի լցվում։ |
| AMB-06, AMB-08 | UNVALIDATED_PARTIAL_FIT | Order և DrugOrder անունները canonical-model candidates են։ UI/lifecycle/validation proof չկա. module չտեղադրել։ |
| AMB-07, AMB-09 | UNVALIDATED_PARTIAL_FIT | Consultation և non-drug order workflow-ն proof չունի. custom order type այս տողով չի ստեղծվում։ |
| AMB-10–12 | UNVALIDATED_PARTIAL_FIT | Clinical data model-ը candidate հիմք է։ Documents և follow-up workflow-ն proof չունեն. custom artifact այս տողով չի ստեղծվում։ |
| AMB-13–14 | UNKNOWN | Draft/sign/correction lifecycle-ը և հայկական տպագրելի output-ը proof չունեն. այս տողով չեն նախագծվում։ |

## INP — inpatient EMR

| IDs | Assessment | Evidence and gap |
|---|---|---|
| INP-01–03 | UNVALIDATED_PARTIAL_FIT | Visit/Encounter/Location-ը candidate հիմք է։ Admission state machine-ը proof չունի և այս տողով չի սահմանվում։ |
| INP-04 | UNVALIDATED_PARTIAL_FIT | Ward/Bed Management անունները discovery candidates են։ Occupancy concurrency, transfers և acceptance criteria-ն BLOCKED են։ |
| INP-05–10 | UNVALIDATED_PARTIAL_FIT | Forms, Obs և Orders անունները candidates են։ Daily notes, handover, nursing execution և consultation workflow-ն proof չունեն. custom UI այս տողով չի ստեղծվում։ |
| INP-11 | UNVALIDATED_GAP | Procedure note-ի form/encounter candidate-ը proof չունի. custom կառուցվածք կամ approval այս տողով չի ստեղծվում։ |
| INP-12 | UNVALIDATED_PARTIAL_FIT | Bed/ward capability-ն candidate է։ Transfer transaction/history-ն proof չունի։ |
| INP-13 | UNVALIDATED_GAP | Discharge encounter-ը candidate է։ Armenian epicrisis և close rules-ը proof չունեն. custom document այս տողով չի ստեղծվում։ |

## DIA/LAB/RAD/FDI/END/TRT

| IDs | Assessment | Evidence and gap |
|---|---|---|
| DIA-01–02 | UNVALIDATED_PARTIAL_FIT | Order model և service concepts-ը candidates են։ Resource/time scheduling-ը proof չունի և այս տողով չի սահմանվում։ |
| DIA-03–04 | UNVALIDATED_PARTIAL_FIT | Order/result կապը candidate է։ Status history, approval և correction-ը proof չունեն. custom state machine այս տողով չի ստեղծվում։ |
| LAB-01–04 | UNVALIDATED_PARTIAL_FIT | TestOrder/Obs/Lab module անունները discovery candidates են։ Sample lifecycle, ranges և dual approval-ը proof չունեն. module չտեղադրել։ |
| RAD-01–03 | UNVALIDATED_PARTIAL_FIT | Order/Obs/attachment-ը candidate է։ Structured report և file storage-ը proof չունեն. storage կամ renderer այս տողով չի ընտրվում։ PACS/DICOM-ը Phase I-ից դուրս է։ |
| FDI-01, END-01, TRT-01 | UNVALIDATED_PARTIAL_FIT | Generic Order/Obs/Form-ը candidate է։ Specialty workflow-ն և templates-ը proof չունեն. custom module այս տողով չի ստեղծվում։ |

FHIR `ServiceRequest`-ի առկայությունը չի նշանակում լիարժեք order-state model․ պաշտոնական mapping-ում status-ը կարող է կախված լինել Task resource-ից կամ դառնալ `unknown`։

## FIN — billing and cashier

| IDs | Assessment | Evidence and gap |
|---|---|---|
| FIN-01–03 | UNVALIDATED_PARTIAL_FIT | OpenMRS Billing անունը discovery candidate է, ոչ ընտրված dependency։ Duplicate charge prevention-ը BLOCKED է։ |
| FIN-04–10 | UNVALIDATED_GAP | Payment method և patient category անունները candidates են։ Prepayment, payer split, debt և refund reversal-ը proof չունեն. custom finance artifact այս տողով չի ստեղծվում։ |
| FIN-11 | UNVALIDATED_GAP | Cashier shift capability-ն proof չունի։ Սա custom Java OMOD ստեղծելու որոշում կամ coding authorization չէ։ |
| FIN-12–14 | UNVALIDATED_GAP | Financial documents և exports-ը proof չունեն. report կամ document generator այս տողով չի ստեղծվում։ |
| FIN-15 | UNVALIDATED_GAP | OpenMRS privileges-ը candidate հիմք են։ Financial authorization և immutable audit-ը proof չունեն. custom design այս տողով չի սկսվում։ |

Գնահատման վարկած. Billing module անունը accelerator candidate է, ոչ `FIN-01–15` ամբողջական լուծում և ոչ custom finance module ստեղծելու որոշում։

## REP — dashboards and reports

| IDs | Assessment | Evidence and gap |
|---|---|---|
| REP-01–06 | UNVALIDATED_GAP | OpenMRS data/report API անունները candidates են։ Dashboard, query, read model կամ O3 widget այս տողով չի ստեղծվում։ |
| REP-07 | UNVALIDATED_PARTIAL_FIT | Reporting Module անունը discovery candidate է։ Report register-ի dataset/layout/export-ը proof չունի և այս տողով չի մշակվում։ |

## ADM — users, roles and administration

| IDs | Assessment | Evidence and gap |
|---|---|---|
| ADM-01–04 | UNVALIDATED_PARTIAL_FIT | OpenMRS User/Role/Privilege model-ը candidate baseline է։ Armenian role catalog-ը proof չունի. metadata այս տողով չի լցվում։ |
| ADM-05–06 | UNVALIDATED_GAP | Location/department/service/patient-care scope-ը proof չունի. authorization policy այս տողով չի հորինվում։ |
| ADM-07–08 | UNVALIDATED_PARTIAL_FIT | Native OpenMRS authentication-ը Phase I boundary է։ MFA capability-ն անհայտ է. սեփական MFA կամ external IdP այս տողով չի կառուցվում։ |
| ADM-09–11 | UNVALIDATED_GAP | Encounter/Obs voiding/version history-ն candidate է։ Internal approval և correction contract-ը proof չունեն. այս տողով չեն նախագծվում։ |
| ADM-10 | UNVALIDATED_GAP | Platform audit/Envers անունը candidate է, ոչ acceptance evidence։ Action/user/time/object, conditional old/new, IP/device capture semantics-ը, export/break-glass linkage-ը, storage/access/retention-ը և verification-ը proof չունեն։ Every-view audit-ը Phase I default չէ և այս տողով չի միացվում։ |
| ADM-12 | UNVALIDATED_GAP | Break-glass policy, expiry, reason, alert և audit-ը proof չունեն. custom control այս տողով չի ստեղծվում։ |
| ADM-13 | UNVALIDATED_PARTIAL_FIT | Locations, concepts, forms և configuration-ը candidates են։ Status/workflow configurability-ն proof չունի։ |

External IdP/Keycloak-ը Phase I-ում չի իրականացվում։ OpenMRS persisted users/roles/privileges-ը Phase I authorization boundary-ն են, ոչ պատրաստ privilege matrix։

## Cross-cutting capabilities

| Requirement | Assessment | Decision needed |
|---|---|---|
| Form builder | UNVALIDATED_CANDIDATE_FIT | ՏԱ-ն պահանջում է վերջնական user capability, բայց տեխնիկական իրականացումը BLOCKED է։ O3 Form Builder/React Form Engine reuse-ը պետք է requirement-by-requirement ապացուցի field types, requiredness, version history, specialty binding և Armenian rendering-ը։ Առանձին custom designer չի կառուցվում և candidate dependency չի ընտրվում մինչև accepted fit/artifact decision ու task `GO`։ Սա requirement-ը չի չեղարկում և custom implementation-ի default թույլտվություն չի ստեղծում։ |
| REST API | UNVALIDATED_CANDIDATE_FIT | Native surface-ի առկայությունը custom/public endpoint authorization չէ |
| FHIR R4 | UNVALIDATED_PARTIAL_FIT | Resource/profile validation-ը proof չունի. FHIR surface այս տողով չի հրապարակվում։ |
| PDF/print | UNVALIDATED_GAP | Renderer, fonts, versioning և archival rules-ը ընտրված չեն. library այս տողով չի ավելացվում։ |
| Excel import/export | UNVALIDATED_GAP | Template contract-ը proof չունի. spreadsheet library այս տողով չի ավելացվում։ |
| Audit Trail | UNVALIDATED_PARTIAL_FIT | ADM-10 change, export և break-glass audit-ի ճարտարապետությունը proof չունի։ Every-view/read-access audit-ը Phase I default չէ և այս տողով չի թույլատրվում։ |
| External integrations | OUT_OF_PHASE_I | Phase I connectors-ը բացառված են, եթե change request չկա. architecture-ready արտահայտությունը connector չի ստեղծում։ |

## Fit-gap validation candidates — not an authorized backlog

Այս ցանկը future validation inventory է, ոչ coding authorization, sprint backlog կամ D-008 pilot-ի scope։ Մինչ ստորագրումը թույլատրված է միայն [D-008 compatibility PoC](../pilot/COMPATIBILITY-POC.md)-ն, որը ստորև նշված business workflow-ները չի իրականացնում։ Կետեր 2–10-ը կարող են պլանավորվել միայն ստորագրված scope-ից, համապատասխան requirement traceability-ից և առանձին go որոշումից հետո։ `Audit read` հիշատակումը fit-gap հարց է և Phase I-ի պարտադիր every-view audit չի սահմանում։

1. Pin candidate Reference Application release և ամբողջ compatibility matrix-ը։
2. Armenian patient registration/search/merge։
3. Appointment → visit → queue ամբողջական workflow։
4. Form-constructor validation՝ O3 Form Builder/React Form Engine candidate-ի միջոցով, առանց այն dependency կամ երկրորդ custom designer հաստատելու։
5. Admission → bed assignment → transfer → discharge concurrency/history։
6. Lab order → result → critical flag → approval/correction։
7. Billing՝ invoice, partial payment, prepayment, split payer, refund և cashier shift։
8. Role/location/patient-context access և break-glass։
9. Audit validation՝ create/update/void/export/break-glass։ `read`/every-view audit-ը առանձին բաց requirement է և այս candidate list-ով չի թույլատրվում։
10. Armenian PDF և Excel report generation։

## Primary evidence

- O3 Patient Management configuration: <https://o3-docs.openmrs.org/en-US/docs/configure-o3/configure-patient-management/>
- O3 forms: <https://o3-docs.openmrs.org/en-US/docs/forms-in-o3/>
- OpenMRS key repositories: <https://o3-docs.openmrs.org/en-US/docs/key-repositories/>
- OpenMRS API overview: <https://openmrs.atlassian.net/wiki/spaces/docs/pages/25520547/OpenMRS>
- OpenMRS Billing: <https://openmrs.atlassian.net/wiki/spaces/projects/pages/26938835/Billing>
- OpenMRS Reporting: <https://openmrs.atlassian.net/wiki/spaces/docs/pages/25462110/Reporting+Module>
- FHIR implementation guide: <https://fhir.openmrs.org/>
