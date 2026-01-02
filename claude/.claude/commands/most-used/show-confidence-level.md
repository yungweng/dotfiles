# Show Confidence Level Command

## Purpose
Display confidence percentages for every statement, assumption, decision, and implementation plan made by Claude Code, providing transparency about certainty levels and helping identify areas that need validation or further research.

## Prerequisites/Context
- Any coding task, decision, or implementation planning
- Works across all domains (technical, architectural, debugging, etc.)
- Can be toggled on/off or used selectively
- Optional: $ARGUMENTS for specific confidence categories or detail level

## Core Instructions

### 1. Confidence Tracking Framework
```
CONFIDENCE_TARGET: [Statement/Decision/Plan being evaluated]
├── Base Confidence: [Initial assessment based on available information]
├── Confidence Factors: [What increases/decreases confidence]
├── Evidence Quality: [How reliable is the supporting information]
├── Risk Assessment: [Impact if confidence proves wrong]
└── Improvement Path: [How to increase confidence if needed]
```

### 2. Confidence Calculation Engine

#### Multi-Factor Confidence Analysis
```python
# confidence-calculator.py
class ConfidenceCalculator:
    def __init__(self):
        self.confidence_factors = {
            'positive_factors': {
                'documentation_exists': {'weight': 0.15, 'description': 'Official documentation available'},
                'working_examples': {'weight': 0.20, 'description': 'Verified working code examples'},
                'personal_experience': {'weight': 0.15, 'description': 'Direct experience with technology'},
                'community_validation': {'weight': 0.10, 'description': 'Community consensus/best practices'},
                'test_coverage': {'weight': 0.15, 'description': 'Tests validate approach'},
                'simple_solution': {'weight': 0.10, 'description': 'Solution is straightforward'},
                'recent_knowledge': {'weight': 0.10, 'description': 'Information is current'},
                'multiple_sources': {'weight': 0.05, 'description': 'Multiple sources confirm'}
            },
            
            'negative_factors': {
                'high_complexity': {'weight': -0.20, 'description': 'Complex implementation required'},
                'unknown_dependencies': {'weight': -0.15, 'description': 'Unclear external dependencies'},
                'edge_case': {'weight': -0.15, 'description': 'Unusual or edge case scenario'},
                'outdated_info': {'weight': -0.10, 'description': 'Information might be outdated'},
                'conflicting_sources': {'weight': -0.10, 'description': 'Sources disagree'},
                'untested_approach': {'weight': -0.15, 'description': 'No tests validate this'},
                'platform_specific': {'weight': -0.10, 'description': 'Platform-specific uncertainty'},
                'missing_context': {'weight': -0.05, 'description': 'Important context missing'}
            }
        }
        
        self.confidence_categories = {
            'technical_implementation': {
                'description': 'Confidence in technical approach and code',
                'key_factors': ['documentation_exists', 'working_examples', 'test_coverage']
            },
            'architectural_decision': {
                'description': 'Confidence in system design choices',
                'key_factors': ['personal_experience', 'community_validation', 'simple_solution']
            },
            'problem_diagnosis': {
                'description': 'Confidence in problem identification',
                'key_factors': ['multiple_sources', 'test_coverage', 'personal_experience']
            },
            'performance_estimation': {
                'description': 'Confidence in performance predictions',
                'key_factors': ['working_examples', 'test_coverage', 'platform_specific']
            },
            'security_assessment': {
                'description': 'Confidence in security analysis',
                'key_factors': ['documentation_exists', 'community_validation', 'recent_knowledge']
            }
        }
    
    def calculate_confidence(self, statement_context, factors_present):
        """Calculate confidence percentage based on present factors."""
        base_confidence = 0.5  # Start at 50%
        
        # Add positive factors
        for factor in factors_present.get('positive', []):
            if factor in self.confidence_factors['positive_factors']:
                base_confidence += self.confidence_factors['positive_factors'][factor]['weight']
        
        # Subtract negative factors
        for factor in factors_present.get('negative', []):
            if factor in self.confidence_factors['negative_factors']:
                base_confidence += self.confidence_factors['negative_factors'][factor]['weight']
        
        # Ensure confidence stays within 0-100%
        confidence = max(0, min(1, base_confidence)) * 100
        
        return {
            'percentage': round(confidence),
            'level': self.get_confidence_level(confidence),
            'factors': self.explain_factors(factors_present),
            'recommendations': self.generate_recommendations(confidence, factors_present)
        }
    
    def get_confidence_level(self, percentage):
        """Categorize confidence into levels with visual indicators."""
        if percentage >= 90:
            return {'level': 'Very High', 'indicator': '🟢', 'color': 'green'}
        elif percentage >= 75:
            return {'level': 'High', 'indicator': '🟢', 'color': 'green'}
        elif percentage >= 60:
            return {'level': 'Moderate', 'indicator': '🟡', 'color': 'yellow'}
        elif percentage >= 40:
            return {'level': 'Low', 'indicator': '🟠', 'color': 'orange'}
        else:
            return {'level': 'Very Low', 'indicator': '🔴', 'color': 'red'}
    
    def visualize_confidence(self, percentage):
        """Create visual confidence bar."""
        filled = int(percentage / 10)
        empty = 10 - filled
        bar = '█' * filled + '░' * empty
        return f"[{bar}] {percentage}%"
```

### 3. Inline Confidence Display Format

#### Statement Confidence Notation
```markdown
**Format Examples:**

**High Confidence (80-100%):**
🟢 [95%] "This approach using async/await will handle the concurrent requests efficiently"
├── ✓ Well-documented pattern in official docs
├── ✓ Multiple working examples verified
└── ✓ Extensive community validation

**Moderate Confidence (60-79%):**
🟡 [72%] "The database migration should complete in under 5 minutes"
├── ✓ Similar migrations have taken 3-7 minutes
├── ⚠️ Depends on current database load
└── ℹ️ Recommend: Test on staging environment first

**Low Confidence (40-59%):**
🟠 [45%] "This regex pattern might capture all edge cases"
├── ⚠️ Complex pattern with limited testing
├── ⚠️ Edge cases not fully enumerated
└── 🔍 Action: Generate comprehensive test cases

**Critical Confidence (<40%):**
🔴 [25%] "The third-party API probably supports batch operations"
├── ❌ No documentation found for this feature
├── ❌ Conflicting information in forums
└── ⛔ Action: Contact API support or find alternative approach
```

### 4. Comprehensive Confidence Reports

#### Implementation Planning Confidence
```yaml
implementation_confidence_template:
  overall_confidence: 
    percentage: 78%
    visual: "████████░░"
    trend: "↗️ improving"
    
  phase_breakdown:
    planning:
      confidence: 85%
      factors:
        positive: ["requirements clear", "similar projects done"]
        negative: ["timeline aggressive"]
      risk: "LOW"
      
    development:
      confidence: 75%
      factors:
        positive: ["tech stack familiar", "good documentation"]
        negative: ["complex integrations", "new team members"]
      risk: "MEDIUM"
      
    testing:
      confidence: 70%
      factors:
        positive: ["automated tests planned", "staging environment"]
        negative: ["limited time for testing", "complex scenarios"]
      risk: "MEDIUM"
      
    deployment:
      confidence: 82%
      factors:
        positive: ["CI/CD pipeline exists", "rollback plan"]
        negative: ["first production deployment"]
      risk: "LOW"
      
  critical_uncertainties:
    - description: "Third-party API rate limits unclear"
      impact: "HIGH"
      mitigation: "Implement exponential backoff and caching"
      
    - description: "Database performance under load"
      impact: "MEDIUM"
      mitigation: "Load test before launch, prepare scaling plan"
      
  confidence_improvement_actions:
    immediate:
      - "Review API documentation for rate limits"
      - "Create spike to test integration points"
      - "Set up monitoring for critical paths"
      
    before_launch:
      - "Complete load testing"
      - "Document rollback procedures"
      - "Train team on debugging tools"
```

#### Decision Confidence Matrix
```python
# decision-confidence-matrix.py
class DecisionConfidenceMatrix:
    def __init__(self):
        self.decision_thresholds = {
            'reversible_low_impact': {
                'minimum_confidence': 60,
                'description': 'Easy to change, minimal consequences',
                'examples': ['code style choices', 'internal naming']
            },
            'reversible_high_impact': {
                'minimum_confidence': 70,
                'description': 'Can be changed but affects many areas',
                'examples': ['API design', 'major refactoring']
            },
            'irreversible_low_impact': {
                'minimum_confidence': 75,
                'description': 'Hard to change but limited scope',
                'examples': ['database schema', 'published APIs']
            },
            'irreversible_high_impact': {
                'minimum_confidence': 85,
                'description': 'Very difficult to change with broad impact',
                'examples': ['architecture decisions', 'technology choices']
            }
        }
    
    def evaluate_decision(self, decision_type, confidence_level, context):
        """Evaluate if confidence is sufficient for the decision type."""
        threshold = self.decision_thresholds[decision_type]['minimum_confidence']
        
        evaluation = {
            'decision': context,
            'type': decision_type,
            'confidence': confidence_level,
            'threshold': threshold,
            'recommendation': self.get_recommendation(confidence_level, threshold),
            'risk_assessment': self.assess_risk(confidence_level, threshold, decision_type)
        }
        
        return evaluation
    
    def get_recommendation(self, confidence, threshold):
        """Generate recommendation based on confidence vs threshold."""
        if confidence >= threshold + 10:
            return "✅ PROCEED - High confidence for this decision type"
        elif confidence >= threshold:
            return "✅ PROCEED WITH CAUTION - Meets minimum confidence"
        elif confidence >= threshold - 10:
            return "⚠️ GATHER MORE INFO - Close to threshold, reduce uncertainty"
        else:
            return "🛑 DO NOT PROCEED - Insufficient confidence, investigate further"
    
    def generate_confidence_report(self, statement, category, factors):
        """Generate a comprehensive confidence report."""
        report = f"""
### Confidence Analysis Report

**Statement**: {statement}
**Category**: {category}
**Confidence**: {self.visualize_confidence(factors['percentage'])}

#### Confidence Factors
**Positive Factors** ✅
{self.format_factors(factors['positive_factors'])}

**Negative Factors** ⚠️
{self.format_factors(factors['negative_factors'])}

#### Risk Assessment
{self.generate_risk_assessment(factors)}

#### Recommendations
{self.generate_recommendations(factors)}

#### How to Increase Confidence
{self.suggest_confidence_improvements(factors)}
"""
        return report
```

### 5. Risk-Based Confidence Assessment

#### Risk Calculation Based on Confidence
```yaml
risk_matrix:
  calculation: "Risk = (100 - Confidence%) × Impact × Probability"
  
  impact_levels:
    critical:
      score: 10
      examples: ["Data loss", "Security breach", "System outage"]
    high:
      score: 7
      examples: ["Performance degradation", "User experience issues"]
    medium:
      score: 4
      examples: ["Feature limitations", "Minor bugs"]
    low:
      score: 1
      examples: ["Cosmetic issues", "Nice-to-have features"]
      
  risk_categories:
    extreme_risk:
      range: "Risk score > 70"
      action: "⛔ Do not proceed without expert validation"
      color: "red"
      
    high_risk:
      range: "Risk score 50-70"
      action: "🔴 Significant investigation required"
      color: "orange"
      
    medium_risk:
      range: "Risk score 30-49"
      action: "🟡 Additional validation recommended"
      color: "yellow"
      
    low_risk:
      range: "Risk score < 30"
      action: "🟢 Acceptable risk level"
      color: "green"
```

### 6. Historical Confidence Tracking

#### Confidence Evolution Tracker
```javascript
// confidence-history-tracker.js
class ConfidenceHistoryTracker {
    constructor() {
        this.history = [];
        this.patterns = {
            'improving': {
                indicator: '📈',
                description: 'Confidence increasing over time',
                implication: 'Learning and validation working'
            },
            'declining': {
                indicator: '📉',
                description: 'Confidence decreasing',
                implication: 'New complexities discovered'
            },
            'stable': {
                indicator: '➡️',
                description: 'Confidence remains steady',
                implication: 'Understanding stabilized'
            },
            'volatile': {
                indicator: '📊',
                description: 'Confidence fluctuating',
                implication: 'Uncertain or changing context'
            }
        };
    }
    
    trackConfidence(topic, confidence, timestamp = new Date()) {
        this.history.push({
            topic,
            confidence,
            timestamp,
            factors: confidence.factors,
            context: confidence.context
        });
        
        return this.analyzePattern(topic);
    }
    
    analyzePattern(topic) {
        const topicHistory = this.history.filter(h => h.topic === topic);
        if (topicHistory.length < 2) return null;
        
        const recent = topicHistory.slice(-5);
        const trend = this.calculateTrend(recent);
        
        return {
            pattern: trend,
            visualization: this.visualizeTrend(recent),
            insights: this.generateInsights(trend, recent)
        };
    }
    
    visualizeTrend(history) {
        const chart = history.map(h => {
            const bars = Math.floor(h.confidence.percentage / 20);
            return '█'.repeat(bars) + '░'.repeat(5 - bars);
        }).join(' → ');
        
        return chart;
    }
}
```

### 7. Confidence-Aware Output Formatting

#### Progressive Disclosure Format
```markdown
**Summary View (Default):**
```
🟢 [85%] Solution: Implement caching layer with Redis
         Quick confidence check: ✓ Proven pattern ✓ Team experience ✓ Good docs
```

**Detailed View (On Request):**
```
### Confidence Breakdown: Implement caching layer with Redis

**Overall Confidence**: 🟢 85% [████████░░]

**Confidence Factors:**
✅ **Positive Factors** (Contributing +35%)
   • Well-documented Redis patterns (+15%)
   • Team has Redis experience (+10%)
   • Similar implementation succeeded (+10%)

⚠️ **Uncertainty Factors** (Contributing -15%)
   • Cache invalidation complexity (-10%)
   • Additional infrastructure required (-5%)

**Risk Assessment**: LOW-MEDIUM
• Impact if wrong: MEDIUM (performance issues)
• Probability of issues: LOW (well-tested approach)
• Overall risk score: 25/100

**To Increase Confidence:**
1. Review Redis best practices documentation
2. Prototype cache invalidation strategy
3. Load test with expected traffic patterns

**Decision Recommendation**: ✅ PROCEED
Confidence exceeds threshold (75%) for reversible high-impact decisions
```
```

### 8. Context-Aware Confidence Adjustments

#### Domain-Specific Confidence Modifiers
```python
# domain-confidence-modifiers.py
class DomainConfidenceModifiers:
    def __init__(self):
        self.domain_modifiers = {
            'security': {
                'base_reduction': -0.1,  # Security requires extra caution
                'critical_factors': ['security_audit', 'penetration_tested', 'cryptography_review'],
                'minimum_acceptable': 85
            },
            'financial': {
                'base_reduction': -0.15,  # Financial systems need highest confidence
                'critical_factors': ['regulatory_compliance', 'audit_trail', 'transaction_integrity'],
                'minimum_acceptable': 90
            },
            'experimental': {
                'base_reduction': 0.1,  # Experimental work accepts more uncertainty
                'critical_factors': ['innovation_potential', 'learning_opportunity'],
                'minimum_acceptable': 60
            },
            'production': {
                'base_reduction': -0.05,  # Production requires more confidence than dev
                'critical_factors': ['tested_in_staging', 'monitoring_ready', 'rollback_plan'],
                'minimum_acceptable': 80
            }
        }
    
    def adjust_confidence(self, base_confidence, domain, context):
        """Adjust confidence based on domain requirements."""
        if domain not in self.domain_modifiers:
            return base_confidence
            
        modifier = self.domain_modifiers[domain]
        adjusted = base_confidence + (modifier['base_reduction'] * 100)
        
        # Check critical factors
        for factor in modifier['critical_factors']:
            if factor not in context.get('validated_factors', []):
                adjusted -= 5  # Penalty for missing critical factors
        
        return {
            'original': base_confidence,
            'adjusted': max(0, min(100, adjusted)),
            'domain': domain,
            'minimum_required': modifier['minimum_acceptable'],
            'meets_threshold': adjusted >= modifier['minimum_acceptable']
        }
```

### 9. Actionable Confidence Improvements

#### Confidence Improvement Suggestions
```yaml
improvement_strategies:
  for_technical_implementation:
    low_confidence_actions:
      - "Create proof of concept to validate approach"
      - "Research similar implementations in open source"
      - "Consult with team members who have experience"
      - "Review official documentation thoroughly"
      
    medium_confidence_actions:
      - "Write comprehensive tests for edge cases"
      - "Get code review from senior developer"
      - "Test in staging environment"
      
    optimization_actions:
      - "Document decision rationale"
      - "Create runbooks for common issues"
      - "Set up monitoring and alerts"
      
  for_architectural_decisions:
    low_confidence_actions:
      - "Create architectural spike/prototype"
      - "Research industry best practices"
      - "Consult with system architects"
      - "Analyze similar system architectures"
      
    medium_confidence_actions:
      - "Document trade-offs explicitly"
      - "Create proof of concept for risky parts"
      - "Get external architecture review"
      
  for_debugging_diagnosis:
    low_confidence_actions:
      - "Gather more diagnostic information"
      - "Reproduce issue consistently"
      - "Check similar issues in bug tracker"
      - "Use debugging tools systematically"
      
    medium_confidence_actions:
      - "Verify hypothesis with targeted tests"
      - "Check logs and monitoring data"
      - "Consult with team members"
```

### 10. Integration Examples

#### Sample Output with Confidence Tracking
```markdown
### Implementation Plan: User Authentication System

**Overall Implementation Confidence**: 🟢 82% [████████░░]

#### Phase 1: Setup OAuth Provider
🟢 [90%] Configure Google OAuth integration
└── High confidence: Well-documented, many examples available

#### Phase 2: Implement JWT Tokens
🟢 [85%] Create JWT token generation and validation
├── ✓ Standard library available
├── ✓ Security best practices documented
└── ⚠️ Ensure proper key rotation strategy

#### Phase 3: Session Management
🟡 [70%] Implement Redis-based session storage
├── ✓ Redis setup straightforward
├── ⚠️ Session invalidation complexity
└── 🔍 Need to test concurrent session handling

#### Phase 4: Security Hardening
🟡 [65%] Add rate limiting and brute force protection
├── ⚠️ Configuration complexity for different endpoints
├── ⚠️ Testing all attack vectors challenging
└── 📋 Action: Research security testing tools

**Critical Uncertainties**:
1. 🟠 [45%] GDPR compliance for token storage
   └── Action: Consult with legal team
   
2. 🟡 [60%] Performance impact of rate limiting
   └── Action: Load test with realistic traffic

**Risk Matrix**:
```
Impact ↑  │ 🟡 Medium Risk  │ 🔴 High Risk    │
High      │ (Rate limiting) │ (GDPR compliance)│
          ├─────────────────┼─────────────────┤
Low       │ 🟢 Low Risk     │ 🟡 Medium Risk  │
          │ (JWT standard)  │ (Redis setup)   │
          └─────────────────┴─────────────────┘
            High              Low          ← Confidence
```

**Next Steps to Increase Confidence**:
1. ✅ Review OWASP authentication guidelines
2. ✅ Prototype rate limiting implementation
3. ✅ Schedule security review with expert
4. ✅ Create comprehensive test suite
```

## Usage Instructions

### Activation Methods
1. **Global Toggle**: Enable confidence tracking for entire session
2. **Inline Request**: Ask for confidence on specific statements
3. **Report Generation**: Request confidence report for plans/implementations
4. **Continuous Mode**: Show confidence for all technical statements

### Command Variations
- `show-confidence-level`: Default balanced view
- `show-confidence-level --detailed`: Comprehensive breakdowns
- `show-confidence-level --summary`: Quick confidence indicators only
- `show-confidence-level --risks`: Focus on risk assessment
- `show-confidence-level --improve`: Focus on improvement suggestions

## Integration with Other Commands

### Complementary Commands
- **code-review**: Confidence in code quality assessments
- **debugging**: Confidence in problem diagnosis
- **test-generation**: Confidence in test coverage adequacy
- **security-audit**: Confidence in security assessments
- **best-practice**: Confidence in recommendation applicability

### Workflow Integration
```yaml
confidence_enhanced_workflow:
  1_planning:
    - Generate implementation plan
    - Show confidence levels for each phase
    - Identify high-risk areas needing research
    
  2_implementation:
    - Track confidence as code is written
    - Flag low-confidence decisions for review
    - Suggest validation steps in real-time
    
  3_validation:
    - Confidence-based test prioritization
    - Focus reviews on low-confidence areas
    - Track confidence improvements
    
  4_deployment:
    - Final confidence assessment
    - Risk-based deployment strategy
    - Monitoring focus on uncertain areas
```

## Anti-Patterns/Warnings

- Don't treat high confidence as guarantee - always validate critical decisions
- Don't ignore low confidence - it's valuable signal for where to focus effort  
- Don't optimize for high confidence scores - optimize for accurate assessment
- Don't skip validation even with high confidence in security/financial domains
- Don't use confidence as excuse to avoid decision - use it to make better decisions

## Validation Checklist

- [ ] Confidence percentages are realistic and well-calibrated
- [ ] Factors contributing to confidence are clearly explained
- [ ] Low confidence areas have actionable improvement suggestions
- [ ] Risk assessment accurately reflects confidence and impact
- [ ] Visual indicators make confidence immediately apparent
- [ ] Integration with decision-making process is clear
- [ ] Historical tracking provides learning insights
- [ ] Domain-specific adjustments are appropriately applied