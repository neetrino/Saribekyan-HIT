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
owner_decisions:
  - decision_id: "<stable id or N/A_NONE>"
    state: "N/A_NONE|BLOCKED_OWNER_DECISION_REQUIRED|OWNER_DECIDED"
    question: "<missing critical decision>"
    documentation_gap: "<why canonical documentation is insufficient>"
    affected_requirements: []
    affected_tasks: []
    affected_paths: []
    options:
      - option: "<viable option>"
        tradeoffs: "<benefits, costs and risks>"
    recommendation_only: "<agent recommendation, never approval>"
    owner_selection: "<explicit selection or PENDING>"
    approval_evidence: "<message/record/ADR reference or PENDING>"
    adr: "<path or N/A_NO_SIGNIFICANT_ARCHITECTURE_DECISION>"
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
new_subagent:
  requested: false
  owner_approval_evidence: "N/A_NO_NEW_SUBAGENT"
  owner_selected_model: "N/A_NO_NEW_SUBAGENT"
background_execution:
  supported_after_parent_turn: false
  mechanism: "<supported wait/resume mechanism or N/A>"
  user_notified_at: "<ISO-8601 or N/A>"
model_routing:
  - role: orchestrator
    model: "Opus 5.5"
    reasoning: "platform default"
    substitution: "PROHIBITED_WITHOUT_OWNER_APPROVAL"
  - role: developer
    model: "Sonnet 5.5"
    reasoning: "platform default"
    substitution: "PROHIBITED_WITHOUT_OWNER_APPROVAL"
  - role: reviewer
    model: "GPT-5.4"
    reasoning: "medium"
    substitution: "PROHIBITED_WITHOUT_OWNER_APPROVAL"
  - role: qa-playwright
    model: "Grok 4.7"
    reasoning: "platform default"
    substitution: "PROHIBITED_WITHOUT_OWNER_APPROVAL"
  - role: security-privacy-reviewer
    model: "Opus 5.5"
    reasoning: "platform default"
    substitution: "PROHIBITED_WITHOUT_OWNER_APPROVAL"
review_identity: "PENDING"
blockers: []
```

## Work allocation

| Agent | Model | Selection reason | Assignment | Owned paths | Depends on | Status |
|---|---|---|---|---|---|---|
| developer |  |  |  |  |  | PENDING |
| reviewer |  |  |  | read-only review | developer | PENDING |
| security-privacy-reviewer |  |  |  | read-only review | developer | N/A |
| qa-playwright |  |  |  | test artifacts only | stable build | N/A |

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

### Developer implementation

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
targeted_checks: []
final_integration_checks:
  diff_review: PENDING
  unfinished_parts: PENDING
  conflicts_and_duplication: PENDING
  architecture_integrity: PENDING
  imports_and_types: PENDING
  lint: PENDING
  tests: PENDING
  build: PENDING
  playwright_if_applicable: PENDING
  unrelated_files: PENDING
  requirement_conformance: PENDING
commits:
  - stage: "<logical completed stage>"
    owner: "<orchestrator or assigned integration agent>"
    sha: "PENDING"
    message: "<conventional commit message>"
    paths: []
    pushed: false
```
