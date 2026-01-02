# Seminar Paper Review Command

## Purpose
Comprehensively review an entire seminar paper using specialized subagents to check narrative cohesion, factcheck claims, and cross-reference content across all sections, providing actionable insights for improvement.

## Prerequisites/Context
- Complete seminar paper with multiple sections (typically 5 sections)
- Clear section boundaries (e.g., LaTeX sections or markdown headers)
- Bibliography or reference list for fact-checking
- Understanding of the paper's research question and methodology
- Optional: Specific review focus areas (cohesion, accuracy, consistency)

## Core Instructions

### 1. Paper Structure Analysis

#### Initial Paper Assessment
```
PAPER_STRUCTURE_ANALYSIS:
├── Document Overview
│   ├── Total sections identified
│   ├── Word count per section
│   ├── Citation density mapping
│   └── Structural integrity check
├── Research Framework Identification
│   ├── Research question extraction
│   ├── Methodology approach
│   ├── Expected argument flow
│   └── Conclusion requirements
└── Review Strategy Planning
    ├── Subagent allocation (2 per section)
    ├── Review focus prioritization
    ├── Cross-reference requirements
    └── Expected timeline
```

### 2. Subagent Deployment Framework

#### Dual-Agent Section Review System
```python
# section-review-orchestrator.py
class SectionReviewOrchestrator:
    def __init__(self):
        self.agent_pairs = {
            'cohesion_agent': {
                'focus': 'Narrative flow and argumentative coherence',
                'tasks': [
                    'Analyze paragraph-to-paragraph transitions',
                    'Check topic sentence alignment with section goals',
                    'Verify logical progression of arguments',
                    'Assess connection to overall research question',
                    'Identify narrative gaps or jumps'
                ],
                'evaluation_criteria': {
                    'logical_flow': 'Ideas build upon each other systematically',
                    'transition_quality': 'Smooth connections between concepts',
                    'argument_development': 'Claims properly supported and developed',
                    'section_unity': 'All content contributes to section purpose'
                }
            },
            
            'factcheck_agent': {
                'focus': 'Accuracy verification and reference validation',
                'tasks': [
                    'Verify all factual claims against sources',
                    'Check citation accuracy and relevance',
                    'Validate statistical data and figures',
                    'Confirm methodology claims are supported',
                    'Identify unsupported assertions'
                ],
                'evaluation_criteria': {
                    'claim_accuracy': 'All statements factually correct',
                    'source_reliability': 'Citations from credible sources',
                    'data_precision': 'Numbers and statistics accurate',
                    'citation_coverage': 'All claims properly supported'
                }
            }
        }
        
        self.cross_reference_requirements = {
            'terminology_consistency': 'Key terms used uniformly throughout',
            'data_consistency': 'Statistics and figures align across sections',
            'argument_alignment': 'Section arguments support overall thesis',
            'methodology_coherence': 'Consistent application of stated methods',
            'conclusion_support': 'All sections contribute to final conclusions'
        }
    
    def deploy_section_agents(self, section_content, section_number, paper_context):
        """Deploy two specialized agents per section."""
        cohesion_task = {
            'agent_type': 'cohesion',
            'section': section_number,
            'content': section_content,
            'context': paper_context,
            'specific_checks': self.agent_pairs['cohesion_agent']['tasks']
        }
        
        factcheck_task = {
            'agent_type': 'factcheck',
            'section': section_number,
            'content': section_content,
            'bibliography': paper_context['bibliography'],
            'specific_checks': self.agent_pairs['factcheck_agent']['tasks']
        }
        
        return cohesion_task, factcheck_task
```

### 3. Cross-Reference Analysis Engine

#### Multi-Section Consistency Validation
```yaml
cross_reference_framework:
  terminology_tracking:
    implementation:
      - "Build glossary of key terms from introduction"
      - "Track usage consistency across all sections"
      - "Flag terminology evolution or inconsistencies"
      - "Suggest standardization where needed"
    
  data_point_verification:
    implementation:
      - "Catalog all statistics, figures, and data claims"
      - "Cross-check for consistency across mentions"
      - "Verify source alignment for repeated data"
      - "Flag any numerical discrepancies"
    
  argument_thread_analysis:
    implementation:
      - "Map main argument threads from intro to conclusion"
      - "Track how each section advances the argument"
      - "Identify missing links or logical gaps"
      - "Ensure conclusion addresses all threads"
    
  citation_pattern_review:
    implementation:
      - "Analyze citation distribution across sections"
      - "Check for citation clustering or gaps"
      - "Verify cross-references between sections"
      - "Ensure balanced source usage throughout"
```

### 4. Parallel Agent Execution Strategy

#### Concurrent Review Implementation
```javascript
// parallel-review-executor.js
class ParallelReviewExecutor {
    constructor() {
        this.review_phases = {
            'phase_1_section_analysis': {
                'description': 'Deploy all 10 agents simultaneously',
                'agent_deployment': [
                    'Section 1: Cohesion Agent + Factcheck Agent',
                    'Section 2: Cohesion Agent + Factcheck Agent',
                    'Section 3: Cohesion Agent + Factcheck Agent',
                    'Section 4: Cohesion Agent + Factcheck Agent',
                    'Section 5: Cohesion Agent + Factcheck Agent'
                ],
                'expected_outputs': {
                    'cohesion_reports': 5,
                    'factcheck_reports': 5,
                    'initial_findings': 'Per-section issues identified'
                }
            },
            
            'phase_2_synthesis': {
                'description': 'Synthesize findings across all agents',
                'synthesis_tasks': [
                    'Compile cohesion issues by severity',
                    'Aggregate factual errors and concerns',
                    'Identify cross-section patterns',
                    'Build comprehensive issue matrix'
                ],
                'cross_reference_checks': [
                    'Terminology consistency validation',
                    'Data point cross-verification',
                    'Argument thread continuity',
                    'Bibliography usage patterns'
                ]
            },
            
            'phase_3_recommendations': {
                'description': 'Generate actionable improvement plan',
                'recommendation_categories': [
                    'Critical fixes (factual errors, logical flaws)',
                    'Cohesion improvements (flow, transitions)',
                    'Consistency updates (terminology, data)',
                    'Enhancement opportunities (clarity, depth)'
                ]
            }
        };
    }
    
    async executeParallelReview(paper_sections, bibliography) {
        // Phase 1: Deploy all agents concurrently
        const agent_tasks = [];
        for (let i = 0; i < paper_sections.length; i++) {
            agent_tasks.push(this.deployCohesionAgent(paper_sections[i], i + 1));
            agent_tasks.push(this.deployFactcheckAgent(paper_sections[i], i + 1, bibliography));
        }
        
        const all_results = await Promise.all(agent_tasks);
        
        // Phase 2: Synthesize findings
        const synthesis = this.synthesizeFindings(all_results);
        
        // Phase 3: Generate recommendations
        const recommendations = this.generateRecommendations(synthesis);
        
        return {
            individual_reports: all_results,
            synthesis: synthesis,
            recommendations: recommendations
        };
    }
}
```

### 5. Finding Synthesis and Prioritization

#### Comprehensive Review Summary Generator
```python
# review-synthesis-engine.py
class ReviewSynthesisEngine:
    def __init__(self):
        self.finding_categories = {
            'critical_errors': {
                'priority': 1,
                'description': 'Factual errors or logical contradictions',
                'examples': [
                    'Incorrect citation of source material',
                    'Contradictory claims between sections',
                    'Misrepresented methodology or data',
                    'Unsupported central arguments'
                ]
            },
            
            'coherence_issues': {
                'priority': 2,
                'description': 'Narrative flow and structure problems',
                'examples': [
                    'Abrupt transitions between paragraphs',
                    'Missing logical connections',
                    'Unclear section objectives',
                    'Repetitive or circular arguments'
                ]
            },
            
            'consistency_gaps': {
                'priority': 3,
                'description': 'Cross-section alignment problems',
                'examples': [
                    'Terminology variations for same concept',
                    'Inconsistent data presentation',
                    'Shifting methodological claims',
                    'Unaligned section conclusions'
                ]
            },
            
            'enhancement_opportunities': {
                'priority': 4,
                'description': 'Areas for quality improvement',
                'examples': [
                    'Strengthen evidence with additional sources',
                    'Clarify complex arguments',
                    'Add transitional sentences',
                    'Expand underdeveloped points'
                ]
            }
        }
    
    def synthesize_review_findings(self, agent_reports):
        """Create comprehensive synthesis from all agent reports."""
        synthesis = {
            'executive_summary': self.create_executive_summary(agent_reports),
            'findings_by_priority': self.prioritize_findings(agent_reports),
            'section_specific_issues': self.map_section_issues(agent_reports),
            'cross_cutting_themes': self.identify_patterns(agent_reports),
            'improvement_roadmap': self.create_improvement_plan(agent_reports)
        }
        
        return synthesis
```

### 6. Output Format Specification

#### Structured Review Report
```markdown
# SEMINAR PAPER COMPREHENSIVE REVIEW

## Executive Summary
- **Overall Quality Score**: [X/100]
- **Critical Issues Found**: [Count]
- **Major Recommendations**: [Top 3-5 actions]

## Section-by-Section Analysis

### Section 1: [Title]
**Cohesion Analysis:**
- Narrative flow score: [X/10]
- Key issues: [Bullet points]
- Transition quality: [Assessment]

**Fact-Check Results:**
- Claims verified: [X/Y]
- Unsupported assertions: [List]
- Citation issues: [Details]

### [Repeat for all sections...]

## Cross-Reference Findings

### Terminology Consistency
- Terms tracked: [Count]
- Inconsistencies found: [List with locations]
- Standardization recommendations: [Suggestions]

### Data Consistency
- Data points tracked: [Count]
- Discrepancies identified: [List with details]
- Correction requirements: [Specific fixes]

### Argument Thread Analysis
- Main threads identified: [List]
- Continuity assessment: [Strong/Moderate/Weak]
- Gap locations: [Section references]

## Priority Improvement Matrix

### Critical (Must Fix)
1. [Issue] - Location: Section X, Paragraph Y
2. [Issue] - Location: Section X, Paragraph Y

### High Priority (Should Fix)
1. [Issue] - Suggested improvement
2. [Issue] - Suggested improvement

### Medium Priority (Consider Fixing)
1. [Enhancement opportunity]
2. [Enhancement opportunity]

## Implementation Roadmap
1. **Immediate Actions** (1-2 hours)
   - [Specific tasks]
2. **Short-term Improvements** (2-4 hours)
   - [Specific tasks]
3. **Long-term Enhancements** (4+ hours)
   - [Specific tasks]
```

## Implementation Workflow

### Phase 1: Initialization (2-3 minutes)
1. Parse paper structure and identify all sections
2. Extract bibliography and reference list
3. Build paper context (research question, methodology)
4. Prepare agent deployment strategy

### Phase 2: Parallel Agent Execution (10-15 minutes)
1. Deploy 10 agents simultaneously (2 per section)
2. Each cohesion agent analyzes narrative flow
3. Each factcheck agent verifies claims and sources
4. Agents work independently on assigned sections

### Phase 3: Cross-Reference Analysis (5-7 minutes)
1. Compile terminology usage across sections
2. Track data points and statistics consistency
3. Map argument threads from intro to conclusion
4. Analyze citation distribution patterns

### Phase 4: Synthesis and Reporting (5-7 minutes)
1. Aggregate all agent findings
2. Prioritize issues by severity
3. Generate cross-cutting insights
4. Create structured improvement recommendations

## Integration with Other Commands

### Synergistic Workflows
```yaml
review_enhancement_workflows:
  paper_review_then_section_enhancer:
    flow: "Complete review → Target weak sections for enhancement"
    benefit: "Prioritized improvement based on comprehensive analysis"
    
  paper_review_plus_citation_validator:
    flow: "Review findings → Deep citation verification"
    benefit: "Thorough fact-checking with source validation"
    
  paper_review_then_coherence_optimizer:
    flow: "Identify gaps → Systematic coherence improvement"
    benefit: "Targeted fixes for narrative flow issues"
    
  iterative_review_cycle:
    flow: "Review → Fix → Re-review targeted sections"
    benefit: "Continuous improvement with validation"
```

## Anti-Patterns/Warnings

- Don't run sequential agents when parallel execution is possible
- Don't ignore cross-section dependencies when reviewing
- Don't focus only on grammar/style - check substance and logic
- Don't miss citation-claim mismatches (common academic error)
- Don't overlook methodology-conclusion alignment
- Don't generate generic feedback - be specific and actionable

## Validation Checklist

- [ ] All sections analyzed by both agent types
- [ ] Cross-references checked across entire paper
- [ ] Findings prioritized by severity and impact
- [ ] Recommendations are specific and actionable
- [ ] Report highlights both strengths and weaknesses
- [ ] Implementation roadmap is realistic and ordered
- [ ] Critical errors clearly marked for immediate attention
- [ ] Synthesis captures paper-wide patterns and issues