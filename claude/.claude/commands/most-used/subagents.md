# Subagents Command

## Purpose
Deploy multiple specialized AI agents in parallel to explore different aspects of a problem simultaneously, maximizing coverage and insight generation.

## Prerequisites/Context
- Complex problem requiring multiple perspectives
- Task tool access for parallel execution
- Clear objective that benefits from diverse approaches

## Core Instructions

### 1. Agent Deployment Strategy
```
MISSION: [Main objective]
├── Agent Squad Size: [3-6 agents optimal]
├── Specialization Areas: [Domain-specific focuses]
├── Coordination Protocol: [How agents share findings]
└── Synthesis Method: [How to combine insights]
```

### 2. Standard Agent Roles

#### Core Technical Agents
```
CODE_EXPLORER_AGENT:
- Mission: Find all relevant files and code patterns
- Focus: Implementation details, dependencies, structure
- Tools: Grep, Glob, Read
- Output: Code map with relationships

ARCHITECTURE_AGENT:  
- Mission: Analyze system design and data flow
- Focus: High-level patterns, interfaces, abstractions
- Tools: Deep search, documentation analysis
- Output: System architecture insights

TEST_COVERAGE_AGENT:
- Mission: Assess testing landscape and gaps
- Focus: Existing tests, coverage, missing scenarios
- Tools: Test file analysis, pattern detection
- Output: Testing strategy recommendations
```

#### Domain-Specific Agents
```
SECURITY_AGENT:
- Mission: Identify security implications and vulnerabilities
- Focus: Authentication, authorization, data protection
- Tools: Security pattern analysis, threat modeling
- Output: Security assessment and recommendations

PERFORMANCE_AGENT:
- Mission: Analyze performance characteristics and bottlenecks
- Focus: Scalability, optimization opportunities, resource usage
- Tools: Profiling, complexity analysis, benchmark research
- Output: Performance optimization roadmap

API_DESIGN_AGENT:
- Mission: Evaluate interface design and consistency
- Focus: Endpoints, contracts, backward compatibility
- Tools: API pattern analysis, documentation review
- Output: API design recommendations
```

#### Research Agents
```
DOCUMENTATION_AGENT:
- Mission: Gather all relevant documentation and context
- Focus: READMEs, comments, issue discussions, specifications
- Tools: Documentation mining, historical research
- Output: Comprehensive context map

ECOSYSTEM_AGENT:
- Mission: Research external solutions and best practices
- Focus: Industry standards, library comparisons, community patterns
- Tools: Web search, package analysis, trend research
- Output: External landscape analysis

HISTORICAL_AGENT:
- Mission: Analyze past decisions and evolution
- Focus: Git history, issue tracking, decision rationale
- Tools: Git archaeology, issue analysis, change tracking
- Output: Historical context and lessons learned
```

### 3. Parallel Execution Protocol

#### Phase 1: Agent Briefing
```markdown
AGENT_BRIEFING:
- Primary Objective: [Specific goal]
- Domain Focus: [Your specialization]
- Success Criteria: [What good looks like]
- Coordination Points: [When to share findings]
- Time Constraint: [Execution deadline]
```

#### Phase 2: Concurrent Investigation
```bash
# Deploy all agents simultaneously using Task tool
Task 1: CODE_EXPLORER_AGENT mission
Task 2: ARCHITECTURE_AGENT mission  
Task 3: SECURITY_AGENT mission
Task 4: PERFORMANCE_AGENT mission
Task 5: DOCUMENTATION_AGENT mission
```

#### Phase 3: Intelligence Gathering
Each agent reports findings in structured format:
```
AGENT: [Agent Name]
FINDINGS: [Key discoveries]
EVIDENCE: [Supporting data/files/patterns]
CONFIDENCE: [High/Medium/Low]
DEPENDENCIES: [What this relies on]
IMPLICATIONS: [What this means for the mission]
RECOMMENDATIONS: [Specific actions]
```

### 4. Synthesis and Integration

#### Cross-Agent Validation
```
FINDING_VALIDATION:
├── Agent A says: [Finding]
├── Agent B confirms: [Supporting evidence]
├── Agent C contradicts: [Conflicting evidence]
└── Resolution: [Consensus or investigation needed]
```

#### Pattern Recognition Across Agents
```
EMERGING_PATTERNS:
- Security + Performance: [Shared concerns]
- Architecture + Code: [Implementation alignment]
- Documentation + History: [Evolution story]
```

#### Unified Recommendations
```
SYNTHESIS_OUTPUT:
1. High-Confidence Findings: [All agents agree]
2. Medium-Confidence Findings: [Majority consensus]
3. Contradictions to Resolve: [Agent disagreements]
4. Integrated Action Plan: [Combined recommendations]
5. Risk Assessment: [Potential issues identified]
```

### 5. Agent Communication Patterns

#### Information Sharing Protocol
```
AGENT_COMMUNICATION:
- Discovery broadcast: "Found critical pattern X in file Y"
- Validation request: "Can anyone confirm behavior Z?"
- Contradiction alert: "My findings conflict with Agent B on topic W"
- Synthesis contribution: "My domain perspective on the unified solution"
```

#### Conflict Resolution
```
WHEN_AGENTS_DISAGREE:
1. Present both perspectives clearly
2. Identify root cause of disagreement
3. Seek additional evidence
4. Flag for human decision if unresolvable
```

### 6. Specialized Mission Types

#### Bug Investigation Squad
```
AGENTS:
- Reproduction Agent: Create minimal test case
- Root Cause Agent: Trace error to source
- Impact Agent: Assess blast radius
- Solution Agent: Design fix strategy
```

#### Feature Implementation Team
```
AGENTS:  
- Requirements Agent: Clarify specifications
- Design Agent: Plan architecture
- Implementation Agent: Code strategy
- Testing Agent: Validation approach
```

#### Refactoring Committee
```
AGENTS:
- Legacy Analysis Agent: Understand current state
- Target State Agent: Define desired outcome
- Migration Agent: Plan transition steps
- Risk Assessment Agent: Identify dangers
```

## Integration with Other Commands

### With Deep Search
- Agents use deep search techniques in their domains
- Parallel deep searches across different dimensions
- Cross-validation of deep search findings

### With Debugging
- Deploy debugging-focused agent squad
- Specialized agents for different error types
- Parallel investigation of multiple theories

### With Best Practices
- Research agents gather external best practices
- Implementation agents apply practices to local context
- Validation agents ensure practice compliance

## Anti-Patterns/Warnings
- Don't deploy too many agents (creates noise)
- Avoid overlapping agent responsibilities
- Don't proceed without agent synthesis
- Beware of confirmation bias across agents

## Validation Checklist
- [ ] Agent roles clearly defined and non-overlapping
- [ ] Parallel execution properly coordinated
- [ ] Findings validated across multiple agents
- [ ] Contradictions identified and resolved
- [ ] Synthesis provides actionable insights
- [ ] Agent specializations match problem domain