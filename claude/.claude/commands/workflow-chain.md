# Workflow Chain Command

## Purpose
Queue multiple commands and execute them in sequence after receiving the trigger phrase.

## Instructions

### Phase 1: Command Collection & Discovery
When this command is invoked, enter "collection mode" where you:
1. **Auto-discover all available commands** by scanning ~/.claude/commands/ directory
2. Display the complete command arsenal dynamically
3. Acknowledge each command/instruction with: "✓ Command registered: [command_name]"
4. Do NOT execute anything yet
5. Keep collecting until you see the trigger phrase

### Dynamic Command Discovery
**IMPORTANT**: When workflow-chain is invoked, use the Glob tool to scan for all .md files in ~/.claude/commands/ and automatically display the complete, up-to-date command arsenal.

**Discovery Process:**
1. Use `Glob` tool with pattern `*.md` in `~/.claude/commands/` directory
2. Extract command names from filenames (remove .md extension)
3. Categorize commands automatically based on content/naming patterns
4. Display organized command arsenal with brief descriptions

**Auto-Categorization Patterns:**
- **Cognitive Enhancement**: mental-model, thought-experiment, devil-advocate, socratic-dialogue, first-principles
- **Core Analysis**: subagents, deep-search, websearch, double-check-fact-check, sequentialthinking, debugging
- **Development & Quality**: code-review, test-generation, refactor, documentation, performance-audit, api-design
- **Security & Dependencies**: dependency-update, security-audit, error-analysis, tech-debt-assessment
- **Git & Project Management**: issue, pull-request, commit-push
- **Workflow & Meta**: best-practice, create-a-prompt, workflow-chain

### Phase 2: Supported Commands to Queue
- **subagent**: Use Task tool for parallel exploration
- **sequentialthinking**: Break down problem step-by-step with explicit reasoning
- **debugging**: Analyze error logs and trace issues systematically
- **websearch**: Research current best practices
- **codeanalysis**: Deep dive into codebase structure
- **testing**: Focus on test creation and validation
- **performance**: Analyze and optimize performance
- **security**: Security audit and vulnerability check

### Phase 3: Context Collection
After commands are queued, user may provide:
- Error logs
- Code snippets
- Screenshots
- Additional context

Acknowledge with: "✓ Context received: [type of context]"

### Phase 4: Trigger Phrases
Execute the queued workflow when you see one of these phrases:
- "EXECUTE WORKFLOW"
- "GO"
- "START PROCESSING"
- "RUN IT"

### Phase 5: Execution Pattern
When triggered:
1. Create a TodoWrite list with all queued commands
2. Execute each command in sequence
3. Apply each command's perspective to the problem
4. Combine insights from all approaches
5. Deliver comprehensive solution

## Example Usage

```
User: /project:workflow-chain
Assistant: ✓ Workflow chain mode activated. Queue your commands.

User: subagent
Assistant: ✓ Command registered: subagent

User: sequentialthinking  
Assistant: ✓ Command registered: sequentialthinking

User: debugging
Assistant: ✓ Command registered: debugging

User: Here's my error log: [error details]
Assistant: ✓ Context received: error log

User: EXECUTE WORKFLOW
Assistant: [Begins executing all queued commands with the provided context]
```

## Implementation Notes
- Maintain command queue in working memory
- Each command adds a specific lens/approach
- Combine all perspectives for comprehensive solution
- Use TodoWrite to track progress through queue