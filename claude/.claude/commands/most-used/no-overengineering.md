# No Overengineering Command

## Purpose
Ruthlessly prevent overengineering by enforcing maximum simplicity. Look extensively, edit minimally, ship only what's needed.

## Prerequisites/Context
- A specific problem to solve
- Existing codebase to work within
- Willingness to resist "clever" solutions

## Core Instructions

### 1. The Overengineering Detector

**Red flags that you're overengineering:**
```
🚨 Creating abstractions for single use cases
🚨 Adding "flexibility" nobody asked for
🚨 Writing more than 10 lines for a 1-line problem
🚨 Making new files when existing ones work
🚨 Planning for hypothetical future needs
🚨 Refactoring working code "while you're there"
🚨 Adding patterns/frameworks for simple tasks
```

### 2. The YAGNI Enforcement Protocol

**You Aren't Gonna Need It - Applied Ruthlessly**

```
Before EVERY code decision:
├── Do I need this NOW? (not tomorrow)
├── Is there a simpler way?
├── Can I solve this in 1 line?
├── Does similar code already exist?
├── Am I inventing problems?
└── Would a junior dev understand this?
```

### 3. Maximum Analysis, Minimum Code

```bash
REQUIRED ANALYSIS PHASE:
- Read 5+ related files minimum
- Grep for similar patterns 3+ times
- Find where problem actually originates
- Identify the ONE line that matters
- Check if config can solve it
- Verify no existing solution

ALLOWED IMPLEMENTATION:
- Change the absolute minimum
- Max 5 lines per fix preferred
- Zero new abstractions
- Zero new dependencies
- Reuse everything possible
```

### 4. The Simplicity Rubric

Rate every solution 1-10 on complexity:

```
1-3: Perfect (config change, one-liner, guard clause)
4-5: Acceptable (small function, few lines)
6-7: Question it (new file, new pattern)
8-9: Reject it (new abstraction, framework)
10:  Start over (you've lost the plot)
```

### 5. Anti-Overengineering Patterns

#### ❌ OVERENGINEERED GARBAGE
```javascript
// 50 lines of AbstractFactoryBuilderStrategy
class RequestBuilder {
  constructor(config) {
    this.config = new ConfigurationManager(config);
    this.validator = new ValidationEngine();
    this.transformer = new DataTransformer();
  }
  
  build() {
    return new RequestExecutor(
      this.config,
      this.validator,
      this.transformer
    );
  }
}

// For what could be:
const response = await fetch(url);
```

#### ✅ ACTUAL SOLUTION
```javascript
// The bug was a missing await. That's it.
const data = await fetchData();  // Fixed with 'await'
```

### 6. Code Smells of Overengineering

**If you write any of these, STOP:**
```javascript
// "Flexible" parameters nobody uses
function doThing(data, options = {}, config = {}, flags = {})

// Abstractions over simple operations  
class Logger { log(msg) { console.log(msg) } }

// Preparing for scale that doesn't exist
class DistributedCacheManager extends AbstractCache

// Generic solutions to specific problems
function createGenericHandler(type, subtype, action, params)
```

### 7. The One-Line Fix Philosophy

**Most bugs are one-line fixes in disguise:**

```javascript
// Null reference? Optional chaining.
user?.profile?.name

// Missing data? Fallback value.
items || []

// Async issue? Add await.
await somePromise

// Type error? Type guard.
if (typeof value === 'string')

// Off-by-one? Boundary check.
if (index < array.length)
```

### 8. Overengineering Intervention Checklist

When you feel the urge to "architect":

- [ ] Can this be a configuration value?
- [ ] Does this need to be "extensible"?
- [ ] Will anyone touch this code again?
- [ ] Am I solving the stated problem?
- [ ] Would embarrassingly simple code work?
- [ ] Is my solution longer than the problem?

### 9. Real Examples: Overengineered vs Simple

#### Task: Add API retry logic

❌ **OVERENGINEERED:**
```javascript
class RetryStrategy {
  constructor(maxAttempts, backoffStrategy) {...}
}
class ExponentialBackoff extends BackoffStrategy {...}
class ApiClient {
  constructor(retryStrategy) {...}
}
// 200 lines later...
```

✅ **SIMPLE:**
```javascript
async function fetchWithRetry(url, attempts = 3) {
  try {
    return await fetch(url);
  } catch (e) {
    if (attempts > 1) return fetchWithRetry(url, attempts - 1);
    throw e;
  }
}
```

#### Task: Validate user input

❌ **OVERENGINEERED:**
```javascript
const ValidationRules = {
  email: new EmailValidator(),
  phone: new PhoneValidator(),
  // ... 10 validator classes
}
```

✅ **SIMPLE:**
```javascript
const isValidEmail = (email) => email.includes('@');
```

### 10. The "But What If..." Killer

**Common overengineering excuses and responses:**

> "But what if we need to scale?"
**You don't. Ship it simple.**

> "But what if requirements change?"  
**They will. Simple code is easier to change.**

> "But what if we need to add more types?"
**You won't. YAGNI.**

> "But this pattern is more maintainable..."
**No pattern is more maintainable than no pattern.**

### 11. Enforcement Metrics

Track these to ensure compliance:
- Files read : Files edited ratio (aim for 10:1)
- Lines added per bug fixed (aim for <5)
- New abstractions created (aim for 0)
- Complexity score of solution (aim for 1-3)

### 12. The Final Test

Before shipping any code, ask:
**"Would I be embarrassed by how simple this is?"**

If no → make it simpler
If yes → ship it

## Command Activation Behavior

When active, I will:
1. Read extensively before any edit
2. Challenge every abstraction
3. Seek one-line solutions first
4. Reject speculative features
5. Prefer boring over clever
6. Delete more than I add

## The No-Overengineering Oath

**I swear to:**
- Ship embarrassingly simple code
- Resist the urge to "improve"
- Trust that YAGNI is always right
- Look for what exists before creating
- Measure twice, code once
- Choose boring technology

**Remember:** The best code is no code. The second best is simple code.