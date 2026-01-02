---
description: Security-focused code review - OWASP Top 10 and beyond
argument-hint: file, PR, or commit to review
---

$ARGUMENTS

# Security Code Review

Review this code with a security-first mindset. Assume attackers will find every weakness.

## OWASP Top 10 Check

### A01: Broken Access Control
- [ ] Authorization checks on every sensitive endpoint?
- [ ] Direct object references protected?
- [ ] CORS configured correctly?
- [ ] Rate limiting in place?

### A02: Cryptographic Failures
- [ ] Sensitive data encrypted at rest?
- [ ] TLS enforced for data in transit?
- [ ] Proper key management?
- [ ] No deprecated algorithms (MD5, SHA1 for security)?

### A03: Injection
- [ ] SQL queries parameterized?
- [ ] NoSQL injection prevented?
- [ ] Command injection prevented?
- [ ] LDAP injection prevented?
- [ ] XPath injection prevented?

### A04: Insecure Design
- [ ] Threat modeling done?
- [ ] Security requirements defined?
- [ ] Fail-secure defaults?

### A05: Security Misconfiguration
- [ ] Default credentials removed?
- [ ] Error messages don't leak info?
- [ ] Security headers set?
- [ ] Unnecessary features disabled?

### A06: Vulnerable Components
- [ ] Dependencies up to date?
- [ ] Known vulnerabilities checked?
- [ ] Unnecessary dependencies removed?

### A07: Authentication Failures
- [ ] Strong password requirements?
- [ ] Brute force protection?
- [ ] Session management secure?
- [ ] MFA supported?

### A08: Software and Data Integrity
- [ ] CI/CD pipeline secured?
- [ ] Dependencies verified?
- [ ] Deserialization safe?

### A09: Logging and Monitoring
- [ ] Security events logged?
- [ ] Logs don't contain sensitive data?
- [ ] Alerting configured?

### A10: SSRF
- [ ] URL inputs validated?
- [ ] Internal network access restricted?
- [ ] Redirects validated?

## Additional Security Checks

### Secrets Management
- [ ] No hardcoded secrets?
- [ ] Environment variables used correctly?
- [ ] Secrets not logged?
- [ ] Secrets not in error messages?

### Input Handling
- [ ] All inputs treated as untrusted?
- [ ] Input length limits enforced?
- [ ] Content-type validation?
- [ ] File upload restrictions?

### Output Encoding
- [ ] HTML encoding for web output?
- [ ] JSON encoding proper?
- [ ] URL encoding when needed?

## Output Format

```
## Critical Security Issues (BLOCK)
- [CWE-XXX] [file:line] [vulnerability] — [attack scenario]

## High Risk Issues
- [file:line] [issue] — [potential impact]

## Medium Risk Issues
- [file:line] [issue] — [recommended fix]

## Security Improvements
- [suggestion]

## Attack Scenarios Considered
- [scenario 1]
- [scenario 2]

## Security Verdict
[SECURE / NEEDS FIXES / INSECURE]
```
