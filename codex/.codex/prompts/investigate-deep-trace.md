---
description: Deep trace through code execution paths - find the root cause
argument-hint: function, error, or behavior to investigate
---

$ARGUMENTS

# Deep Code Investigation

You are investigating this code like a detective. Follow every thread until you understand exactly what happens.

## Phase 1: Map the Territory

### Entry Points
- Where does execution start?
- What triggers this code path?
- What inputs flow in?

### Exit Points
- Where does execution end?
- What outputs are produced?
- What side effects occur?

### Data Flow Map
```
Input → [Transform 1] → [Transform 2] → ... → Output
           ↓                ↓
        [Side Effect]   [Side Effect]
```

## Phase 2: Follow the Data

For EVERY function in the path:

1. **Read the implementation** - Don't trust the name
2. **Trace inputs** - Where does each parameter come from?
3. **Track mutations** - What changes? When? Why?
4. **Follow outputs** - Where does the return value go?
5. **Find side effects** - What else does this touch?

### Questions to Answer
- Can any input be null/undefined here?
- Can any input be the wrong type?
- Can any input be maliciously crafted?
- What happens if this function throws?
- What happens if this function hangs?

## Phase 3: Check the Edges

### Null/Undefined Paths
- What happens with null input?
- What happens with undefined input?
- Are optional parameters handled?

### Empty Collection Paths
- What happens with empty array?
- What happens with empty object?
- What happens with empty string?

### Error Paths
- What exceptions can be thrown?
- Are they caught? Where?
- Is error information preserved?

### Concurrent Paths
- Can this be called twice simultaneously?
- Are there race conditions?
- Is there proper synchronization?

## Phase 4: Build the Evidence Chain

Document your trace with specific references:

```
1. [file:line] Input received: [description]
2. [file:line] Transformed by: [function]
3. [file:line] Passed to: [next function]
4. [file:line] Side effect: [what changed]
5. [file:line] Output produced: [description]
```

## Phase 5: Report Findings

```
## Investigation Summary
Target: [what was investigated]
Scope: [files/functions examined]

## Execution Flow
[Numbered steps from entry to exit]

## Data Transformations
[How data changes at each step]

## Issues Found
- [file:line] [issue type] [description]

## Root Cause (if investigating a bug)
Location: [file:line]
Cause: [specific reason]
Evidence: [how you verified this]

## Recommendations
[Suggested fixes with confidence level]

## Confidence Assessment
- Flow understanding: [HIGH/MEDIUM/LOW]
- Root cause certainty: [HIGH/MEDIUM/LOW]
- Areas not fully traced: [list]
```
