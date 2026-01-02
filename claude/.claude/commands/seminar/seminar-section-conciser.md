# Seminar Section Conciser Command

## Purpose
Intelligently reduce the length of seminar sections without losing information by applying advanced concision techniques, with mandatory subagent verification before and after changes.

## Prerequisites/Context
- Section content to be condensed (provided by user)
- Clear understanding of which section needs condensing
- Context about the seminar's purpose and audience
- Any specific constraints or requirements for the shortened version

## Core Instructions

### 1. Initial Analysis Phase
```
SECTION ANALYSIS:
├── Current Length: [word/character count]
├── Information Density: [low/medium/high]
├── Redundancy Assessment: [identify repeated concepts]
├── Essential vs Supporting Content: [categorize all elements]
└── Concision Potential: [percentage reduction possible without info loss]
```

### 2. Pre-Concision Verification (MANDATORY)
Launch subagent to verify feasibility:
```
SUBAGENT TASK: Verify Concision Feasibility
- Analyze the section for information completeness
- Identify all unique information points
- Assess which elements can be condensed without loss
- Flag any sections that CANNOT be shortened without losing information
- Return verdict: FEASIBLE (with %) or NOT FEASIBLE (with reasons)
```

### 3. Concision Strategies

#### Information-Preserving Techniques
```python
concision_techniques = {
    'redundancy_elimination': {
        'target': 'Repeated concepts, phrases, examples',
        'method': 'Keep first/best instance, remove duplicates',
        'preservation': 'All unique information retained'
    },
    
    'syntactic_compression': {
        'target': 'Wordy constructions, passive voice, filler words',
        'method': 'Active voice, direct statements, precise verbs',
        'preservation': 'Meaning unchanged, expression tightened'
    },
    
    'structural_optimization': {
        'target': 'Inefficient organization, scattered related points',
        'method': 'Group related concepts, logical flow',
        'preservation': 'All points present, better organized'
    },
    
    'example_consolidation': {
        'target': 'Multiple examples illustrating same point',
        'method': 'Select most representative example',
        'preservation': 'Concept fully illustrated with fewer words'
    },
    
    'implicit_reference': {
        'target': 'Concepts already established in seminar',
        'method': 'Brief reference instead of re-explanation',
        'preservation': 'Full understanding via context'
    }
}
```

#### Advanced Compression Patterns
```
COMPRESSION PATTERNS:
1. Nominalization: "The system analyzes data" → "System data analysis"
2. Compound Terms: "tool for analyzing code" → "code-analysis tool"
3. Bullet Consolidation: Multiple related bullets → Single comprehensive point
4. Parenthetical Integration: Separate explanatory sentences → Inline clarifications
5. Implied Connections: Remove obvious transition phrases when flow is clear
```

### 4. Concision Execution Process

#### Step-by-Step Transformation
```
For each sentence/paragraph:
1. IDENTIFY: What unique information does this convey?
2. COMPRESS: Apply appropriate concision technique
3. VERIFY: Does compressed version retain ALL information?
4. OPTIMIZE: Can it be compressed further without loss?
5. INTEGRATE: Ensure smooth flow with surrounding text
```

#### Information Tracking Grid
```
| Original Element | Information Points | Compressed Version | Info Preserved? |
|-----------------|-------------------|-------------------|-----------------|
| [sentence 1]    | [A, B, C]        | [new sentence]    | ✓ A ✓ B ✓ C   |
| [sentence 2]    | [D, E]           | [merged above]    | ✓ D ✓ E       |
```

### 5. Post-Concision Verification (MANDATORY)

Launch second subagent verification:
```
SUBAGENT TASK: Verify Information Preservation
- Compare original vs concised version
- Create exhaustive list of information points in original
- Verify EVERY point exists in concised version
- Check readability and comprehension
- Return: VERIFIED (all info preserved) or FAILED (missing: [list])
```

### 6. Failure Protocol

If concision is NOT FEASIBLE without information loss:
```
CONCISION IMPOSSIBILITY REPORT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  CANNOT REDUCE SECTION WITHOUT INFORMATION LOSS

Why this section cannot be shortened:
├── Information Density: [Already maximally compressed]
├── No Redundancy: [Each element conveys unique information]
├── Essential Examples: [All examples necessary for understanding]
└── Technical Precision: [Any reduction compromises accuracy]

Required Actions:
1. Reconsider section boundaries (split into subsections?)
2. Reassess what constitutes "essential" information
3. Consider different presentation format (table/diagram?)
4. Accept current length as necessary

Specific Constraints:
- [List specific elements that cannot be compressed]
- [Explain why each is essential]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 7. Quality Metrics

Track concision effectiveness:
```yaml
concision_metrics:
  length_reduction:
    - original_words: [count]
    - final_words: [count]
    - reduction_percentage: [%]
    
  information_preservation:
    - original_info_points: [count]
    - preserved_info_points: [count]
    - preservation_rate: [must be 100%]
    
  readability:
    - sentence_complexity: [simpler/same/more complex]
    - flow_quality: [improved/maintained/degraded]
    - comprehension_ease: [easier/same/harder]
```

### 8. Special Handling Cases

#### Technical Content
- Preserve all technical terms and specifications
- Cannot simplify at expense of precision
- May require footnotes for necessary elaboration

#### Legal/Compliance Text
- Often cannot be shortened due to requirements
- Flag immediately as NOT FEASIBLE if legally required

#### Mathematical/Scientific Proofs
- Each step usually essential
- Focus on notation efficiency rather than content reduction

## Integration with seminar-section-enhancer

### Workflow Integration
```
1. User identifies section needing concision
2. seminar-section-enhancer provides context
3. seminar-section-conciser analyzes feasibility
4. If feasible: Execute concision with verification
5. If not feasible: Provide detailed impossibility report
6. Return to enhancer with results
```

### Context Requirements from User
- Which specific section to concise
- Target length or reduction percentage (if any)
- Audience knowledge level (affects what can be implicit)
- Any untouchable elements (must preserve exactly)
- Format constraints (bullets, paragraphs, etc.)

## Example Execution

### Input
"The system performs an analysis of the data by examining each data point individually and then combining the results to create a comprehensive overview that allows for better understanding."

### Analysis
- Redundancy: "performs an analysis" = "analyzes"
- Wordiness: "by examining...individually" can be compressed
- Filler: "that allows for" is unnecessary

### Output
"The system analyzes each data point and combines results into a comprehensive overview for better understanding."

### Verification
✓ All information preserved (analysis, individual examination, combination, comprehensive overview, understanding improvement)
✓ 40% length reduction achieved

## Anti-Patterns/Warnings

- NEVER sacrifice accuracy for brevity
- NEVER remove examples if they illustrate different aspects
- NEVER compress technical specifications
- NEVER skip verification steps
- NEVER claim success if information was lost
- NEVER make text less clear in pursuit of brevity

## Validation Checklist

- [ ] All information points catalogued before concision
- [ ] Feasibility verified by subagent
- [ ] Appropriate concision techniques selected
- [ ] Each change preserves information
- [ ] Post-concision verification confirms no loss
- [ ] Readability maintained or improved
- [ ] If infeasible, clear report provided
- [ ] User informed of any limitations