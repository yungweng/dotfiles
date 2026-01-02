# Explain Command

## Purpose
Provide concise explanations and usage examples for any command in the ~/.claude/commands directory.

## Prerequisites/Context
- Command name to explain (required argument)
- Access to ~/.claude/ directory with command files

## Core Instructions

### 1. Command Analysis Framework
```
COMMAND_NAME: [Input command to explain]
├── Purpose: [What the command does]
├── Key Features: [Main capabilities]
├── Use Cases: [When to use it]
└── Examples: [Practical usage scenarios]
```

### 2. Implementation

```javascript
const fs = require('fs');
const path = require('path');

class CommandExplainer {
  constructor() {
    this.commandsDir = path.join(process.env.HOME, '.claude');
    this.knownCommands = this.scanAvailableCommands();
  }
  
  scanAvailableCommands() {
    try {
      return fs.readdirSync(this.commandsDir)
        .filter(file => file.endsWith('.md'))
        .map(file => file.replace('.md', ''));
    } catch (error) {
      return [];
    }
  }
  
  explainCommand(commandName) {
    const commandFile = path.join(this.commandsDir, `${commandName}.md`);
    
    if (!fs.existsSync(commandFile)) {
      return this.handleUnknownCommand(commandName);
    }
    
    try {
      const content = fs.readFileSync(commandFile, 'utf8');
      return this.parseAndExplain(commandName, content);
    } catch (error) {
      return `Error reading command file: ${error.message}`;
    }
  }
  
  parseAndExplain(commandName, content) {
    const sections = this.extractSections(content);
    
    return {
      command: commandName,
      purpose: this.extractPurpose(sections),
      key_features: this.extractKeyFeatures(sections),
      use_cases: this.generateUseCases(commandName, sections),
      examples: this.extractExamples(sections),
      integration: this.extractIntegration(sections)
    };
  }
  
  extractPurpose(sections) {
    const purposeSection = sections.find(s => s.title.toLowerCase().includes('purpose'));
    return purposeSection ? 
      purposeSection.content.split('\n')[0].trim() : 
      'Purpose not clearly defined in command file';
  }
  
  extractKeyFeatures(sections) {
    const features = [];
    
    // Look for numbered lists, bullet points, or framework sections
    sections.forEach(section => {
      if (section.title.toLowerCase().includes('framework') || 
          section.title.toLowerCase().includes('feature') ||
          section.title.toLowerCase().includes('instruction')) {
        
        const bullets = section.content.match(/^[-*+]\s+(.+)$/gm);
        const numbers = section.content.match(/^\d+\.\s+(.+)$/gm);
        
        if (bullets) features.push(...bullets.map(b => b.replace(/^[-*+]\s+/, '')));
        if (numbers) features.push(...numbers.map(n => n.replace(/^\d+\.\s+/, '')));
      }
    });
    
    return features.slice(0, 5); // Top 5 features
  }
  
  generateUseCases(commandName, sections) {
    const useCaseMap = {
      'pair-programming': [
        'Real-time collaborative coding sessions',
        'Code review with live feedback',
        'Learning programming with AI guidance',
        'Debugging complex issues together'
      ],
      'rubber-duck-debug': [
        'Stuck on a confusing bug',
        'Code logic seems wrong but unsure why',
        'Need to verbalize problem to find solution',
        'Want to verify understanding of code flow'
      ],
      'code-narrator': [
        'Understanding complex code execution',
        'Code reviews with detailed explanations',
        'Educational programming sessions',
        'Performance analysis with commentary'
      ],
      'intent-to-code': [
        'Quick prototyping from natural language',
        'Converting requirements to implementation',
        'Exploring different technical approaches',
        'Generating boilerplate with best practices'
      ],
      'pattern-mining': [
        'Identifying repeated code patterns',
        'Finding refactoring opportunities',
        'Extracting reusable components',
        'Discovering anti-patterns and code smells'
      ],
      'impossibility-navigator': [
        'Overcoming "impossible" technical challenges',
        'Finding creative solutions to constraints',
        'Challenging limiting assumptions',
        'Exploring alternative approaches'
      ],
      'paradox-resolver': [
        'Handling contradictory requirements',
        'Balancing competing priorities',
        'Resolving design conflicts',
        'Finding synthesis solutions'
      ],
      'reality-checker': [
        'Validating technical assumptions',
        'Testing performance claims',
        'Verifying architecture decisions',
        'Cross-checking implementation facts'
      ],
      'perception-shifter': [
        'Reframing stuck problems',
        'Finding new angles on challenges',
        'Breaking mental blocks',
        'Discovering hidden opportunities'
      ],
      'constraint-alchemist': [
        'Turning limitations into features',
        'Working creatively within restrictions',
        'Finding advantages in constraints',
        'Building competitive differentiators'
      ]
    };
    
    return useCaseMap[commandName] || this.inferUseCases(sections);
  }
  
  extractExamples(sections) {
    const examples = [];
    
    sections.forEach(section => {
      // Look for code blocks or example sections
      const codeBlocks = section.content.match(/```[\s\S]*?```/g);
      const exampleSections = section.content.match(/EXAMPLE[:\s]+([\s\S]*?)(?=\n\n|\n[A-Z]|$)/g);
      
      if (codeBlocks) {
        examples.push(...codeBlocks.slice(0, 2)); // First 2 code examples
      }
      
      if (exampleSections) {
        examples.push(...exampleSections.slice(0, 2));
      }
    });
    
    return examples.slice(0, 3); // Max 3 examples
  }
  
  formatExplanation(explanation) {
    return `
## ${explanation.command}

**Purpose:** ${explanation.purpose}

**Key Features:**
${explanation.key_features.map(f => `• ${f}`).join('\n')}

**Use Cases:**
${explanation.use_cases.map(uc => `• ${uc}`).join('\n')}

**Example Usage:**
\`/user:${explanation.command}\`

${explanation.examples.length > 0 ? 
  `**Examples:**\n${explanation.examples.join('\n\n')}` : 
  ''}

${explanation.integration ? 
  `**Integrates With:** ${explanation.integration.join(', ')}` : 
  ''}
    `.trim();
  }
  
  handleUnknownCommand(commandName) {
    const suggestions = this.findSimilarCommands(commandName);
    
    return `
Command "${commandName}" not found.

Available commands:
${this.knownCommands.map(cmd => `• ${cmd}`).join('\n')}

${suggestions.length > 0 ? 
  `\nDid you mean: ${suggestions.join(', ')}?` : 
  ''}
    `.trim();
  }
  
  findSimilarCommands(input) {
    return this.knownCommands
      .filter(cmd => 
        cmd.includes(input) || 
        input.includes(cmd) ||
        this.levenshteinDistance(cmd, input) <= 2
      )
      .slice(0, 3);
  }
  
  levenshteinDistance(str1, str2) {
    const matrix = [];
    
    for (let i = 0; i <= str2.length; i++) {
      matrix[i] = [i];
    }
    
    for (let j = 0; j <= str1.length; j++) {
      matrix[0][j] = j;
    }
    
    for (let i = 1; i <= str2.length; i++) {
      for (let j = 1; j <= str1.length; j++) {
        if (str2.charAt(i - 1) === str1.charAt(j - 1)) {
          matrix[i][j] = matrix[i - 1][j - 1];
        } else {
          matrix[i][j] = Math.min(
            matrix[i - 1][j - 1] + 1,
            matrix[i][j - 1] + 1,
            matrix[i - 1][j] + 1
          );
        }
      }
    }
    
    return matrix[str2.length][str1.length];
  }
}

// CLI Usage
if (require.main === module) {
  const explainer = new CommandExplainer();
  const commandName = process.argv[2];
  
  if (!commandName) {
    console.log('Usage: explain-command <command-name>');
    console.log('\nAvailable commands:');
    explainer.knownCommands.forEach(cmd => console.log(`• ${cmd}`));
    process.exit(1);
  }
  
  const explanation = explainer.explainCommand(commandName);
  console.log(typeof explanation === 'string' ? 
    explanation : 
    explainer.formatExplanation(explanation)
  );
}

module.exports = CommandExplainer;
```

### 3. Usage Examples

```bash
# Explain a specific command
/user:explain-command pair-programming

# Get info about debugging command  
/user:explain-command rubber-duck-debug

# Learn about pattern mining
/user:explain-command pattern-mining

# Check unknown command (shows suggestions)
/user:explain-command impossible
```

### 4. Output Format

```
## pair-programming

**Purpose:** Interactive real-time coding with AI feedback, simulating a collaborative programming session with immediate guidance and suggestions.

**Key Features:**
• Real-time feedback and micro-reviews
• Progressive enhancement suggestions
• Educational pairing sessions
• TDD collaboration support
• Code quality gates

**Use Cases:**
• Real-time collaborative coding sessions
• Code review with live feedback  
• Learning programming with AI guidance
• Debugging complex issues together

**Example Usage:**
`/user:pair-programming`

**Integrates With:** rubber-duck-debug, code-review, testing
```

### 5. Error Handling

```javascript
// Handle common error scenarios
class ExplainCommandErrorHandler {
  static handleMissingCommand(commandName, availableCommands) {
    const suggestions = this.findClosestMatches(commandName, availableCommands);
    
    return {
      error: `Command "${commandName}" not found`,
      suggestions,
      available: availableCommands,
      tip: 'Use exact command name or check available commands list'
    };
  }
  
  static handleFileReadError(commandName, error) {
    return {
      error: `Could not read command file for "${commandName}"`,
      reason: error.message,
      suggestion: 'Check if command file exists and is readable'
    };
  }
  
  static handleParseError(commandName, error) {
    return {
      error: `Could not parse command file for "${commandName}"`,
      reason: error.message,
      suggestion: 'Command file may be corrupted or in wrong format'
    };
  }
}
```

## Usage Patterns

### Quick Reference
```bash
# Get help on any command
explain-command <command-name>

# Common patterns
explain-command code-narrator     # Understand code narration
explain-command reality-checker   # Learn assumption validation  
explain-command impossibility-navigator  # Overcome "impossible" problems
```

### Integration with Other Commands
- Works with all commands in ~/.claude/ directory
- Provides context for command selection
- Helps understand command capabilities before use
- Suggests related commands for workflow building

## Anti-Patterns/Warnings
- Don't use for commands outside ~/.claude/ directory
- Avoid assuming command exists without checking
- Don't expect explanations for corrupted command files
- Be careful with command name spelling

## Validation Checklist
- [ ] Command file exists in ~/.claude/ directory
- [ ] File is readable and properly formatted
- [ ] Purpose and features extracted correctly
- [ ] Relevant use cases identified
- [ ] Examples are practical and clear
- [ ] Error handling provides helpful guidance