# Barra (Omarchy shell)

Configuración de la barra superior, sus widgets y los plugins locales
hechos a mano para este equipo.

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.config/omarchy/shell.json` | `~/.config/omarchy/shell.json` | Layout de la barra, widgets, idle, plugins habilitados |
| `.config/omarchy/shell.toml` | `~/.config/omarchy/shell.toml` | Configuración adicional del shell |
| `.config/omarchy/omasettings.json` | `~/.config/omarchy/omasettings.json` | Estado de OmaSettings |
| `.config/omarchy/dock-settings.json` | `~/.config/omarchy/dock-settings.json` | Configuración del dock |
| `.config/omarchy/extensions/` | `~/.config/omarchy/extensions/` | Extensiones del menú de Omarchy |
| `.config/omarchy/hooks/` | `~/.config/omarchy/hooks/` | Hooks activos (sin `.sample`) |
| `.config/omarchy/plugins/local.*` | `~/.config/omarchy/plugins/local.*` | Los cuatro plugins locales de este equipo |

## Personalizaciones

### Barra activa

`"id": "io.github.guiestrela.glassbar"` — la barra activa es **Glass Bar**
(plugin de terceros), no la barra de stock de Omarchy (`omarchy.bar`, que
aparece `disabled` en `manifests/omarchy-plugins.txt`). Posición: `top`,
`transparent: false`.

### Layout, en el orden exacto de `shell.json`

**Izquierda:**
1. `local.arch-menu`
2. `local.workspace-dots`
3. `local.dofus-workspaces`
4. `io.github.feartheploto.musica` (modo `cava`)

**Centro:**
1. `omarchy.clock` (también fijado como `centerAnchor`)

**Derecha:**
1. `omarchy.indicators`
2. `omarchy.keyboard-layout`
3. `omarchy.system-update`
4. `omaplug`
5. `omarchy.weather`
6. `omarchy.tray`
7. `jesusarchive.keyboard-layout-switcher`
8. `crmne.hyprmoncfg`
9. `local.collapser`
10. `meviusisback.hw-monitor` (ver ajustes abajo)
11. `omarchy.agents`
12. `omarchy.bluetooth`
13. `omarchy.network`
14. `omarchy.audio`
15. `omarchy.power`

### Ajustes del widget `meviusisback.hw-monitor`

```
tempFormat: degree-unit   ramFormat: percent   mode: icons
showGpu: true             gpu: nvidia          showGpuTemp: false
showCpu: true             showCpuTemp: false   showClocks: false
showGauges: false
```

`gpu` está fijado explícitamente a `nvidia` — en un equipo con gráficos
híbridos NVIDIA + AMD, sin fijarlo el widget podría reportar la GPU
equivocada según cuál esté activa (ver `docs/04-problemas-conocidos.md`).

### Plugins locales

| Plugin | Qué hace (según su `manifest.json`) |
|---|---|
| `local.arch-menu` | Botón de menú de Omarchy con el logo de Arch Linux |
| `local.collapser` | Colapsa/expande con animación los widgets de la sección derecha colocados antes de él |
| `local.dofus-workspaces` | Un icono por cliente de Dofus en ejecución, con cambio de slot por teclas F |
| `local.workspace-dots` | Indicadores de workspace como puntos en vez de números |

### Idle y bloqueo (definidos en `shell.json`)

`idle.lock = 300` segundos (5 min), `idle.screensaver = 150` segundos
(2.5 min) — coincide con los tiempos de `hyprland/.config/hypr/hypridle.conf`.

### Plugins deshabilitados y clones

- `disabledPlugins`: `omarchy.lock` (reemplazado por
  `io.github.sirjul1337.lock-explorer`, con `design: "neon"`).
- `cloneSourceRestores`: `io.github.sirjul1337.lock-explorer`.

### Plugins de terceros

El resto de plugins activos (`bobbynicholas.omaland`, los
`hancore.shibumi.*` en modo servicio, `olauncher`, etc.) se reinstalan
siguiendo `manifests/omarchy-plugins.txt`, que trae el origen y el
procedimiento de instalación verificado de cada uno.

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`. `~/.config/omarchy` es un
directorio real gestionado por Omarchy (no symlink en sí), pero puede
contener enlaces internos gestionados (por ejemplo temas activos); revisar
con `readlink` cualquier ruta puntual que sorprenda antes de sobrescribir.

```bash
cp -r ~/.config/omarchy/extensions ~/.config/omarchy/extensions.orig 2>/dev/null
cp -r ~/.config/omarchy/hooks ~/.config/omarchy/hooks.orig 2>/dev/null
cp -r ~/.config/omarchy/plugins ~/.config/omarchy/plugins.orig 2>/dev/null
cp ~/.config/omarchy/shell.json ~/.config/omarchy/shell.json.orig 2>/dev/null
cp ~/.config/omarchy/shell.toml ~/.config/omarchy/shell.toml.orig 2>/dev/null
cp ~/.config/omarchy/omasettings.json ~/.config/omarchy/omasettings.json.orig 2>/dev/null
cp ~/.config/omarchy/dock-settings.json ~/.config/omarchy/dock-settings.json.orig 2>/dev/null
cp -r ~/Repositories/Dots-files/bar/.config/omarchy/. ~/.config/omarchy/
omarchy restart shell
```

## Cómo verificar

```bash
omarchy plugin list   # confirma qué plugins quedaron habilitados
```
Revisar visualmente que la barra muestre las tres secciones en el orden
de arriba.

## Dependencias

- Plugin `io.github.guiestrela.glassbar` (barra activa).
- Los plugins de terceros listados en la sección derecha e izquierda (ver
  `manifests/omarchy-plugins.txt` para cada URL de origen).
- Los cuatro plugins `local.*` de este repo.
