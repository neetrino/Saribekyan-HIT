# OpenMRS Compatibility Pilot

## Authorization and scope

Այս PoC-ն թույլատրված է D-008-ով և business feature չէ։ Այն չունի REG–ADM requirement ID կամ owning business module։ Այն չի պահում patient/clinical/finance տվյալ, չի ստեղծում production table և չի սահմանում production architecture-ը։

## Temporary identifiers

- Workspace: `pilot/openmrs-compatibility`
- Backend module ID: `saribekyanpilot`
- Temporary Java package: `org.openmrs.module.saribekyanpilot`
- Frontend extension name: `saribekyan-pilot-extension`

Սրանք disposable PoC identifiers են և business code-ում չեն պահպանվում։ Production reverse-domain prefix-ը մնում է առանձին blocker։

## Candidate baseline selection

Pilot-ը սկսվում է պաշտոնական `openmrs/openmrs-distro-referenceapplication` repository-ի `main` branch-ի **մեկ exact commit SHA-ից**, որը գրանցվում է այս փաստաթղթի «Run record» բաժնում մինչև որևէ code generation։ Օգտագործվում են հենց այդ commit-ի distribution manifests/images/module versions-ը։

- `main`, `latest`, `next` կամ floating image tag-ը evidence-ում բավարար pin չէ։
- OpenMRS Platform `2.8.0` և Java `21` հիշատակումները ինքնաբերաբար pilot baseline չեն։
- Pilot commit-ի ընտրությունը production approval չէ։ Pilot-ի արդյունքից հետո compatibility matrix-ն է առաջարկում production candidate-ը։
- Եթե ընտրված commit-ը reproducibly չի build/run լինում, failure-ը append-only evidence է։ Հաջորդ փորձը կարող է փոխել **միայն** նույն `openmrs/openmrs-distro-referenceapplication` repository-ի exact commit SHA-ն և պետք է նոր attempt-ով գրանցի պատճառը, նախորդ SHA-ն ու նոր SHA-ն։ Run record-ի թարմացումը Bahmni, Ozone, այլ distribution, PostgreSQL կամ commit-ի manifest-ից դուրս JVM/DB/module substitution չի թույլատրում։ Այդպիսի փոփոխությունը D-008-ից դուրս է և պահանջում է նոր ընդունված որոշում։

Official baseline source: <https://github.com/openmrs/openmrs-distro-referenceapplication>

## Allowed minimal layout

```text
pilot/openmrs-compatibility/
├── README.md                     # commands and limitations
├── RUN-RECORD.md                 # commit SHA, resolved versions, environment, results
├── upstream/
│   └── reference-application/    # exact-SHA checkout/worktree; ignored, not modified or committed
├── distribution/
│   └── patches/
│       └── spa-assemble-config.patch # patches the selected commit's real frontend/spa-assemble-config.json
├── work/
│   └── reference-application/    # ignored derived copy used for build after patches are applied
├── backend/                      # official OpenMRS SDK/archetype output, minimal module only
└── frontend/                     # minimal O3 extension generated from supported tooling/template
```

Pilot-ը **չի օգտագործում** `03-STRUCTURE.md`-ի business module skeleton-ը։ Backend layout-ը վերցվում է ընտրված baseline-ին համատեղելի պաշտոնական OpenMRS module SDK/archetype-ից։ Դատարկ custom `application/domain/infrastructure/web` layers չեն ավելացվում։

Pristine `upstream/reference-application/` checkout-ը չի խմբագրվում։ Build-ից առաջ այն պատճենվում է ignored `work/reference-application/` directory, և այնտեղ կիրառվում են reviewable patches-ը։ O3 extension-ի patch-ը target է անում ընտրված commit-ում փաստացի առկա `frontend/spa-assemble-config.json` ֆայլը. առանձին հորինված overlay config չի ստեղծվում։ Եթե ընտրված commit-ում այդ path-ը փոխված է, agent-ը կանգ է առնում և run record-ում արձանագրում է incompatibility-ն՝ այլ filename հորինելու փոխարեն։

OMOD artifact-ի distro inclusion-ը նույնպես կատարվում է ընտրված commit-ի իրական manifest/config path-ին ուղղված reviewable patch-ով։ Effective diff-ը պահվում է run record-ում։ `upstream/` և `work/` checkout-ները project source-ի մաս չեն commit արվում։

Եթե archetype-ը գեներացնում է `liquibase.xml` կամ դրա registration-ը, pilot-ը դրանք հեռացնում է մինչև առաջին commit/build-ը։ No-op/empty changeset չի պահվում։ Եթե ընտրված official tooling-ը առանց դրա չի build լինում, փորձը գրանցվում է որպես compatibility failure. ֆայլը չի վերադարձվում միայն build-ը կանաչ դարձնելու համար։ Custom table կամ production migration արգելված է։

## Probe endpoint contract

- Method/path: `GET /ws/rest/v1/saribekyanpilot/status`
- Authentication: գործող native OpenMRS session և ընտրված distro-ի արդեն գոյություն ունեցող համապատասխան administrative privilege։
- Public/anonymous access, custom auth bypass, `@Public` equivalent կամ security disable արգելված է։
- Pilot O3 extension-ը կանչում է endpoint-ը նույն authenticated O3 session-ով։ Թեստը կատարվում է distro-ի admin test account-ով։
- `200` body՝ `{ "moduleId": "saribekyanpilot", "status": "UP" }`։
- Առանց session-ի՝ `401`; session կա, privilege չկա՝ `403`։ Endpoint-ը patient/system secrets կամ version inventory չի վերադարձնում։

## Proof required

1. Reference distribution-ը exact SHA-ից reproducibly բարձրանում է։
2. Minimal OMOD-ը compile/package/install/start է լինում։
3. Վերևում սահմանված authenticated probe endpoint-ը վերադարձնում է contract-ի `200/401/403` արդյունքները։
4. Minimal O3 extension-ը build/load է լինում extension system-ով։
5. Frontend-ը կանչում է pilot endpoint-ը՝ առանց clinical/business payload-ի։
6. Resolved JVM, DB, Platform, OMOD և O3 package versions-ը գրանցված են։
7. Clean rerun և teardown-ը documented են։

## Prohibited

Business entities/services, production Liquibase changes, canonical OpenMRS data writes, authentication replacement, external integrations, candidate libraries և REG–ADM directories։

## Run record

- Reference repository commit SHA: `TBD at pilot kickoff`
- Attempt number and previous SHA (if retry):
- Retry reason (if any):
- Selection date:
- Resolved distribution/platform/JVM/DB versions:
- Generated backend archetype/tool version:
- Generated frontend template/tool version:
- Existing OpenMRS privilege used by probe:
- Effective distro/SPA overlay diff:
- Commands and checks:
- Result and blockers:
- ADR-0002 recommendation:
