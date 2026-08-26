{ pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
  ];
  # programs.claude-code = {
  #   enable = true;
  #
  #   settings = {
  #     model = "claude-sonnet-5";
  #     effortLevel = "medium";
  #
  #     # Keep: reduces the cost of long-running sessions.
  #     autoCompactEnabled = true;
  #
  #     # Disable if you do not value Claude learning across sessions.
  #     autoMemoryEnabled = false;
  #
  #     # Removes built-in commit/PR instructions and the automatic git-status
  #     # snapshot from the system prompt.
  #     includeGitInstructions = false;
  #
  #     includeCoAuthoredBy = false;
  #
  #     # Remove optional tools and integrations.
  #     disableArtifact = true;
  #     disableClaudeAiConnectors = true;
  #
  #     # Preserve normal skills such as /debug and /code-review, but remove
  #     # dynamic workflows and bundled workflow commands.
  #     disableWorkflows = true;
  #
  #     # Prevent accidentally leaving expensive fast mode enabled.
  #     fastModePerSessionOptIn = true;
  #
  #     env = {
  #       # Prevent accidental advisor calls to another model.
  #       CLAUDE_CODE_DISABLE_ADVISOR_TOOL = "1";
  #     };
  #   };
  #
  #   agents = {
  #     scout =
  #       # markdown
  #       ''
  #         ---
  #         name: scout
  #         description: Use proactively to locate code, trace data flow, identify relevant files, and explore unfamiliar parts of a repository before implementation.
  #         tools: Read, Glob, Grep
  #         model: claude-haiku-4-5
  #         effort: low
  #         maxTurns: 10
  #         ---
  #
  #         Explore only what is necessary for the requested task.
  #
  #         Return:
  #
  #         - relevant files and symbols
  #         - a concise call or data-flow explanation
  #         - likely edit points
  #         - uncertainties that require verification
  #
  #         Prefer targeted searches and narrow file reads.
  #
  #         Do not read generated files, dependency trees, lock files, build output,
  #         snapshots, or vendored code unless they are directly relevant.
  #
  #         Do not propose broad refactors or implementation details unless requested.
  #       '';
  #     test-runner =
  #       # markdown
  #       ''
  #         ---
  #         name: test-runner
  #         description: Use proactively for running focused tests, investigating failures, and processing verbose compiler, linter, or test output without polluting the main context.
  #         tools: Bash, Read, Grep
  #         model: claude-haiku-4-5
  #         effort: low
  #         maxTurns: 8
  #         ---
  #
  #         Run the narrowest relevant test, compiler, or lint command.
  #
  #         Stop after identifying the likely root cause. Do not edit files.
  #
  #         Return only:
  #
  #         - the exact command executed
  #         - whether it passed or failed
  #         - the likely root cause
  #         - relevant files and line numbers
  #         - at most 40 lines of essential output
  #         - the next recommended action
  #
  #         Do not return full logs.
  #       '';
  #     reviewer =
  #       # markdown
  #       ''
  #         ---
  #         name: reviewer
  #         description: Review completed changes for correctness, regressions, security problems, missing tests, and inconsistencies. Use after substantial implementation work.
  #         tools: Bash, Read, Glob, Grep
  #         model: claude-sonnet-5
  #         effort: medium
  #         maxTurns: 8
  #         ---
  #
  #         Review only the changed code and directly related definitions.
  #
  #         Begin with:
  #
  #         - git diff --stat
  #         - git diff --unified=40
  #
  #         Prioritize:
  #
  #         1. correctness and regressions
  #         2. security and data handling
  #         3. concurrency and error handling
  #         4. missing or inadequate tests
  #         5. unnecessary complexity
  #
  #         Return concise, actionable findings ordered by severity. Include file and line
  #         references. Do not summarize unchanged code and do not edit files.
  #       '';
  #   };
  #
  #   context =
  #     # markdown
  #     ''
  #       # Token-efficient working style
  #
  #       - Start with targeted search. Do not scan the whole repository unless required.
  #       - Read only relevant sections of files.
  #       - Avoid generated, vendored, build, coverage, snapshot, and lock files.
  #       - Use the `scout` subagent for broad exploration.
  #       - Use the `test-runner` subagent for verbose tests, logs, linting, and builds.
  #       - Keep responses concise and do not restate the prompt or unchanged code.
  #       - Before large changes, identify the exact files and provide a short plan.
  #       - Prefer existing project patterns over introducing new abstractions.
  #
  #       # Compact instructions
  #
  #       Preserve:
  #
  #       - the current objective
  #       - decisions and constraints
  #       - changed files and important code locations
  #       - exact commands and meaningful test results
  #       - unresolved errors and remaining work
  #
  #       Discard verbose logs, completed exploration, superseded plans, and repeated
  #       explanations.
  #     '';
  # };
}
