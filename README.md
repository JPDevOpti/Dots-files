# Dots-files

Documentación y archivos de configuración del entorno de escritorio de
`jpdevopti`: Omarchy (Arch Linux + Hyprland) en un portátil con NVIDIA RTX
4050 + iGPU AMD, LUKS + Btrfs y Limine. Si este equipo se formatea, este
repositorio permite reconstruirlo: qué software estaba instalado, cómo
estaba configurado, y qué personalizaciones se hicieron sobre Omarchy por
defecto.

Este repositorio **no contiene scripts propios**. Es documentación más los
archivos de configuración reales, organizados por módulo; cada paso de
instalación o restauración se hace a mano, siguiendo la guía escrita
(`docs/`) y el README de cada módulo, con comandos `cp`/`sudo cp` estándar.

## Política: nada queda fijado en versión

Este repositorio nunca fija una versión concreta de paquete, herramienta o
dependencia propia (pacman, AUR, mise, npm global): todo se instala siempre
en su versión más reciente disponible en el momento de restaurar
(`omarchy pkg add`, `mise use -g <tool>@latest`, `npm install -g <pkg>@latest`).
La contrapartida es que una restauración puede traer versiones más nuevas
que las que estaban probadas la última vez que se hizo el backup — por eso
el checklist de verificación final en `docs/02-instalacion-desde-cero.md`
importa: no basta con "se instaló", hay que comprobar que funciona.

## Módulos

Cada componente vive en su propio directorio, con las rutas relativas a
`$HOME` dentro (por ejemplo `alacritty/.config/alacritty/alacritty.toml`
restaura a `~/.config/alacritty/alacritty.toml`). El README de cada módulo
trae su propia sección "Instalación manual" con los comandos `cp` exactos.

| Módulo | Qué es |
|---|---|
| [`hyprland/`](hyprland/README.md) | Compositor Hyprland: config Lua, idle, lock, sunset, scripts |
| [`monitors/`](monitors/README.md) | Perfiles de hyprmoncfg y configuración de nwg-displays |
| [`alacritty/`](alacritty/README.md) | Terminal Alacritty |
| [`terminal/`](terminal/README.md) | Foot y tmux |
| [`shell/`](shell/README.md) | Bash y starship |
| [`bar/`](bar/README.md) | Barra de Omarchy shell: layout, hooks, plugins locales |
| [`wallpapers/`](wallpapers/README.md) | Fondos de pantalla de Omarchy |
| [`theme/`](theme/README.md) | Temas añadidos, branding, pantalla de bloqueo, GTK, fuentes, dconf |
| [`editors/`](editors/README.md) | Neovim, Zed, VS Code |
| [`ai/`](ai/README.md) | Claude Code, OpenCode, Gentle AI |
| [`apps/`](apps/README.md) | Lanzadores, scripts personales, utilidades varias |
| [`devtools/`](devtools/README.md) | Git y mise |
| [`input/`](input/README.md) | Solaar (MX Master), fcitx5, voxtype |
| [`audio/`](audio/README.md) | WirePlumber |
| [`services/`](services/README.md) | Unidades systemd de usuario y environment.d |

Además: [`system/`](system/README.md) (copias de archivos de `/etc`, de
solo lectura y aplicación manual con `sudo cp`),
[`packages/`](packages/README.md) y `manifests/` (listas planas generadas
del sistema, para reinstalar a mano) y `docs/` (guías paso a paso).

## Mantener el repo al día

No hay script de backup: actualizar el repo es copiar a mano, desde el
sistema vivo hacia el repo, cada archivo que cambió.

```bash
# Por cada módulo que cambió, copiar del sistema al repo (ejemplo con alacritty)
cp ~/.config/alacritty/alacritty.toml ~/Repositories/Dots-files/alacritty/.config/alacritty/alacritty.toml

# Revisar qué cambió y publicar
cd ~/Repositories/Dots-files
git status
git diff
git add -A && git commit -m "..." && git push
```

El procedimiento completo, módulo por módulo, y el chequeo de secretos
antes de commitear están en
[`docs/01-antes-de-formatear.md`](docs/01-antes-de-formatear.md).

## Guía completa

1. [Antes de formatear](docs/01-antes-de-formatear.md)
2. [Instalación desde cero](docs/02-instalacion-desde-cero.md)
3. [Personalizaciones](docs/03-personalizaciones.md) — índice hacia cada README de módulo
4. [Problemas conocidos](docs/04-problemas-conocidos.md)
