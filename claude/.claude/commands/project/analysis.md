<task>
    <objective>
      Create an extremely detailed, comprehensive documentation of this entire project. This documentation will be used to optimize Claude Code configuration, so include every relevant technical detail.
    </objective>

    <output_requirements>
      <format>Single comprehensive Markdown document</format>
      <detail_level>EXTREMELY detailed with specific examples from the actual codebase</detail_level>
      <requirements>
        <requirement>Clear section headers</requirement>
        <requirement>Code examples where relevant</requirement>
        <requirement>Actual file paths from this project</requirement>
        <requirement>Specific version numbers and tool names</requirement>
        <requirement>Real examples from the codebase (not generic placeholders)</requirement>
      </requirements>
    </output_requirements>

    <sections>
      <section id="1">
        <title>Project Overview</title>
        <items>
          <item>What this project does (business purpose)</item>
          <item>Target users/audience</item>
          <item>Key features and capabilities</item>
          <item>Current development stage</item>
        </items>
      </section>

      <section id="2">
        <title>Technical Architecture</title>
        <items>
          <item>Complete tech stack (languages, frameworks, libraries with exact versions)</item>
          <item>Architecture pattern (monorepo, microservices, monolith, etc.)</item>
          <item>Complete directory structure with purpose of each major directory</item>
          <item>Package/module organization and relationships</item>
          <item>Dependency graph between components/packages</item>
        </items>
      </section>

      <section id="3">
        <title>Codebase Patterns & Conventions</title>
        <subsections>
          <subsection>
            <title>TypeScript/JavaScript</title>
            <items>
              <item>tsconfig settings and strictness level</item>
              <item>Type definition patterns</item>
              <item>Module system (ESM, CommonJS)</item>
              <item>Import/export patterns</item>
              <item>Naming conventions (files, variables, functions, types)</item>
            </items>
          </subsection>

          <subsection>
            <title>File Organization</title>
            <items>
              <item>Where different types of code live (components, services, utils, types)</item>
              <item>Co-location vs separation patterns</item>
              <item>Test file locations and naming</item>
            </items>
          </subsection>

          <subsection>
            <title>Code Style</title>
            <items>
              <item>ESLint/Prettier configuration details</item>
              <item>Key linting rules that are enforced</item>
              <item>Formatting preferences</item>
              <item>Import ordering rules</item>
            </items>
          </subsection>
        </subsections>
      </section>

      <section id="4">
        <title>Testing Strategy</title>
        <items>
          <item>Test frameworks used (exact names and versions)</item>
          <item>Test structure and organization</item>
          <item>Coverage requirements</item>
          <item>Mocking strategies</item>
          <item>Integration vs unit test patterns</item>
          <item>E2E testing approach</item>
        </items>
      </section>

      <section id="5">
        <title>Build & Development</title>
        <items>
          <item>Package manager (npm/yarn/pnpm with version)</item>
          <item>Build tools (Webpack, Vite, Turborepo, etc.)</item>
          <item>Development workflow (how to start, build, test)</item>
          <item>Available npm scripts and what each one does</item>
          <item>Environment setup requirements</item>
          <item>Hot reload/watch mode setup</item>
        </items>
      </section>

      <section id="6">
        <title>Dependencies & Integrations</title>
        <items>
          <item>Critical dependencies and why they're used</item>
          <item>Internal package dependencies (if monorepo)</item>
          <item>External APIs and services integrated</item>
          <item>Authentication/authorization approach</item>
          <item>Database(s) used and ORM/query approach</item>
        </items>
      </section>

      <section id="7">
        <title>Common Workflows</title>
        <items>
          <item>How to add a new feature (step by step)</item>
          <item>How to fix a bug (process)</item>
          <item>How to run tests (commands and options)</item>
          <item>How to create a build (commands and outputs)</item>
          <item>Git workflow (branching strategy, commit conventions, PR process)</item>
          <item>Deployment process</item>
        </items>
      </section>

      <section id="8">
        <title>Error Handling</title>
        <items>
          <item>Error handling patterns used in the codebase</item>
          <item>Logging approach and tools</item>
          <item>Monitoring/observability setup</item>
        </items>
      </section>

      <section id="9">
        <title>Project-Specific Quirks</title>
        <items>
          <item>Non-obvious architectural decisions and their rationale</item>
          <item>Known issues or workarounds currently in place</item>
          <item>Performance considerations</item>
          <item>Security requirements</item>
          <item>Areas that need special attention when modifying</item>
        </items>
      </section>

      <section id="10">
        <title>File Inventory</title>
        <items>
          <item>List all configuration files and their specific purpose</item>
          <item>Key source directories and what they contain</item>
          <item>Generated/build directories to ignore</item>
          <item>Files containing or potentially containing sensitive data</item>
        </items>
      </section>
    </sections>

    <examples>
      <good_example>
        "We use TypeScript 5.2 in strict mode with noUncheckedIndexedAccess enabled, exactOptionalPropertyTypes disabled, and paths configured for @/ alias pointing to src/"
      </good_example>
      <bad_example>
        "We use TypeScript"
      </bad_example>

      <good_example>
        "Tests are co-located using .test.ts extension and use Vitest 1.0.4 with React Testing Library 14.0.0. Mocks are created using vi.mock() and placed in __mocks__ directories adjacent to source files"
      </good_example>
      <bad_example>
        "We write tests"
      </bad_example>
    </examples>

    <instructions>
      <instruction>Analyze the ENTIRE codebase to extract this information</instruction>
      <instruction>Be specific with actual file paths, version numbers, and configuration values</instruction>
      <instruction>Include real code examples from the project</instruction>
      <instruction>Don't use generic placeholders - use actual names from the project</instruction>
      <instruction>If something doesn't exist or isn't applicable, explicitly state that</instruction>
    </instructions>
  </task>
