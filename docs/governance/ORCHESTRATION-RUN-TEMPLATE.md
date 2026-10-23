# Orchestration run record

> Template. Copy for a long, multi-agent or high-risk task. This record coordinates work; it does not authorize business scope or replace governing evidence.

```yaml
run_id: "ORCH-YYYYMMDD-NNN"
task_id: "<task id>"
objective: "<measurable outcome>"
state: "INTAKE|DESIGN|IMPLEMENTATION|REVIEW|QA|NEEDS_REWORK|BLOCKED|COMPLETE"
orchestrator: orchestrator
started_at: "<ISO-8601>"
updated_at: "<ISO-8601>"
source_paths: []
in_scope: []
out_of_scope: []
dependencies:
  resolved: []
  unresolved: []
risk_flags:
  security: false
  privacy_phi: false
  authorization: false
  schema_migration: false
  money: false
  concurrency: false
  external_integration: false
  browser_flow: false
required_agents: []
review_identity: "PENDING"
blockers: []
```

## Work allocation

| Agent | Assignment | Owned paths | Depends on | Status |
|---|---|---|---|---|
| developer |  |  |  | PENDING |
| coder |  |  | developer | PENDING |
| reviewer |  | read-only review | coder | PENDING |
| security-privacy-reviewer |  | read-only review | coder | N/A |
| qa-playwright |  | test artifacts only | stable build | N/A |

## Acceptance checks

- [ ] `<observable result>`

## Handoffs

### Developer

```yaml
status: PENDING
summary: ""
evidence: []
assumptions: []
risks: []
blockers: []
```

### Coder

```yaml
status: PENDING
summary: ""
changed_paths: []
evidence: []
blockers: []
review_identity: "PENDING"
```

### Reviewer

```yaml
status: PENDING
findings: []
evidence: []
review_identity: "PENDING"
```

### Security/privacy reviewer

```yaml
status: N/A
findings: []
evidence: []
review_identity: "PENDING"
```

### QA — Playwright

```yaml
status: N/A
environment: ""
scenarios: []
artifacts: []
console_errors: []
failed_requests: []
review_identity: "PENDING"
```

## Final aggregation

```yaml
state: "COMPLETE|BLOCKED|NEEDS_REWORK"
completed_at: "<ISO-8601 or null>"
accepted_evidence: []
residual_risks: []
follow_up_tasks: []
```
