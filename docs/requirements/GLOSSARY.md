# Glossary

| Տերմին | Սահմանում |
|---|---|
| HIS | Hospital Information System՝ բժշկական համալիրի միասնական տեղեկատվական համակարգ։ |
| EMR | Պացիենտի էլեկտրոնային բժշկական պատմություն։ |
| OpenMRS Platform | Java-ով կառուցված OpenMRS backend/core և module runtime։ |
| OpenMRS O3 | OpenMRS-ի ժամանակակից modular frontend ecosystem։ |
| OMOD | OpenMRS backend module-ի deployable փաթեթ։ Այս սահմանումը package/layer skeleton չի սահմանում և չի պահանջում `domain`, `application`, `infrastructure` կամ `web` directories։ Ներքին layout-ը վերցվում է միայն approved artifact boundary-ից և ընտրված OpenMRS tooling-ի փաստացի output-ից։ |
| O3 frontend module | OpenMRS app shell-ին route/extension/workspace տրամադրող frontend package։ |
| Distribution | Համատեղելի OpenMRS Platform, backend modules, O3 modules և configuration տարբերակների ամրագրված հավաքածու։ |
| Concept | OpenMRS-ի clinical terminology/data dictionary տարր։ |
| Encounter | Պացիենտի հետ կլինիկական փոխգործակցության գրառում։ |
| Visit | Մեկ կամ մի քանի encounter միավորող բժշկական այց/դեպք։ |
| Observation (Obs) | Կլինիկական դիտարկում կամ չափված/գրանցված արդյունք։ |
| Order | Հետազոտության, դեղի, խորհրդատվության կամ այլ ծառայության նշանակում։ |
| Patient Registry | Պացիենտի ինքնության և հիմնական demographic տվյալների գրանցամատյան։ |
| FHIR | Առողջապահական տվյալների փոխգործունակության HL7 ստանդարտ։ |
| ICD | Հիվանդությունների միջազգային դասակարգիչ։ Կիրառվող version/localization-ը պետք է հաստատվի։ |
| Audit Trail | Ով, երբ, ինչ օբյեկտի նկատմամբ ինչ գործողություն է կատարել և, կիրառելի դեպքում, ինչ է փոխվել։ |
| Internal approval | Համակարգի ներսում օգտատիրոջ, ժամանակի և version-ի պահպանմամբ հաստատում, որը որակավորված էլեկտրոնային ստորագրություն չէ։ |
| Break-glass | Սովորական սահմանափակումներից դուրս արտակարգ հասանելիություն՝ պարտադիր պատճառաբանմամբ և առանձին audit-ով։ |
| UAT | Պատվիրատուի կողմից իրական բիզնես սցենարներով ընդունման փորձարկում։ |
| Compatibility PoC / D-008 pilot | Մեկ disposable, ոչ-business OMOD/O3 համատեղելիության փորձ `pilot/openmrs-compatibility/`-ում։ Սա production release կամ Phase I implementation չէ։ |
| Production pilot-release | Մեկնարկից հետո պայմանագրով նախատեսվող արտադրական փորձնական շահագործման տարբերակ, ոչ վերջնական ընդունման ակտ։ Սա D-008 compatibility PoC-ն չէ։ |
| Fit-gap analysis | Պահանջի և ընտրված պատրաստի հնարավորության համեմատություն՝ reuse, configuration և custom development սահմանը որոշելու համար։ |
| ADR | Architecture Decision Record՝ մեկ էական տեխնիկական որոշման պատճառներն ու հետևանքները գրանցող փաստաթուղթ։ |
| As-built documentation | Իրական ներդրված համակարգի վերջնական վիճակին համապատասխան փաստաթղթեր։ |
