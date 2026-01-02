---
description: Verify claims in code comments and documentation
argument-hint: file or section to fact-check
---

$ARGUMENTS

# Code Fact-Check

Verify every claim in this code against the actual implementation. Comments lie. Names mislead. Trust nothing.

## Verification Protocol

For every claim found (comments, docstrings, function names, variable names):

### Step 1: Identify the Claim
- What is being stated or implied?
- Where is it stated? (file:line)
- What would be true if this claim is accurate?

### Step 2: Verify Against Code
- Read the actual implementation
- Trace the actual behavior
- Test edge cases mentally

### Step 3: Render Verdict
- ✅ ACCURATE - Claim matches implementation
- ❌ INACCURATE - Claim contradicts implementation
- ⚠️ INCOMPLETE - Claim is partially true
- 🔄 OUTDATED - Claim was probably true before
- ❓ UNVERIFIABLE - Can't determine from code alone

## Common Lies to Check

### Function Names
- Does `validateInput()` actually validate?
- Does `sanitize()` actually sanitize?
- Does `safe*()` actually make it safe?
- Does `ensure*()` actually ensure?

### Comments
- "This should never happen" — But can it?
- "TODO: Add error handling" — Is it actually needed?
- "Temporary fix" — How long has it been there?
- "Performance optimization" — Is it actually faster?

### Docstrings
- Do @param types match actual types?
- Do @returns descriptions match actual returns?
- Do @throws list all possible exceptions?
- Are examples still working?

### Variable Names
- Does `isValid` actually indicate validity?
- Does `sanitizedInput` actually be sanitized?
- Does `safeValue` actually be safe?
- Does `result` contain the expected result?

## Output Format

```
## Fact-Check Report

### Claims Verified
| Location | Claim | Verdict | Evidence |
|----------|-------|---------|----------|
| file:line | "claim text" | ✅/❌/⚠️ | [proof] |

### Critical Inaccuracies
- [file:line] Claim: "[claim]"
  Reality: [what actually happens]
  Impact: [why this matters]

### Outdated Documentation
- [file:line] [what's outdated and why]

### Missing Documentation
- [file:line] [what should be documented but isn't]

### Recommendations
1. [specific fix with location]

## Fact-Check Confidence
- Coverage: [what % of claims were verified]
- Certainty: [HIGH/MEDIUM/LOW]
```

Remember: The most dangerous bugs hide behind confident-sounding comments.
