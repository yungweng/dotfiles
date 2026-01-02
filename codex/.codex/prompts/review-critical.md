---
description: Maximum scrutiny code review - find every possible issue
argument-hint: file, PR, or commit to review
---

$ARGUMENTS

# Critical Code Review

Apply maximum scrutiny. Assume bugs exist until proven otherwise.

## Review Checklist

### 1. Error Handling Trace
For every function:
- [ ] What errors can it throw/return?
- [ ] Are all errors handled by callers?
- [ ] Are errors logged with sufficient context?
- [ ] Are errors ever swallowed silently?

### 2. Input Validation
- [ ] All external inputs validated?
- [ ] Null/undefined checks present?
- [ ] Type coercion handled correctly?
- [ ] Boundary conditions tested?

### 3. State Management
- [ ] All state mutations explicit?
- [ ] Race conditions possible?
- [ ] State can become inconsistent?
- [ ] Cleanup always happens (finally blocks)?

### 4. Security Scan
- [ ] SQL/NoSQL injection possible?
- [ ] XSS vectors present?
- [ ] Secrets hardcoded or logged?
- [ ] Auth checks on all sensitive paths?
- [ ] Input size limits enforced?

### 5. Performance Red Flags
- [ ] O(n²) or worse operations?
- [ ] Unbounded memory growth?
- [ ] Missing pagination?
- [ ] N+1 query patterns?
- [ ] Blocking operations in async code?

### 6. Test Coverage Analysis
- [ ] Happy path tested?
- [ ] Error paths tested?
- [ ] Edge cases tested?
- [ ] Tests actually assert behavior?
- [ ] Tests don't just check "no crash"?

## Output Format

```
## Critical Issues (Must Fix)
- [file:line] [issue] — [impact]

## Serious Concerns (Should Fix)
- [file:line] [issue] — [risk if not fixed]

## Minor Issues (Nice to Fix)
- [file:line] [issue]

## Questions Requiring Answers
- [question] — [why it matters]

## Verification Steps Taken
- [what I checked and how]

## Confidence Assessment
- Overall confidence: [HIGH/MEDIUM/LOW]
- Areas of uncertainty: [list]
```
