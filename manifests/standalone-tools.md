# Herramientas instaladas fuera de un gestor de paquetes

Cada fila describe cómo se determinó el método de instalación (evidencia
real inspeccionada en este equipo) y cómo reinstalar la herramienta siempre
en su última versión disponible. No se fija ninguna versión.

| Herramienta | Evidencia observada | Cómo reinstalar |
|---|---|---|
| `engram` | Binario ELF estático en `~/.local/bin/engram`, sin metadatos de paquete (`pacman -Qo` no lo reconoce). | Método de instalación no determinado. |
| `gentle-ai` | Binario ELF estático en `~/.local/bin/gentle-ai`, sin metadatos de paquete. | Método de instalación no determinado. |
| `codegraph` | Presente como paquete npm global `@colbymchenry/codegraph`, resuelto por mise/node en `~/.local/share/mise/installs/node/*/bin/codegraph`. | `npm install -g @colbymchenry/codegraph@latest` (tras instalar node con mise). |
| `zed` | `~/.local/bin/zed` y `~/.local/zed.app/` (paquete de la app, no gestionado por pacman). | Instalador oficial de Zed: `curl -f https://zed.dev/install.sh \| sh` (siempre entrega la última versión). |
| `aws` (AWS CLI v2) | `pacman -Qo /usr/bin/aws` reporta el paquete `aws-cli`; **no** vive en `~/.local/aws-cli` como se asumió inicialmente — está instalado por pacman. | Ya cubierto por `packages/pacman.txt` (`omarchy pkg add aws-cli`). |
| `pandoc` | Binario ELF estático en `~/.local/bin/pandoc`, sin metadatos de paquete. | Método de instalación no determinado; si hace falta, el binario oficial se descarga desde las releases de `jgm/pandoc` en GitHub. |
| `prismlauncher` | Binario ELF estático en `~/.local/bin/prismlauncher`, sin metadatos de paquete (aunque también existe `org.prismlauncher.PrismLauncher.desktop`). | Método de instalación no determinado; alternativa disponible como paquete AUR `prismlauncher`. |
| `openclaw` | Directorio `~/.openclaw/` con `bin/`, `agents/`, permisos `0700` (datos propios de la app). | Método de instalación no determinado a partir de la evidencia disponible. |
| `dofustabs` | Repositorio clonado en `~/Projects/DOFUS/dofustabs` (remoto `https://github.com/JPDevOpti/DofusTabs.git`), binario expuesto en `~/.local/bin/dofustabs`. | Clonar el repo (ver `manifests/repos.txt`) y seguir su propio proceso de build/enlace. |
| Dofus (AppImage) | `~/Applications/Dofus.AppImage`. | Descargar el AppImage actual desde el lanzador oficial de Ankama y colocarlo en `~/Applications/`. |

## CLI shims resueltos vía mise

Estos binarios en `~/.local/bin/` son *shims* de una línea que delegan en
`mise use -g --quiet "<backend>"`; mise resuelve e instala la última versión
la primera vez que se ejecutan. No requieren instalación manual: basta con
tener `mise` activo (ver `~/.config/mise/config.toml`) y ejecutar el comando
una vez, o instalarlos por adelantado con `mise use -g <backend>`.

| Comando | Backend mise |
|---|---|
| `codex` | `codex` |
| `copilot` | `copilot` |
| `crush` | `crush` |
| `cursor-agent` | `cursor-agent` |
| `gemini` | `gemini` |
| `grok` | `npm:@xai-official/grok` |
| `hunk` | `aqua:modem-dev/hunk` |
| `omp` | `github:can1357/oh-my-pi` |
| `pi` | `pi` |
| `playwright` | `npm:playwright` |
| `playwright-cli` | `npm:playwright` (subcomando `playwright-cli`) |
| `ghui` | `npm:@kitlangton/ghui` |

Este repositorio no copia esos shims (no son configuración personal, son
generados por mise). Para recrearlos manualmente: `mise use -g <backend>`
por cada fila de la tabla; no forman parte de `packages/mise.txt`.
