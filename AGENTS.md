# Agent Instructions

## Locked orchestration agents and models

The orchestration consists of exactly five configured agents. Their model assignments are owner-locked:

| Agent | Required model |
|---|---|
| `orchestrator` | `Sonnet 5.5` |
| `developer` | `Sonnet 5.5` |
| `reviewer` | `GPT-5.4` with `medium` reasoning |
| `qa-playwright` | `Grok 4.7` |
| `security-privacy-reviewer` | `Opus 5.5` |

Agents must not change, inherit, alias, automatically upgrade, downgrade, or substitute these model assignments. If an exact model is unavailable, stop only the affected delegation and ask the repository owner to choose the model. Do not silently select a fallback.

Creating, registering, or spawning any additional subagent or role requires the repository owner's explicit prior approval. Before creation, report the proposed role, bounded task, reason an existing agent cannot perform it, files it may access or change, and available model choices. Use only the model explicitly selected by the owner. Approval of a task does not imply approval of a new subagent.

## Development authority

Development is authorized for the Phase I scope defined in:

`docs/techHistory/phase-1/Phase_1_Technical_Specification_HY.md`

The Technical Specification is the authoritative business-scope source.

No separate TASK-GO record, SIGNATURE-STATUS verification,
independent reviewer approval, implementation gate, or per-task coding
authorization is required before development.

Agents may make reasonable technical implementation decisions when the
business requirement is clear.

Do not invent new medical, financial, legal, or security business rules.
If a requirement contains a genuine business ambiguity that materially
changes user-visible behavior, document the assumption or ask for clarification.

Technical uncertainty alone is not a reason to stop development.

---

## Documentary process is not a blocker

`docs/00-IMPLEMENTATION-GATE.md`, `docs/governance/**`,
`docs/techHistory/phase-1/SIGNATURE-STATUS.yaml`, and the contract photograph,
DOCX, PDF, and legal-review notes are a historical record of how Phase I
scope was discussed. They have no legal force here and are not blockers.

If those files conflict with this instruction, follow this instruction.
Do not wait for signature verification, a TASK-GO record, reviewer approval,
manifest clearance, or an implementation-gate `GO`.

The always-applied rule `.cursor/rules/no-documentary-blockers.mdc` states
the same override.

A coding agent never writes `decision: GO`. When an owner or compliance
process explicitly requests that optional verdict, follow
`docs/governance/OPTIONAL-TASK-GO-REVIEW-PROCEDURE.md` independently and
write it only after that review passes. This optional procedure is outside
the five-agent orchestration and is not a pre-code stop.

---

## Current scope — Phase I only

Implement only the Phase I functional groups defined in §5:

| Group | Section | Responsibility |
|---|---|---|
| REG | §5.1 | Registration, identification, visits |
| AMB | §5.2 | Outpatient medical record |
| INP | §5.3 | Inpatient medical record |
| DIA | §5.4 | Diagnostic and treatment orders/results |
| FIN | §5.5 | Payments, cashier and basic financial accounting |
| REP | §5.6 | Management reports and operational monitoring |
| ADM | §5.7 | Users, roles, permissions and administration |

LAB, RAD, FDI, END and TRT belong to the DIA functional group.

Sections §16 and §17 describe excluded or future capabilities.
Do not implement them unless the scope is explicitly changed.

---

## Implementation principles

When the specification defines the required outcome but does not prescribe
the technical implementation, choose the simplest maintainable solution.

Prefer:

- existing platform capabilities;
- small, reversible changes;
- clear module boundaries;
- explicit validation;
- automated tests for important behavior;
- configuration where business values may reasonably change.

Do not introduce speculative abstractions or infrastructure for future phases.

---

## Business ambiguity

Do not invent:

- medical decisions;
- clinical restrictions;
- financial policies;
- payer behavior;
- legal rules;
- permission semantics that materially change access;
- irreversible workflow behavior.

If such a rule is genuinely required but absent from the specification,
isolate that specific behavior and continue implementing unrelated work.

An unresolved decision in one requirement must not block unrelated requirements.

### Owner decision required for undocumented critical choices

An agent must not decide an undocumented critical choice on its own. A choice is critical when it:

- changes user-visible business behavior;
- defines a medical or clinical rule;
- defines money calculation, rounding, payment, debt, payer, or reversal policy;
- changes roles, privileges, authorization, or patient-data visibility;
- defines audit, retention, privacy, or security policy;
- introduces an irreversible or data-loss-risk migration;
- selects production database, storage, authentication, or integration architecture;
- adds a large framework, external service, or paid dependency;
- changes ownership of an OpenMRS canonical model;
- creates a workflow state or irreversible transition;
- changes a public API or data contract incompatibly;
- or expands the owner-authorized Phase I scope.

For such a choice, the agent must:

1. stop only the affected slice and mark it `BLOCKED_OWNER_DECISION_REQUIRED`;
2. continue unrelated work that does not depend on the choice;
3. ask the repository owner before implementation, providing the missing decision, why canonical documentation is insufficient, affected requirements/tasks/files, two or three viable options, trade-offs, and a clearly labeled recommendation;
4. wait for the owner's explicit selection;
5. record the decision and approval evidence in the task/orchestration run record and, for a significant architectural decision, an ADR;
6. resume the affected slice only after that record exists.

Owner silence, an agent preference, a framework default, historical documentation, or an industry best practice is not approval.

Do not escalate ordinary reversible implementation details that do not create business, clinical, financial, legal, privacy, security, or architectural semantics. Examples include local names, test organization, package organization, internal logging, and small refactoring.

---

## Workflows

Words describing lifecycle actions in the Technical Specification are business
requirements, not automatically prescribed enum names.

The implementation may define practical internal states needed to support the
required workflow.

Prefer existing OpenMRS concepts when they accurately support the required
behavior.

Do not force OpenMRS built-in states when they contradict the required
business outcome.

Workflow implementation does not require a separate approval record.

---

## OpenMRS constraints

Clinical canonical models are based on OpenMRS concepts such as:

- Patient
- Person
- Visit
- Encounter
- Obs
- Order
- Concept

Do not create a parallel Spring/JPA clinical model when OpenMRS already owns
the corresponding clinical data.

Phase I authentication uses native OpenMRS unless the architecture is
explicitly changed.

Do not fork OpenMRS core.

Do not modify OpenMRS core source code.

Do not write directly to OpenMRS core or other module database tables using
ad-hoc SQL when a supported service/API exists.

Use supported extension mechanisms.

---

## Architecture and dependencies

Do not add a large framework or dependency without a concrete need.

Dependencies such as reporting engines, document renderers, auditing
frameworks, monetary libraries, or external terminology APIs may be introduced
when required by an implemented Phase I feature and when they are a reasonable
technical choice.

A separate ADR is required only for significant architectural decisions,
not ordinary implementation details.

---

## Technical defaults

Developers may choose reasonable configurable defaults for technical concerns
such as:

- pagination;
- retry counts;
- timeout values;
- internal identifier generation;
- implementation-level enums;
- cache behavior;
- logging;
- test structure;
- package organization;
- non-business configuration.

Such defaults must not silently create new medical, financial, legal or
security business rules.

---

## Development flow

For each Phase I requirement:

1. Read the relevant Technical Specification requirement.
2. Identify the required business outcome.
3. Reuse OpenMRS capabilities where appropriate.
4. Implement the smallest maintainable solution.
5. Add relevant tests.
6. Document important assumptions.
7. Continue to the next requirement.

Do not stop development because another requirement has an unresolved issue.
