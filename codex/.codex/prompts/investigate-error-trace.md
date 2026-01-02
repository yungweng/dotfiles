---
description: Trace error handling paths - find where errors get lost
argument-hint: error, exception, or failure to trace
---

$ARGUMENTS

# Error Path Investigation

Trace how errors flow through this code. Find where they're swallowed, lost, or mishandled.

## Error Path Mapping

### Phase 1: Identify Error Sources
For this code, list every possible error source:
- External API calls
- Database operations
- File system operations
- User input validation
- Type conversions
- Business logic failures
- Resource exhaustion

### Phase 2: Trace Each Error

For each error source, follow its path:

```
Error Origin: [where it starts]
    ↓
Handler 1: [file:line] — Action: [caught/rethrown/logged/ignored]
    ↓
Handler 2: [file:line] — Action: [caught/rethrown/logged/ignored]
    ↓
Final Fate: [user sees error / error logged / error lost]
```

### Phase 3: Evaluate Error Handling Quality

For each error handler, check:
- [ ] Is error information preserved?
- [ ] Is context added?
- [ ] Is it logged appropriately?
- [ ] Is the user informed (if applicable)?
- [ ] Is cleanup performed?
- [ ] Is the error distinguishable from other errors?

## Red Flags to Find

### Silent Swallowing
```javascript
// BAD: Error disappears
try { ... } catch (e) { }

// BAD: Logged but ignored
try { ... } catch (e) { console.log(e); }
```

### Information Loss
```javascript
// BAD: Original error lost
catch (e) { throw new Error('Something went wrong'); }
```

### Wrong Error Type
```javascript
// BAD: Catching too broadly
catch (e) { /* handles ALL errors the same */ }
```

### Missing Cleanup
```javascript
// BAD: Resource leak on error
const conn = openConnection();
doRiskyThing(); // If this throws, conn is never closed
conn.close();
```

### Error in Error Handler
```javascript
// BAD: Handler can throw
catch (e) {
  await logToDatabase(e); // What if DB is down?
}
```

## Output Format

```
## Error Flow Report

### Error Sources Identified
1. [file:line] [error type] — [when it occurs]

### Error Paths Traced
#### Path 1: [error name]
- Origin: [file:line]
- Handler: [file:line] — [action taken]
- Final fate: [outcome]
- Quality: [GOOD/ACCEPTABLE/POOR/CRITICAL]

### Critical Issues
- [file:line] [issue] — [impact]

### Silent Failure Points
- [file:line] [how errors get lost]

### Recommendations
1. [specific fix]

## Error Handling Health
- Overall Grade: [A/B/C/D/F]
- Errors properly handled: [X/Y]
- Errors with lost context: [count]
- Silent failure points: [count]
```
