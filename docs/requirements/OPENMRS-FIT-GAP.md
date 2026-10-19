# OpenMRS fit-gap analysis — Phase I

## Assessment rule

| Result | Meaning |
|---|---|
| Strong fit | Պաշտոնական/current capability կա, բայց configuration և local validation դեռ պահանջվում են |
| Partial fit | Canonical model կամ module կա, սակայն ՏԱ-ի workflow-ի մի մասը custom է |
| Gap | Պահանջի հիմնական մասը պետք է custom մշակել |
| Unknown | Առանց exact version/PoC-ի վստահ եզրակացություն հնարավոր չէ |

Ոչ մի `Strong fit` implementation-ready չի համարվում մինչև distribution compatibility test-ը։

## REG — registration, identity and visits

| IDs | Assessment | Evidence and gap |
|---|---|---|
| REG-01–02 | Strong fit | O3 Patient Registration և Patient Search modules-ը նախատեսված են գրանցման ու որոնման համար։ Local identifiers, Armenian fields և validation-ը պետք է configure/test անել։ |
| REG-03 | Partial fit | OpenMRS patient merge capability-ն թեկնածու հիմք է։ Duplicate scoring, preview, irreversible merge safeguards և audit-ը պահանջում են PoC։ |
| REG-04–05 | Strong/partial fit | Appointments module-ը ստեղծում/փոփոխում է appointments և աշխատում է provider schedule-ի հետ։ ՏԱ-ի visit types և local workflow-ը պետք է map անել։ |
| REG-06 | Strong fit | Service Queues-ը outpatient queue capability ունի։ Status-ները, priority-ն և queue numbering-ը configuration են։ |
| REG-07 | Partial fit | Visit/encounter data կա, բայց «միասնական պատմության» UX-ը և finance/diagnostic միավորումը պետք է նախագծել։ |
| REG-08–09 | Gap/partial | Referral model-ը և հայկական PDF փաստաթղթերը պահանջում են custom workflow/document generation։ |

## AMB — outpatient EMR

| IDs | Assessment | Evidence and gap |
|---|---|---|
| AMB-01–04 | Strong/partial fit | Visit, Encounter, Obs և O3 Forms-ը համապատասխան հիմք են։ Հայերեն clinical forms-ը և exact workflow-ն implementation-specific են։ |
| AMB-05 | Partial fit | OpenMRS concept model-ը համապատասխան է terminology-ին։ ICD version, Armenian localization և update policy բաց են։ |
| AMB-06, AMB-08 | Strong/partial fit | Order և DrugOrder canonical models կան։ UI/lifecycle/validation-ը պետք է ստուգել ընտրված modules-ով։ |
| AMB-07, AMB-09 | Partial fit | Consultation և non-drug order workflow-ները չեն համարվում պատրաստ առանց PoC/custom order type-ի։ |
| AMB-10–12 | Partial fit | Clinical data model-ը բավարար հիմք է, սակայն documents և linked follow-up workflow-ը custom է։ |
| AMB-13–14 | Gap/unknown | Draft/sign/controlled correction lifecycle-ը և հայկական տպագրելի output-ը պետք է առանձին նախագծել ու ապացուցել։ |

## INP — inpatient EMR

| IDs | Assessment | Evidence and gap |
|---|---|---|
| INP-01–03 | Partial fit | Visit/Encounter/Location model-ը admission-ի հիմք է, բայց admission state machine-ը տեղային workflow է։ |
| INP-04 | Partial fit | O3 ecosystem-ում Ward և Bed Management modules կան։ Occupancy concurrency, transfers, history և local acceptance criteria-ն պահանջում են PoC։ |
| INP-05–10 | Partial fit | Forms, Obs և Orders-ը տվյալային հիմք են։ Daily notes, handover, nursing execution և consultation workflows-ը custom configuration/UI են։ |
| INP-11 | Gap/partial | Procedure note-ը կարող է form/encounter լինել, բայց ՏԱ-ի կառուցվածքը և հաստատումը custom են։ |
| INP-12 | Partial fit | Bed/ward capability կա, բայց transfer transaction/history-ն պետք է ապացուցել։ |
| INP-13 | Gap/partial | Discharge encounter հիմքը կա, իսկ Armenian epicrisis և close rules-ը custom են։ |

## DIA/LAB/RAD/FDI/END/TRT

| IDs | Assessment | Evidence and gap |
|---|---|---|
| DIA-01–02 | Partial fit | Order model և service concepts կան։ Resource/time scheduling-ը diagnostic workflow-ի համար առանձին ստուգում է պահանջում։ |
| DIA-03–04 | Partial fit | Order/result կապը հնարավոր է, բայց ամբողջ status history, approval և controlled correction-ը custom design են։ |
| LAB-01–04 | Partial fit | TestOrder/Obs/Lab modules-ը հիմք են։ Sample lifecycle, rejection, reference/critical ranges և dual approval-ը PoC են պահանջում։ |
| RAD-01–03 | Partial fit | Order/Obs/attachment հիմքը կա։ Structured report, image/file storage և approval-ը պետք է նախագծել։ PACS/DICOM-ը Phase I-ից դուրս է։ |
| FDI-01, END-01, TRT-01 | Partial fit | Generic Order/Obs/Form model-ը կարող է պահել տվյալները, բայց specialty workflow-ները և templates-ը custom են։ |

FHIR `ServiceRequest`-ի առկայությունը չի նշանակում լիարժեք order-state model․ պաշտոնական mapping-ում status-ը կարող է կախված լինել Task resource-ից կամ դառնալ `unknown`։

## FIN — billing and cashier

| IDs | Assessment | Evidence and gap |
|---|---|---|
| FIN-01–03 | Partial fit | OpenMRS 3 Billing modules-ը billable services, bills և payments հիմք ունեն։ Duplicate charge prevention-ը պետք է ապացուցել։ |
| FIN-04–10 | Partial/gap | Payment methods և patient categories հիմք են, բայց prepayment, payer split, insurance/manual contract share, debt և refund reversal-ը պահանջ առ պահանջ PoC/custom են։ |
| FIN-11 | Gap | Cashier shift/opening/closing/reconciliation workflow-ը custom Java module է սպասվում։ |
| FIN-12–14 | Gap/partial | Financial documents և exact exports-ը custom report/document work են։ |
| FIN-15 | Gap/partial | OpenMRS privileges-ը հիմք են, բայց financial authorization և immutable audit-ը custom design են։ |

Եզրակացություն՝ Billing module-ը accelerator է, ոչ `FIN-01–15` ամբողջական լուծում։ Finance-ը Phase I-ի ամենաբարձր custom և correctness risk ունեցող մոդուլներից է։

## REP — dashboards and reports

| IDs | Assessment | Evidence and gap |
|---|---|---|
| REP-01–06 | Gap/partial | OpenMRS data/report APIs-ը հիմք են, սակայն ՏԱ-ի dashboards/alerts-ը custom queries, read models և O3 widgets են պահանջում։ |
| REP-07 | Partial fit | Reporting Module-ը extensible reporting հիմք է, բայց փակ report register-ի յուրաքանչյուր արդյունքի dataset/layout/export-ը պետք է առանձին մշակել և ընդունել։ |

## ADM — users, roles and administration

| IDs | Assessment | Evidence and gap |
|---|---|---|
| ADM-01–04 | Partial fit | OpenMRS User/Role/Privilege model-ը baseline է։ Armenian roles-ը metadata/configuration են։ |
| ADM-05–06 | Gap/partial | Location/department/service/patient-care scope-ը միայն role անուններով չի լուծվում և պահանջում է authorization policy։ |
| ADM-07–08 | Unknown | Native authentication-ը և external IdP/Keycloak տարբերակը պետք է համեմատել։ MFA-ն exact integration PoC է պահանջում։ |
| ADM-09–11 | Partial/gap | Encounter/Obs voiding/version history-ը հիմք է, բայց legal internal approval և controlled correction contract-ը պետք է առանձին նախագծել։ |
| ADM-10 | Partial/gap | Platform audit/Envers capability կա, բայց read access, export, break-glass և custom entities-ի ամբողջ audit-ը բաց է։ |
| ADM-12 | Gap | Break-glass policy, expiry, reason, alert և separate audit-ը custom են։ |
| ADM-13 | Partial fit | Locations, concepts, forms և configuration-ի մեծ մասը configurable է, բայց բոլոր status/workflow-ները ոչ։ |

Keycloak-ը հնարավոր թեկնածու է, բայց OpenMRS-ը շարունակում է պահանջել persisted users/roles։ Հետևաբար dual user lifecycle և role synchronization-ը architecture concern են։

## Cross-cutting capabilities

| Requirement | Assessment | Decision needed |
|---|---|---|
| Form builder | Strong fit | React Form Engine workflow, schema versioning և Armenian rendering PoC |
| REST API | Strong fit as platform API | Որ endpoint-ներն են արտաքին contract, որոնք՝ internal only |
| FHIR R4 | Partial fit | Required resource/profile-by-profile validation |
| PDF/print | Gap | Rendering library, Armenian fonts, versioning և archival rules |
| Excel import/export | Gap/partial | Template contracts, validation և security |
| Audit Trail | Partial fit | Unified clinical/custom/read-access audit architecture |
| External integrations | Architecture-ready only | Phase I connectors-ը բացառված են, եթե change request չկա |

## Required PoC backlog

1. Pin candidate Reference Application release և ամբողջ compatibility matrix-ը։
2. Armenian patient registration/search/merge։
3. Appointment → visit → queue ամբողջական workflow։
4. O3 Form Builder/React Form Engine՝ Armenian clinical form, draft, publish և correction։
5. Admission → bed assignment → transfer → discharge concurrency/history։
6. Lab order → result → critical flag → approval/correction։
7. Billing՝ invoice, partial payment, prepayment, split payer, refund և cashier shift։
8. Role/location/patient-context access և break-glass։
9. Audit՝ create/update/void/read/export/break-glass։
10. Armenian PDF և Excel report generation։

## Primary evidence

- O3 Patient Management configuration: <https://o3-docs.openmrs.org/en-US/docs/configure-o3/configure-patient-management/>
- O3 forms: <https://o3-docs.openmrs.org/en-US/docs/forms-in-o3/>
- OpenMRS key repositories: <https://o3-docs.openmrs.org/en-US/docs/key-repositories/>
- OpenMRS API overview: <https://openmrs.atlassian.net/wiki/spaces/docs/pages/25520547/OpenMRS>
- OpenMRS Billing: <https://openmrs.atlassian.net/wiki/spaces/projects/pages/26938835/Billing>
- OpenMRS Reporting: <https://openmrs.atlassian.net/wiki/spaces/docs/pages/25462110/Reporting+Module>
- FHIR implementation guide: <https://fhir.openmrs.org/>

