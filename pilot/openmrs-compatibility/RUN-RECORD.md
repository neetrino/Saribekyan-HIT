# D-008 run record — attempt 1

Checkpoint: `COMPLETION_REVIEW`

Result: `TERMINAL_INCOMPATIBILITY`

No checkout, module, extension, image build, or runtime was started. The release commit's own build files do not accept an external local OMOD or O3 extension. `docs/pilot/COMPATIBILITY-POC.md` treats that as a completed PoC outcome. No Dockerfile, build context, copy-into-work-tree, or published-image workaround was used.

## Pre-code inputs

- Reference repository: `https://github.com/openmrs/openmrs-distro-referenceapplication`
- Release tag: `3.7.1`
- Tag object SHA: `be2d14d14ac95165aeef9fe77100d5eb2b7dbb19` (annotated tag, not the code)
- Commit SHA: `a476fd609612394ff66fce0b4ce29e949b0cfaf9`
- Commit message: `(release) Release 3.7.1`
- Selection date: 2026-10-21
- Attempt: `1`
- Previous SHA: `N/A_FIRST_ATTEMPT`
- Retry reason: `N/A_FIRST_ATTEMPT`
- Source: `GITHUB_RELEASE_TAG`
- CI status for this exact commit: `NOT_VERIFIED_NO_DIRECT_CHECKS_FOUND` (`check-runs` total_count `0`)
- Tag signature: unsigned (`verified: false`)
- Rationale: 3.7.1 is the RefApp release under test. The code pin is the commit the annotated tag points to, not `main` and not the tag object.

## What the commit actually builds

Backend inclusion file: `distro/distro.properties`. Every module is a Maven coordinate such as `omod.webservices.rest=${webservices.rest.version}`. There is no relative path to a local OMOD.

Backend build, from `.github/workflows/build-backend.yml` and the root `Dockerfile`:

- Context: repository root (`.`)
- Copied into the image: `pom.xml` and `distro/` only
- Base images: `openmrs/openmrs-core:2.8.x-dev-amazoncorretto-21` and `openmrs/openmrs-core:2.8.x-amazoncorretto-21` (floating tags, not digests)
- Database declared by `docker-compose.yml`: `mariadb:10.11.7`
- Compose images: `openmrs/openmrs-reference-application-3-backend:${TAG:-qa}` and the matching frontend/gateway tags. Published images are not an OMOD install proof.

Frontend build, from `.github/workflows/build-frontend.yml` and `frontend/Dockerfile`:

- Context: `./frontend`
- Copied files: `spa-assemble-config.json`, `spa-build-config.json`, `startup.sh`, `nginx.conf`, `config-core_demo.json`
- Command: `npx --legacy-peer-deps openmrs@10.0.0 assemble --manifest --mode config --config spa-assemble-config.json --target ./spa`
- `frontend/spa-assemble-config.json` at this commit (blob `87fb3b5252783e1c3785a904a18c61216d5ca4bb`) lists published npm versions. `coreVersion` is `10.0.0`. It has no `file:` entry.

`pilot/openmrs-compatibility/backend` and `pilot/openmrs-compatibility/frontend` sit outside both build contexts. Reaching them needs a `../../` reference, a copy into `work/reference-application/`, or a Docker context change. The compatibility spec forbids all three.

## Post-run outputs

- Resolved distribution/platform/JVM/DB versions: not run. Declared, not resolved, values are platform image tag `2.8.x`, frontend `coreVersion` `10.0.0`, database image `mariadb:10.11.7`.
- Resolved OMOD/O3 package versions and container image digests: not run. Frontend package versions are pinned in the commit file. Image digests were not produced.
- Generated backend archetype/tool version: not generated
- Generated frontend template/tool version: not generated
- Browser/import-map evidence: not run
- Effective distro/SPA overlay diff: none. No patch was applied.
- Executed commands: GitHub API reads of the commit only. No `docker build`, checkout, or Maven build.
- HTTP `200/401` and `403`: not run
- Teardown and clean rerun: not applicable. Nothing was started.
- Privilege: not selected. The inclusion failure stops the attempt before an endpoint exists.
- ADR-0002 recommendation: 3.7.1's supported build consumes published Maven modules and published npm packages. A local OMOD and a local O3 extension are outside that mechanism. Another RefApp commit can be attempt 2 only if its inclusion file and original build context accept the local artifacts. This attempt does not promote `saribekyanpilot`.
