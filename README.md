# figjam-board — a Claude Code skill

Build or **fix** rich FigJam boards reliably (roadmaps, kanban, living source-of-truth boards, competitive maps) through the `figma-console` MCP server.

FigJam is fragile to script by hand — appending a node to a section silently shifts its coordinates, `absoluteBoundingBox` is stale right after a reparent, and you can't even create a page. This skill ships a **coordinate-safe place-and-verify engine** that neutralizes all of that, plus a `verify()` pass that catches overlaps, text overflow, and out-of-zone spills *before* you screenshot.

## Install — one command

```bash
git clone https://github.com/vishalmotionwork-lang/figjam-board-skill.git
cd figjam-board-skill && ./install.sh
```

That installs **everything scriptable**:
- ✅ the skill → `~/.claude/skills/figjam-board`
- ✅ the `figma-console` MCP server (registered with Claude Code)
- ✅ the **Figma Desktop Bridge** plugin (staged, ready to import)

**One manual step remains** — Figma blocks scripted plugin installs, so no tool can skip this (~20 seconds, one time):

1. Figma Desktop → **Plugins → Development → Import plugin from manifest…**
2. Select the path the installer prints (`~/.figma-console-mcp/plugin/manifest.json`)
3. In any FigJam file → **Plugins → Development → Figma Desktop Bridge → Run**

Then, in your next Claude Code session: ask to **"build a FigJam board"** / **"fix this board"**, or run `/figjam-board`.

> **Requires:** [Claude Code](https://claude.com/claude-code), Node/npm (for `npx`), and Figma Desktop.

## What's in the repo

| Path | Purpose |
|---|---|
| `figjam-board/SKILL.md` | The workflow: connect → safe-place → build → **verify** → screenshot → iterate, plus a FIX flow, gotchas, and board conventions. |
| `figjam-board/figjam-kit.js` | The pasteable engine: tokens + `zone()` / `card()` / `text()` / `kanban()` / `row()` + `verify()` + `finish()`. |
| `desktop-bridge/` | The Figma Desktop Bridge plugin (the Figma-side half of `figma-console`), bundled so install is one step. See `desktop-bridge/SOURCE.md` for attribution. |
| `install.sh` | One-command installer for all of the above. |

## The three FigJam traps it neutralizes

1. **`section.appendChild` adds the section's origin to children** → build free on the page, let `finish()` reparent + convert (`n.x -= W.x`).
2. **`absoluteBoundingBox` is stale ~1 tick after a reparent** → size wrappers from recorded coords, never mid-call from the bounding box.
3. **`figma.createPage()` throws in FigJam** → build on `currentPage` in empty space + one wrapper section (right-click → Move to page).

## Optional: auto-trigger hook

To make Claude *always* reach for this engine instead of hand-rolling board JS, add a `PreToolUse` hook in `~/.claude/settings.json` matching `mcp__figma-console__figma_execute|mcp__figma-console__figjam_create_.*` that prints a reminder to use `/figjam-board`. (Details in `figjam-board/SKILL.md`.)

## Manual install (no script)

```bash
cp -r figjam-board ~/.claude/skills/
claude mcp add figma-console --scope user -- npx -y figma-console-mcp@latest
# then import desktop-bridge/manifest.json in Figma (step above)
```

## License

Skill + installer: MIT. The `desktop-bridge/` plugin belongs to the `figma-console-mcp` project — see `desktop-bridge/SOURCE.md`.
