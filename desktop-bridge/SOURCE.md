# Desktop Bridge — attribution

The files in this folder (`manifest.json`, `code.js`, `ui.html`) are the **Figma Desktop Bridge** plugin from the [`figma-console-mcp`](https://www.npmjs.com/package/figma-console-mcp) project (Southleft). They are bundled here **for convenience** so this skill installs in one step.

- The Bridge is the Figma-side half of the `figma-console` MCP server. The MCP server talks to it over a local WebSocket (ports 9223–9232).
- These files are auto-generated at `~/.figma-console-mcp/plugin/` whenever you run `figma-console-mcp`. If you prefer, install that package directly and import the bridge it generates instead of the copy here — that guarantees the newest version.
- All rights and license to the Bridge belong to the `figma-console-mcp` authors. Bundled unmodified.

This skill (`figjam-board/`) is independent of the Bridge — it just needs *a* working `figma-console` connection.
