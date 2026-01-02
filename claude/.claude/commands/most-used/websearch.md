# Web Search Command

## Purpose
Conduct targeted web searches for current information, best practices, and solutions beyond knowledge cutoff.

## Prerequisites/Context
- Clear search objective
- Optional: specific domains to include/exclude
- Understanding of information reliability hierarchy

## Core Instructions

### 1. Search Strategy Framework
```
OBJECTIVE: [What specific information needed]
├── Primary Query: [Main search terms]
├── Secondary Queries: [Alternative phrasings]
├── Domain Focus: [Specific sites if relevant]
└── Time Sensitivity: [Recent vs historical]
```

### 2. Progressive Search Refinement

#### Initial Broad Search
```
Query: "react hooks best practices 2024"
Purpose: Get overview of current landscape
```

#### Focused Technical Search
```
Query: "react useEffect cleanup patterns memory leaks"
Purpose: Drill into specific implementation details
```

#### Domain-Specific Search
```
Query: site:github.com "react hooks" performance
Purpose: Find real-world implementations
```

### 3. Information Source Hierarchy

#### Tier 1: Authoritative Sources
- Official documentation
- Framework/library official blogs
- Specification documents (W3C, RFC, etc.)
- Security advisories (CVE, vendor alerts)

#### Tier 2: Trusted Community
- Stack Overflow (accepted answers)
- GitHub issues/discussions
- Developer blogs from core maintainers
- Conference talks/presentations

#### Tier 3: General Community
- Medium articles
- Dev.to posts
- Reddit discussions
- YouTube tutorials

#### Verification Required
- Personal blogs
- Forum posts
- AI-generated content
- Outdated documentation

### 4. Search Query Patterns

#### Current Best Practices
```
"[technology] best practices 2024"
"[technology] patterns 2024"
"modern [technology] architecture"
```

#### Problem-Specific Searches
```
"[error message]" "[technology]"
"[technology] [specific issue] solution"
"how to [action] [technology] [constraint]"
```

#### Comparison Research
```
"[option A] vs [option B] 2024"
"[technology] alternatives comparison"
"why choose [X] over [Y]"
```

#### Security Research
```
"[technology] security vulnerabilities"
"[package] CVE"
"[technology] security best practices"
```

### 5. Information Validation Process

#### Recency Check
- Publication date
- Last updated timestamp
- Version compatibility
- Deprecation status

#### Authority Assessment
- Author credentials
- Publication venue
- Community consensus
- Official endorsement

#### Cross-Reference Validation
- Multiple source confirmation
- Conflicting information analysis
- Implementation examples
- Real-world usage

## Search Examples

### Framework Research
```bash
# Current state of technology
WebSearch: "Vue 3 vs React 18 performance comparison 2024"

# Migration guidance  
WebSearch: "migrate from Vue 2 to Vue 3 best practices"

# Security considerations
WebSearch: "Vue 3 security vulnerabilities 2024"
```

### Problem Solving
```bash
# Specific error resolution
WebSearch: "TypeError: Cannot read property of undefined react hooks"

# Performance optimization
WebSearch: "React component re-render optimization patterns"

# Integration challenges
WebSearch: "Next.js 13 app router integration issues"
```

### Architecture Research
```bash
# Design patterns
WebSearch: "microservices communication patterns 2024"

# Technology evaluation
WebSearch: "PostgreSQL vs MongoDB performance comparison"

# Scalability solutions
WebSearch: "horizontal scaling Node.js applications"
```

## Anti-Patterns/Warnings
- Don't rely on single search result
- Avoid outdated information (check dates)
- Beware of AI-generated content without verification
- Don't trust information without cross-referencing
- Avoid search terms that are too broad or too narrow

## Integration with Other Commands
- Feeds into `double-check-fact-check` for verification
- Provides context for `best-practice` implementations
- Supports `debugging` with current solutions
- Informs `subagents` with external knowledge

## Validation Checklist
- [ ] Search terms match objective
- [ ] Multiple reliable sources found
- [ ] Information recency verified
- [ ] Cross-references confirmed
- [ ] Potential biases identified
- [ ] Actionable insights extracted