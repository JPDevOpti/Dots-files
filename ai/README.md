# Herramientas de IA

Configuración escrita a mano de Claude Code, OpenCode y Gentle AI. No
incluye estado de sesión, credenciales, historial ni cachés.

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Instrucciones globales del usuario |
| `.claude/settings.json` | `~/.claude/settings.json` | Configuración de Claude Code |
| `.claude/agents/`, `commands/`, `output-styles/`, `skills/`, `themes/` | mismas rutas bajo `~/.claude/` | Agentes, comandos, estilos y skills personalizados |
| `.config/opencode/AGENTS.md`, `opencode.json`, `opencode.jsonc`, `tui.json`, `package.json`, `.gentle-ai-default-agent.json` | mismas rutas bajo `~/.config/opencode/` | Configuración de OpenCode |
| `.config/opencode/plugins/`, `skills/`, `themes/`, `commands/`, `tui-plugins/` | mismas rutas | Extensiones de OpenCode |
| `.config/gentle-ai/custom-agents.json` | `~/.config/gentle-ai/custom-agents.json` | Agentes personalizados de Gentle AI |

## Personalizaciones

- Solo se rastrea configuración escrita a mano: se excluyen deliberadamente
  `~/.claude/.credentials.json`, `~/.claude/projects/`,
  `~/.claude/history.jsonl` y cualquier directorio de runtime de Claude.
- Dos symlinks que existían en `~/.claude/skills/` (`diagnose-crash`,
  `omarchy`) apuntan a `/usr/share/omarchy/default/agents/skills/` —
  gestionados por el paquete de Omarchy, no se copian.
- `.config/opencode/package.json` declara sus dependencias con rangos
  semver (`^1.18.29`, `^1.7.0`, `^1.3.0`), no versiones exactas; no se
  rastrea ningún lockfile (`package-lock.json`, `bun.lock`, etc.).

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`. Los symlinks
`~/.claude/skills/omarchy` y `~/.claude/skills/diagnose-crash` (hacia
`/usr/share/omarchy/default/agents/skills/`) los gestiona el paquete de
Omarchy; no copiar nada encima de ellos, confirmar con
`readlink ~/.claude/skills/omarchy`.

```bash
cp -r ~/.claude ~/.claude.orig 2>/dev/null
mkdir -p ~/.claude
cp -r ~/Repositories/Dots-files/ai/.claude/. ~/.claude/

cp -r ~/.config/opencode ~/.config/opencode.orig 2>/dev/null
mkdir -p ~/.config/opencode
cp -r ~/Repositories/Dots-files/ai/.config/opencode/. ~/.config/opencode/

mkdir -p ~/.config/gentle-ai
cp ~/.config/gentle-ai/custom-agents.json ~/.config/gentle-ai/custom-agents.json.orig 2>/dev/null
cp ~/Repositories/Dots-files/ai/.config/gentle-ai/custom-agents.json ~/.config/gentle-ai/custom-agents.json
```

## Cómo verificar

```bash
claude --version
opencode --version
```
Iniciar sesión en cada CLI (ver `docs/02-instalacion-desde-cero.md`, Fase 10).

## Dependencias

- `mise` para instalar `claude`, `codex`, `opencode`, `pi` (ver
  `packages/mise.txt`).
- Autenticación propia de cada CLI (no incluida en este repo).

## Notas

Las skills de terceros bajo `.claude/skills/` pueden contener ejemplos de
`export API_KEY="your-key"` en su documentación — son placeholders, no
credenciales.
