# Sequential Thinking Command

## Purpose
Apply systematic, step-by-step reasoning to break down complex problems.

## Execution Pattern

### 1. Problem Decomposition
```
PROBLEM STATEMENT: [Clearly define the problem]
├── Component 1: [Break down]
│   ├── Sub-component 1.1
│   └── Sub-component 1.2
├── Component 2: [Break down]
└── Component 3: [Break down]
```

### 2. Sequential Analysis
For each component:
```
ANALYZING: [Component Name]
- Current State: [What exists now]
- Desired State: [What we want]
- Gap Analysis: [What needs to change]
- Dependencies: [What it relies on]
- Impact: [What it affects]
```

### 3. Solution Building
```
STEP 1: [First action]
  Rationale: [Why this first]
  Prerequisites: [What's needed]
  
STEP 2: [Next action]
  Rationale: [Why this follows]
  Dependencies: [From Step 1]
  
[Continue for all steps...]
```

### 4. Validation Chain
```
✓ Step 1 enables Step 2 because...
✓ Step 2 enables Step 3 because...
✓ Final state matches desired outcome
```

## Thinking Patterns

### Forward Chaining
Start from known facts → derive conclusions
```
Given: A, B, C
If A and B then D
If C and D then E
Therefore: E
```

### Backward Chaining
Start from goal → work backwards to requirements
```
Goal: Z
Z requires: X and Y
Y requires: V and W
X requires: T and U
Therefore need: T, U, V, W
```

### Constraint Propagation
Identify constraints → propagate through system
```
Constraint 1 limits options to: [A, B, C]
Constraint 2 eliminates: [B]
Constraint 3 requires: [A or C]
Solution space: [A, C]
```

## Integration Notes
- Follows naturally after subagent exploration
- Provides structure for debugging phase
- Essential for complex logic problems