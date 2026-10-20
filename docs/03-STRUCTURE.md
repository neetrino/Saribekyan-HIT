# Repository Structure

## Status

Սա ապագա նպատակային structure-ի reference է, ոչ repository initialization հրահանգ։ **Մինչ pilot OMOD/O3 compatibility PoC-ի ավարտը ստորև բերված tree-ն կամ business module directories-ը չստեղծել։** Exact artifact/package names-ը որոշվում են pilot-ից հետո։

```text
<future-repository-root>/           # DO NOT CREATE before pilot + go decision
├── <approved distribution assembly>
├── <approved business module artifacts>
├── <approved O3 extension artifacts>
├── <versioned configuration/metadata>
├── <approved integration contracts>
└── <tests and operations assets>
```

Սա ownership/boundary map է, ոչ directory-generation template։ REG/AMB/INP/DIA/FIN/REP/ADM ownership group-ները չեն նշանակում մեկական OMOD կամ folder։ Physical artifact count-ը, repository root անունը և build layout-ը որոշվում են pilot evidence-ից ու առանձին go որոշումից հետո։

Դատարկ directories-ը Git-ում պահվում են միայն README-ով, երբ դրանց purpose-ը հաստատված է։ Անհաստատ technology-ի placeholder code չի ավելացվում։

> D-008-ը թույլ է տալիս միայն մեկ pilot OMOD/O3 compatibility PoC։ Այն թույլ չի տալիս որևէ business module կամ ամբողջ tree գեներացնել։ Business module-ները ստեղծվում են միայն pilot stack-ը pin անելուց և [implementation gate](./00-IMPLEMENTATION-GATE.md)-ը անցնելուց հետո։

## Post-pilot business backend skeleton

Այս բաժինը pilot-ի համար չէ և չի կարող օգտագործվել մինչև ADR-0002-ի ընդունումն ու production package/stack որոշումները։ Pilot-ի միակ layout-ը [COMPATIBILITY-POC.md](./pilot/COMPATIBILITY-POC.md)-ում է։ Ստորև բերվածը conceptual target է, ոչ OpenMRS archetype-ի պատճեն։

```text
backend/modules/<module>/
├── pom.xml
├── README.md
├── api/
│   └── src/main/java/.../<module>/api/       # public interfaces և stable DTOs
├── omod/
│   ├── src/main/java/.../<module>/
│   │   ├── application/                      # use cases / transaction orchestration
│   │   ├── domain/                           # custom rules, եթե OpenMRS model-ում չկան
│   │   ├── infrastructure/                   # DAO, adapters, OpenMRS integration
│   │   └── web/                              # REST resources/controllers
│   ├── src/main/resources/                    # միայն իրական module resources
│   └── src/test/
└── integration-tests/
```

OpenMRS module archetype-ի իրական layout-ը որոշվում է pilot evidence-ով։ Liquibase file ավելացվում է միայն իրական module-owned schema ունենալու դեպքում, ոչ որպես դատարկ placeholder։ Կարևոր սահմանը `api`/public contract-ն է. այլ module-ը չի import անում `application`, `infrastructure` կամ `web` implementation-ը։

## Post-pilot business frontend skeleton

```text
frontend/modules/<module>/
├── package.json
├── README.md
├── src/
│   ├── index.ts                    # O3 lifecycle/extension exports
│   ├── routes/
│   ├── extensions/
│   ├── workspaces/
│   ├── components/
│   ├── api/                        # typed clients; no business authorization
│   ├── translations/
│   │   └── hy.json
│   └── __tests__/
└── e2e/
```

Custom UI-ն օգտագործում է O3 extension/workspace/navigation mechanisms և shared design system-ը։ Երկրորդ անկախ SPA ստեղծելու համար առանձին ADR է անհրաժեշտ։

## Ownership rules

- Canonical patient/visit/encounter/obs/order ownership-ը OpenMRS-ինն է։
- Custom module-ը միայն իր schema changeset-ներն ու business rules-ն է տնօրինում։
- Cross-module call-ը գնում է public Java/API contract-ով, ոչ implementation import-ով կամ direct SQL-ով։
- Configuration artifact-ը code review, version և promotion history ունի։
- Generated build output, secrets և runtime patient data repository-ում չեն պահվում։
- Յուրաքանչյուր module README-ն լրացվում է [module template](./modules/MODULE-TEMPLATE.md)-ով։

## Dependency direction

```text
O3 UI -> REST/FHIR/custom facade -> application service
application service -> OpenMRS public services + own domain/API
infrastructure -> own schema/external adapter
other modules -> public API only
```

Circular module dependencies-ը արգելված են։ Shared code-ը ստեղծվում է միայն իրական երկու կամ ավելի consumer-ից հետո և չի դառնում անկապ business logic-ի պարկ։

## Post-pilot production build and versioning

Այս բաժինը D-008 compatibility pilot-ի վրա չի կիրառվում։ Pilot-ի local unpublished OMOD/O3 artifact-ի inclusion-ը և build-context սահմանները կարգավորվում են միայն [COMPATIBILITY-POC.md](./pilot/COMPATIBILITY-POC.md)-ով։

- OpenMRS Platform, OMOD և O3 dependencies-ը exact pin են արվում distribution manifest-ում։
- Backend build-ը Maven-compatible է, frontend-ը՝ ընտրված O3 toolchain-ին համապատասխան։ Exact Node/package-manager/JDK versions-ը pin կլինեն միայն հաջող D-008 compatibility PoC-ի evidence review/go որոշումից հետո։
- Production business distribution-ը clean checkout-ից պետք է build լինի միայն repository-ում version-controlled կամ immutable registry-ով pinned artifact-ներով, առանց developer machine-ից վերցվող unpublished artifact-ի։
- Module schema version-ը և application compatibility-ն ստուգվում են CI distribution smoke test-ով։

## Post-pilot production naming

Այս բաժնի reverse-domain կանոնը production business modules-ի համար է։ D-008 pilot-ը պարտադիր օգտագործում է compatibility spec-ի disposable `org.openmrs.module.saribekyanpilot` package-ը և չի սպասում production prefix-ի հաստատմանը։

- Repository paths՝ lowercase kebab-case։
- Java packages՝ կազմակերպության հաստատված reverse-domain prefix + module անուն։ Prefix-ը դեռ որոշված չէ և agent-ը չի կարող այն հորինել։
- API resources՝ plural nouns, stable version prefix միայն custom facade-ում։
- DB objects՝ OpenMRS/module conventions-ին համապատասխան և module prefix-ով, երբ collision-ի վտանգ կա։
- Requirement IDs-ը (`REG-01`, `FIN-03`) պահվում են test/UAT metadata-ում, ոչ class name-ի պարտադիր մաս։
