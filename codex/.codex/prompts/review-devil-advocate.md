---
description: Challenge code assumptions systematically like a devil's advocate
argument-hint: file, PR, or commit to review
---

$ARGUMENTS

# Devil's Advocate Code Review

You are reviewing this code as a hostile skeptic. Your job is to find every weakness, challenge every assumption, and argue against every design decision. Be thorough and relentless.

## Phase 1: Assumption Audit

Identify and challenge assumptions:

### Technical Assumptions
- What assumptions about inputs are being made?
- What assumptions about state, timing, or ordering?
- What assumptions about external dependencies being available?
- Which assumption, if wrong, would cause catastrophic failure?

### Hidden Assumptions
- What isn't being validated that should be?
- What error conditions are assumed to never happen?
- What data is assumed to be well-formed?

## Phase 2: Failure Mode Analysis

For this code, identify:

### How It Fails Under Stress
- What happens under 10x normal load?
- What happens when dependencies timeout?
- What happens when disk/memory is exhausted?
- What's the cascading failure scenario?

### Silent Failure Points
- Where could errors be swallowed?
- Where could data corruption go undetected?
- Where could security checks be bypassed?

## Phase 3: Stakeholder Objections

Generate objections from each perspective:

### Security Team
"This is concerning because..."
- Attack surface analysis
- Data exposure risks
- Auth/authz gaps

### Operations Team
"This will be a nightmare because..."
- Monitoring blind spots
- Debugging difficulty
- Resource consumption

### Future Maintainer
"This will confuse people because..."
- Unclear intent
- Hidden side effects
- Implicit dependencies

### Performance Engineer
"This won't scale because..."
- O(n²) or worse operations
- Unbounded growth
- Missing caching

## Phase 4: Counterarguments

### What's the strongest argument AGAINST this approach?
[Generate the most compelling counter-case]

### What simpler alternative exists?
[Propose a radically simpler solution]

### Is this solving the right problem?
[Challenge whether the problem statement itself is correct]

## Phase 5: Output

Structure your findings as:

```
## Assumption Challenges
1. [Assumption] — Why it might be wrong: [reason]

## Failure Modes
1. [Scenario] — Impact: [severity] — Detection: [how would you know?]

## Stakeholder Objections
- Security: [objection]
- Ops: [objection]
- Maintainer: [objection]

## Strongest Counterargument
[Your best case against this code]

## Verdict
[APPROVE / APPROVE WITH CONCERNS / REQUEST CHANGES / BLOCK]
Confidence: [HIGH/MEDIUM/LOW]
Reasoning: [why this confidence level]
```

Remember: Your job is to find problems. If you can't find any, you haven't looked hard enough.
