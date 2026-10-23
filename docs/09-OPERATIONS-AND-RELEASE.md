# Operations and release baseline

## Status

`ACTIVE_DELIVERY_BASELINE`. Գործող runtime stack-ն է OpenMRS Reference Application 3.7.1, Platform 2.8.8 և Java 21։ Contract signing metadata-ն operations/release execution gate չէ։

## Reproducible runtime

- Runtime և dependency versions-ի source of truth-ը committed POM/Docker/frontend manifests-ն են։
- Release candidate-ը կառուցվում է clean checkout-ից։
- Developer workstation-ից unpublished artifact-ը production image չի պատճենվում։
- Stack pin-ի փոփոխությունը պահանջում է clean build/start և compatibility verification։
- Secrets-ը repository-ում չեն commit արվում։

## Release checks

1. Java/module և distribution build-ը հաջող է։
2. Database migration/startup-ը հաջող է և rollback/recovery ընթացակարգը փաստագրված է։
3. O3 shell-ը և կիրառելի Playwright flows-ը անցնում են։
4. Requirement-scoped security/privacy review-ը փակված է։
5. Known blockers-ը նշված են և release claim-ը չի ներառում blocked capability-ն։
6. As-built documentation-ը և `PHASE-STATUS.yaml`-ը թարմացված են։

## Backup and recovery

Backup frequency, retention, RPO/RTO և storage location-ը բաց production infrastructure որոշումներ են։ Դրանք չեն հորինվում և կանգնեցնում են միայն production recovery/SLA acceptance-ը։ Մինչ release acceptance-ը պետք է գրանցվեն backup command/automation-ը, encryption/access-ը, restore rehearsal-ը և արդյունքը։

## Rollback

Յուրաքանչյուր release candidate պահպանում է նախորդ image/config identity-ն, database change sequence-ը և rollback կամ forward-fix սահմանը։ Irreversible migration-ը պահանջում է առանձին reviewed recovery plan։

## Current readiness

P0-ը մնում է `IN_PROGRESS`, քանի դեռ clean-clone reproducibility, stable Docker frontend runtime, OMOD inclusion, CI և test harness evidence-ը ամբողջությամբ գրանցված չեն։ P2-ի վաղ REG-02 slice-ը թույլատրված զուգահեռ աշխատանք է և P0 completion չի ենթադրում։
