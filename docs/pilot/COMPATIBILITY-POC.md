# D-008 OpenMRS Compatibility PoC — not `PRODUCTION_PILOT_RELEASE`

## Authorization and scope

Այս PoC-ն թույլատրված է D-008-ով և business feature չէ։ Այն չունի REG–ADM requirement ID կամ owning business module։ Այն չի պահում patient/clinical/finance տվյալ, չի ստեղծում production table և չի սահմանում production architecture-ը։

## Temporary identifiers

- Workspace: `<REPOSITORY_ROOT>/pilot/openmrs-compatibility/`
- Canonical repository-root-relative path: `pilot/openmrs-compatibility/`
- Backend module ID: `saribekyanpilot`
- Temporary Java package: `org.openmrs.module.saribekyanpilot`
- Frontend extension name: `saribekyan-pilot-extension`

Սրանք disposable PoC identifiers են և business code-ում չեն պահպանվում։ Production reverse-domain prefix-ը մնում է առանձին blocker։

Այս spec-ի գտնվելու վայրը՝ `<REPOSITORY_ROOT>/docs/pilot/COMPATIBILITY-POC.md`, workspace-ի parent path չէ։ `<REPOSITORY_ROOT>/docs/pilot/`-ը միայն documentation է։ Agent-ը current file directory-ին relative workspace չի ստեղծում. `docs/pilot/openmrs-compatibility/` և `docs/pilot/**/{backend,frontend,work,upstream,distribution}` paths-ը արգելված են։ Բոլոր layout path-երը ստորև resolve են արվում repository root-ից։

`org.openmrs.module.saribekyanpilot`, `saribekyanpilot` կամ `saribekyan-pilot-extension` անուններից որևէ մեկի հայտնվելը production/business artifact-ում պարտադիր validation failure է։ PoC review/go-ն այս namespace-ը չի «promote» անում. business repository/module ստեղծումը մնում է արգելված մինչև առանձին production prefix և artifact-boundary որոշումները։

## Candidate baseline selection

Pilot-ը սկսվում է պաշտոնական `openmrs/openmrs-distro-referenceapplication` repository-ի reviewer-ի կողմից նախապես հաստատված **մեկ exact commit SHA-ից**, որը գրանցվում է այս փաստաթղթի «Run record» բաժնում մինչև որևէ checkout կամ code generation։ Branch անունը ընտրության կանոն չէ. agent-ը չի վերցնում checkout-ի պահին `main`/`HEAD`-ը և հետո չի գրանցում ստացված SHA-ն։ Օգտագործվում են հենց նախապես հաստատված commit-ի source-ը, distribution manifests-ը, base-image declarations-ը և module versions-ը։ Pilot OMOD պարունակող backend-ը և pilot extension պարունակող frontend-ը build/assemble են արվում այդ commit-ի սեփական distribution build paths-ով։ Upstream-ի հրապարակված պատրաստի backend image-ը OMOD installation proof չէ, իսկ հրապարակված պատրաստի frontend image-ը extension load proof չէ։

SHA-ի ընտրությունը coding agent-ի ազատ ընտրություն չէ։ Մինչ checkout/code generation-ը run record-ում պարտադիր լրացվում և անկախ reviewer-ի կողմից հաստատվում են՝ selection date/time, candidate SHA, official repository URL, commit-ի release/tag հարաբերությունը (եթե կա), upstream CI/build վիճակը, manifest completeness-ը, known support/security նկատառումները, ընտրության rationale-ը և approver-ը։ Default rule-ը «ամենավերջին main commit»-ը չէ։ Չհաստատված SHA-ն `NO_GO` է։ Reviewer-ը կարող է ընտրել միայն այս spec-ով թույլատրված repository-ի commit, ոչ այլ distribution կամ ձեռքով փոխված stack։

- `main`, `latest`, `next` կամ floating image tag-ը evidence-ում բավարար pin չէ։
- Exact source SHA-ն ինքնուրույն reproducible dependency pin չէ։ Եթե ընտրված commit-ի manifest/build-ը օգտագործում է `next`, `latest`, range կամ floating base image, pilot-ը չի փոխարինում դրանք ձեռքով։ Փոխարենը run-ի պահին գրանցվում են փաստացի resolved package/module versions-ը և container image digest-ները։ Եթե build-ից հնարավոր չէ ստանալ immutable resolution evidence, clean rerun-ը չի համարվում ապացուցված և pilot-ը գրանցվում է որպես compatibility failure։
- Repository-ի այլ historical/candidate version հիշատակումներից ոչ մեկը pilot baseline չէ։ Candidate versions-ը վերցվում են միայն ընտրված exact commit-ի manifests/build evidence-ից։
- Pilot commit-ի ընտրությունը production approval չէ։ Pilot-ի արդյունքից հետո compatibility matrix-ն է առաջարկում production candidate-ը։
- Եթե ընտրված commit-ը reproducibly չի build/run լինում, failure-ը append-only evidence է։ Հաջորդ փորձը կարող է փոխել **միայն** նույն `openmrs/openmrs-distro-referenceapplication` repository-ի exact commit SHA-ն և պետք է նոր attempt-ով գրանցի պատճառը, նախորդ SHA-ն ու նոր SHA-ն։ DB engine-ը, ներառյալ MariaDB/PostgreSQL-ը, թույլատրելի կամ արգելված է միայն ընտրված commit-ի սեփական manifest/compose declaration-ի համաձայն։ `PostgreSQL` անունն ինքնուրույն արգելք չէ. արգելված է manifest-ից դուրս ցանկացած JVM/DB/module substitution կամ compose-ի DB engine-ի ձեռքով փոխարինում։ Bahmni/Ozone/այլ distribution-ը նույնպես D-008-ից դուրս է և պահանջում է նոր ընդունված որոշում։

Official baseline source: <https://github.com/openmrs/openmrs-distro-referenceapplication>

## Allowed minimal layout

```text
<REPOSITORY_ROOT>/pilot/openmrs-compatibility/
├── README.md                     # commands and limitations
├── RUN-RECORD.md                 # commit SHA, resolved versions, environment, results
├── upstream/
│   └── reference-application/    # exact-SHA checkout/worktree; ignored, not modified or committed
├── distribution/
│   └── patches/
│       ├── spa-assemble-config.patch # patches the selected commit's real frontend/spa-assemble-config.json
│       └── omod-inclusion.patch       # patches the selected commit's real backend inclusion/build file
├── work/
│   └── reference-application/    # ignored derived copy used for build after patches are applied
├── backend/                      # official OpenMRS SDK/archetype output, minimal module only
└── frontend/                     # minimal O3 extension generated from supported tooling/template
```

Pilot-ը **չի օգտագործում** `03-STRUCTURE.md`-ի business module skeleton-ը։ Backend layout-ը վերցվում է ընտրված baseline-ին համատեղելի պաշտոնական OpenMRS module SDK/archetype-ից։ Դատարկ custom `application/domain/infrastructure/web` layers չեն ավելացվում։

Այս layout-ում `work/`-ի միակ թույլատրելի repository-relative տեղը `pilot/openmrs-compatibility/work/`-ն է։ Repository root-ում, `docs/pilot/`-ի տակ կամ որևէ այլ canonical prefix-ից դուրս path-ով `work/` ստեղծելը validation failure է։

Pristine `pilot/openmrs-compatibility/upstream/reference-application/` checkout-ը չի խմբագրվում։ Build-ից առաջ այն պատճենվում է ignored `pilot/openmrs-compatibility/work/reference-application/` directory, և այնտեղ կիրառվում են reviewable patches-ը։ O3 extension-ի patch-ը target է անում ընտրված commit-ում փաստացի առկա `frontend/spa-assemble-config.json` ֆայլը. առանձին հորինված overlay config չի ստեղծվում։ Եթե ընտրված commit-ում այդ path-ը փոխված է, agent-ը կանգ է առնում և run record-ում արձանագրում է incompatibility-ն՝ այլ filename հորինելու փոխարեն։

Patched `pilot/openmrs-compatibility/work/reference-application/` copy-ից frontend-ը assemble/build է արվում ընտրված commit-ի արդեն գոյություն ունեցող frontend build path-ով և նույն commit-ի compose/distribution wiring-ով։ Նոր frontend Dockerfile, երկրորդ frontend image lineage, runtime-mounted import map/extension կամ upstream published frontend image-ով load proof արգելված են։ Եթե commit-ը patched `spa-assemble-config.json`-ից frontend artifact/image build անելու supported path չունի, agent-ը կանգ է առնում և գրանցում compatibility failure՝ build mechanism հորինելու փոխարեն։

OMOD artifact-ի distro inclusion-ը կատարվում է `omod-inclusion.patch`-ով, որը target է անում ընտրված commit-ի արդեն գոյություն ունեցող backend module inclusion/build file-ը և օգտագործում է նույն commit-ի Dockerfile/compose distribution build-ը։ Target relative path-ը գրանցվում է run record-ում։ Առանձին Dockerfile, երկրորդ image lineage, runtime volume-mounted OMOD կամ այլ հրապարակված backend image չի թույլատրվում։ Եթե commit-ում supported inclusion point չի գտնվում, agent-ը կանգ է առնում և գրանցում compatibility failure՝ path կամ mechanism հորինելու փոխարեն։ Effective diff-ը պահվում է run record-ում։ `upstream/` և `work/` checkout-ները project source-ի մաս չեն commit արվում։

`pilot/openmrs-compatibility/backend/`-ում և `pilot/openmrs-compatibility/frontend/`-ում հավաքված local artifact-ը patched distro build-ին կարելի է միացնել միայն այն դեպքում, երբ ընտրված commit-ի արդեն գոյություն ունեցող inclusion/assemble file-ը և իր սկզբնական build context-ը ընդունում են այդ relative path-ը։ Չի թույլատրվում artifact-ը կամ source-ը պատճենել `pilot/openmrs-compatibility/work/reference-application/`-ի ներսում նոր directory, օգտագործել `../../backend` / `../../frontend` հղում, եթե այն դուրս է գործող build context-ից, կամ փոխել compose/Docker `context:`-ը։ Եթե commit-ի սեփական mechanism-ը արտաքին local artifact չի ընդունում, համապատասխան backend կամ frontend proof-ը compatibility failure է. նոր artifact-transfer կամ deployment ճանապարհ չի ստեղծվում։

Supported inclusion/build path-ի բացակայությունը **սպասելի և լիարժեք terminal PoC արդյունք** է, ոչ spec-ը շրջանցելու պատճառ։ Անկախ փորձերի քանակից agent-ը չի ստեղծում copy-into-work-tree workaround, երկրորդ Dockerfile/image lineage, նոր build context կամ runtime mount։ Reviewer-ը կարող է ընդունել failure evidence-ը և ADR-0002 recommendation կազմել կամ առանձին նոր որոշում պահանջել. «proof required» ցանկը failure-ը կանաչ դարձնելու պարտավորություն չի ստեղծում։

Եթե archetype-ը գեներացնում է `liquibase.xml` կամ դրա registration-ը, pilot-ը դրանք հեռացնում է մինչև առաջին commit/build-ը։ No-op/empty changeset չի պահվում։ Եթե ընտրված official tooling-ը առանց դրա չի build լինում, փորձը գրանցվում է որպես compatibility failure. ֆայլը չի վերադարձվում միայն build-ը կանաչ դարձնելու համար։ Custom table կամ production migration արգելված է։

## Probe endpoint contract

- Method/path: `GET /ws/rest/v1/saribekyanpilot/status`
- Authentication: գործող native OpenMRS session և ընտրված distro-ի արդեն գոյություն ունեցող համապատասխան administrative privilege։ Privilege-ը ընտրվում է read-only inspection-ով և նրա exact անունը գրանցվում է run record-ում։ Pilot-ը privilege չի ստեղծում, չի վերանվանում և չի նշանակում role/user-ին։ Եթե endpoint-ին կիրառելի գոյություն ունեցող privilege չկա, agent-ը չի իջեցնում պաշտպանությունը մինչև պարզապես authenticated access. pilot-ը կանգ է առնում `NO_EXISTING_PRIVILEGE_FIXTURE` compatibility failure-ով։
- Public/anonymous access, custom auth bypass, `@Public` equivalent կամ security disable արգելված է։
- Pilot O3 extension-ը կանչում է endpoint-ը նույն authenticated O3 session-ով։ Թեստը կատարվում է distro-ի admin test account-ով։
- `200` body՝ `{ "moduleId": "saribekyanpilot", "status": "UP" }`։
- Առանց session-ի ստուգվում է `401`։ `403` ստուգվում է միայն եթե ընտրված distro-ում արդեն գոյություն ունի authenticated սահմանափակ test account, որը չունի ընտրված privilege-ը։ Այդպիսի fixture չլինելու դեպքում pilot-ը user, patient, role կամ privilege assignment չի ստեղծում. `403` check-ը նշվում է `NOT_RUN_MISSING_EXISTING_FIXTURE`, և սա pilot failure չէ։ Endpoint-ը patient/system secrets կամ version inventory չի վերադարձնում։
- Այս probe-ը չի հետևում [04-API.md](../04-API.md)-ի custom facade envelope-ին։ `401/403` response body-ն մնում է ընտրված OpenMRS REST runtime-ի native ձևաչափով, և pilot-ը assertion է անում միայն HTTP status-ի վրա։ Error adapter, wrapper կամ ընդհանուր API layer չի կառուցվում։

## Completion evidence: success or terminal incompatibility (`D008_SUCCESS_OR_TERMINAL_EVIDENCE`)

Ստորև կետերը success path-ի proof targets են, ոչ բոլորն անպայման կանաչ դարձնելու հրահանգ։ Եթե §-ով թույլատրելի terminal incompatibility է արձանագրվել (օրինակ՝ supported inclusion/build path չկա), բաց success proof-ը չի շրջանցվում workaround-ով. run record-ը պահում է հասած քայլերը, failure evidence-ը և չկատարված proof-ի պատճառը։ `COMPLETION_REVIEW`-ը կարող է ընդունել այդ արդյունքը որպես ավարտված PoC, ոչ որպես production compatibility success։

1. Reference distribution-ը exact SHA-ից reproducibly բարձրանում է։
2. Minimal OMOD-ը compile/package/install/start է լինում։
3. Probe-ը վերադարձնում է `200`, anonymous request-ը՝ `401`, իսկ `403`-ը կամ ստուգված է գոյություն ունեցող սահմանափակ fixture-ով, կամ բացահայտ գրանցված է `NOT_RUN_MISSING_EXISTING_FIXTURE`։
4. Minimal O3 extension-ը build/load է լինում patched work copy-ի նույն commit-ի սեփական frontend assembly/build-ից։ Browser-ում loaded asset/import-map evidence-ը պետք է ցույց տա pilot extension-ը. upstream published frontend image-ը proof չէ։
5. Frontend-ը կանչում է pilot endpoint-ը՝ առանց clinical/business payload-ի։
6. Resolved JVM, DB, Platform, OMOD և O3 package versions-ը գրանցված են։
7. Clean rerun և teardown-ը documented են։

## Prohibited

Business entities/services, production Liquibase changes, canonical OpenMRS data writes, authentication replacement, external integrations, candidate libraries և REG–ADM directories։

## Run record

Run record-ը ստեղծվում է pre-code review-ից առաջ և ունի երկու checkpoint։ `KICKOFF_READY` վիճակում բոլոր **Pre-code inputs**-ը փաստացի արժեքներով լրացված են, իսկ բոլոր **Post-run outputs**-ը նշվում են բառացի `PENDING_D008_EXECUTION`։ Սա թույլատրելի pending marker է միայն Post-run outputs-ի համար, ոչ proof և ոչ pre-code input-ի փոխարինող։ `COMPLETION_REVIEW` վիճակում ոչ մի `PENDING_D008_EXECUTION` չի մնում. յուրաքանչյուր output field պարունակում է success/failure/not-run evidence՝ spec-ի թույլատրած պատճառներով։

### Pre-code inputs — actual values required for `KICKOFF_READY`

- Checkpoint: `KICKOFF_READY`
- Reference repository commit SHA (actual full 40-hex commit SHA; token, label, blank կամ placeholder-ը `NO_GO` է):
- SHA selection rationale and release/tag relation:
- Upstream CI/build evidence:
- SHA approved by/date/evidence:
- Attempt number (positive integer; first attempt is `1`):
- Previous SHA: `N/A_FIRST_ATTEMPT` for attempt `1`; actual full 40-hex previous SHA for attempt `2+`
- Retry reason: `N/A_FIRST_ATTEMPT` for attempt `1`; concrete failure/retry reason for attempt `2+`
- Selection date:
- Planned frontend assembly/build command and target from selected commit:
- Planned backend inclusion target relative path:
- Existing OpenMRS privilege selected for probe, or pre-code `NO_EXISTING_PRIVILEGE_FIXTURE` finding:
- Existing limited account selected for 403, or planned `NOT_RUN_MISSING_EXISTING_FIXTURE`:
- Planned commands and check IDs:

### Post-run outputs — `PENDING_D008_EXECUTION` at kickoff, evidence at completion

- Resolved distribution/platform/JVM/DB versions:
- Resolved OMOD/O3 package versions and container image digests:
- Generated backend archetype/tool version:
- Generated frontend template/tool version:
- Browser/import-map evidence for pilot extension:
- Effective distro/SPA overlay diff:
- Executed commands and check results:
- HTTP `200/401` and applicable `403` evidence:
- Teardown and clean-rerun evidence:
- Result and blockers:
- ADR-0002 recommendation:

Kickoff-ից առաջ դատարկ, `TBD`, `REQUIRED_BEFORE_KICKOFF_GO`, `PENDING_D008_EXECUTION` կամ այլ placeholder պարունակող Pre-code input-ը `NO_GO` է։ Reference SHA դաշտում պետք է լինի հենց actual full 40-hex commit SHA-ն։ Post-run outputs-ի **յուրաքանչյուր** դաշտ, ներառյալ `Effective distro/SPA overlay diff`, `Executed commands and check results`, `Result and blockers`, kickoff պահին պարտադիր `PENDING_D008_EXECUTION` է։ Completion review-ում checkpoint-ը փոխվում է `COMPLETION_REVIEW`, և բոլոր այդ markers-ը փոխարինվում են փաստացի evidence-ով։

`N/A_FIRST_ATTEMPT`-ը placeholder չէ և թույլատրելի է միայն attempt `1`-ի `Previous SHA` ու `Retry reason` դաշտերում։ Attempt `2+`-ի դեպքում այդ token-ը `NO_GO` է. previous SHA-ն և retry reason-ը պետք է փաստացի լրացված լինեն։

Run record-ում չեն գրվում admin/limited-account գաղտնաբառերը, session cookie-ները, tokens-ը կամ այլ secrets։ Գրանցվում են միայն account identifier-ը, privilege-ի անունը և non-secret artifact/version evidence-ը։
