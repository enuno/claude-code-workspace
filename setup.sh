#!/bin/bash
# ============================================
# Claude Code Workspace Setup Script
# For: Brandon Packard
# Created: 2026-03-07
# ============================================

set -e

WORKSPACE="$HOME/claude-code-workspace"

echo "🔧 Setting up Claude Code workspace at $WORKSPACE"

# 1. Create the workspace folder
mkdir -p "$WORKSPACE"
cd "$WORKSPACE"

# 2. Initialize git
if [ ! -d ".git" ]; then
  git init
  echo "✅ Git initialized"
else
  echo "⏭️  Git already initialized"
fi

# 3. Create directory structure
mkdir -p .claude
mkdir -p projects
mkdir -p scratch
mkdir -p outputs
mkdir -p scripts

echo "✅ Directory structure created"

# 4. Create .claude/settings.json
cat > .claude/settings.json << 'SETTINGS'
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(node:*)",
      "Bash(python*:*)",
      "Bash(pip:*)",
      "Bash(git:*)",
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Bash(mkdir:*)",
      "Bash(cp:*)",
      "Bash(mv:*)",
      "Bash(find:*)",
      "Bash(grep:*)",
      "Bash(echo:*)",
      "Bash(touch:*)",
      "Bash(chmod:*)"
    ],
    "deny": []
  }
}
SETTINGS
echo "✅ Claude Code settings created"

# 5. Create CLAUDE.md (project instructions Claude Code reads automatically)
cat > CLAUDE.md << 'CLAUDEMD'
# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.
CLAUDEMD
echo "✅ CLAUDE.md created"

# 6. Create .gitignore
cat > .gitignore << 'GITIGNORE'
# Dependencies
node_modules/
__pycache__/
*.pyc
.venv/
venv/

# Environment
.env
.env.local
.env.*.local

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Build artifacts
dist/
build/
*.egg-info/

# Logs
*.log
npm-debug.log*

# Scratch outputs (keep the folder, ignore contents)
scratch/*
!scratch/.gitkeep

# Outputs (keep the folder, ignore contents)
outputs/*
!outputs/.gitkeep
GITIGNORE
echo "✅ .gitignore created"

# 7. Create .gitkeep files to preserve empty dirs
touch scratch/.gitkeep
touch outputs/.gitkeep
touch projects/.gitkeep
touch scripts/.gitkeep

# 8. Initial commit
git add -A
git commit -m "Initialize claude-code-workspace

Structured workspace for Claude Code with:
- Project scaffolding (projects/, scratch/, outputs/, scripts/)
- CLAUDE.md with working principles and preferences
- .claude/settings.json with sensible permissions
- .gitignore for clean repos"

echo ""
echo "============================================"
echo "✅ Workspace ready at: $WORKSPACE"
echo ""
echo "To start using it:"
echo "  cd ~/claude-code-workspace"
echo "  claude"
echo ""
echo "To start a new project:"
echo "  cd ~/claude-code-workspace/projects"
echo "  mkdir my-project && cd my-project"
echo "  claude"
echo "============================================"
