# Repository Structure

## Status

Սա ապագա ownership/structure reference է, ոչ repository initialization հրահանգ։ **Pilot run-ի ավարտը բավարար չէ։ Մինչ evidence review/go-ն, ADR-0002-ի որոշումը և production artifact-boundary որոշումը business module directories չստեղծել։** Exact artifact/package names-ը որոշվում են դրանից հետո։

Այս փաստաթուղթը դիտավորյալ չի ցուցադրում նույնիսկ placeholder repository tree (`NO_PRE_GO_LAYOUT`)։ REG/AMB/INP/DIA/FIN/REP/ADM ownership group-ները չեն նշանակում մեկական OMOD կամ folder։ Distribution assembly-ի, business artifact-ի, O3 extension-ի, configuration-ի, integration contract-ի և test asset-ի physical paths/count/layout-ը որոշվում են միայն pilot evidence-ից, Accepted artifact-boundary որոշումից և task-level `GO`-ից հետո։

Դատարկ directories-ը Git-ում պահվում են միայն README-ով, երբ դրանց purpose-ը հաստատված է։ Անհաստատ technology-ի placeholder code չի ավելացվում։

> D-008-ը թույլ է տալիս միայն մեկ pilot OMOD/O3 compatibility PoC։ Այն թույլ չի տալիս որևէ business module կամ ամբողջ tree գեներացնել։ Business artifacts-ը ստեղծվում են միայն evidence review/go-ից, ADR-0002-ի որոշումից, stack pin-ից, ստորագրված scope-ից և [implementation gate](./00-IMPLEMENTATION-GATE.md)-ը task-ի համար անցնելուց հետո։

## Post-go artifact layout

Այս փաստաթուղթը backend/frontend directory skeleton չի սահմանում։ Հաստատված go-ից հետո backend layout-ը վերցվում է ընտրված և pin արված OpenMRS tooling/archetype-ի փաստացի output-ից, իսկ frontend layout-ը՝ ընտրված O3 toolchain-ի փաստացի template/extension contract-ից։ Agent-ը սեփական ենթադրյալ layered directory tree չի ստեղծում միայն այս փաստաթղթից։ Liquibase file ավելացվում է միայն իրական module-owned schema-ի հաստատված պահանջով, ոչ placeholder-ով։ Public contract/implementation սահմանը և O3 extension mechanism-ը պահպանվում են՝ անկախ վերջնական physical layout-ից։

## Ownership rules

- Canonical patient/visit/encounter/obs/order ownership-ը OpenMRS-ինն է։
- Custom module-ը միայն իր schema changeset-ներն ու business rules-ն է տնօրինում։
- Cross-module call-ը գնում է public Java/API contract-ով, ոչ implementation import-ով կամ direct SQL-ով։
- Configuration artifact-ը code review, version և promotion history ունի։
- Generated build output, secrets և runtime patient data repository-ում չեն պահվում։
- Յուրաքանչյուր առանձին հաստատված business artifact-ի README-ն լրացվում է [module template](./modules/MODULE-TEMPLATE.md)-ով։ Ownership boundary-ն ինքնաբերաբար artifact չէ։

## Dependency direction

```text
approved UI consumer -> approved native/custom public contract
approved backend capability -> OpenMRS public services and explicitly owned data
other approved artifacts -> public contract only
```

Այս սխեմայի բառերը package/directory/layer անուններ չեն։ `application`, `domain`, `infrastructure`, `web`, facade կամ adapter պանակներ չեն ստեղծվում այս diagram-ից։ Circular artifact dependencies-ը արգելված են։ Shared code-ը ստեղծվում է միայն իրական երկու կամ ավելի approved consumer-ից հետո և չի դառնում անկապ business logic-ի պարկ։

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
