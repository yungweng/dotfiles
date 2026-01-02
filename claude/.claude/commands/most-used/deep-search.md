# Deep Search Command

## Purpose
Exhaustive exploration of codebase, documentation, and dependencies to uncover hidden patterns, relationships, and insights.

## Prerequisites/Context
- Specific target for deep investigation
- Codebase access
- Understanding of search scope and depth
- Patience for comprehensive analysis

## Core Instructions

### 1. Multi-Dimensional Search Framework
```
SEARCH TARGET: [Specific element to investigate]
├── Scope: [File/Module/System/Ecosystem]
├── Depth: [Surface/Implementation/Architecture/Historical]
├── Relationships: [Dependencies/Usages/Patterns]
└── Context: [Why this search is needed]
```

### 2. Codebase Archaeological Dig

#### Layer 1: Surface Discovery
```bash
# Find all references
rg "searchTerm" --type js --type ts
rg "className" --type py
grep -r "functionName" . --include="*.java"

# File pattern analysis  
find . -name "*pattern*" -type f
fd ".*config.*" --type f
```

#### Layer 2: Structural Analysis
```bash
# Dependency tracking
rg "import.*searchTerm" --type ts
rg "from.*searchTerm" --type py
grep -r "include.*searchTerm" . --include="*.cpp"

# Inheritance/extension patterns
rg "extends.*ClassName" --type js
rg "class.*\(.*BaseClass\)" --type py
```

#### Layer 3: Behavioral Patterns
```bash
# Usage patterns across codebase
rg "methodName\(" --type js -A 3 -B 3
rg "\.propertyName" --type ts -C 2

# Configuration patterns
rg "config\." -g "*.json" -g "*.yaml" -g "*.toml"
rg "environment\." -g "*.env*"
```

#### Layer 4: Historical Context
```bash
# Git archaeology
git log --grep="searchTerm" --oneline
git log -S "functionName" --source --all
git blame filename.js | grep "searchTerm"

# Evolution tracking
git log --follow -- path/to/file
```

### 3. Semantic Search Strategies

#### Concept Mapping
```
CONCEPT: Authentication
├── Direct: login, auth, user, session
├── Related: security, token, credential, verify
├── Implementation: jwt, oauth, passport, bcrypt
└── Infrastructure: middleware, guard, interceptor
```

#### Pattern Recognition
```bash
# Design pattern detection
rg "class.*Factory" --type java
rg ".*Observer.*" --type cpp  
rg "function.*Singleton" --type js

# Anti-pattern detection
rg "eval\(" --type js  # Dangerous patterns
rg "SELECT \*" --type sql  # Performance issues
```

### 4. Cross-Reference Analysis

#### Forward Tracing
```
Function X calls:
├── Function Y (direct)
├── Function Z (via callback)
├── External API (via HTTP)
└── Database (via ORM)
```

#### Backward Tracing  
```
Function X is called by:
├── Controller A (web endpoint)
├── Service B (business logic)
├── Test Suite C (verification)
└── Migration D (setup)
```

#### Lateral Analysis
```
Similar functions in codebase:
├── Same pattern, different domain
├── Similar logic, different implementation
├── Same purpose, different technology
└── Evolution of same concept
```

### 5. Documentation Mining

#### Code Comments Archaeology
```bash
# TODO/FIXME/HACK tracking
rg "TODO|FIXME|HACK|XXX" -n -C 2

# Decision rationale
rg "because|reason|why" -i -C 1

# Performance notes
rg "performance|optimize|slow|fast" -i -C 2
```

#### README/Doc Analysis
```bash
# Find all documentation
fd "README|CHANGELOG|CONTRIBUTING" --type f
fd "\.(md|rst|txt)$" --type f

# Extract configuration info
rg "^\s*[A-Z_]+=" .env.example
rg "default:" -g "*.yaml" -g "*.yml"
```

### 6. Dependency Deep Dive

#### Package Analysis
```bash
# Direct dependencies
cat package.json | jq '.dependencies'
cat requirements.txt
cat Cargo.toml

# Transitive dependencies
npm ls --depth=3
pip list
cargo tree
```

#### Version Tracking
```bash
# Version constraints
rg "\^|\~|>=|<=" package.json
rg "==" requirements.txt

# Security implications
npm audit
safety check
cargo audit
```

### 7. Performance Hotspot Detection

#### Resource Usage Patterns
```bash
# Memory allocations
rg "new |malloc|calloc" --type cpp
rg "new Array|new Object" --type js

# Loop patterns
rg "for.*in|for.*of|while|forEach" --type js -C 1
rg "for.*range|for.*in" --type py -C 1
```

#### Database Query Analysis
```bash
# Query patterns
rg "SELECT|INSERT|UPDATE|DELETE" --type sql -i
rg "find|findOne|aggregate" --type js
rg "query|filter|get" --type py
```

## Advanced Search Techniques

### AST-Based Search
```bash
# Using tree-sitter or similar
# Find all function declarations
# Identify complex expressions
# Detect code smells
```

### Semantic Similarity
```bash
# Functions with similar signatures
# Classes with similar interfaces  
# Modules with similar exports
```

### Temporal Analysis
```bash
# Code churn analysis
git log --stat --since="1 month ago"

# File modification patterns
git log --name-only --pretty=format: | sort | uniq -c | sort -nr
```

## Integration Patterns

### With Subagents
- Deploy specialized search agents for different layers
- Parallel exploration of related concepts
- Cross-validation of findings

### With Debugging
- Deep search for error patterns
- Historical bug analysis
- Related issue identification

### With Best Practices
- Pattern validation across codebase
- Consistency analysis
- Standard deviation identification

## Anti-Patterns/Warnings
- Don't search without clear objective
- Avoid analysis paralysis from too much data
- Don't ignore negative results (absence of patterns)
- Beware of confirmation bias in pattern recognition

## Validation Checklist
- [ ] Search scope appropriately defined
- [ ] Multiple search strategies employed
- [ ] Findings cross-referenced and validated
- [ ] Historical context considered
- [ ] Relationships mapped accurately
- [ ] Actionable insights identified