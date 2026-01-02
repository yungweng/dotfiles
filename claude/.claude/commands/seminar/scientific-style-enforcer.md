# Scientific Style Enforcer Command

## Purpose
Systematically analyze and transform seminar paper sections to meet rigorous scientific writing standards for master's degree level, ensuring formal academic tone, precise language, and scholarly voice while maintaining content integrity.

## Prerequisites/Context
- Section of seminar paper to be analyzed
- Field of study (sciences, humanities, social sciences, etc.)
- Target style guide (APA, MLA, Chicago, IEEE, etc.)
- Understanding of master's level academic expectations
- Access to websearch for current best practices verification

## Core Instructions

### 1. Initial Style Analysis
```
SECTION STYLE ASSESSMENT:
├── Current Writing Level: [undergraduate/mixed/near-graduate]
├── Formality Score: [informal/semi-formal/formal]
├── Scientific Precision: [vague/moderate/precise]
├── Scholarly Voice: [weak/developing/strong]
├── Critical Issues: [count of major violations]
└── Quick Wins: [easy improvements available]
```

### 2. Scientific Writing Violations Detection

#### Language and Tone Issues
```python
scientific_violations = {
    'informal_language': {
        'patterns': [
            'contractions (don\'t, can\'t, won\'t)',
            'colloquialisms (pretty much, kind of, basically)',
            'personal pronouns (I, we, you)',
            'conversational phrases (as we all know, obviously)',
            'emotional language (amazing, terrible, horrible)'
        ],
        'severity': 'HIGH',
        'fix': 'Replace with formal academic equivalents'
    },
    
    'imprecise_language': {
        'patterns': [
            'vague quantifiers (many, few, some, a lot)',
            'ambiguous terms (things, stuff, etc.)',
            'hedge words overuse (might, maybe, perhaps)',
            'absolute statements without evidence',
            'undefined technical terms'
        ],
        'severity': 'HIGH',
        'fix': 'Specify exact quantities, define terms, support claims'
    },
    
    'weak_academic_voice': {
        'patterns': [
            'passive voice overuse',
            'weak verb choices (is, has, does)',
            'redundant phrases',
            'wordy constructions',
            'lack of topic sentences'
        ],
        'severity': 'MEDIUM',
        'fix': 'Strengthen verbs, tighten prose, clarify structure'
    },
    
    'poor_argumentation': {
        'patterns': [
            'unsupported claims',
            'logical fallacies',
            'overgeneralization',
            'bias indicators',
            'missing evidence'
        ],
        'severity': 'CRITICAL',
        'fix': 'Add citations, qualify statements, provide evidence'
    }
}
```

### 3. Master's Level Enhancement Framework

#### Academic Writing Standards
```yaml
masters_level_requirements:
  depth_and_analysis:
    expectations:
      - "Complex idea synthesis"
      - "Critical evaluation of sources"
      - "Original contribution to field"
      - "Nuanced argumentation"
    
  scholarly_voice:
    characteristics:
      - "Third-person perspective"
      - "Objective tone"
      - "Discipline-specific terminology"
      - "Formal register throughout"
    
  evidence_integration:
    standards:
      - "Multiple source synthesis"
      - "Critical source evaluation"
      - "Seamless quote integration"
      - "Proper attribution"
    
  structural_sophistication:
    elements:
      - "Clear thesis development"
      - "Logical flow between ideas"
      - "Effective transitions"
      - "Cohesive argumentation"
```

### 4. Automated Style Corrections

#### Transformation Rules
```python
class ScientificStyleTransformer:
    def __init__(self):
        self.transformations = {
            # Informal to Formal
            "don't": "do not",
            "can't": "cannot",
            "won't": "will not",
            "it's": "it is",
            "that's": "that is",
            
            # Vague to Precise
            "a lot of": "numerous",
            "many": "[specify number/percentage]",
            "few": "[specify number/percentage]",
            "things": "[specify what things]",
            "etc.": "[complete the list or use 'among others']",
            
            # Weak to Strong Verbs
            "is important": "plays a crucial role",
            "has an effect": "influences",
            "does the work": "performs",
            "makes a difference": "significantly impacts",
            
            # Personal to Impersonal
            "I argue": "This paper argues",
            "we can see": "the evidence demonstrates",
            "you might think": "one might consider",
            "in my opinion": "the analysis suggests"
        }
        
        self.sentence_patterns = {
            'topic_sentence': "This section examines/analyzes/investigates...",
            'evidence_introduction': "According to [Author (Year)],",
            'transition': "Furthermore/Moreover/Additionally/However,",
            'conclusion': "These findings indicate/suggest/demonstrate..."
        }
    
    def enhance_paragraph_structure(self, paragraph):
        """Ensure each paragraph has proper academic structure"""
        return {
            'topic_sentence': self.create_topic_sentence(paragraph),
            'supporting_evidence': self.integrate_evidence(paragraph),
            'analysis': self.add_critical_analysis(paragraph),
            'transition': self.create_transition(paragraph)
        }
```

### 5. Field-Specific Adjustments

#### Discipline Conventions
```yaml
field_specific_styles:
  sciences:
    characteristics:
      - "Passive voice for methods"
      - "Past tense for results"
      - "Numerical precision"
      - "Hypothesis-driven structure"
    
  humanities:
    characteristics:
      - "Active voice preferred"
      - "Present tense for analysis"
      - "Interpretive language"
      - "Argument-driven structure"
    
  social_sciences:
    characteristics:
      - "Mixed voice usage"
      - "Empirical focus"
      - "Statistical language"
      - "Theory-practice integration"
```

### 6. Quality Verification Process

#### Pre-Correction Websearch
```
WEBSEARCH TASK: Verify Current Best Practices
Query: "[field] master's seminar paper writing style [year]"
Purpose: Ensure corrections align with latest standards
Extract: Current trends, recent changes, field evolution
```

#### Post-Correction Validation
```
VALIDATION CHECKLIST:
□ All informal language eliminated
□ Vague terms specified or replaced
□ Personal pronouns removed (except where appropriate)
□ Each paragraph has clear structure
□ Evidence properly integrated
□ Transitions smooth and logical
□ Discipline conventions followed
□ Master's level depth achieved
```

### 7. Comprehensive Output Report

```markdown
## Scientific Style Enhancement Report

### Executive Summary
- Original Style Score: [X/100]
- Enhanced Style Score: [Y/100]
- Major Improvements: [count]
- Remaining Concerns: [list]

### Section-by-Section Analysis

#### [Section Title]

**Critical Issues Fixed:**
1. **Informal Language** (5 instances)
   - Original: "We can't ignore that..."
   - Corrected: "The evidence cannot be overlooked..."
   
2. **Vague Quantifiers** (3 instances)
   - Original: "Many researchers believe..."
   - Corrected: "Seventy-eight percent of researchers (Smith et al., 2023) maintain..."

**Style Enhancements:**
- Strengthened topic sentences in 4 paragraphs
- Added evidence integration in 3 locations
- Improved transitions between all major points
- Elevated vocabulary to graduate level throughout

**Academic Voice Improvements:**
- Eliminated first-person pronouns: 12 instances
- Converted to passive voice where appropriate: 6 instances
- Added hedging language for unsupported claims: 8 instances

### Master's Level Criteria Assessment

| Criterion | Before | After | Standard Met |
|-----------|--------|-------|--------------|
| Scholarly Voice | Weak | Strong | ✓ |
| Evidence Integration | Basic | Advanced | ✓ |
| Critical Analysis | Surface | Deep | ✓ |
| Structural Sophistication | Simple | Complex | ✓ |

### Field-Specific Compliance
- Style Guide: [APA/MLA/Chicago]
- Conventions Followed: ✓
- Terminology Standardized: ✓
- Citation Format Verified: ✓

### Remaining Recommendations

1. **Consider Adding:**
   - More recent sources (2020-2024)
   - Contrasting viewpoints for balance
   - Theoretical framework discussion

2. **Further Enhancement:**
   - Develop conclusion implications
   - Strengthen methodology justification
   - Add limitations discussion
```

### 8. Interactive Improvement Mode

```python
class InteractiveStyleCoach:
    def __init__(self):
        self.learning_patterns = {}
        
    def identify_recurring_issues(self, text):
        """Track user's common style mistakes"""
        return {
            'frequent_errors': self.analyze_patterns(text),
            'improvement_areas': self.prioritize_learning(text),
            'custom_rules': self.generate_user_rules(text)
        }
    
    def provide_targeted_feedback(self, issue_type):
        """Give specific guidance for improvement"""
        feedback = {
            'explanation': self.explain_why_incorrect(issue_type),
            'examples': self.show_correct_usage(issue_type),
            'practice': self.suggest_exercises(issue_type),
            'resources': self.recommend_readings(issue_type)
        }
        return feedback
```

## Integration Notes

- Works with `seminar-section-enhancer` for comprehensive improvement
- Complements `seminar-reference-auditor` for complete academic compliance
- Can be used with `list-to-flow-converter` for style consistency
- Integrates with `seminar-section-conciser` after style improvement

## Anti-Patterns/Warnings

- DON'T over-formalize to the point of obscurity
- DON'T remove all hedge words (some uncertainty is scholarly)
- DON'T change technical terms without verification
- DON'T apply science conventions to humanities texts
- DON'T lose the author's voice completely
- DON'T introduce errors while fixing style

## Validation Checklist

- [ ] Current best practices researched via websearch
- [ ] All informal language identified and corrected
- [ ] Vague language made precise
- [ ] Academic voice strengthened throughout
- [ ] Field-specific conventions applied
- [ ] Evidence properly integrated
- [ ] Master's level depth achieved
- [ ] Original meaning preserved
- [ ] No new errors introduced