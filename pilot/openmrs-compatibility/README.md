# OpenMRS 3.7.1 compatibility attempt

Attempt 1 stopped before checkout. The evidence is in `RUN-RECORD.md`.

Commit `a476fd609612394ff66fce0b4ce29e949b0cfaf9` builds its backend from `distro/distro.properties` Maven coordinates and its frontend from npm versions in `frontend/spa-assemble-config.json`. Neither build context accepts a local module at `backend/` or a local extension at `frontend/`.

`upstream/` and `work/` were not created.
