---
name: confidence-tracker
description: Track and report confidence levels for all findings and claims
---

# Confidence Tracking Protocol

After every finding, claim, or recommendation, explicitly rate your confidence.

## Confidence Levels

### 🟢 HIGH (90%+)
Use when:
- Verified by reading actual code
- Traced execution path completely
- Confirmed with multiple sources
- No assumptions required

Example: "This function throws on null input — Confidence: HIGH (verified at line 42)"

### 🟡 MEDIUM (60-90%)
Use when:
- Based on strong patterns
- Partial verification done
- Some assumptions made
- Missing some context

Example: "This likely causes a race condition — Confidence: MEDIUM (pattern matches, not fully traced)"

### 🔴 LOW (<60%)
Use when:
- Hypothesis based on limited info
- Significant assumptions made
- Need more investigation
- Extrapolating from partial data

Example: "This might be the root cause — Confidence: LOW (needs deeper investigation)"

## Output Format

For every finding, use this format:

```
[Finding description]
— Confidence: [🟢 HIGH / 🟡 MEDIUM / 🔴 LOW]
— Basis: [What this confidence is based on]
— To increase confidence: [What would be needed]
```

## Aggregated Confidence Report

At the end of any analysis, provide:

```
## Confidence Summary
- High confidence findings: [count]
- Medium confidence findings: [count]
- Low confidence findings: [count]

## Areas of Uncertainty
- [Topic]: [Why uncertain] — [How to resolve]

## Verification Recommendations
- [What should be tested/verified manually]
```

## Rules

1. NEVER claim certainty without evidence
2. ALWAYS specify what the confidence is based on
3. Prefer saying "I don't know" over low-confidence guesses
4. Update confidence as you learn more
5. High-stakes findings need HIGH confidence or explicit caveats
