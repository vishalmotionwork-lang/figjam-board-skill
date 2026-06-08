# figjam-board — a Claude Code skill

Build or **fix** rich FigJam boards reliably (roadmaps, kanban, living source-of-truth boards, competitive maps) through the [`figma-console`](https://github.com/figma-console-mcp) MCP server.

FigJam is fragile to script by hand — appending a node to a section silently shifts its coordinates, `absoluteBoundingBox` is stale right after a reparent, and you can't even create a page. This skill ships a **coordinate-safe place-and-verify engine** that neutralizes all of that, plus a `verify()` pass that catches overlaps, text overflow, and out-of-zone spills *before* you screenshot.

## What's inside

| File | Purpose |
|---|---|
| `figjam-board/SKILL.md` | The workflow: connect → safe-place → build → **verify** → screenshot → iterate, plus a FIX flow for repairing existing boards, the gotchas, and board conventions. |
| `figjam-board/figjam-kit.js` | The pasteable engine: design tokens + `zone()` / `card()` / `text()` / `kanban()` / `row()` + `verify()` + `finish()` (wraps everything in one movable section, sized from records — never from the stale bounding box). |

## Install

**Requires:** [Claude Code](https://claude.com/claude-code) + the `figma-console` MCP server connected (with the Figma Desktop Bridge plugin running in a FigJam file).

```bash
git clone https://github.com/vishalmotionwork-lang/figjam-board-skill.git
cp -r figjam-board-skill/figjam-board ~/.claude/skills/
```

That's it. Next session, Claude Code auto-discovers it. Trigger it by asking to "build a FigJam board" / "fix this board", or invoke `/figjam-board` directly.

### Optional: auto-trigger hook
To make Claude *always* reach for this engine instead of hand-rolling board JS, add a `PreToolUse` hook in `~/.claude/settings.json` matching `mcp__figma-console__figma_execute|mcp__figma-console__figjam_create_.*` that prints a reminder to use `/figjam-board`. (See SKILL.md.)

## The three FigJam traps it neutralizes

1. **`section.appendChild` adds the section's origin to children** → build free on the page, let `finish()` reparent + convert (`n.x -= W.x`).
2. **`absoluteBoundingBox` is stale ~1 tick after a reparent** → size wrappers from recorded coords, never mid-call from the bounding box.
3. **`figma.createPage()` throws in FigJam** → build on `currentPage` in empty space + one wrapper section (right-click → Move to page).

## License

MIT — use it, fork it, share it.
