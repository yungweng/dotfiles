# Double Check Fact Check Command

## Purpose
Rigorously verify assumptions, validate information accuracy, and ensure correctness before proceeding with implementations.

## Prerequisites/Context
- Statement, assumption, or implementation to verify
- Access to documentation, code, or external resources
- Critical thinking mindset - assume nothing

## Core Instructions

### 1. Information Verification Framework
```
CLAIM: [Statement to verify]
├── Source: [Where this came from]
├── Confidence: [Initial confidence level]
└── Category: [Technical/Business/Security/Performance]

VERIFICATION STEPS:
1. Primary source check
2. Cross-reference validation  
3. Empirical testing
4. Edge case analysis
```

### 2. Technical Fact Checking

#### API/Library Verification
```bash
# Verify package exists and version
npm info <package-name>
pip show <package-name>

# Check actual implementation
grep -r "functionName" node_modules/package/
rg "className" --type py

# Verify compatibility
npm ls <package-name>  # Check for conflicts
```

#### Code Behavior Verification
```javascript
// Don't assume - test it
console.log(typeof null);  // "object" - not "null"!
console.log(0.1 + 0.2 === 0.3);  // false!
console.log([] == false);  // true!

// Create minimal test case
const assumption = "Array.sort() is stable";
const test = [{a:1,b:1}, {a:1,b:2}];
const result = test.sort((x,y) => x.a - y.a);
console.log("Stable?", result[0].b === 1);  // Verify!
```

### 3. Documentation Verification

#### Official Source Hierarchy
1. Official documentation (latest version)
2. Source code (actual implementation)
3. Specification documents (standards)
4. Community consensus (Stack Overflow, issues)
5. Blog posts (least reliable)

#### Version-Specific Checking
```bash
# Check documentation for specific version
# Node.js: https://nodejs.org/docs/latest-v16.x/api/
# Python: https://docs.python.org/3.9/
# React: https://react.dev/reference/react

# Verify version in use
node --version
python --version
npm list react
```

### 4. Security Fact Checking

```bash
# Verify security claims
npm audit
safety check  # Python
snyk test

# Check CVE database
# https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=packagename

# Verify encryption claims
openssl version -a  # Check available algorithms
```

### 5. Performance Verification

```javascript
// Don't trust performance claims - measure
console.time('approach1');
// ... code ...
console.timeEnd('approach1');

// Use proper benchmarking
const Benchmark = require('benchmark');
new Benchmark.Suite()
  .add('Method A', () => { /* ... */ })
  .add('Method B', () => { /* ... */ })
  .on('complete', function() {
    console.log('Fastest:', this.filter('fastest').map('name'));
  })
  .run();
```

### 6. Common Misconceptions Database

#### JavaScript/TypeScript
- `typeof null` returns "object" (historical bug)
- `Array.sort()` mutates in place
- `const` doesn't make objects immutable
- `async/await` doesn't make code parallel

#### Python
- Lists are mutable, tuples aren't
- `is` vs `==` have different semantics
- Default arguments are evaluated once
- `__init__` is not a constructor

#### General Programming
- UTF-8 vs UTF-16 vs ASCII differences
- Floating point precision limitations
- Time complexity vs space complexity tradeoffs
- Security through obscurity doesn't work

## Verification Patterns

### The Three-Source Rule
Never trust a single source:
1. Find claim in official docs
2. Verify in source code/implementation
3. Test empirically in your environment

### The Edge Case Check
```
Normal case: Works? ✓
Empty input: Works? 
Null/undefined: Works?
Maximum values: Works?
Negative values: Works?
Concurrent access: Works?
```

### The Version Matrix
```
Works in development? ✓
Works in test environment?
Works in production?
Works with current dependencies?
Works after updates?
```

## Anti-Patterns/Warnings
- Don't trust outdated Stack Overflow answers
- Beware of version-specific behavior
- Don't assume library behavior from names
- Verify security claims independently
- Test performance claims in your context

## Validation Checklist
- [ ] Checked official documentation
- [ ] Verified version compatibility
- [ ] Tested actual behavior
- [ ] Considered edge cases
- [ ] Cross-referenced multiple sources
- [ ] Validated in target environment