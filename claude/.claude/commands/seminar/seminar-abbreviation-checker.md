# Seminar Abbreviation Checker Command

## Purpose
Comprehensively analyze seminar paper sections to verify correct usage of abbreviations and acronyms, detect double declarations, ensure proper formatting, and automatically update the abbreviations page with missing entries while maintaining academic standards.

## Prerequisites/Context
- LaTeX seminar paper with defined structure (main_thesis.tex + content/ directory)
- Existing abbreviations page/list (or location where it should be created)
- LaTeX acronym package usage (\usepackage{acronym}) for abbreviation management
- Specific section(s) to check for abbreviation compliance
- Understanding of the paper's field and common abbreviations
- Academic formatting requirements for abbreviations

## Core Instructions

### 1. Comprehensive Abbreviation Analysis Framework

#### Initial Document Scan and Inventory
```
ABBREVIATION_ANALYSIS_STRUCTURE:
├── Document-Wide Scan
│   ├── Identify all potential abbreviations (uppercase patterns, acronyms)
│   ├── Extract parenthetical definitions: "Term (ABBR)"
│   ├── Locate existing abbreviations page/section
│   └── Map abbreviation usage across all sections
├── Abbreviation Classification
│   ├── Standard field abbreviations (e.g., AI, ML, API)
│   ├── Paper-specific abbreviations
│   ├── Organizational acronyms
│   └── Technical specifications (HTTP, REST, etc.)
├── Usage Pattern Analysis
│   ├── First occurrence tracking
│   ├── Definition presence and format
│   ├── Consistency of usage
│   └── Context appropriateness
└── Compliance Assessment
    ├── Academic formatting standards
    ├── Field-specific conventions
    ├── Internal consistency
    └── Abbreviations page completeness
```

### 2. Abbreviation Detection Patterns

When checking for abbreviations, look for these patterns:

#### Standard LaTeX Patterns:
- **Explicit definition**: Full term (ABBR) - e.g., Application Programming Interface (API)
- **Reverse definition**: ABBR (Full term) - e.g., API (Application Programming Interface)
- **Standalone acronyms**: Uppercase sequences like API, REST, HTTP without definitions
- **Mixed case**: PhD, DevOps, IoT
- **Academic abbreviations**: e.g., i.e., etc., vs., cf.

#### LaTeX Acronym Package Patterns:
- **Definition**: `\acro{KEY}{Full Form}` in abbreviations list
- **Usage**: `\ac{KEY}`, `\acs{KEY}`, `\acl{KEY}`, `\acp{KEY}` in text
- **Check for**: Raw abbreviations that should use `\ac{}` commands

#### Validation Rules:
1. **First use definition**: When using acronym package, `\ac{}` handles this automatically
2. **Consistent usage**: Use `\ac{}` commands consistently (except in headings/figures)
3. **No double declarations**: Each abbreviation defined only once in `\begin{acronym}` environment
4. **Complete abbreviations list**: All used abbreviations must have `\acro{}` definitions

### 3. Section-by-Section Analysis Process

#### Detailed Section Checker
```yaml
section_analysis_workflow:
  preprocessing:
    - Remove LaTeX comments to avoid false positives
    - Handle special LaTeX commands that might contain capitals
    - Identify section boundaries and hierarchy
    
  abbreviation_extraction:
    definition_formats:
      - Natural Language Processing (NLP)  # Manual definition
      - NLP (Natural Language Processing)  # Reverse manual definition
      - "\\acro{NLP}{Natural Language Processing}"  # Acronym package definition
      - "\\ac{NLP}"  # Acronym package usage (first use shows full form)
      - "\\acs{NLP}"  # Acronym package short form only
      - "\\acl{NLP}"  # Acronym package long form only
      - "\\acp{NLP}"  # Acronym package plural form
    
    standalone_detection:
      - Identify all uppercase sequences (2+ characters)
      - Filter out LaTeX commands and environments
      - Check against common words list (USA, NASA, etc.)
      - Validate against paper's domain vocabulary
      - Check if abbreviation is used without \\ac{} command
      - Verify abbreviation is defined in acronym environment
  
  usage_validation:
    first_occurrence:
      - Track line number and context of first use
      - Verify definition present within ±2 sentences
      - Check if already defined in previous sections
      
    subsequent_usage:
      - Ensure abbreviation used after definition
      - Flag inconsistent switching between full/abbreviated
      - Note any redefinitions or clarifications
      
    formatting_compliance:
      - Verify consistent capitalization
      - Check plural forms (APIs vs API's vs APIs')
      - Validate punctuation in abbreviations
```

### 4. Abbreviation Page Management

#### When Using LaTeX Acronym Package:

1. **Check document structure**:
   - Verify `\usepackage{acronym}` in preamble
   - Locate abbreviations file (usually `content/00-abbreviations.tex`)
   - Confirm `\begin{acronym}...\end{acronym}` environment exists

2. **Format for adding new abbreviations**:
   ```latex
   \begin{acronym}[LONGEST]
   \acro{API}{Application Programming Interface}
   \acro{REST}{Representational State Transfer}
   \acro{MVP}{Minimum Viable Product}
   \end{acronym}
   ```

3. **Update process**:
   - Add missing abbreviations in alphabetical order or by first appearance
   - Use consistent formatting: `\acro{ABBR}{Full Form}`
   - Set longest abbreviation in `[LONGEST]` parameter for alignment

4. **Text usage corrections**:
   - Replace raw abbreviations with `\ac{KEY}` commands
   - Use `\acp{KEY}` for plurals instead of "KEYs"
   - Use `\Ac{KEY}` for sentence beginnings

### 5. Validation Categories and Actions

#### Critical Errors:
- **Undefined abbreviations**: Abbreviations used without any definition
  - Action: Add `\acro{KEY}{Full Form}` to abbreviations list
- **Conflicting definitions**: Same abbreviation defined differently
  - Action: Resolve conflict, use different abbreviations

#### Major Issues:
- **Double declarations**: Abbreviation defined multiple times in `\begin{acronym}`
  - Action: Keep first definition, remove duplicates
- **Missing from list**: Used abbreviation not in abbreviations page
  - Action: Add missing `\acro{}` definition
- **Raw usage**: Not using `\ac{}` commands when acronym package is loaded
  - Action: Replace with appropriate `\ac{}` commands

#### Minor Issues:
- **Formatting inconsistency**: Inconsistent capitalization or punctuation
  - Action: Standardize formatting
- **Unused definitions**: Abbreviations defined but never used
  - Action: Consider removing or verify if needed

#### Style Recommendations:
- **Overuse of abbreviations**: Too many abbreviations affecting readability
  - Action: Consider spelling out less frequent terms
- **Unnecessary abbreviation**: Term abbreviated but used infrequently (<3 times)
  - Action: Consider using full term throughout

### 6. Output Report Generation

```markdown
## Abbreviation Check Report: [Section Name]

### 📊 Summary Statistics
- Total abbreviations found: [X]
- Properly defined with \acro{}: [Y] ([%])
- Using \ac{} commands correctly: [W] ([%])
- Raw abbreviations without \ac{}: [V]
- Missing from abbreviations page: [Z]
- Double declarations: [N]
- Undefined abbreviations: [M]

### ✅ Correctly Used Abbreviations
| Abbreviation | Full Term | First Definition Location |
|--------------|-----------|---------------------------|
| API | Application Programming Interface | Section 2.1, line 45 |
| REST | Representational State Transfer | Section 2.2, line 12 |

### 🔴 CRITICAL ISSUES

#### Undefined Abbreviations
1. **HTTP** 
   - First use: Section 3.1, line 23
   - Occurrences: 15 times
   - Suggested definition: Hypertext Transfer Protocol (HTTP)
   - Action: Add definition at first use

#### Conflicting Definitions
1. **ML**
   - Definition 1: Machine Learning (Section 2.3)
   - Definition 2: Markup Language (Section 4.1)
   - Action: Use different abbreviations (ML for Machine Learning, MkL for Markup Language)

### ⚠️ MAJOR ISSUES

#### Double Declarations
1. **API**
   - First definition: Section 2.1, line 45
   - Redundant definition: Section 3.2, line 78
   - Action: Remove second definition

#### Missing from Abbreviations Page
The following abbreviations need to be added:
1. DevOps - Development and Operations
2. CI/CD - Continuous Integration/Continuous Deployment
3. SDK - Software Development Kit

### 📝 Suggested Abbreviations Page Updates

```latex
% Add to abbreviations.tex within \begin{acronym} environment
\acro{DevOps}{Development and Operations}
\acro{CICD}{Continuous Integration/Continuous Deployment}
\acro{SDK}{Software Development Kit}
```

### 🔧 Text Usage Corrections

Replace raw abbreviations with acronym package commands:

| Current Usage | Correct Usage | Location |
|---------------|---------------|----------|
| API | \ac{API} | Section 2.1, line 45 |
| REST API | \ac{REST} \ac{API} | Section 3.1, line 23 |
| APIs | \acp{API} | Section 4.2, line 67 |

### 💡 Style Recommendations

1. **Overused Abbreviation**: "PoC" (Proof of Concept)
   - Used only 3 times in entire document
   - Recommendation: Spell out in full

2. **Inconsistent Usage**: Natural Language Processing
   - Sometimes "NLP", sometimes spelled out after definition
   - Recommendation: Use "NLP" consistently after first definition

### 🔧 Formatting Corrections Needed

1. **Inconsistent Pluralization**
   - Found: "API's" (possessive)
   - Should be: "APIs" (plural)
   - Locations: Section 3.2, line 45; Section 4.1, line 23

2. **Capitalization Issues**
   - Found: "api" (lowercase)
   - Should be: "API"
   - Location: Section 5.1, line 67

### 📋 Action Items Priority

1. **Immediate (Before Submission)**
   - Define all undefined abbreviations
   - Resolve conflicting definitions
   - Update abbreviations page with missing entries

2. **Important (Quality Improvement)**
   - Remove double declarations
   - Fix formatting inconsistencies
   - Ensure consistent usage patterns

3. **Recommended (Style Enhancement)**
   - Review abbreviation necessity
   - Improve readability by reducing abbreviation density
```

### 7. Common Academic Abbreviations Reference

```yaml
standard_academic_abbreviations:
  latin_phrases:
    - e.g. : exempli gratia (for example)
    - i.e. : id est (that is)
    - etc. : et cetera (and so forth)
    - vs. : versus
    - cf. : confer (compare)
    
  academic_titles:
    - PhD : Doctor of Philosophy
    - Prof. : Professor
    - Dr. : Doctor
    
  measurements_units:
    - km : kilometers
    - MB : megabytes
    - ms : milliseconds
    
  # These typically don't need definition in academic papers
  exempt_from_definition:
    - USA, UK, EU (well-known countries/regions)
    - HTML, CSS, JSON (in CS papers)
    - DNA, RNA (in biology papers)
    
# LaTeX acronym package commands reference
acronym_package_commands:
  definition:
    - \\acro{KEY}{Full Form} : Define acronym in abbreviations list
    
  usage_in_text:
    - \\ac{KEY} : First use: Full Form (KEY), subsequent: KEY
    - \\acs{KEY} : Short form only: KEY
    - \\acl{KEY} : Long form only: Full Form
    - \\acp{KEY} : Plural: KEYs (or custom plural if defined)
    - \\acsp{KEY} : Plural short form only
    - \\aclp{KEY} : Plural long form only
    - \\Ac{KEY} : Capitalized first letter
    - \\acf{KEY} : Force full form: Full Form (KEY)
    - \\acused{KEY} : Mark as already used (won't show full form next time)
```

## Integration with Other Commands

- Works with `seminar-reference-auditor` for comprehensive paper checking
- Can be run after `seminar-section-enhancer` to verify abbreviations
- Provides input for `scientific-style-enforcer` regarding terminology consistency

## Usage Example

### Example 1: With LaTeX acronym package

```
User: Please check Section 3 of my seminar paper for abbreviation issues and update my abbreviations page

Response:
I'll analyze Section 3 for abbreviation compliance, checking for proper usage of the LaTeX acronym package.

First, I notice your document uses the acronym package (\\usepackage{acronym}). Let me scan for issues:

### Issues Found in Section 3:

1. **Raw abbreviations without \\ac{} commands:**
   - Line 45: The MVP approach... → Should be: The \\ac{MVP} approach...
   - Line 67: ...improved UI significantly → Should be: ...improved \\ac{UI} significantly
   - Line 89: KPIs were measured... → Should be: \\acp{KPI} were measured...

2. **Undefined abbreviations:**
   - Line 102: \\ac{A/B} used but not defined in abbreviations.tex
   - Line 134: \\ac{ROI} used but not defined

3. **Missing from abbreviations page:**
   - A/B (A/B Testing)
   - ROI (Return on Investment)

### Suggested additions to content/00-abbreviations.tex:

```latex
\\acro{AB}{A/B Testing}
\\acro{ROI}{Return on Investment}
```

### Text corrections needed:
- Replace all raw abbreviation usage with appropriate \\ac{} commands
- Use \\acp{} for plurals (e.g., \\acp{KPI} instead of KPIs)
- First usage will automatically show full form with acronym package

Would you like me to make these corrections?