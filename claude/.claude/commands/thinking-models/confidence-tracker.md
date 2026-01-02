# Confidence Tracker Command

## Purpose
Display transparent confidence percentages for every statement, assumption, decision, and plan made during interactions. Provides clear visibility into certainty levels with explanations of contributing factors and actionable insights for areas of uncertainty.

## Prerequisites/Context
- Understanding of the task or problem domain
- Available context and information sources
- Clear differentiation between facts, assumptions, and uncertainties
- Optional: $ARGUMENTS for specific confidence domains (technical/implementation/assumptions/risks)

## Core Instructions

### 1. Confidence Tracking Framework
```
CONFIDENCE_ASSESSMENT: [Task/Decision/Statement being evaluated]
├── Overall Confidence: [0-100%]
├── Confidence Factors: [What contributes to this level]
├── Uncertainty Sources: [What reduces confidence]
├── Validation Needed: [Steps to increase confidence]
└── Risk Assessment: [Impact of being wrong]
```

### 2. Confidence Categories and Indicators

#### Confidence Levels with Visual Indicators
```python
class ConfidenceLevel:
    def __init__(self):
        self.levels = {
            'certain': {
                'range': (95, 100),
                'color': '🟢',
                'indicator': '████████████',
                'description': 'Based on documented facts or direct evidence'
            },
            'highly_confident': {
                'range': (85, 94),
                'color': '🟢',
                'indicator': '██████████░░',
                'description': 'Strong evidence with minor uncertainties'
            },
            'confident': {
                'range': (70, 84),
                'color': '🟡',
                'indicator': '████████░░░░',
                'description': 'Good evidence but some assumptions made'
            },
            'moderately_confident': {
                'range': (50, 69),
                'color': '🟡',
                'indicator': '██████░░░░░░',
                'description': 'Mixed evidence, significant assumptions'
            },
            'low_confidence': {
                'range': (30, 49),
                'color': '🟠',
                'indicator': '████░░░░░░░░',
                'description': 'Limited evidence, mostly assumptions'
            },
            'uncertain': {
                'range': (0, 29),
                'color': '🔴',
                'indicator': '██░░░░░░░░░░',
                'description': 'Speculation or educated guess'
            }
        }
    
    def format_confidence(self, percentage: int, context: str) -> str:
        """Format confidence with visual indicators."""
        for level, data in self.levels.items():
            if data['range'][0] <= percentage <= data['range'][1]:
                return f"""
{data['color']} **{percentage}% Confidence** {data['indicator']}
**Level:** {level.replace('_', ' ').title()}
**Context:** {context}
**Basis:** {data['description']}
"""
```

### 3. Confidence Factor Analysis

#### Technical Implementation Confidence
```javascript
// technical-confidence-calculator.js
class TechnicalConfidenceCalculator {
    calculateConfidence(context) {
        const factors = {
            // Positive factors (increase confidence)
            positive: {
                'documented_api': { weight: 20, present: false },
                'working_examples': { weight: 15, present: false },
                'test_coverage': { weight: 15, present: false },
                'similar_implementations': { weight: 10, present: false },
                'clear_requirements': { weight: 10, present: false },
                'stable_dependencies': { weight: 10, present: false }
            },
            // Negative factors (decrease confidence)
            negative: {
                'version_incompatibility': { weight: -20, present: false },
                'deprecated_features': { weight: -15, present: false },
                'complex_integration': { weight: -15, present: false },
                'unclear_behavior': { weight: -10, present: false },
                'external_dependencies': { weight: -10, present: false }
            }
        };

        // Base confidence starts at 70%
        let confidence = 70;
        
        // Apply positive factors
        for (const [factor, data] of Object.entries(factors.positive)) {
            if (data.present) {
                confidence += data.weight;
            }
        }
        
        // Apply negative factors
        for (const [factor, data] of Object.entries(factors.negative)) {
            if (data.present) {
                confidence += data.weight; // weight is already negative
            }
        }
        
        // Ensure confidence stays within 0-100 range
        confidence = Math.max(0, Math.min(100, confidence));
        
        return {
            percentage: confidence,
            factors: this.getActiveFactors(factors),
            recommendations: this.getConfidenceRecommendations(confidence, factors)
        };
    }
    
    getActiveFactors(factors) {
        const active = {
            positive: [],
            negative: []
        };
        
        for (const [type, factorList] of Object.entries(factors)) {
            for (const [factor, data] of Object.entries(factorList)) {
                if (data.present) {
                    active[type].push({
                        factor: factor.replace(/_/g, ' '),
                        impact: Math.abs(data.weight) + '%'
                    });
                }
            }
        }
        
        return active;
    }
}
```

#### Decision Confidence Matrix
```python
# decision-confidence-matrix.py
from typing import List, Dict, Tuple
from dataclasses import dataclass

@dataclass
class DecisionFactor:
    name: str
    confidence: int
    weight: float
    evidence: str
    uncertainty: str

class DecisionConfidenceMatrix:
    def __init__(self):
        self.decision_factors = []
        
    def add_factor(self, factor: DecisionFactor):
        """Add a decision factor to the matrix."""
        self.decision_factors.append(factor)
    
    def calculate_weighted_confidence(self) -> Tuple[int, Dict]:
        """Calculate overall confidence using weighted factors."""
        if not self.decision_factors:
            return 0, {}
        
        total_weight = sum(f.weight for f in self.decision_factors)
        weighted_sum = sum(f.confidence * f.weight for f in self.decision_factors)
        
        overall_confidence = int(weighted_sum / total_weight) if total_weight > 0 else 0
        
        # Identify critical uncertainties
        critical_uncertainties = [
            f for f in self.decision_factors 
            if f.confidence < 50 and f.weight > 0.2
        ]
        
        return overall_confidence, {
            'factors': self.decision_factors,
            'critical_uncertainties': critical_uncertainties,
            'confidence_distribution': self.get_confidence_distribution()
        }
    
    def get_confidence_distribution(self) -> Dict[str, int]:
        """Get distribution of confidence levels."""
        distribution = {
            'high': 0,    # 80-100%
            'medium': 0,  # 50-79%
            'low': 0      # 0-49%
        }
        
        for factor in self.decision_factors:
            if factor.confidence >= 80:
                distribution['high'] += 1
            elif factor.confidence >= 50:
                distribution['medium'] += 1
            else:
                distribution['low'] += 1
        
        return distribution
    
    def generate_confidence_report(self) -> str:
        """Generate detailed confidence report."""
        overall, details = self.calculate_weighted_confidence()
        
        report = f"""
## Decision Confidence Analysis

### Overall Confidence: {overall}% {self.get_confidence_emoji(overall)}

### Factor Breakdown:
"""
        
        for factor in sorted(self.decision_factors, key=lambda x: x.weight, reverse=True):
            report += f"""
#### {factor.name} (Weight: {factor.weight:.1f})
- **Confidence:** {factor.confidence}% {self.get_confidence_emoji(factor.confidence)}
- **Evidence:** {factor.evidence}
- **Uncertainty:** {factor.uncertainty}
"""
        
        if details['critical_uncertainties']:
            report += """
### ⚠️ Critical Uncertainties:
"""
            for uncertainty in details['critical_uncertainties']:
                report += f"- **{uncertainty.name}:** {uncertainty.uncertainty}\n"
        
        return report
    
    def get_confidence_emoji(self, confidence: int) -> str:
        """Get emoji indicator for confidence level."""
        if confidence >= 90:
            return "🟢"
        elif confidence >= 70:
            return "🟡"
        elif confidence >= 50:
            return "🟠"
        else:
            return "🔴"
```

### 4. Inline Confidence Tracking

#### Implementation Format
```markdown
# Inline Confidence Examples

## Technical Statements
[95%] "This SQL query will return user data" 
- Based on: Standard SQL syntax, tested pattern
- Uncertainty: None significant

[70%] "This optimization should improve performance by 30%"
- Based on: Similar optimizations in comparable systems
- Uncertainty: Actual performance depends on data distribution

[40%] "The third-party API might have rate limits around 1000 req/min"
- Based on: Common API patterns, no official documentation found
- Uncertainty: No explicit rate limit documentation

## Implementation Decisions
[85%] "Using React Context for state management will work well here"
- Based on: App size, complexity level, team familiarity
- Uncertainty: Future scaling requirements unknown

[60%] "This regex pattern should handle all edge cases"
- Based on: Testing with known inputs
- Uncertainty: Unknown edge cases may exist

[25%] "The legacy system probably uses this data format"
- Based on: Limited code inspection, old comments
- Uncertainty: No documentation or tests found
```

### 5. Risk Assessment Based on Confidence

#### Risk Matrix Generator
```python
class ConfidenceRiskMatrix:
    def __init__(self):
        self.risk_levels = {
            'critical': {
                'confidence_threshold': 50,
                'impact': 'System failure or data loss',
                'color': '🔴'
            },
            'high': {
                'confidence_threshold': 60,
                'impact': 'Major functionality affected',
                'color': '🟠'
            },
            'medium': {
                'confidence_threshold': 70,
                'impact': 'User experience degraded',
                'color': '🟡'
            },
            'low': {
                'confidence_threshold': 80,
                'impact': 'Minor inconvenience',
                'color': '🟢'
            }
        }
    
    def assess_risk(self, confidence: int, impact_level: str) -> Dict:
        """Assess risk based on confidence and impact."""
        risk_score = (100 - confidence) * self.get_impact_multiplier(impact_level)
        
        return {
            'risk_score': risk_score,
            'risk_level': self.get_risk_level(risk_score),
            'mitigation_priority': self.get_mitigation_priority(risk_score),
            'recommended_actions': self.get_risk_mitigation_actions(confidence, impact_level)
        }
    
    def get_impact_multiplier(self, impact_level: str) -> float:
        """Get multiplier based on impact level."""
        multipliers = {
            'critical': 2.0,
            'high': 1.5,
            'medium': 1.0,
            'low': 0.5
        }
        return multipliers.get(impact_level, 1.0)
    
    def get_risk_mitigation_actions(self, confidence: int, impact: str) -> List[str]:
        """Get recommended actions to mitigate risk."""
        actions = []
        
        if confidence < 50:
            actions.extend([
                "Conduct thorough research or proof of concept",
                "Seek expert consultation",
                "Create fallback plan"
            ])
        elif confidence < 70:
            actions.extend([
                "Add comprehensive testing",
                "Document assumptions clearly",
                "Set up monitoring"
            ])
        elif confidence < 85:
            actions.extend([
                "Add edge case testing",
                "Review with team",
                "Plan for iterations"
            ])
        
        if impact in ['critical', 'high']:
            actions.append("Implement gradual rollout strategy")
            actions.append("Create detailed rollback plan")
        
        return actions
    
    def generate_risk_matrix_visual(self, assessments: List[Dict]) -> str:
        """Generate visual risk matrix."""
        matrix = """
## Risk Assessment Matrix

| Confidence | Impact | Risk Level | Actions Required |
|------------|---------|------------|------------------|
"""
        for assessment in assessments:
            conf = assessment['confidence']
            impact = assessment['impact']
            risk = self.assess_risk(conf, impact)
            
            matrix += f"| {conf}% | {impact} | {risk['risk_level']} {self.risk_levels[risk['risk_level']]['color']} | "
            matrix += f"{', '.join(risk['recommended_actions'][:2])} |\n"
        
        return matrix
```

### 6. Confidence Tracking Output Formats

#### Detailed Confidence Report
```markdown
# Confidence Analysis Report

## Summary Dashboard
```
Overall Task Confidence: 72% 🟡 ████████░░░░
├── Technical Implementation: 85% 🟢 ██████████░░
├── Integration Confidence: 60% 🟡 ██████░░░░░░
├── Timeline Estimates: 70% 🟡 ████████░░░░
└── Risk Assessment: 65% 🟡 ███████░░░░░
```

## Detailed Analysis

### High Confidence Areas (>80%)
1. **Database Schema Design** [90%] 
   - Evidence: Well-defined requirements, standard patterns
   - Validation: Matches similar successful implementations

2. **API Endpoint Structure** [85%]
   - Evidence: RESTful standards, clear documentation
   - Validation: Follows established patterns

### Medium Confidence Areas (50-80%)
1. **Performance Under Load** [65%]
   - Evidence: Theoretical calculations, similar systems
   - Uncertainty: Actual usage patterns unknown
   - Action: Load testing required before production

2. **Third-party Integration** [55%]
   - Evidence: API documentation available
   - Uncertainty: Rate limits, error handling unclear
   - Action: Build comprehensive error handling

### Low Confidence Areas (<50%)
1. **Legacy System Migration** [35%]
   - Evidence: Partial documentation, some code inspection
   - Uncertainty: Hidden dependencies, data formats
   - Action: Thorough analysis and pilot migration needed

## Validation Steps to Increase Confidence

### Immediate Actions (This Sprint)
- [ ] Create proof of concept for integration [+20% confidence]
- [ ] Review with senior architect [+10% confidence]
- [ ] Run performance benchmarks [+15% confidence]

### Short-term Actions (Next Month)
- [ ] Complete integration testing [+15% confidence]
- [ ] Document all assumptions [+5% confidence]
- [ ] Validate with stakeholders [+10% confidence]

## Risk Mitigation Plan

### Critical Risks (Confidence <50% + High Impact)
1. **Legacy Migration Failure**
   - Current Confidence: 35%
   - Mitigation: Parallel run strategy, incremental migration
   - Contingency: Maintain legacy system during transition

### Monitoring Strategy
- Set up confidence tracking dashboard
- Weekly confidence reassessment
- Trigger alerts when confidence drops below thresholds
```

#### Progressive Disclosure Format
```typescript
interface ConfidenceDisplay {
    // Summary view (always visible)
    summary: {
        statement: string;
        confidence: number;
        indicator: string; // Visual indicator
    };
    
    // Detailed view (on expansion)
    details: {
        factors: {
            positive: string[];
            negative: string[];
        };
        evidence: string[];
        assumptions: string[];
        unknowns: string[];
    };
    
    // Action view (on request)
    actions: {
        validation_steps: string[];
        time_to_higher_confidence: string;
        resources_needed: string[];
    };
}

// Example implementation
function displayConfidence(assessment: ConfidenceDisplay): string {
    return `
[${assessment.summary.confidence}%] ${assessment.summary.statement} ${assessment.summary.indicator}

<details>
<summary>📊 See confidence breakdown</summary>

**Supporting Evidence:**
${assessment.details.evidence.map(e => `- ✓ ${e}`).join('\n')}

**Assumptions Made:**
${assessment.details.assumptions.map(a => `- ⚡ ${a}`).join('\n')}

**Unknown Factors:**
${assessment.details.unknowns.map(u => `- ❓ ${u}`).join('\n')}

**To Increase Confidence:**
${assessment.actions.validation_steps.map(v => `- [ ] ${v}`).join('\n')}
</details>
`;
}
```

### 7. Historical Confidence Tracking

#### Confidence Evolution Tracker
```python
class ConfidenceHistoryTracker:
    def __init__(self):
        self.confidence_history = []
        
    def record_confidence(self, task: str, confidence: int, 
                         timestamp: str, factors: Dict):
        """Record confidence level for historical tracking."""
        self.confidence_history.append({
            'task': task,
            'confidence': confidence,
            'timestamp': timestamp,
            'factors': factors
        })
    
    def analyze_confidence_trends(self) -> Dict:
        """Analyze how confidence changed over time."""
        if not self.confidence_history:
            return {}
        
        # Group by task
        task_trends = {}
        for entry in self.confidence_history:
            task = entry['task']
            if task not in task_trends:
                task_trends[task] = []
            task_trends[task].append({
                'confidence': entry['confidence'],
                'timestamp': entry['timestamp']
            })
        
        # Calculate trends
        trends_analysis = {}
        for task, history in task_trends.items():
            if len(history) > 1:
                initial = history[0]['confidence']
                final = history[-1]['confidence']
                change = final - initial
                
                trends_analysis[task] = {
                    'initial_confidence': initial,
                    'final_confidence': final,
                    'change': change,
                    'trend': 'improving' if change > 0 else 'declining',
                    'history': history
                }
        
        return trends_analysis
    
    def generate_confidence_timeline(self) -> str:
        """Generate visual timeline of confidence changes."""
        trends = self.analyze_confidence_trends()
        
        timeline = """
## Confidence Evolution Timeline

"""
        for task, data in trends.items():
            timeline += f"""
### {task}
Initial: {data['initial_confidence']}% → Final: {data['final_confidence']}% ({data['change']:+d}% {data['trend']})

"""
            # Create simple ASCII chart
            for point in data['history']:
                bars = '█' * (point['confidence'] // 10)
                timeline += f"{point['timestamp']}: {bars} {point['confidence']}%\n"
        
        return timeline
```

### 8. Integration with Decision Making

#### Confidence-Based Decision Framework
```python
class ConfidenceBasedDecisionMaker:
    def __init__(self):
        self.decision_thresholds = {
            'proceed': 80,      # High confidence - go ahead
            'proceed_with_caution': 60,  # Medium - proceed but monitor
            'research_more': 40,  # Low - need more information
            'defer': 0          # Very low - don't proceed
        }
    
    def make_decision(self, confidence: int, impact: str, 
                     reversibility: str) -> Dict:
        """Make decision based on confidence and other factors."""
        
        # Adjust thresholds based on impact and reversibility
        adjusted_threshold = self.adjust_threshold(
            impact, reversibility
        )
        
        decision = self.determine_action(confidence, adjusted_threshold)
        
        return {
            'confidence': confidence,
            'decision': decision,
            'reasoning': self.explain_decision(
                confidence, decision, impact, reversibility
            ),
            'next_steps': self.recommend_next_steps(
                confidence, decision
            )
        }
    
    def adjust_threshold(self, impact: str, reversibility: str) -> Dict:
        """Adjust thresholds based on context."""
        thresholds = self.decision_thresholds.copy()
        
        # High impact requires higher confidence
        if impact == 'high':
            for key in thresholds:
                thresholds[key] += 10
        
        # Irreversible decisions need higher confidence
        if reversibility == 'irreversible':
            for key in thresholds:
                thresholds[key] += 15
                
        return thresholds
    
    def determine_action(self, confidence: int, thresholds: Dict) -> str:
        """Determine action based on confidence and thresholds."""
        if confidence >= thresholds['proceed']:
            return 'proceed'
        elif confidence >= thresholds['proceed_with_caution']:
            return 'proceed_with_caution'
        elif confidence >= thresholds['research_more']:
            return 'research_more'
        else:
            return 'defer'
    
    def explain_decision(self, confidence: int, decision: str, 
                        impact: str, reversibility: str) -> str:
        """Explain the reasoning behind the decision."""
        explanations = {
            'proceed': f"With {confidence}% confidence and {impact} impact, "
                      f"we have sufficient certainty to proceed.",
            'proceed_with_caution': f"At {confidence}% confidence with {impact} impact, "
                                   f"we can proceed but should monitor closely.",
            'research_more': f"At only {confidence}% confidence for a {impact} impact decision, "
                           f"we need more information before proceeding.",
            'defer': f"With {confidence}% confidence, the uncertainty is too high "
                    f"for this {reversibility} decision."
        }
        return explanations.get(decision, "Decision unclear")
    
    def recommend_next_steps(self, confidence: int, decision: str) -> List[str]:
        """Recommend next steps based on decision."""
        steps = {
            'proceed': [
                "Implement with standard process",
                "Set up success metrics",
                "Monitor for unexpected issues"
            ],
            'proceed_with_caution': [
                "Implement with enhanced monitoring",
                "Create rollback plan",
                "Set up early warning indicators",
                "Schedule frequent reviews"
            ],
            'research_more': [
                "Identify key unknowns",
                "Conduct targeted research",
                "Build proof of concept",
                "Consult domain experts"
            ],
            'defer': [
                "Document current findings",
                "Identify what would increase confidence",
                "Set criteria for revisiting",
                "Consider alternative approaches"
            ]
        }
        return steps.get(decision, [])
```

## Integration with Other Commands

### With Code Review
- Include confidence levels in code review comments
- Highlight low-confidence implementations for extra scrutiny
- Track confidence improvements through review iterations

### With Debugging
- Use confidence tracking to prioritize debugging efforts
- Focus on low-confidence areas when troubleshooting
- Document confidence in bug fix solutions

### With Test Generation
- Generate more comprehensive tests for low-confidence code
- Use confidence levels to determine test coverage needs
- Track confidence improvements from test additions

### With Technical Debt Assessment
- Map confidence levels to technical debt risks
- Prioritize refactoring based on confidence scores
- Track confidence improvements from debt reduction

## Anti-Patterns/Warnings
- Don't use false precision (avoid 73.2% - round to 5% increments)
- Avoid confidence without justification
- Don't conflate confidence with optimism
- Beware of overconfidence in familiar domains
- Don't ignore low confidence warnings

## Validation Checklist
- [ ] Every significant statement includes confidence level
- [ ] Confidence percentages are justified with evidence
- [ ] Uncertainties and assumptions are explicitly stated
- [ ] Low confidence areas have mitigation plans
- [ ] Risk assessment completed for critical decisions
- [ ] Validation steps identified to increase confidence
- [ ] Historical confidence tracked for learning
- [ ] Decision thresholds adjusted for context