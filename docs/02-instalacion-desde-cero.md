# Instalación desde cero

Procedimiento ordenado para reconstruir este equipo después de instalar
Omarchy. Instala siempre la versión actual de Omarchy y del sistema —
ninguna versión queda fijada en este repositorio (ver política en
`README.md`).

Este repositorio no tiene scripts propios: cada fase de abajo se ejecuta a
mano, copiando o instalando lo que realmente se quiere en el equipo nuevo —
no hay que ejecutar nada "a ciegas", cada comando es explícito.

## Fase 0 — Primer arranque y actualización

```bash
omarchy update
omarchy debug --no-sudo --print   # revisar que no hay errores de hardware/driver
```

**Verificación:** `omarchy version` responde sin error; `omarchy debug` no
muestra fallos de arranque.

## Fase 1 — SSH y autenticación GitHub

```bash
# Restaurar ~/.ssh desde el respaldo externo (ver docs/01-antes-de-formatear.md)
chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_*
gh auth login
```

**Verificación:** `gh auth status` muestra sesión activa; `ssh -T git@github.com`
responde con el usuario correcto.

**Requisito para el primer commit**: `devtools/.config/git/config` firma
los commits con SSH (`commit.gpgsign = true`, `gpg.format = ssh`,
`user.signingkey = ~/.ssh/id_ed25519.pub`). Sin `~/.ssh/id_ed25519`
restaurado en este paso, cualquier commit posterior fallará al intentar
firmarse. Ver `devtools/README.md`.

## Fase 2 — Clonar este repositorio

```bash
mkdir -p ~/Repositories
git clone git@github.com:JPDevOpti/Dots-files.git ~/Repositories/Dots-files
cd ~/Repositories/Dots-files
```

**Verificación:** `git log -1` muestra el último commit esperado.

## Fase 3 — Instalar paquetes

Seguir `packages/README.md`: instalar `packages/pacman.txt` con
`omarchy pkg add`, `packages/aur.txt` con `omarchy pkg aur add`, y luego
`packages/mise.txt` y `packages/npm-global.txt`. Todo en su última versión.

**Verificación:** `omarchy pkg present $(< packages/pacman.txt)` responde
`true`. Si un paquete falla, revisarlo puntualmente (puede haber cambiado
de nombre en AUR).

## Fase 4 — Herramientas fuera de gestor de paquetes

Seguir `manifests/standalone-tools.md` para `engram`, `gentle-ai`, `codegraph`,
`zed`, `pandoc`, `prismlauncher`, `openclaw`, `dofustabs`, el AppImage de
Dofus y los shims de CLI resueltos por mise.

**Verificación:** ejecutar `<herramienta> --version` (o `--help` si no
soporta `--version`) para cada una.

## Fase 5 — Restaurar configuración, módulo por módulo

Cada módulo tiene su propia sección "Instalación manual" con los comandos
`cp` exactos. Orden recomendado (de más fundacional a más superficial):

1. [`hyprland/`](../hyprland/README.md) — compositor, antes que nada gráfico
2. [`monitors/`](../monitors/README.md) — depende de `hyprland/` ya instalado
3. [`theme/`](../theme/README.md) — temas, branding, GTK, fuentes
4. [`wallpapers/`](../wallpapers/README.md)
5. [`bar/`](../bar/README.md) — depende de los plugins de la Fase 6
6. [`alacritty/`](../alacritty/README.md), [`terminal/`](../terminal/README.md), [`shell/`](../shell/README.md)
7. [`editors/`](../editors/README.md)
8. [`devtools/`](../devtools/README.md) — requiere `~/.ssh/id_ed25519` restaurado (Fase 1)
9. [`input/`](../input/README.md), [`audio/`](../audio/README.md)
10. [`apps/`](../apps/README.md)
11. [`ai/`](../ai/README.md)
12. [`services/`](../services/README.md) — ver también Fase 7

**Verificación:**
```bash
hyprctl reload
hyprctl configerrors   # debe estar vacío
omarchy restart shell
```

## Fase 6 — Plugins y tema de Omarchy

```bash
# Temas añadidos con remoto git (manifests/omarchy-theme.txt)
omarchy theme install https://github.com/HANCORE-linux/omarchy-saga-theme.git
omarchy theme install https://github.com/HANCORE-linux/omarchy-greek-noir-theme.git
omarchy theme install https://github.com/EF-Code/omarchy-oligarchy-theme.git
omarchy theme install https://github.com/OldJobobo/omarchy-city-783-theme
# Los temas wallhaven-* se copian a mano (ver theme/README.md)

# Plugins de terceros normales (id -> url en manifests/omarchy-plugins.txt)
omarchy plugin add <url>
omarchy plugin enable <id>

# Los 24 plugins hancore.shibumi.* se instalan desde su propio repositorio
# (procedimiento verificado, ver manifests/omarchy-plugins.txt):
sudo pacman -S --needed python jq curl networkmanager power-profiles-daemon \
  upower xdg-utils libnotify wl-clipboard ttf-material-symbols-variable \
  ttf-jetbrains-mono-nerd-basic noto-fonts-cjk adwaita-fonts
git clone https://github.com/HANCORE-linux/Shibumi-Shell.git
cd Shibumi-Shell && ./scripts/shibumi-suite install --yes && cd ..

# Los plugins local.* ya llegaron al copiar bar/ (Fase 5); solo falta activarlos
omarchy plugin enable local.arch-menu
omarchy plugin enable local.collapser
omarchy plugin enable local.dofus-workspaces
omarchy plugin enable local.workspace-dots

omarchy theme set Saga
```

**Verificación:** `omarchy theme list` incluye los temas añadidos;
`omarchy plugin list` coincide con `manifests/omarchy-plugins.txt` en los
plugins marcados `enabled`; `omarchy theme current` devuelve `Saga`.

## Fase 7 — Servicios

Copiar las unidades de `services/` (ver `services/README.md`) y habilitar,
por cada fila de `manifests/services.txt`:

```bash
sudo systemctl enable --now mariadb mongodb ufw docker.socket bluetooth supergfxd
systemctl --user enable --now hyprmoncfgd voxtype openclaw-gateway bt-agent
```

**Verificación:** `systemctl is-active <servicio>` (o
`systemctl --user is-active <servicio>`) para cada uno de
`manifests/services.txt`.

## Fase 8 — Archivos de `/etc`

Seguir `system/README.md` — requieren `sudo` y tocan `/etc`, fuera del
alcance de cualquier módulo bajo `$HOME`.

**Verificación:** `bat /etc/modprobe.d/nvidia.conf` (o el archivo que
corresponda) refleja el contenido del repo; `systemctl daemon-reload` no
da error.

## Fase 9 — Hardware: NVIDIA + AMD híbrido, monitores

```bash
supergfxctl -g          # modo de gráficos activo
supergfxctl -S          # modos soportados
```

Revisar `.config/hypr/monitors.lua` y, si aplica, correr
`.config/hypr/scripts/monitors-home.sh` para el layout de tres monitores en
casa. El daemon `hyprmoncfgd` (plugin `crmne.hyprmoncfg`) gestiona el
`.config/hypr/hyprmoncfg-monitors.lua` generado — no lo edites a mano.

**Verificación:** `hyprctl monitors` lista las pantallas esperadas;
`supergfxctl -g` responde sin error.

## Fase 10 — Login de herramientas de IA

```bash
claude          # primer arranque pide login
codex login
opencode auth login
gentle-ai review mode status   # confirmar que RDD sigue apagado por defecto, o encenderlo si se usaba
```

**Verificación:** cada CLI responde a un comando simple sin pedir
autenticación de nuevo.

## Fase 11 — Re-clonar repositorios de trabajo

Por cada fila de `manifests/repos.txt`:

```bash
mkdir -p "$(dirname <ruta>)"
git clone <remote-url> <ruta>
```

**Verificación:** cada ruta de `manifests/repos.txt` existe y
`git status` en cada una reporta limpio (sin cambios locales inesperados).

## Checklist final

- [ ] `omarchy update` sin errores
- [ ] `gh auth status` autenticado
- [ ] Paquetes instalados sin fallos residuales
- [ ] `hyprctl configerrors` vacío
- [ ] Tema y plugins activos coinciden con los manifiestos
- [ ] Servicios `active`/`enabled` según `manifests/services.txt`
- [ ] Archivos de `/etc` aplicados y `daemon-reload` corrido
- [ ] GPU híbrida y monitores funcionando como se espera
- [ ] Herramientas de IA autenticadas
- [ ] Repositorios de trabajo clonados y limpios

**Pendiente de decisión:** si conservar el kernel `linux` vanilla junto a
`linux-omarchy`, y el origen de instalación de `engram` (no determinado con
la evidencia disponible en este equipo).
