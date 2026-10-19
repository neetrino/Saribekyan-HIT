# Phase I module source matrix

## Նպատակ

Այս ֆայլը նախնական mapping է, ոչ վերջնական տեխնոլոգիական որոշում։ Այն ցույց է տալիս, թե պահանջների որ մասը նախատեսվում է ուսումնասիրել OpenMRS reuse/configuration-ի, custom Java OMOD-ի, O3 frontend module-ի կամ արտաքին բաղադրիչի միջոցով։ Վերջնական արդյունքը գրանցվում է fit-gap review-ից և ADR-ից հետո։

## Դասակարգում

| Նշում | Իմաստ |
|---|---|
| OpenMRS candidate | Core կամ community module-ի միջոցով reuse-ի թեկնածու |
| Configure/extend | OpenMRS model/configuration-ը կա, բայց պահանջվում է տեղայնացում կամ workflow extension |
| Custom Java OMOD | Custom backend domain/service/API անհրաժեշտություն |
| Custom O3 UI | Custom workflow կամ UI extension անհրաժեշտություն |
| External candidate | Առանձին service/library/API-ի թեկնածու |
| Validation required | Version, capability, license կամ maintenance status-ը դեռ պետք է ապացուցել |

## Մոդուլների նախնական քարտեզ

| Պահանջների խումբ | Նախնական հիմք | Հավանական custom սահման | Կարգավիճակ |
|---|---|---|---|
| REG-01–03 | OpenMRS patient registry և patient merge | Armenian identifiers, duplicate policy և UI | Validation required |
| REG-04–06 | Appointments/queue capabilities | Տեղային schedule/queue կանոններ և UI | Validation required |
| REG-07 | Visit/encounter history | Միասնական բժշկական timeline presentation | Validation required |
| REG-08–09 | Encounter/referral model և document data | Referral OMOD, PDF/print templates | Proposed mapping |
| AMB-01–04 | Visit, encounter, forms և observations | Հայերեն forms և workflow orchestration | Validation required |
| AMB-05 | OpenMRS concept model | ICD source, version, localization և sync | Validation required |
| AMB-06–09 | Order model և drug orders | Consultation/non-drug order types և execution workflow | Validation required |
| AMB-10–14 | Encounter/forms | Approval lifecycle, controlled correction և Armenian documents | Validation required |
| INP-01–03 | Visits/encounters | Admission workflow configuration | Validation required |
| INP-04, INP-12 | OpenMRS Ward/Bed Management candidate + Location/Visit հիմք | Occupancy concurrency, transfer history և local workflow gaps | Validation required |
| INP-05–10 | Encounters, observations և orders | Nursing/ward workflow extensions | Validation required |
| INP-11, INP-13 | Clinical forms/data | Procedure documentation և discharge documents | Proposed custom |
| DIA-01–04 | Order/service concepts | Status orchestration և local catalog | Validation required |
| LAB/RAD/FDI/END/TRT | Orders, observations և attachments | Approval, critical result և specialty workflows | Validation required |
| FIN-01–15 | OpenMRS billing ecosystem-ի ուսումնասիրություն | Հաշիվներ, վճարումներ, payer split, refund, cashier shift և audit | High custom risk |
| REP-01–07 | OpenMRS data/reporting ecosystem-ի ուսումնասիրություն | ՏԱ-ի փակ report register և dashboards | High custom risk |
| ADM-01–13 | OpenMRS native authentication, users և privileges | Fine-grained scope, break-glass, approval և audit | Validation required |
| Form builder | OpenMRS form ecosystem | Armenian templates և version governance | Validation required |
| API հիմք | OpenMRS REST/FHIR ecosystem | Contract facade, versioning և integration policy | Architecture decision required |

## Լրացուցիչ տեխնոլոգիաների թեկնածուներ

Ստորև նշված թեկնածուները dependency ավելացնելու թույլտվություն չեն։ Յուրաքանչյուրը պահանջում է հաստատված տեխնիկական որոշում, իսկ Phase I-ից դուրս թեկնածուն՝ change request։

| Թեկնածու | Նախնական նպատակ | Մինչև հաստատումը ստուգվող հարցեր |
|---|---|---|
| Keycloak | Future identity integration; Phase I-ից դուրս | Առանձին change request, OpenMRS mapping և operations |
| WHO ICD API | Չհաստատված future candidate | Phase I ICD version/content-ը տրամադրում կամ հաստատում է Պատվիրատուն |
| JasperReports | Փակ report register և export | Template lifecycle, Armenian fonts, performance և maintainability |
| Apache POI | Structured Excel export/import | Large-file limits, validation և formula safety |
| openhtmltopdf | PDF generation | Armenian fonts, pagination, signatures և archival output |
| JaVers | Custom entity change history | OpenMRS audit overlap, medical immutability և storage growth |
| Moneta/JSR 354 | Monetary calculations | AMD-only rules, rounding, persistence և reporting compatibility |

Այս աղյուսակը candidate register է, ոչ ընտրված stack։ Keycloak-ը և WHO ICD API integration-ը Phase I-ից դուրս են, իսկ մյուս թեկնածուները մնում են չհաստատված մինչև առանձին որոշում։
