#!/usr/bin/env bash
# One-command installer for the figjam-board skill + its FigJam connection.
# Installs: the skill, the figma-console MCP server, and stages the Desktop Bridge plugin.
# Figma requires ONE manual step at the end (it blocks scripted plugin installs).
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
say(){ printf '%s\n' "$*"; }

say "→ figjam-board installer"
say ""

# 1) Skill ------------------------------------------------------------------
mkdir -p "$HOME/.claude/skills"
cp -r "$DIR/figjam-board" "$HOME/.claude/skills/"
say "✓ Skill installed → ~/.claude/skills/figjam-board"

# 2) figma-console MCP server (gives Claude the FigJam tools) ----------------
if command -v claude >/dev/null 2>&1; then
  if claude mcp get figma-console >/dev/null 2>&1; then
    say "• figma-console MCP already registered"
  else
    claude mcp add figma-console --scope user -- npx -y figma-console-mcp@latest \
      && say "✓ figma-console MCP registered (user scope)" \
      || say "⚠ Could not auto-register MCP. Run manually: claude mcp add figma-console --scope user -- npx -y figma-console-mcp@latest"
  fi
else
  say "⚠ 'claude' CLI not found — install Claude Code, then run:"
  say "    claude mcp add figma-console --scope user -- npx -y figma-console-mcp@latest"
fi

# 3) Desktop Bridge plugin --------------------------------------------------
BRIDGE_DST="$HOME/.figma-console-mcp/plugin"
mkdir -p "$BRIDGE_DST"
cp "$DIR/desktop-bridge/manifest.json" "$BRIDGE_DST/"
cp "$DIR/desktop-bridge/code.js"       "$BRIDGE_DST/"
cp "$DIR/desktop-bridge/ui.html"       "$BRIDGE_DST/"
cp "$DIR/desktop-bridge/.version"      "$BRIDGE_DST/" 2>/dev/null || true
MANIFEST="$BRIDGE_DST/manifest.json"
say "✓ Desktop Bridge staged → $MANIFEST"

# 4) The one manual step (Figma can't be scripted) --------------------------
say ""
say "──────────────────────────────────────────────────────────────"
say "ONE manual step left (Figma blocks scripted plugin installs):"
say ""
say "  1. Open Figma Desktop"
say "  2. Plugins → Development → Import plugin from manifest…"
say "     Select:  $MANIFEST"
say "  3. Open any FigJam file →"
say "     Plugins → Development → Figma Desktop Bridge → Run"
say "──────────────────────────────────────────────────────────────"
say ""
say "Done. Next Claude Code session: ask to \"build a FigJam board\" or run /figjam-board."
