# Create A Prompt Command

## Purpose
Engineer high-quality prompts for AI systems, following best practices for clarity, specificity, and effectiveness.

## Prerequisites/Context
- Clear objective for the prompt
- Understanding of target AI system capabilities
- Knowledge of prompt engineering principles
- Optional: $ARGUMENTS for prompt topic/domain

## Core Instructions

### 1. Prompt Engineering Framework
```
PROMPT_OBJECTIVE: [What the prompt should achieve]
├── Target AI: [GPT, Claude, specialized model]
├── Use Case: [Coding, analysis, creative, etc.]
├── Context Level: [Minimal, moderate, comprehensive]
└── Output Format: [Text, code, structured data]
```

### 2. Prompt Architecture Patterns

#### Basic Structure Template
```markdown
# [ROLE DEFINITION]
You are a [specific expertise] with [relevant experience/knowledge].

## Context
[Provide necessary background information]

## Objective
[Clear, specific goal statement]

## Instructions
1. [Step-by-step guidance]
2. [Specific requirements]
3. [Quality criteria]

## Constraints
- [Limitation 1]
- [Limitation 2]
- [Boundary conditions]

## Output Format
[Specify exact format expected]

## Examples
[Provide concrete examples of desired output]
```

#### Advanced Cognitive Architecture
```markdown
# IDENTITY BLOCK
[Who the AI should be - expertise, perspective, capabilities]

# COGNITIVE FRAMEWORK
[How the AI should think - methodologies, approaches, reasoning patterns]

# OPERATIONAL PRINCIPLES
[Core guidelines that should always apply]

# CONTEXT TRIGGERS
[When to activate specific behaviors or knowledge areas]

# OUTPUT EXCELLENCE PATTERNS
[What high-quality responses look like]

# SAFEGUARDS
[Error prevention and quality control measures]
```

### 3. Prompt Engineering Techniques

#### Chain of Thought Prompting
```markdown
Think through this step-by-step:
1. First, analyze the problem by [specific approach]
2. Then, consider [relevant factors]
3. Next, evaluate [alternatives/options]
4. Finally, synthesize your findings into [desired output]

Show your reasoning for each step.
```

#### Few-Shot Learning
```markdown
Here are examples of the task:

Example 1:
Input: [example input]
Output: [desired output format]
Reasoning: [why this is correct]

Example 2:
Input: [different example]
Output: [consistent format]
Reasoning: [explanation]

Now apply this pattern to: [new input]
```

#### Role-Based Prompting
```markdown
Act as a [specific role] with [years] of experience in [domain].
Your expertise includes [specific areas].
Your communication style is [tone/approach].
When approaching problems, you always [methodology].
```

### 4. Domain-Specific Prompt Templates

#### Code Review Prompt
```markdown
# Expert Code Reviewer

You are a senior software engineer with expertise in [language/framework].

## Review Criteria
- Code quality and maintainability
- Security vulnerabilities
- Performance implications
- Best practice adherence
- Documentation quality

## Review Process
1. Analyze code structure and organization
2. Identify potential issues and improvements
3. Provide specific, actionable feedback
4. Suggest concrete alternatives where applicable

## Output Format
```
SUMMARY: [Overall assessment]

CRITICAL ISSUES:
- [Issue 1]: [Location] - [Description] - [Fix]

IMPROVEMENTS:
- [Suggestion 1]: [Rationale] - [Implementation]

POSITIVE ASPECTS:
- [Good practice 1]: [Why it's good]
```
```

#### Architecture Analysis Prompt
```markdown
# System Architecture Analyst

You are a solutions architect specializing in [domain].

## Analysis Framework
1. System Structure: Components and relationships
2. Data Flow: Information movement patterns
3. Scalability: Growth and performance considerations
4. Security: Attack vectors and mitigations
5. Maintainability: Long-term sustainability

## Deliverables
- Architecture diagram (textual description)
- Trade-off analysis
- Risk assessment
- Improvement recommendations
```

#### Debugging Assistant Prompt
```markdown
# Debugging Specialist

You are an expert debugger with deep knowledge of [technology stack].

## Debugging Protocol
1. Error Analysis: Parse error messages and stack traces
2. Root Cause Investigation: Trace issue to source
3. Hypothesis Formation: Develop testable theories
4. Solution Design: Create targeted fixes
5. Prevention Strategy: Avoid similar issues

## Response Format
```
ERROR_ANALYSIS: [Breakdown of the error]
ROOT_CAUSE: [Underlying problem]
SOLUTION: [Step-by-step fix]
PREVENTION: [How to avoid in future]
TESTING: [How to verify fix works]
```
```

### 5. Prompt Optimization Techniques

#### Specificity Enhancement
```markdown
BEFORE: "Write good code"
AFTER: "Write a TypeScript function that validates email addresses, includes comprehensive error handling, follows clean code principles, and includes JSDoc documentation"
```

#### Context Injection
```markdown
# Project Context
- Framework: [React 18 with TypeScript]
- Architecture: [Component-based with hooks]
- Styling: [Tailwind CSS]
- State Management: [Zustand]
- Testing: [Jest with React Testing Library]

Given this context, [your request]
```

#### Constraint Definition
```markdown
## Requirements
- MUST use existing utility functions in utils/
- MUST follow established naming conventions
- MUST include error handling
- SHOULD optimize for performance
- SHOULD maintain backward compatibility
- COULD enhance user experience
```

### 6. Prompt Testing and Iteration

#### Quality Assessment Criteria
```markdown
PROMPT_QUALITY_CHECKLIST:
- [ ] Clear and unambiguous instructions
- [ ] Specific role and expertise definition
- [ ] Concrete examples provided
- [ ] Expected output format specified
- [ ] Constraints and boundaries defined
- [ ] Success criteria articulated
```

#### A/B Testing Framework
```markdown
VERSION_A: [Original prompt]
VERSION_B: [Modified prompt with specific change]

TEST_CRITERIA:
- Response quality
- Consistency across runs
- Adherence to requirements
- Usability of output
```

### 7. Prompt Libraries and Management

#### Categorization System
```
prompts/
├── coding/
│   ├── code-review.md
│   ├── debugging.md
│   └── refactoring.md
├── analysis/
│   ├── architecture.md
│   ├── performance.md
│   └── security.md
└── creative/
    ├── documentation.md
    └── naming.md
```

#### Version Control
```markdown
# Prompt: Code Review Assistant
# Version: 2.1
# Last Updated: [Date]
# Changes: Added security focus, enhanced output format
# Performance: 8.5/10 average quality score
```

## Anti-Patterns/Warnings
- Don't make prompts too long (cognitive overload)
- Avoid ambiguous language
- Don't assume context that isn't provided
- Beware of conflicting instructions
- Don't use overly complex jargon

## Integration with Other Commands
- **Subagents**: Create specialized prompts for each agent
- **Best Practice**: Incorporate best practices into prompts
- **Deep Search**: Use findings to inform prompt context
- **Debugging**: Create debugging-specific prompts

## Validation Checklist
- [ ] Prompt objective clearly defined
- [ ] Target audience/system specified
- [ ] Instructions are step-by-step and actionable
- [ ] Examples demonstrate desired output
- [ ] Constraints prevent unwanted behavior
- [ ] Success criteria are measurable
- [ ] Prompt tested with multiple inputs