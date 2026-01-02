# Devil's Advocate Command

## Purpose
Systematically challenge assumptions, question decisions, and explore counterarguments to strengthen ideas, reveal blind spots, and stress-test proposals before implementation.

## Prerequisites/Context
- Proposal, decision, or idea to challenge
- Understanding of the context and stakeholders
- Willingness to explore uncomfortable questions
- Optional: $ARGUMENTS for focus area (technical/business/security/ethical)

## Core Instructions

### 1. Devil's Advocate Framework
```
CHALLENGE_TARGET: [Proposal/Decision/Idea to challenge]
├── Assumptions: [What beliefs are taken for granted]
├── Counterarguments: [Alternative perspectives and objections]
├── Edge Cases: [Where the proposal might break down]
├── Unintended Consequences: [What could go wrong]
└── Alternative Approaches: [Different ways to achieve the goal]
```

### 2. Systematic Assumption Challenging

#### Assumption Discovery Engine
```python
# assumption-challenger.py
class AssumptionChallenger:
    def __init__(self):
        self.challenge_categories = {
            'technical_assumptions': [
                'Technology will work as expected',
                'Performance requirements are achievable',
                'Integration will be straightforward',
                'Security measures are sufficient',
                'Scalability won\'t be an issue'
            ],
            
            'business_assumptions': [
                'Market demand exists and will continue',
                'Users will adopt the solution',
                'Competition won\'t respond aggressively',
                'Budget and timeline are realistic',
                'ROI projections are accurate'
            ],
            
            'organizational_assumptions': [
                'Team has necessary skills',
                'Stakeholders will support the initiative',
                'Resources will remain available',
                'Organizational priorities won\'t shift',
                'Change management will be smooth'
            ],
            
            'environmental_assumptions': [
                'Regulatory environment will remain stable',
                'Technology landscape won\'t shift dramatically',
                'Economic conditions will remain favorable',
                'Partner relationships will continue',
                'Infrastructure will remain reliable'
            ]
        }
        
        self.questioning_techniques = {
            'five_whys_reverse': 'Why might this assumption be wrong?',
            'perspective_flip': 'How would a critic see this?',
            'worst_case_scenario': 'What\'s the worst that could happen?',
            'historical_analysis': 'When has this assumption failed before?',
            'stakeholder_challenge': 'Who would disagree and why?'
        }

    def challenge_proposal(self, proposal_description):
        """Systematically challenge a proposal from multiple angles."""
        challenge_analysis = {
            'assumption_audit': self.audit_assumptions(proposal_description),
            'stakeholder_objections': self.generate_stakeholder_objections(proposal_description),
            'failure_modes': self.identify_failure_modes(proposal_description),
            'opportunity_costs': self.analyze_opportunity_costs(proposal_description),
            'unintended_consequences': self.predict_unintended_consequences(proposal_description),
            'alternative_approaches': self.suggest_alternatives(proposal_description)
        }
        
        return challenge_analysis

    def audit_assumptions(self, proposal):
        """Identify and challenge key assumptions."""
        assumption_audit = {
            'explicit_assumptions': 'What does the proposal openly assume?',
            'implicit_assumptions': 'What beliefs are taken for granted?',
            'critical_assumptions': 'Which assumptions, if wrong, would doom the project?',
            'untested_assumptions': 'What hasn\'t been validated yet?',
            'outdated_assumptions': 'What might have been true before but not now?'
        }
        
        # Systematic assumption challenges
        challenges = {
            'technical_viability': [
                'What if the technology doesn\'t work as expected?',
                'What if performance is 10x worse than anticipated?',
                'What if security vulnerabilities are discovered?',
                'What if the technology becomes obsolete quickly?'
            ],
            
            'market_assumptions': [
                'What if users don\'t want this solution?',
                'What if competitors launch something better first?',
                'What if market conditions change dramatically?',
                'What if adoption is 90% slower than projected?'
            ],
            
            'resource_assumptions': [
                'What if it costs 3x more than estimated?',
                'What if it takes 2x longer than planned?',
                'What if key team members leave?',
                'What if budget gets cut mid-project?'
            ]
        }
        
        return assumption_audit, challenges

    def generate_stakeholder_objections(self, proposal):
        """Generate objections from different stakeholder perspectives."""
        stakeholder_challenges = {
            'developers': {
                'concerns': ['Technical debt', 'Complexity', 'Maintainability', 'Learning curve'],
                'objections': [
                    'This will make the codebase much harder to maintain',
                    'We don\'t have the expertise to do this well',
                    'This introduces unnecessary complexity',
                    'The technical risk is too high'
                ]
            },
            
            'product_managers': {
                'concerns': ['User experience', 'Time to market', 'Feature completeness', 'Market fit'],
                'objections': [
                    'This doesn\'t solve the user\'s real problem',
                    'We\'re building the wrong thing',
                    'This will delay more important features',
                    'The market opportunity isn\'t as big as claimed'
                ]
            },
            
            'business_stakeholders': {
                'concerns': ['ROI', 'Risk', 'Competitive advantage', 'Resource allocation'],
                'objections': [
                    'The ROI doesn\'t justify the investment',
                    'This is too risky for the potential return',
                    'We should focus on proven revenue drivers',
                    'The competition is already ahead'
                ]
            },
            
            'operations_team': {
                'concerns': ['Reliability', 'Scalability', 'Monitoring', 'Support burden'],
                'objections': [
                    'This will make the system less reliable',
                    'We can\'t monitor or debug this effectively',
                    'This will create too much operational overhead',
                    'Support will be much more complex'
                ]
            },
            
            'security_team': {
                'concerns': ['Attack surface', 'Compliance', 'Data protection', 'Audit trail'],
                'objections': [
                    'This significantly increases our attack surface',
                    'This doesn\'t meet compliance requirements',
                    'We can\'t adequately secure this approach',
                    'This makes incident response much harder'
                ]
            }
        }
        
        return stakeholder_challenges

    def identify_failure_modes(self, proposal):
        """Identify ways the proposal could fail."""
        failure_analysis = {
            'technical_failures': [
                'Core technology doesn\'t work as expected',
                'Performance is unacceptable',
                'Security vulnerabilities are discovered',
                'Integration problems prove insurmountable',
                'Scalability hits unexpected limits'
            ],
            
            'execution_failures': [
                'Team lacks necessary skills',
                'Timeline is completely unrealistic',
                'Budget is insufficient',
                'Requirements keep changing',
                'Quality is sacrificed for speed'
            ],
            
            'market_failures': [
                'No one wants the solution',
                'Competition launches superior alternative',
                'Market conditions change',
                'Adoption is much slower than expected',
                'Users find workarounds instead'
            ],
            
            'organizational_failures': [
                'Leadership support disappears',
                'Priorities shift mid-project',
                'Key stakeholders become opponents',
                'Change management fails',
                'Politics derail the initiative'
            ]
        }
        
        return failure_analysis

    def analyze_opportunity_costs(self, proposal):
        """Analyze what we're giving up by pursuing this approach."""
        opportunity_costs = {
            'alternative_solutions': 'What other approaches could solve the same problem?',
            'competing_priorities': 'What important work won\'t get done?',
            'resource_allocation': 'What else could we do with these resources?',
            'timing_costs': 'What opportunities might we miss while focused on this?',
            'reversibility': 'How hard would it be to change course later?'
        }
        
        specific_challenges = [
            'What if we\'re solving the wrong problem entirely?',
            'What if there\'s a simpler solution we\'re overlooking?',
            'What if the status quo is actually better?',
            'What if this prevents us from pursuing a bigger opportunity?',
            'What if the cost of switching later is prohibitive?'
        ]
        
        return opportunity_costs, specific_challenges

# Specific devil's advocate templates for common scenarios
devil_advocate_templates = {
    'microservices_adoption': {
        'technical_challenges': [
            'Distributed systems are much harder than you think',
            'Network latency will kill performance',
            'Debugging across services is a nightmare',
            'Data consistency becomes nearly impossible',
            'The operational complexity will overwhelm the team'
        ],
        
        'business_challenges': [
            'The monolith actually works fine',
            'This will slow down feature development for years',
            'The migration will cost 10x more than estimated',
            'You\'re solving yesterday\'s problems, not tomorrow\'s',
            'The team will spend all their time on infrastructure'
        ]
    },
    
    'new_technology_adoption': {
        'risk_challenges': [
            'This technology is too immature for production',
            'The learning curve will destroy productivity',
            'Support and documentation are inadequate',
            'The ecosystem lacks critical tools',
            'Hiring will become much harder'
        ],
        
        'strategic_challenges': [
            'We\'re not solving a real problem',
            'This creates vendor lock-in',
            'The technology might be abandoned',
            'It doesn\'t integrate with our existing stack',
            'The ROI timeline is too long'
        ]
    },
    
    'major_refactoring': {
        'execution_challenges': [
            'The scope is much larger than estimated',
            'You\'ll break things that currently work',
            'Business won\'t tolerate the slowdown',
            'The team will burn out on the complexity',
            'Requirements will change mid-refactor'
        ],
        
        'value_challenges': [
            'Users don\'t care about internal code quality',
            'This effort could build 10 new features instead',
            'The technical debt isn\'t actually that painful',
            'Market timing will be ruined by this delay',
            'Competitors will gain advantage while we refactor'
        ]
    }
}
```

### 3. Critical Questioning Frameworks

#### Socratic Questioning for Technical Decisions
```yaml
# critical-questioning-framework.yaml
questioning_frameworks:
  technical_decision_challenges:
    clarification_questions:
      - "What exactly do you mean by [technical term]?"
      - "Can you give me a specific example?"
      - "How does this relate to [existing system]?"
      - "What are the key components involved?"
      
    assumption_questions:
      - "What assumptions are you making about performance?"
      - "How do you know users actually want this?"
      - "What evidence supports this technical approach?"
      - "What if your assumptions about scale are wrong?"
      
    evidence_questions:
      - "What data supports this decision?"
      - "How did you test this hypothesis?"
      - "What metrics will prove this is working?"
      - "What would convince you this approach is wrong?"
      
    perspective_questions:
      - "How would [stakeholder] view this decision?"
      - "What would a security expert say about this?"
      - "How would this look from a user's perspective?"
      - "What would a maintenance programmer think?"
      
    implication_questions:
      - "What are the long-term consequences?"
      - "How does this affect other systems?"
      - "What new problems might this create?"
      - "How will this constrain future decisions?"

  business_decision_challenges:
    market_reality_checks:
      - "How do you know there's actually demand for this?"
      - "What if competitors respond faster than expected?"
      - "What evidence shows users will change their behavior?"
      - "How sensitive is this to economic conditions?"
      
    resource_reality_checks:
      - "What if this takes 3x longer than estimated?"
      - "How will you maintain quality under pressure?"
      - "What happens if key people leave mid-project?"
      - "Where will ongoing maintenance resources come from?"
      
    strategic_alignment_checks:
      - "How does this advance our core mission?"
      - "What opportunities are we passing up?"
      - "Is this the best use of limited resources?"
      - "How does this position us for the future?"

  ethical_and_impact_challenges:
    user_impact_questions:
      - "Who might be harmed by this decision?"
      - "What unintended consequences could emerge?"
      - "How does this affect user privacy and autonomy?"
      - "What happens to users who can't adapt?"
      
    societal_impact_questions:
      - "What are the broader implications?"
      - "How might this be misused or abused?"
      - "Does this make society better or worse?"
      - "What precedent does this set?"
      
    fairness_questions:
      - "Who benefits and who bears the costs?"
      - "Does this create or reduce inequality?"
      - "Are we being transparent about trade-offs?"
      - "How would this look if everyone did it?"
```

### 4. Counterargument Generation

#### Structured Opposition Research
```javascript
// counterargument-generator.js
class CounterArgumentGenerator {
    constructor() {
        this.oppositionStrategies = {
            'technical_opposition': {
                'complexity_argument': 'This solution is unnecessarily complex',
                'reliability_concern': 'This approach is less reliable than alternatives',
                'performance_doubt': 'Performance will be worse than claimed',
                'maintainability_fear': 'This will be impossible to maintain',
                'security_risk': 'This introduces unacceptable security risks'
            },
            
            'business_opposition': {
                'roi_skepticism': 'Return on investment is overstated',
                'market_timing': 'Wrong time to make this move',
                'competitive_response': 'Competitors will neutralize advantage',
                'opportunity_cost': 'Better alternatives exist',
                'resource_drain': 'This will consume too many resources'
            },
            
            'strategic_opposition': {
                'vision_misalignment': 'This doesn\'t fit our long-term vision',
                'capability_mismatch': 'We lack core competencies needed',
                'market_position': 'This weakens our competitive position',
                'brand_dilution': 'This dilutes our brand focus',
                'cultural_conflict': 'This conflicts with our values'
            }
        };
    }

    generateOpposition(proposal, focus_area) {
        const opposition = {
            strongest_counterarguments: this.findStrongestCounters(proposal),
            stakeholder_objections: this.mapStakeholderObjections(proposal),
            alternative_proposals: this.generateAlternatives(proposal),
            risk_amplification: this.amplifyRisks(proposal),
            precedent_analysis: this.analyzeNegativePrecedents(proposal)
        };
        
        return opposition;
    }

    findStrongestCounters(proposal) {
        return {
            technical_counters: [
                'The proposed architecture will not scale',
                'Implementation complexity is vastly underestimated',
                'Technology choices create vendor lock-in',
                'Security model has fundamental flaws',
                'Performance requirements cannot be met'
            ],
            
            business_counters: [
                'Market demand is not validated',
                'Competitive advantage is not sustainable',
                'Cost-benefit analysis is flawed',
                'Timeline is completely unrealistic',
                'Resource requirements will bankrupt other initiatives'
            ],
            
            strategic_counters: [
                'This takes us away from core competencies',
                'It\'s a solution looking for a problem',
                'We\'re following rather than leading',
                'It creates dependency on external factors',
                'The risk-reward ratio is unacceptable'
            ]
        };
    }

    generateRedTeamQuestions(proposal) {
        return {
            attack_vectors: [
                'How would a malicious actor exploit this?',
                'What\'s the worst possible interpretation?',
                'Where are the single points of failure?',
                'What assumptions can be deliberately broken?',
                'How could this be turned against us?'
            ],
            
            stress_tests: [
                'What happens under 10x load?',
                'How does this behave when starved of resources?',
                'What if key dependencies disappear?',
                'How does this degrade under attack?',
                'What\'s the cascading failure scenario?'
            ],
            
            adversarial_scenarios: [
                'What if competitors copy this immediately?',
                'How would a disgruntled insider sabotage this?',
                'What if regulatory environment becomes hostile?',
                'How could this create legal liability?',
                'What if public opinion turns against this?'
            ]
        };
    }

    challengeFromMultiplePerspectives(proposal) {
        const perspectives = {
            'conservative_challenger': {
                viewpoint: 'Risk-averse, prefers proven solutions',
                challenges: [
                    'This is too experimental for our needs',
                    'Proven alternatives exist and work fine',
                    'The risk of failure is unacceptable',
                    'We should evolve, not revolutionize',
                    'Stability is more important than innovation'
                ]
            },
            
            'pragmatic_challenger': {
                viewpoint: 'Focused on practical execution',
                challenges: [
                    'Implementation will be much harder than described',
                    'We lack the skills to execute this properly',
                    'The timeline ignores real-world constraints',
                    'Maintenance costs are severely underestimated',
                    'This solves theoretical rather than real problems'
                ]
            },
            
            'strategic_challenger': {
                viewpoint: 'Focused on long-term competitive position',
                challenges: [
                    'This doesn\'t create sustainable competitive advantage',
                    'We\'re optimizing for yesterday\'s problems',
                    'This commits us to a path that limits future options',
                    'Competitors will leapfrog while we\'re building this',
                    'This distracts from more important strategic goals'
                ]
            },
            
            'user_advocate': {
                viewpoint: 'Represents end user interests',
                challenges: [
                    'Users don\'t actually want this',
                    'This makes the experience more complex',
                    'Users will find workarounds instead',
                    'The learning curve is too steep',
                    'This solves our problems, not user problems'
                ]
            }
        };
        
        return perspectives;
    }

    // Example: API Design Devil's Advocate
    apiDesignChallenges(apiProposal) {
        return {
            design_challenges: [
                'This API design is too complex for most use cases',
                'The abstraction level is wrong - too high or too low',
                'Versioning strategy will create maintenance nightmare',
                'Performance implications haven\'t been considered',
                'Error handling is insufficient for real-world use'
            ],
            
            adoption_challenges: [
                'Developers won\'t want to learn yet another API',
                'Migration path from existing API is too painful',
                'Documentation and examples will be inadequate',
                'SDK support across languages will be spotty',
                'Community won\'t rally around this approach'
            ],
            
            maintenance_challenges: [
                'Breaking changes will be inevitable',
                'Backward compatibility will become impossible',
                'Support burden will overwhelm the team',
                'Edge cases will proliferate beyond control',
                'Rate limiting and abuse prevention are afterthoughts'
            ]
        };
    }
}

// Red team analysis for security decisions
const securityRedTeam = {
    threat_modeling_challenges: [
        'Threat model is based on outdated attack patterns',
        'Assumes attackers follow rules and limitations',
        'Underestimates insider threat capabilities',
        'Ignores supply chain attack vectors',
        'Focuses on technical over social engineering'
    ],
    
    defense_strategy_challenges: [
        'Defense in depth is really defense in shallow',
        'Security by obscurity is masquerading as real security',
        'Monitoring and alerting will generate too many false positives',
        'Incident response plan assumes perfect execution',
        'Recovery procedures haven\'t been tested under stress'
    ],
    
    compliance_challenges: [
        'Compliance framework doesn\'t match actual risks',
        'Audit checklist mentality misses real vulnerabilities',
        'Regulatory requirements conflict with security best practices',
        'Compliance evidence is more theater than substance',
        'Gap between policy and implementation is enormous'
    ]
};
```

### 5. Alternative Perspective Generation

#### Multi-Stakeholder Challenge Matrix
```python
# alternative-perspective-generator.py
class AlternativePerspectiveGenerator:
    def __init__(self):
        self.stakeholder_lenses = {
            'end_users': {
                'primary_concerns': ['Usability', 'Reliability', 'Performance', 'Privacy'],
                'common_objections': [
                    'This makes things more complicated',
                    'The current solution works fine',
                    'I don\'t trust this with my data',
                    'The learning curve is too steep'
                ]
            },
            
            'developers': {
                'primary_concerns': ['Maintainability', 'Technical debt', 'Learning curve', 'Tool support'],
                'common_objections': [
                    'This will make debugging impossible',
                    'The abstraction hides important details',
                    'Documentation and examples are insufficient',
                    'This increases cognitive load significantly'
                ]
            },
            
            'operations_team': {
                'primary_concerns': ['Reliability', 'Monitoring', 'Incident response', 'Resource usage'],
                'common_objections': [
                    'This makes the system much harder to monitor',
                    'Troubleshooting will be a nightmare',
                    'Resource requirements are underestimated',
                    'Deployment complexity increases dramatically'
                ]
            },
            
            'security_team': {
                'primary_concerns': ['Attack surface', 'Data protection', 'Compliance', 'Audit trail'],
                'common_objections': [
                    'Attack surface increases unacceptably',
                    'Audit trail becomes impossible to follow',
                    'Compliance requirements cannot be met',
                    'Incident response becomes much harder'
                ]
            },
            
            'business_stakeholders': {
                'primary_concerns': ['ROI', 'Time to market', 'Competitive advantage', 'Risk'],
                'common_objections': [
                    'ROI timeline is too long and uncertain',
                    'This delays more important business goals',
                    'Competitive advantage is not sustainable',
                    'Risk is too high for potential return'
                ]
            }
        }

    def generate_alternative_perspectives(self, proposal):
        """Generate challenges from multiple stakeholder viewpoints."""
        perspectives = {}
        
        for stakeholder, lens in self.stakeholder_lenses.items():
            perspectives[stakeholder] = {
                'core_concerns': lens['primary_concerns'],
                'specific_objections': self.generate_specific_objections(proposal, lens),
                'alternative_suggestions': self.suggest_alternatives(proposal, lens),
                'success_criteria': self.define_success_from_perspective(lens)
            }
        
        return perspectives

    def challenge_from_extremes(self, proposal):
        """Challenge from extreme positions to stress-test thinking."""
        extreme_positions = {
            'radical_conservative': {
                'position': 'Change nothing, keep everything as is',
                'arguments': [
                    'Current system works perfectly fine',
                    'Any change introduces unnecessary risk',
                    'Resources should go to optimization, not rebuilding',
                    'Users are happy with status quo'
                ]
            },
            
            'radical_progressive': {
                'position': 'Go much further, this is too incremental',
                'arguments': [
                    'This change doesn\'t go far enough',
                    'Half-measures waste more resources than bold moves',
                    'Market is moving faster than this proposal',
                    'Incremental change leads to technical debt'
                ]
            },
            
            'cost_minimalist': {
                'position': 'Minimize all costs and complexity',
                'arguments': [
                    'Simplest possible solution is always best',
                    'Every feature adds cost without proportional value',
                    'Complexity is the enemy of reliability',
                    'Lean and mean beats feature-rich and complex'
                ]
            },
            
            'perfectionist': {
                'position': 'Nothing less than perfect is acceptable',
                'arguments': [
                    'This solution has too many compromises',
                    'We should wait for better technology',
                    'Quality should never be sacrificed for speed',
                    'Half-done solutions create more problems'
                ]
            }
        }
        
        return extreme_positions

    def generate_contrarian_analysis(self, proposal):
        """Generate systematic contrarian viewpoint."""
        contrarian_analysis = {
            'problem_redefinition': {
                'challenge': 'We\'re solving the wrong problem entirely',
                'alternative_framing': [
                    'The real problem is user behavior, not technology',
                    'The problem is organizational, not technical',
                    'The problem is market positioning, not features',
                    'The problem doesn\'t actually need solving'
                ]
            },
            
            'solution_inversion': {
                'challenge': 'The opposite approach would work better',
                'inversions': [
                    'Instead of adding complexity, remove it',
                    'Instead of building new, fix what exists',
                    'Instead of automating, add human oversight',
                    'Instead of scaling up, scale down'
                ]
            },
            
            'timing_challenge': {
                'challenge': 'This is the wrong time for this solution',
                'arguments': [
                    'Too early - market not ready',
                    'Too late - opportunity has passed',
                    'Wrong sequence - other things need to happen first',
                    'Wrong duration - this needs more/less time'
                ]
            },
            
            'capability_challenge': {
                'challenge': 'We\'re not the right organization for this',
                'arguments': [
                    'This requires capabilities we don\'t have',
                    'Someone else is better positioned to do this',
                    'This conflicts with our core competencies',
                    'We should partner rather than build'
                ]
            }
        }
        
        return contrarian_analysis

# Historical failure analysis
historical_challenge_patterns = {
    'technology_adoption_failures': {
        'examples': [
            'Google Glass - too early, privacy concerns',
            'Segway - solved problem that didn\'t exist',
            'Google+ - late to market, forced adoption',
            'Microsoft Zune - better technology, wrong ecosystem'
        ],
        'patterns': [
            'Great technology, wrong market timing',
            'Solving problem users don\'t have',
            'Underestimating ecosystem effects',
            'Overestimating user willingness to change'
        ]
    },
    
    'architecture_decision_failures': {
        'examples': [
            'Microservices without team structure',
            'NoSQL without understanding trade-offs',
            'Cloud migration without cost analysis',
            'Event-driven without operational readiness'
        ],
        'patterns': [
            'Technology-first instead of problem-first thinking',
            'Underestimating operational complexity',
            'Ignoring team and organizational readiness',
            'Following trends without understanding context'
        ]
    }
}
```

## Integration with Other Commands

### With Thought Experiment
- Use devil's advocate to challenge experiment assumptions
- Test scenarios against critical perspectives
- Ensure experiments consider hostile viewpoints

### With Mental Model
- Challenge the mental models being used
- Question model assumptions and boundaries
- Explore alternative mental frameworks

### With Socratic Dialogue
- Use questioning techniques to systematically challenge
- Dig deeper into challenged assumptions
- Explore implications of counterarguments

## Challenge Facilitation Techniques

### Structured Debate Format
- Assign team members to argue against the proposal
- Rotate perspectives to avoid personal attachment
- Focus on ideas, not personalities
- Document strongest counterarguments

### Red Team Exercises
- External perspective challenging
- Systematic attack on assumptions
- Worst-case scenario planning
- Adversarial thinking techniques

### Historical Analysis
- Review similar decisions that failed
- Analyze what went wrong and why
- Apply lessons to current proposal
- Look for recurring failure patterns

## Anti-Patterns/Warnings
- Don't become attached to being contrarian
- Avoid personal attacks while challenging ideas
- Don't let perfect be the enemy of good
- Balance skepticism with constructive alternatives

## Validation Checklist
- [ ] Key assumptions have been systematically challenged
- [ ] Multiple stakeholder perspectives considered
- [ ] Strongest counterarguments identified and addressed
- [ ] Failure modes and risks thoroughly explored
- [ ] Alternative approaches seriously evaluated
- [ ] Historical lessons and patterns analyzed
- [ ] Challenges lead to stronger final proposal
- [ ] Team understanding of trade-offs improved