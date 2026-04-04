# Claude Code Power User Cheat Sheet

Extracted from Boris Cherny (creator), Thariq (Anthropic), and community best practices. Skip-the-basics edition.

---

## Power User Tips (Non-Obvious Stuff)

### Parallel Everything
- Run 3-5 git worktrees simultaneously: `claude -w` spins up an isolated worktree per session
- Name worktrees and set shell aliases (`2a`, `2b`, `2c`) for one-keystroke switching
- `/batch` fans out work to dozens/hundreds of worktree agents for massive migrations
- Boris runs **dozens of Claudes at all times** using worktrees

### Loop + Schedule = Autonomous Workflows
- `/loop 5m /babysit` -- auto-address code review, auto-rebase, shepherd PRs to production
- `/loop 30m /slack-feedback` -- auto-create PRs from Slack feedback
- `/loop 1h /pr-pruner` -- close stale PRs automatically
- Any skill can become a loop. If you do something more than once a day, make it a skill, then loop it

### Session Tricks
- `/branch` forks your current conversation -- you stay in the branch
- `claude --resume <id> --fork-session` resumes without mutating the original
- `/btw` asks a side question without polluting the agent's working context
- `/teleport` pulls a cloud session to your local terminal
- `/remote-control` lets you control a local session from phone/web
- Enable "Remote Control for all sessions" in `/config` for always-on access

### Hooks for Deterministic Control
- `SessionStart` hook to dynamically inject context every time Claude starts
- `PreToolUse` hook to log every bash command the model runs
- `PermissionRequest` hook to route approvals to WhatsApp/Slack
- `Stop` hook to poke Claude to keep going when it stops prematurely
- Skills can register **on-demand hooks** that only activate when the skill is called:
  - `/careful` -- blocks rm -rf, DROP TABLE, force-push via PreToolUse
  - `/freeze` -- blocks Edit/Write outside a specific directory

### Prompting That Works
- "Use subagents" appended to any request makes Claude throw more compute at it
- "Knowing everything you know now, scrap this and implement the elegant solution" after a mediocre fix
- "Grill me on these changes and don't make a PR until I pass your test" -- make Claude your reviewer
- "Prove to me this works" -- have Claude diff behavior between main and your branch
- After every correction: "Update your CLAUDE.md so you don't make that mistake again"

### Cross-Model Workflow
- Terminal 1: Claude Code (Opus) writes the plan
- Terminal 2: Codex CLI (GPT-5.4) reviews plan against actual codebase, inserts "Phase 2.5" corrections
- Terminal 1: Claude implements phase-by-phase
- Terminal 2: Codex verifies implementation against plan
- Different models catch different blind spots

---

## CLI Flags Worth Using

| Flag | What It Does |
|------|-------------|
| `--bare` | **10x faster startup** for SDK/print mode. Skips CLAUDE.md, settings, MCP discovery. Use with `-p` |
| `-w` / `--worktree` | Start in isolated git worktree for parallel work |
| `--add-dir <path>` | Give Claude access to another repo. Also grants permissions to work in it |
| `--agent <name>` | Run with a custom agent (restricted tools, custom prompt, specific model) |
| `--fork-session` | Resume a session without mutating the original (use with `--resume`) |
| `--model opus` | Force Opus for the session. Change mid-session with `/model` |
| `--mcp-config <path>` | Load MCP servers from a specific config. Combine with `--strict-mcp-config` to ignore all others |
| `--permission-mode bypassPermissions` | No permission prompts. For trusted automated workflows only |
| `--max-turns <N>` | Cap agentic turns in print mode. Prevents runaway sessions |
| `--max-budget-usd <N>` | Hard dollar cap for API users in print mode |
| `--append-system-prompt <text>` | Inject instructions without replacing the default system prompt |
| `--debug "api,hooks"` | Debug specific categories without drowning in noise |
| `--teleport` | Pull a cloud session into your local terminal |

---

## Settings Tweaks

### In `~/.claude/settings.json` (Global)
```json
{
  "model": "claude-opus-4-6-max-20250414",
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(npm *)",
      "mcp__*",
      "Read",
      "Glob",
      "Grep"
    ]
  },
  "env": {
    "CLAUDE_CODE_ENABLE_TASKS": "1",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    "ENABLE_TOOL_SEARCH": "auto:10"
  }
}
```

### Key Settings to Know
- `enableAllProjectMcpServers: true` -- stop confirming MCP servers every session
- `additionalDirectories` -- always load extra folders (multi-repo setups)
- `outputStyle` -- set to "Explanatory" or "Learning" when onboarding to new codebase
- `env.MAX_THINKING_TOKENS` -- increase for deeper reasoning on hard problems
- `env.ENABLE_TOOL_SEARCH` -- `auto:10` defers MCP tools when they exceed 10% of context (default). Tune up for tool-heavy setups
- `env.CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` -- set to "1" if background tasks eat your rate limit
- Priority order: Managed > CLI args > `.claude/settings.local.json` > `.claude/settings.json` > `~/.claude/settings.json`

### Hooks in Settings (Not Skills)
```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "cat ~/.context/daily-brief.md"
      }
    ],
    "Stop": [
      {
        "type": "command",
        "command": "echo 'Continue working. Check your todo list.'"
      }
    ]
  }
}
```

---

## Subagent Patterns

### The 6 Built-In Agent Types
| Agent | Model | Use |
|-------|-------|-----|
| `general-purpose` | inherit | Default. Complex multi-step tasks |
| `Explore` | haiku | Fast read-only codebase search. Cheap |
| `Plan` | inherit | Pre-planning research. Read-only |
| `Bash` | inherit | Terminal commands in separate context |
| `statusline-setup` | sonnet | Status line configuration |
| `claude-code-guide` | haiku | Answers Claude Code questions |

### Custom Agent Frontmatter That Matters
- `tools` -- restrict what the agent can touch. Use `Read, Glob, Grep` for read-only agents
- `model` -- route cheap work to `haiku`, hard stuff to `opus`
- `maxTurns` -- prevent runaway subagents
- `skills` -- preload skill content into agent context at startup (not just make available)
- `mcpServers` -- scope MCP servers to specific subagents
- `isolation: "worktree"` -- run in temp git worktree, auto-cleaned if no changes
- `background: true` -- always run as background task
- `permissionMode: "bypassPermissions"` -- for trusted automated agents
- `memory: "project"` -- persistent memory scoped to project

### Orchestration Pattern: Command > Agent > Skill
1. **Command** is the entry point. Handles user interaction, orchestrates flow
2. **Agent** fetches/processes data using preloaded skills (injected at startup)
3. **Skill** creates output independently, invoked via Skill tool
- Agent skills are injected as context. Regular skills are invoked dynamically
- Keep fetch and render as separate concerns

### RPI Workflow (Research > Plan > Implement)
1. `/rpi:research` -- GO/NO-GO analysis with multiple specialist agents
2. `/rpi:plan` -- PM, UX, and engineering specs with validation gates
3. `/rpi:implement` -- Phase-by-phase with test gates per phase
- Each step produces artifacts in `rpi/{feature-slug}/`
- Separate agents for each role: requirement-parser, product-manager, senior-software-engineer, code-reviewer

---

## Memory Best Practices

### CLAUDE.md Loading Rules
- **Ancestors always load at startup** -- Claude walks UP from CWD to root
- **Descendants load lazily** -- only when Claude reads files in those subdirectories
- **Siblings never load** -- working in `frontend/` won't load `backend/CLAUDE.md`
- **Global** -- `~/.claude/CLAUDE.md` applies to ALL sessions

### Structure for Monorepos
```
/repo/
  CLAUDE.md              # Shared conventions, commit format, PR templates
  frontend/CLAUDE.md     # React patterns, component architecture
  backend/CLAUDE.md      # API patterns, DB conventions
  .claude/CLAUDE.local.md  # Personal prefs, git-ignored
```

### Writing Effective CLAUDE.md
- After every correction: "Update your CLAUDE.md so you don't make that mistake again" -- Claude writes great rules for itself
- Keep a notes directory per task/project, updated after every PR. Point CLAUDE.md at it
- Ruthlessly prune. Dead rules waste context. Review monthly
- Put the highest-signal content first -- Claude pays more attention to the top

### Skill Memory
- Skills can store data in their folder (append-only logs, JSON, SQLite)
- Use `${CLAUDE_PLUGIN_DATA}` for stable storage that survives skill upgrades
- Store setup config in `config.json` inside the skill directory

---

## Rate Limit Management

### The Basics
- Limits reset on a **rolling 5-hour window**
- `/usage` shows current limit status
- `/fast` mode is **always billed to extra usage** from the first token, even with plan capacity remaining

### Staying Under Limits
- Route cheap work to `haiku` subagents (read-only exploration, simple lookups)
- Use `/compact` to compress conversation and free context when running long
- Use `--bare` flag for SDK/print mode to skip loading unnecessary context
- Disable background tasks if they eat your budget: `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1`
- Set `--max-turns` and `--max-budget-usd` for automated workflows to prevent runaways

### Extra Usage Setup
- Configure at **claude.ai > Settings > Usage** (web is more reliable than CLI)
- Set a monthly spending cap
- Add prepaid funds with auto-reload
- Daily redemption limit: $2,000/day
- `/extra-usage` CLI command exists but the web UI is the better path

### Token Efficiency (API/SDK Users)
- **Tool Search auto mode** defers MCP tool definitions when they exceed context threshold (~85% token reduction)
- **Programmatic Tool Calling** processes multiple tool calls in one inference pass (~37% token reduction)
- **Dynamic Filtering** for web search/fetch reduces input tokens ~24%
- **Tool Use Examples** in MCP server definitions improve accuracy from 72% to 90%

---

## Advanced Workflows

### Skill Design (From Anthropic's Internal Playbook)
9 skill categories that actually work:
1. **Library/API Reference** -- gotchas + code snippets for internal libs
2. **Product Verification** -- Playwright/tmux-based test flows
3. **Data Fetching** -- credential-aware queries to dashboards/DBs
4. **Business Process** -- standup posts, ticket creation, weekly recaps
5. **Code Scaffolding** -- framework boilerplate with natural language requirements
6. **Code Quality** -- adversarial review, style enforcement, run via hooks
7. **CI/CD** -- babysit PRs, deploy services, cherry-pick to prod
8. **Runbooks** -- symptom in, structured report out
9. **Infrastructure Ops** -- orphan cleanup, dependency management, cost investigation

### Skill Writing Tips
- **Description field is for the model** -- write it as trigger conditions, not a summary
- **Don't state the obvious** -- focus on pushing Claude out of its defaults
- **Build a Gotchas section** -- highest-signal content. Update it every time Claude fails
- **Use progressive disclosure** -- skill is a folder, not a file. Point to `references/`, `scripts/`, `examples/`
- **Don't railroad** -- give goals and constraints, not step-by-step instructions
- **Store scripts in the skill** -- let Claude compose rather than reconstruct boilerplate
- **On-demand hooks** -- register hooks that only activate when the skill is called
- **Measure usage** -- PreToolUse hook to log which skills get triggered

### Plan Mode Protocol
- Start EVERY complex task in plan mode. Pour energy into the plan for 1-shot implementation
- Have one Claude write the plan, spin up a second Claude to review it as a staff engineer
- The moment something goes sideways, switch BACK to plan mode and re-plan. Don't push through
- Use plan mode for verification steps too, not just builds

### Multi-Repo Work
- `claude --add-dir ../other-repo` or `/add-dir ../other-repo` mid-session
- Add `"additionalDirectories"` to team settings.json for always-on multi-repo access
- Each added directory also grants Claude permissions to work in it

### MCP Server Strategy
- **Don't go overboard** -- most power users settle on 4-5 daily drivers
- Recommended stack: Context7 (docs) + Playwright (UI testing) + Chrome extension (debugging) + DeepWiki (repo understanding)
- Use `enableAllProjectMcpServers: true` to skip approval prompts
- Scope MCP servers to subagents via `mcpServers` in agent frontmatter
- Precedence: Subagent > Project (.mcp.json) > User (~/.claude.json)

### Voice-Driven Development
- `/voice` in CLI, hold spacebar to speak
- Boris does most of his coding by speaking -- you speak 3x faster than you type
- Prompts get way more detailed when dictated vs typed
- macOS: fn x2 for system dictation as alternative
