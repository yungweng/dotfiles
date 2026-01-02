# Best Practice Command

## Purpose
Research, analyze, and implement current industry best practices for specific technologies, patterns, or domains.

## Prerequisites/Context
- Specific domain or technology to research
- Current codebase for context and comparison
- Understanding of project constraints and requirements

## Core Instructions

### 1. Best Practice Research Framework
```
DOMAIN: [Technology/Pattern/Practice area]
├── Current State: [How we do it now]
├── Industry Standards: [What's considered best practice]
├── Gap Analysis: [Difference between current and best]
└── Implementation Plan: [How to bridge the gap]
```

### 2. Multi-Source Investigation

#### Official Guidelines
```bash
# Framework official docs
- React: React.dev best practices
- Vue: Vue.js style guide
- Angular: Angular coding style guide
- Node.js: Node.js best practices

# Language standards
- JavaScript: MDN best practices
- TypeScript: TypeScript handbook
- Python: PEP 8, PEP 20
- Java: Oracle Java conventions
```

#### Industry Resources
```bash
# Authoritative sources
- Google Developer Guidelines
- Microsoft coding standards
- Airbnb style guides
- Clean Code principles

# Security standards
- OWASP guidelines
- SANS secure coding
- CWE/CVE databases
```

#### Community Consensus
```bash
# Developer surveys
- Stack Overflow Developer Survey
- State of JS/CSS/Frontend
- GitHub usage statistics
- NPM download trends
```

### 3. Domain-Specific Best Practices

#### Frontend Development
```javascript
// Component Architecture
const BEST_PRACTICES = {
  componentDesign: {
    singleResponsibility: "One component, one purpose",
    composition: "Prefer composition over inheritance",
    props: "Explicit, typed props with defaults",
    state: "Minimal, normalized state"
  },
  performance: {
    rendering: "Avoid unnecessary re-renders",
    bundling: "Code splitting and lazy loading",
    assets: "Optimized images and fonts",
    caching: "Strategic cache invalidation"
  },
  accessibility: {
    semantic: "Use semantic HTML elements",
    keyboard: "Full keyboard navigation",
    screen_readers: "Proper ARIA labels",
    testing: "Automated a11y testing"
  }
};
```

#### Backend Development
```python
# API Design Best Practices
class APIBestPractices:
    def __init__(self):
        self.principles = {
            'rest_design': {
                'resources': 'Noun-based URLs (/users, not /getUsers)',
                'http_methods': 'Proper verb usage (GET, POST, PUT, DELETE)',
                'status_codes': 'Meaningful HTTP status codes',
                'versioning': 'API versioning strategy'
            },
            'security': {
                'authentication': 'JWT or OAuth2 implementation',
                'authorization': 'Role-based access control',
                'input_validation': 'Validate all inputs',
                'rate_limiting': 'Prevent abuse'
            },
            'performance': {
                'caching': 'Response caching strategy',
                'pagination': 'Large dataset handling',
                'database': 'Query optimization',
                'monitoring': 'Performance metrics'
            }
        }
```

#### Database Design
```sql
-- Database Best Practices
-- Normalization
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexing strategy
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Constraints
ALTER TABLE users ADD CONSTRAINT check_email_format 
CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
```

### 4. Implementation Assessment

#### Current Practice Audit
```bash
# Code quality metrics
eslint . --ext .js,.ts
pylint src/
sonarqube analysis

# Security assessment
npm audit
safety check
bandit -r src/

# Performance analysis
lighthouse --chrome-flags="--headless"
webpack-bundle-analyzer
```

#### Gap Analysis Framework
```
PRACTICE_ASSESSMENT:
├── Compliance Score: [0-100%]
├── Critical Gaps: [Must fix immediately]
├── Important Gaps: [Should fix soon]
├── Nice-to-Have: [Future improvements]
└── Custom Considerations: [Project-specific needs]
```

### 5. Gradual Implementation Strategy

#### Phase 1: Foundation
```markdown
IMMEDIATE_ACTIONS:
- [ ] Fix security vulnerabilities
- [ ] Add basic error handling
- [ ] Implement input validation
- [ ] Add basic logging
```

#### Phase 2: Standards Compliance  
```markdown
STANDARDS_ALIGNMENT:
- [ ] Apply consistent code style
- [ ] Add comprehensive tests
- [ ] Implement proper documentation
- [ ] Add performance monitoring
```

#### Phase 3: Advanced Practices
```markdown
ADVANCED_IMPLEMENTATION:
- [ ] Implement advanced patterns
- [ ] Add comprehensive monitoring
- [ ] Optimize for performance
- [ ] Enhance user experience
```

### 6. Practice Validation

#### Automated Compliance Checking
```bash
# Code quality gates
pre-commit hooks
CI/CD quality checks
automated testing
security scanning

# Performance benchmarks
load testing
performance budgets
core web vitals
```

#### Peer Review Process
```markdown
REVIEW_CHECKLIST:
- [ ] Follows project conventions
- [ ] Implements security best practices
- [ ] Includes appropriate tests
- [ ] Maintains performance standards
- [ ] Provides clear documentation
```

### 7. Continuous Improvement

#### Practice Evolution Tracking
```bash
# Stay current with evolving practices
- Subscribe to technology newsletters
- Follow framework changelogs
- Monitor security advisories
- Participate in community discussions
```

#### Regular Assessment Schedule
```markdown
PRACTICE_REVIEW_CYCLE:
- Monthly: Security updates and patches
- Quarterly: Dependency updates and audits
- Semi-annually: Major practice reviews
- Annually: Architecture and technology assessment
```

## Practice Categories

### Security Best Practices
- Input validation and sanitization
- Authentication and authorization
- Data encryption and protection
- Secure communication protocols

### Performance Best Practices
- Code optimization techniques
- Caching strategies
- Database query optimization
- Resource management

### Maintainability Best Practices
- Clean code principles
- Documentation standards
- Testing strategies
- Refactoring techniques

### User Experience Best Practices
- Accessibility compliance
- Responsive design
- Performance optimization
- Error handling and feedback

## Integration with Other Commands

### With Web Search
- Research current best practices
- Find real-world implementations
- Discover emerging patterns

### With Deep Search
- Analyze current implementation patterns
- Identify inconsistencies
- Map practice adoption across codebase

### With Double Check Fact Check
- Validate practice recommendations
- Verify implementation correctness
- Confirm security claims

## Anti-Patterns/Warnings
- Don't implement all practices at once
- Avoid practices that don't fit your context
- Don't sacrifice working code for theoretical best practices
- Beware of outdated or deprecated practices

## Validation Checklist
- [ ] Practices researched from authoritative sources
- [ ] Current implementation assessed
- [ ] Gap analysis completed
- [ ] Implementation plan prioritized
- [ ] Validation criteria defined
- [ ] Continuous improvement process established