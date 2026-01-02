# Seminar Reference Auditor Command

## Purpose
Deploy specialized subagents for each section of a seminar paper to comprehensively audit all references, cross-references, citations, and logical connections against the highest academic and scientific standards.

## Prerequisites/Context
- Complete seminar paper with clearly defined sections/chapters
- Access to bibliography/reference list
- Understanding of the specific academic field's citation standards (APA, MLA, Chicago, IEEE, etc.)
- Knowledge of the paper's argument structure and logical flow

## Core Instructions

### 1. Paper Structure Analysis
```
INITIAL PAPER SCAN:
├── Total Sections/Chapters: [count]
├── Reference Style: [APA/MLA/Chicago/IEEE/etc.]
├── Total Citations: [count]
├── Cross-references: [internal references between sections]
├── External References: [bibliography entries]
└── Logical Dependencies: [how sections build on each other]
```

### 2. Subagent Deployment Strategy

#### Parallel Subagent Creation
```python
subagent_deployment = {
    'section_analyzer': {
        'task': 'Deep analysis of single section',
        'focus': [
            'All in-text citations',
            'Reference formatting',
            'Logical consistency',
            'Cross-section dependencies',
            'Evidence quality'
        ],
        'output': 'Section-specific audit report'
    },
    
    'cross_reference_validator': {
        'task': 'Verify internal references',
        'focus': [
            'Section-to-section references',
            'Figure/table references',
            'Equation references',
            'Appendix references',
            'Consistency of terminology'
        ],
        'output': 'Cross-reference integrity report'
    },
    
    'citation_verifier': {
        'task': 'Validate citation accuracy',
        'focus': [
            'Citation-bibliography matching',
            'Format compliance',
            'Source reliability',
            'Publication dates',
            'Page number accuracy'
        ],
        'output': 'Citation verification report'
    },
    
    'logic_auditor': {
        'task': 'Test argumentative logic',
        'focus': [
            'Claim-evidence alignment',
            'Logical flow between paragraphs',
            'Sufficient support for conclusions',
            'Absence of logical fallacies',
            'Coherence of argument'
        ],
        'output': 'Logical consistency report'
    }
}
```

### 3. Section-Specific Subagent Instructions

```
SUBAGENT TASK for Section [X]: [Section Title]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. REFERENCE INVENTORY
   - List all citations in this section
   - Note citation style and format
   - Identify unique vs repeated references
   - Flag any ambiguous citations

2. FORMAT COMPLIANCE CHECK
   - Verify each citation matches required style
   - Check punctuation, italics, capitalization
   - Validate author name formats
   - Ensure year/date formatting consistency

3. LOGICAL FLOW ANALYSIS
   - Map how references support arguments
   - Identify unsupported claims
   - Check if evidence matches claims
   - Verify logical progression

4. CROSS-REFERENCE VALIDATION
   - List all references to other sections
   - Verify accuracy of section numbers/titles
   - Check figure/table reference accuracy
   - Validate equation numbering

5. SUSPICIOUS PATTERN DETECTION
   - Over-reliance on single sources
   - Outdated references for current topics
   - Missing seminal works in field
   - Potential citation padding
   - Circular reasoning patterns

6. ACADEMIC STANDARD COMPLIANCE
   - Primary vs secondary source balance
   - Peer-reviewed source percentage
   - Currency of references (field-appropriate)
   - Geographic/cultural diversity of sources
   - Methodological rigor of cited studies
```

### 4. Reference Quality Metrics

#### Scientific Standards Checklist
```yaml
reference_quality_criteria:
  source_reliability:
    high_quality:
      - "Peer-reviewed journals with impact factor"
      - "Established academic publishers"
      - "Government/institutional reports"
      - "Recognized conference proceedings"
    
    medium_quality:
      - "Pre-prints from recognized repositories"
      - "Technical reports from reputable organizations"
      - "Established news sources (for current events)"
      - "Expert blogs with credentials"
    
    low_quality:
      - "Wikipedia (only for general context)"
      - "Personal blogs without credentials"
      - "Unverified online sources"
      - "Social media posts"
  
  citation_red_flags:
    critical_issues:
      - "Citation not in bibliography"
      - "Misquoted or misrepresented source"
      - "Fabricated page numbers"
      - "Wrong publication year"
    
    major_issues:
      - "Inconsistent citation format"
      - "Missing page numbers for quotes"
      - "Incomplete citation information"
      - "Wrong author order"
    
    minor_issues:
      - "Punctuation errors"
      - "Inconsistent abbreviations"
      - "Minor formatting deviations"
      - "Style guide variations"
```

### 5. Cross-Reference Verification Matrix

```python
cross_reference_checks = {
    'internal_consistency': {
        'section_references': 'Verify "as discussed in Section X" accuracy',
        'figure_references': 'Check "see Figure Y" points to correct figure',
        'table_references': 'Validate "Table Z shows" accuracy',
        'equation_references': 'Ensure "Equation (N)" is correctly numbered'
    },
    
    'terminology_consistency': {
        'defined_terms': 'Terms used consistently after definition',
        'acronym_usage': 'Acronyms defined on first use, used consistently',
        'concept_references': 'Key concepts referenced consistently'
    },
    
    'logical_dependencies': {
        'forward_references': 'Future sections referenced appropriately',
        'backward_references': 'Previous sections built upon correctly',
        'assumption_tracking': 'Assumptions stated and referenced properly'
    }
}
```

### 6. Output Format for Each Section

```markdown
## Audit Report: Section [X] - [Title]

### ✅ COMPLIANT ELEMENTS
- [List elements meeting academic standards]

### ⚠️ MINOR ISSUES
1. **Issue**: [Description]
   - Location: [Page/paragraph]
   - Current: [What exists]
   - Recommended: [What it should be]
   - Priority: Low

### 🚨 MAJOR ISSUES
1. **Issue**: [Description]
   - Location: [Page/paragraph]
   - Current: [What exists]
   - Required Fix: [What must change]
   - Priority: High
   - Academic Standard Violated: [Specific standard]

### 🔴 CRITICAL VIOLATIONS
1. **Issue**: [Description]
   - Location: [Page/paragraph]
   - Impact: [How this undermines paper integrity]
   - Immediate Action Required: [Specific fix]
   - Related Standards: [Which academic standards violated]

### 📊 Section Statistics
- Total Citations: [X]
- Properly Formatted: [Y] ([%])
- Unique Sources: [Z]
- Average Source Age: [Years]
- Peer-Reviewed Percentage: [%]

### 🤔 SUSPICIOUS PATTERNS
- [Any concerning patterns detected]
```

### 7. Master Aggregation Report

After all subagents complete their analysis:

```markdown
# COMPLETE SEMINAR PAPER REFERENCE AUDIT

## Executive Summary
- Overall Compliance Score: [X/100]
- Critical Issues Found: [Count]
- Major Issues Found: [Count]
- Minor Issues Found: [Count]

## Section-by-Section Summary
[Brief summary of each section's status]

## Cross-Cutting Issues
1. **Systematic Problems**
   - [Issues appearing across multiple sections]

2. **Missing Essential References**
   - [Seminal works not cited]
   - [Recent developments not included]

3. **Logical Continuity Issues**
   - [Breaks in argumentative flow]
   - [Unsupported logical leaps]

## Priority Action Items
1. [CRITICAL - Must fix before submission]
2. [HIGH - Should fix for quality]
3. [MEDIUM - Recommended improvements]
4. [LOW - Nice to have enhancements]

## Academic Standards Compliance
- Citation Format: [✅/⚠️/🔴]
- Source Quality: [✅/⚠️/🔴]
- Logical Rigor: [✅/⚠️/🔴]
- Completeness: [✅/⚠️/🔴]
```

### 8. Special Detection Patterns

#### Academic Integrity Checks
```python
integrity_patterns = {
    'plagiarism_risks': {
        'indicators': [
            'Sudden style changes mid-paragraph',
            'Inconsistent terminology usage',
            'Missing citations for complex ideas',
            'Verbatim text without quotes'
        ],
        'action': 'Flag for manual review with plagiarism checker'
    },
    
    'citation_manipulation': {
        'indicators': [
            'Excessive self-citation',
            'Citation rings (mutual citation groups)',
            'Padding with irrelevant references',
            'Cherry-picking supportive quotes'
        ],
        'action': 'Highlight pattern in audit report'
    },
    
    'methodological_concerns': {
        'indicators': [
            'Only citing studies with positive results',
            'Ignoring contradictory evidence',
            'Misrepresenting study limitations',
            'Overgeneralizing from limited studies'
        ],
        'action': 'Recommend balanced perspective'
    }
}
```

## Integration Notes

- Works seamlessly with `seminar-section-enhancer` for improvements
- Can be run iteratively as references are fixed
- Provides actionable feedback for each detected issue
- Maintains academic integrity throughout the audit process

## Usage Example

```
User: /user:seminar-reference-auditor