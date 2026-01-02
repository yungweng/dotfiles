---
name: deep-investigation
description: Systematic deep-dive investigation methodology for complex code analysis
---

# Deep Investigation Methodology

When investigating complex issues, follow this systematic approach.

## Investigation Phases

### Phase 1: Scope Definition
Before diving in:
- What exactly are we investigating?
- What would "solved" look like?
- What's the boundary of investigation?
- What constraints exist (time, access)?

### Phase 2: Evidence Gathering
Collect all relevant information:
- Error messages (exact text)
- Stack traces (complete)
- Logs (with timestamps)
- Related code changes (git history)
- Configuration (relevant settings)

### Phase 3: Hypothesis Generation
Based on evidence, generate hypotheses:
1. Most likely cause: [hypothesis]
2. Second most likely: [hypothesis]
3. Unlikely but possible: [hypothesis]

For each hypothesis:
- What evidence supports it?
- What evidence contradicts it?
- How can it be tested?

### Phase 4: Systematic Verification
For each hypothesis:
1. Identify the specific code path
2. Trace execution step by step
3. Look for the specific failure point
4. Verify with evidence

### Phase 5: Root Cause Confirmation
Before declaring root cause found:
- [ ] Can I explain WHY this happens?
- [ ] Can I explain WHEN this happens?
- [ ] Can I explain HOW to reproduce?
- [ ] Does fixing this actually solve the problem?
- [ ] Are there other contributing factors?

## Investigation Tools

### Code Tracing
```
rg "function_name" --type ts -A 5 -B 5
```

### Git Archaeology
```
git log -S "search_term" --source --all
git blame file.ts | grep "line_content"
```

### Dependency Mapping
```
rg "import.*module" --type ts
```

### Usage Analysis
```
rg "function_name\(" --type ts
```

## Documentation Requirements

Every investigation must produce:

```
## Investigation Report

### Problem Statement
[What was observed]

### Investigation Scope
[What was examined]

### Evidence Collected
[List of evidence with sources]

### Hypotheses Tested
| Hypothesis | Evidence For | Evidence Against | Verdict |
|------------|--------------|------------------|---------|

### Root Cause
[Specific location and reason]

### Evidence Chain
[Step-by-step from trigger to symptom]

### Additional Findings
[Other issues discovered]

### Recommended Fix
[Specific solution]

### Confidence
[HIGH/MEDIUM/LOW with reasoning]
```

## Rules

1. Never stop at the first plausible explanation
2. Always verify hypotheses against code
3. Document everything—future you will thank you
4. If stuck, step back and re-scope
5. Ask for help before rabbit-holing for hours
