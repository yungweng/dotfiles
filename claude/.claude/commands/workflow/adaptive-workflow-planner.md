# Adaptive Workflow Planner Command

## Purpose
Create dynamic, intelligent workflow plans using todo lists that automatically adapt to changes, context, and user feedback while providing clear summaries and progress tracking throughout the workflow execution.

## Prerequisites/Context
- Clear objective or problem to solve
- Available commands in ~/.claude/commands/ directory
- Understanding of project context and constraints
- Optional: $ARGUMENTS for specific workflow preferences, adaptation strategies, or command suggestions

## Core Instructions

### 1. Workflow Planning Framework
```
ADAPTIVE_WORKFLOW_PLAN: [Dynamic plan for achieving objectives]
├── Initial Discovery: [Understand context and available resources]
├── Plan Synthesis: [Create optimal workflow using todo lists]
├── Summary Generation: [Provide clear overview before execution]
├── Adaptive Execution: [Execute with real-time adaptation]
└── Continuous Learning: [Improve based on results and feedback]
```

### 2. Initial Discovery Phase

#### Command Arsenal Discovery
When invoked, immediately:
1. Use `Glob` tool with pattern `*.md` in `~/.claude/commands/` to discover all available commands
2. Categorize commands automatically based on their purpose
3. Store command capabilities for intelligent workflow planning

#### Context Assessment
```yaml
context_analysis:
  problem_understanding:
    - "What is the core objective?"
    - "What are the constraints and requirements?"
    - "What defines success for this workflow?"
    - "What resources are available?"
  
  complexity_evaluation:
    simple_task: "Single command or straightforward sequence"
    medium_complexity: "Multiple phases with some dependencies"
    high_complexity: "Complex interactions, multiple perspectives needed"
    
  adaptation_requirements:
    flexibility_needed: "How much might requirements change?"
    uncertainty_level: "How well-defined is the problem?"
    feedback_importance: "How critical is user input during execution?"
```

### 3. Intelligent Plan Synthesis

#### Workflow Generation Engine
```python
# workflow-generation-logic.py
class AdaptiveWorkflowPlanner:
    def __init__(self):
        self.workflow_patterns = {
            'sequential': 'Step-by-step progression for clear dependencies',
            'parallel': 'Concurrent execution for independent tasks',
            'iterative': 'Cyclic refinement for evolving solutions',
            'adaptive': 'Dynamic adjustment based on intermediate results',
            'exploratory': 'Discovery-based for unclear problems'
        }
        
        self.command_categories = {
            'analysis': ['deep-search', 'code-review', 'project-analysis', 'trace-flow'],
            'cognitive': ['mental-model', 'first-principles', 'thought-experiment', 'socratic-dialogue'],
            'development': ['debugging', 'refactor', 'test-generation', 'fix-types'],
            'creative': ['dream-logic', 'stream-of-consciousness', 'brainstorming'],
            'validation': ['double-check-fact-check', 'reality-checker', 'test-writer'],
            'execution': ['commit-push', 'pull-request', 'documentation']
        }
    
    def synthesize_workflow(self, objective, context, available_commands):
        """Generate optimal workflow plan with todo list."""
        # Analyze objective complexity
        complexity = self.analyze_complexity(objective)
        
        # Select appropriate workflow pattern
        pattern = self.select_pattern(complexity, context)
        
        # Generate todo items based on pattern and available commands
        todo_items = self.generate_todo_items(
            objective, pattern, available_commands, context
        )
        
        return {
            'pattern': pattern,
            'complexity': complexity,
            'todo_items': todo_items,
            'adaptation_strategy': self.define_adaptation_strategy(context)
        }
```

#### Todo List Generation
```yaml
todo_generation_principles:
  structure:
    - "Break complex objectives into manageable tasks"
    - "Include specific commands for each task when applicable"
    - "Add decision points for adaptation"
    - "Include validation and checkpoint tasks"
    
  task_properties:
    content: "Clear, actionable description with command reference"
    priority: "high/medium/low based on dependencies and impact"
    status: "pending → in_progress → completed"
    adaptability: "Fixed tasks vs flexible tasks that can change"
    
  example_todos:
    - content: "Analyze project structure using deep-search command"
      priority: "high"
      command: "deep-search"
      adaptable: false
      
    - content: "Synthesize findings and identify key patterns"
      priority: "high"
      command: "mental-model"
      adaptable: true
      
    - content: "CHECKPOINT: Review progress and adapt plan if needed"
      priority: "medium"
      command: null
      adaptable: true
```

### 4. Workflow Summary Generation

Before execution, ALWAYS provide a clear summary:

```markdown
## Workflow Plan Summary

**Objective:** [Clear statement of what will be achieved]

**Approach:** [Selected workflow pattern and why]

**Planned Steps:**
1. [Phase 1 description] - Commands: [command1, command2]
2. [Phase 2 description] - Commands: [command3, command4]
3. [Decision Point] - Adapt based on results
4. [Phase 3 description] - Commands: [command5]

**Adaptation Points:**
- After Phase 1: Evaluate findings and adjust approach if needed
- During Phase 2: Monitor progress and optimize resource usage
- Before Phase 3: Confirm direction or pivot based on results

**Success Criteria:**
- [ ] [Specific measurable outcome 1]
- [ ] [Specific measurable outcome 2]
- [ ] [Quality or performance metric]

**Estimated Workflow:** [Sequential/Parallel/Iterative/Adaptive]

Ready to begin? Type 'GO' or provide additional context to refine the plan.
```

### 5. Adaptive Execution Engine

#### Real-time Adaptation Mechanisms
```javascript
// adaptation-engine.js
class AdaptationEngine {
    constructor() {
        this.adaptationTriggers = {
            'result_based': 'Adapt when command results indicate need',
            'user_feedback': 'Adapt based on user input or corrections',
            'context_change': 'Adapt when new information emerges',
            'performance_based': 'Adapt if progress too slow or blocked',
            'opportunity_based': 'Adapt when better path becomes apparent'
        };
        
        this.adaptationStrategies = {
            'reorder_tasks': 'Change sequence for better flow',
            'add_tasks': 'Insert new tasks based on discoveries',
            'remove_tasks': 'Skip tasks that become irrelevant',
            'change_approach': 'Switch to different command or method',
            'parallelize': 'Execute independent tasks concurrently',
            'seek_input': 'Request user guidance for unclear situations'
        };
    }
    
    checkAdaptationNeeded(currentTask, taskResult, todoList, context) {
        // Evaluate if adaptation is needed
        const triggers = this.evaluateTriggers(taskResult, context);
        
        if (triggers.length > 0) {
            return this.proposeAdaptation(triggers, currentTask, todoList);
        }
        
        return null;
    }
    
    proposeAdaptation(triggers, currentTask, todoList) {
        // Generate adaptation proposal
        const proposal = {
            reason: triggers,
            current_task: currentTask,
            proposed_changes: [],
            impact_assessment: '',
            user_approval_needed: false
        };
        
        // Define specific adaptations based on triggers
        for (const trigger of triggers) {
            const strategy = this.selectStrategy(trigger, todoList);
            proposal.proposed_changes.push(strategy);
        }
        
        return proposal;
    }
}
```

#### Progress Tracking and Updates
```yaml
progress_communication:
  task_updates:
    starting: "🚀 Starting: [task description]"
    command_execution: "⚡ Executing [command] for [purpose]"
    completed: "✅ Completed: [task description]"
    adapted: "🔄 Adapting plan: [reason for change]"
    checkpoint: "🎯 Checkpoint: [progress summary]"
    
  periodic_summaries:
    trigger: "Every 3-5 completed tasks or major phase completion"
    format: |
      ## Progress Update
      - Completed: X of Y tasks
      - Current Phase: [phase name]
      - Key Findings: [important discoveries]
      - Next Steps: [upcoming tasks]
      
  adaptation_communication:
    proposal: |
      ## Proposed Plan Adaptation
      **Reason:** [why adaptation needed]
      **Current Plan:** [what was planned]
      **Proposed Change:** [new approach]
      **Impact:** [how this affects overall workflow]
      
      Proceed with adaptation? (yes/no/modify)
```

### 6. Workflow Patterns and Templates

#### Pattern Library
```yaml
workflow_patterns:
  investigation_pattern:
    description: "For understanding complex problems"
    sequence:
      1: "Broad exploration (deep-search, websearch)"
      2: "Focused analysis (code-review, trace-flow)"
      3: "Synthesis (mental-model, first-principles)"
      4: "Validation (double-check-fact-check)"
    adaptation_points: ["After exploration", "During analysis", "Before conclusions"]
    
  development_pattern:
    description: "For implementing solutions"
    sequence:
      1: "Requirements analysis (project-analysis)"
      2: "Design phase (architecture-design, api-design)"
      3: "Implementation (intent-to-code, test-generation)"
      4: "Quality assurance (code-review, test-writer)"
      5: "Deployment (commit-push, pull-request)"
    adaptation_points: ["After design", "During implementation", "Based on test results"]
    
  problem_solving_pattern:
    description: "For fixing issues"
    sequence:
      1: "Problem identification (debugging, error-analysis)"
      2: "Root cause analysis (trace-flow, deep-search)"
      3: "Solution design (first-principles, best-practice)"
      4: "Implementation (fix-types, refactor)"
      5: "Verification (test-generation, performance-audit)"
    adaptation_points: ["After root cause found", "If solution doesn't work", "Based on verification"]
    
  creative_pattern:
    description: "For innovative solutions"
    sequence:
      1: "Inspiration gathering (dream-logic, stream-of-consciousness)"
      2: "Idea exploration (thought-experiment, paradox-resolver)"
      3: "Concept refinement (constraint-alchemist, reality-checker)"
      4: "Prototyping (intent-to-code, api-design)"
      5: "Iteration (user feedback → refinement cycle)"
    adaptation_points: ["After each creative session", "Based on feasibility", "User feedback integration"]
```

### 7. User Interaction Modes

#### Trigger Phrases and Commands
```yaml
execution_triggers:
  start_execution:
    - "GO"
    - "START"
    - "EXECUTE"
    - "BEGIN WORKFLOW"
    
  modification_requests:
    - "MODIFY PLAN"
    - "ADD [command/task]"
    - "SKIP [task]"
    - "CHANGE APPROACH"
    
  feedback_integration:
    - "That worked, continue"
    - "Try different approach"
    - "Focus on [specific aspect]"
    - "Speed up / Slow down"
    
  control_commands:
    - "PAUSE" - Pause execution for discussion
    - "STATUS" - Get current progress summary  
    - "ADAPT" - Trigger manual adaptation
    - "COMPLETE" - Finish current phase and summarize
```

### 8. Example Usage Flows

#### Example 1: Complex Debugging
```
User: /adaptive-workflow-planner debug authentication issues in the app
Assistant: 🔍 Discovering available commands...

## Workflow Plan Summary

**Objective:** Debug and fix authentication issues in the application

**Approach:** Problem-solving pattern with adaptive investigation

**Planned Steps:**
1. Initial Investigation - Commands: [error-analysis, trace-flow]
2. Deep Dive Analysis - Commands: [debugging, deep-search]
3. Root Cause Synthesis - Commands: [first-principles, mental-model]
4. Solution Implementation - Commands: [fix-types, refactor]
5. Verification - Commands: [test-generation, test-writer]

**Adaptation Points:**
- After initial investigation: Narrow focus based on error patterns
- During deep dive: Switch approaches if current path unproductive
- Before implementation: Validate solution approach

**Success Criteria:**
- [ ] Authentication errors identified and understood
- [ ] Root cause determined with confidence
- [ ] Fix implemented and tested successfully
- [ ] No regression in existing auth features

**Estimated Workflow:** Adaptive problem-solving

Ready to begin? Type 'GO' or provide additional context to refine the plan.

User: GO
Assistant: 
[Creates todo list and begins execution with progress updates and adaptation as needed]
```

#### Example 2: Feature Development
```
User: /adaptive-workflow-planner implement user profile feature with avatar upload
Assistant: 🔍 Discovering available commands...

## Workflow Plan Summary

**Objective:** Implement complete user profile feature with avatar upload capability

**Approach:** Development pattern with iterative refinement

**Planned Steps:**
1. Requirements & Design - Commands: [project-analysis, api-design]
2. Backend Implementation - Commands: [crud-generator, form-handler]
3. Frontend Development - Commands: [intent-to-code]
4. Security & Validation - Commands: [sanitize-inputs, security-audit]
5. Testing & Documentation - Commands: [test-generation, documentation]

**Adaptation Points:**
- After design: Adjust based on technical constraints
- During implementation: Optimize based on performance needs
- After security audit: Add additional safeguards if needed

**Success Criteria:**
- [ ] Profile CRUD operations working
- [ ] Avatar upload with size/type validation
- [ ] Secure against common vulnerabilities
- [ ] Comprehensive test coverage
- [ ] API documentation complete

**Estimated Workflow:** Sequential development with validation gates

Ready to begin? Type 'GO' or provide additional context to refine the plan.
```

#### Example 3: Performance Optimization
```
User: /adaptive-workflow-planner optimize slow page load times
Assistant: 🔍 Discovering available commands...

## Workflow Plan Summary

**Objective:** Identify and fix performance bottlenecks causing slow page loads

**Approach:** Investigation pattern with parallel analysis

**Planned Steps:**
1. Performance Baseline - Commands: [performance-audit, trace-flow]
2. Parallel Analysis:
   - Frontend: [code-review focused on bundles]
   - Backend: [query-optimizer, deep-search for N+1]
   - Infrastructure: [project-analysis for config issues]
3. Optimization Strategy - Commands: [first-principles, best-practice]
4. Implementation - Commands: [refactor, fix-imports]
5. Validation - Commands: [performance-audit comparison]

**Adaptation Points:**
- After baseline: Focus on biggest bottlenecks first
- During analysis: Deep dive on surprising findings
- Before optimization: Validate approach won't break features

**Success Criteria:**
- [ ] Page load time reduced by >50%
- [ ] Core Web Vitals in green range
- [ ] No functionality regression
- [ ] Optimizations documented

**Estimated Workflow:** Parallel investigation → Sequential optimization

Ready to begin? Type 'GO' or provide additional context to refine the plan.
```

### 9. Integration with workflow-chain

This command seamlessly integrates with workflow-chain by:
- Auto-discovering all available commands like workflow-chain does
- Creating structured todo lists for workflow management
- Supporting the same trigger phrases (GO, START, etc.)
- Providing clear summaries before execution
- Adding intelligent adaptation based on results

Use this when you need:
- A plan that can change based on what you discover
- Clear visibility into the workflow before starting
- Ability to adapt the plan mid-execution
- Integration with todo tracking for complex workflows

## Anti-Patterns/Warnings

- Don't create overly complex plans for simple tasks
- Don't skip the summary phase - user needs to understand the plan
- Don't be too rigid - adaptation is key to this command's value
- Don't forget to use todo updates throughout execution
- Don't ignore user feedback during execution
- Don't continue with a failing approach - adapt early

## Integration Notes

- **With workflow-chain:** Use this for complex workflows needing adaptation
- **With workflow-synthesizer:** This provides the execution layer for synthesized workflows
- **With subagents:** Can spawn subagents for parallel investigation phases
- **With mental-model:** Use to synthesize findings at checkpoints
- **With project-analysis:** Often the first step in understanding context

## Validation Checklist

- [ ] All available commands discovered and categorized
- [ ] Clear workflow plan created with todo items
- [ ] Summary provided before execution
- [ ] Adaptation points clearly defined
- [ ] Success criteria measurable
- [ ] Progress tracking implemented
- [ ] User can intervene and modify plan
- [ ] Plan adjusts based on results