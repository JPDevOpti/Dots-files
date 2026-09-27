# Hyprland

Configuración del compositor Hyprland (Wayland): atajos de teclado, aspecto,
entrada, autoarranque, idle/lock/night light e integración con DofusTabs.

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.config/hypr/hyprland.lua` | `~/.config/hypr/hyprland.lua` | Punto de entrada; controla el orden de carga de todo lo demás |
| `.config/hypr/bindings.lua` | `~/.config/hypr/bindings.lua` | Atajos de teclado personalizados |
| `.config/hypr/looknfeel.lua` | `~/.config/hypr/looknfeel.lua` | Aspecto: bordes, gaps, blur, sombra, opacidad, cursor |
| `.config/hypr/input.lua` | `~/.config/hypr/input.lua` | Distribución de teclado, sensibilidad, cursor |
| `.config/hypr/monitors.lua` | `~/.config/hypr/monitors.lua` | Configuración manual/heredada de monitores (ver `monitors/README.md`) |
| `.config/hypr/autostart.lua` | `~/.config/hypr/autostart.lua` | Procesos que arrancan con la sesión |
| `.config/hypr/omasettings.lua` | `~/.config/hypr/omasettings.lua` | Generado por OmaSettings, no editar a mano |
| `.config/hypr/hyprmoncfg-monitors.lua` | `~/.config/hypr/hyprmoncfg-monitors.lua` | Generado por el daemon `hyprmoncfgd` (ver `monitors/README.md`) |
| `.config/hypr/dofustabs.lua` | `~/.config/hypr/dofustabs.lua` | Integración con DofusTabs |
| `.config/hypr/hypridle.conf` | `~/.config/hypr/hypridle.conf` | Tiempos de idle, screensaver y bloqueo |
| `.config/hypr/hyprlock.conf` | `~/.config/hypr/hyprlock.conf` | Pantalla de bloqueo |
| `.config/hypr/hyprsunset.conf` | `~/.config/hypr/hyprsunset.conf` | Perfil de luz nocturna (desactivado por defecto) |
| `.config/hypr/xdph.conf` | `~/.config/hypr/xdph.conf` | Portal de escritorio XDG |
| `.config/hypr/envs.conf` | `~/.config/hypr/envs.conf` | Variables de entorno de Hyprland |
| `.config/hypr/scripts/monitors-home.sh` | `~/.config/hypr/scripts/monitors-home.sh` | Layout de monitores de casa (ver `monitors/README.md`) |
| `.config/hypr/legacy/*.conf` | (referencia, no se carga) | Config `.conf` heredada de antes de la migración a Lua; no la carga ningún archivo actual |

## Personalizaciones

### Orden de carga (`hyprland.lua`)

1. `default/hypr/bootstrap.lua` (bootstrap de Omarchy, vía `$OMARCHY_PATH`)
2. `default.hypr.omarchy` (defaults de Omarchy)
3. `hypr.monitors`, `hypr.input`, `hypr.bindings`, `hypr.looknfeel`, `hypr.autostart` (overrides personales, en ese orden)
4. `default.hypr.toggles` (flags de Omarchy)
5. Bloque `dofustabs`: `dofile` protegido con `pcall` sobre `~/.config/hypr/dofustabs.lua`; si falla, registra el error en `~/.cache/dofustabs.log` en vez de romper Hyprland
6. `hypr.omasettings` (gestionado por OmaSettings)
7. Bloque final: si existe `~/.config/hypr/hyprmoncfg-monitors.lua`, se carga con `dofile` — al ser el último paso, gana sobre cualquier declaración de monitor anterior

### Atajos de teclado (`bindings.lua`)

Los atajos por defecto de Omarchy que se liberan (`hl.unbind`) y qué los
reemplaza:

| Atajo | Por defecto (liberado) | Reemplazado por |
|---|---|---|
| `SUPER + W` | Cerrar ventana | Navegador |
| `SUPER + S` | Alternar scratchpad | Captura de región |
| `SUPER + X` | Cortar universal | Pantalla completa |
| `SUPER + C` | Copiar universal | Sacar ventana flotante (pop out) |
| `SUPER + V` | Pegar universal | Alternar split |
| `SUPER + O` | Pop out | (movido a `SUPER + C`) |
| `SUPER + J` | Alternar split | (movido a `SUPER + V`) |
| `SUPER + L` | Alternar layout | (movido a `SUPER + B`) |
| `SUPER + SHIFT + D` | Docker | sin uso |
| `SUPER + RETURN` | Terminal | Recargar Hyprland + shell + monitores |
| `SUPER + SHIFT + RETURN` | Navegador | Recargar Hyprland |
| `SUPER + SPACE` | Menú de Omarchy | Menú de apps |

Atajos activos definidos por este repo:

| Atajo | Acción |
|---|---|
| `SUPER + X` | Pantalla completa |
| `SUPER + C` | Sacar ventana flotante y fijarla (pop out) |
| `SUPER + V` | Alternar split de ventana |
| `SUPER + B` | Alternar layout del workspace |
| `SUPER + Z` | Cerrar ventana |
| Scroll horizontal (MX Master 3S) | Workspace siguiente/anterior (o navegación de pestañas de Dofus si `dofustabs` está cargado) |
| `SUPER + S` | Captura de región al portapapeles |
| `SUPER + A` | Selector de color al portapapeles (`hyprpicker`) |
| `SUPER + Q` | Terminal en `$HOME` (Alacritty) |
| `SUPER + SHIFT + Q` | Terminal + tmux (adjunta o crea sesión `Work`) |
| `SUPER + W` | Navegador |
| `SUPER + SHIFT + W` | Navegador (privado) |
| `SUPER + R` | Editor (Zed) |
| `SUPER + E` | Gestor de archivos (Thunar) |
| `SUPER + ALT + E` | Gestor de archivos en el directorio actual de la terminal |
| `SUPER + SPACE` | Menú de aplicaciones |
| `SUPER + SHIFT + M` | Spotify (lanza o enfoca) |
| `SUPER + D` | Layout de monitores de casa |
| `SUPER + SHIFT + O` | Obsidian |
| `SUPER + SHIFT + /` | 1Password |
| `SUPER + SHIFT + I` | Claude Code en terminal |
| `SUPER + SHIFT + RETURN` | Recargar Hyprland |
| `SUPER + RETURN` | Recargar Hyprland + layout de monitores + shell |

Listado completo (incluyendo lo no tocado): `omarchy menu keybindings --print`.

### Aspecto (`looknfeel.lua`)

- **Bordes**: `border_size = 0`; color activo `#ffffff`, inactivo
  `rgba(7f7f7f99)` — declarado después del tema para ganarle.
- **Gaps**: `gaps_in = 10`, `gaps_out = 14`, `float_gaps = 10`, `gaps_workspaces = 0`.
- **Rounding**: `0` (esquinas cuadradas), `rounding_power = 2.2`.
- **Blur**: activado (`decoration.blur.enabled = true`).
- **Sombra**: activada, `range = 6`, `render_power = 2`.
- **Layout**: `dwindle`, `master.mfact = 0.46`.
- **Opacidad de ventana**: ventana en foco 100%, sin foco 85%
  (`o.window(".*", { opacity = "1.0 0.85" })`, declarada al final del
  archivo). **Excepción**: Zen Browser siempre 100% opaco
  (`o.window("^(zen)$", { opacity = "1.0 1.0" })`).
- **Cursor**: no salta al cambiar de workspace (`warp_on_change_workspace = 0`)
  y no se oculta tras cada tecla (`hide_on_key_press = false`).

### Entrada (`input.lua`)

- Distribución de teclado forzada a `latam` (`kb_layout = "latam"`,
  `kb_options = ""`) — restaura un Caps Lock normal en vez del Compose que
  usa Omarchy por defecto.
- Tema de cursor `Bibata-Modern-Ice`, tamaño `24`, vía variables de entorno
  `XCURSOR_THEME`, `XCURSOR_SIZE`, `HYPRCURSOR_THEME`, `HYPRCURSOR_SIZE`.
- El resto (sensibilidad, gestos táctiles, velocidad de scroll) queda
  comentado como referencia, sin activar.

### Autoarranque (`autostart.lua`)

- `solaar --window=hide` (gestor del ratón MX Master 3S, oculto).

### Idle, bloqueo y luz nocturna

- **Idle** (`hypridle.conf`): pantalla de protección a los 2.5 minutos
  (`timeout = 150`), bloqueo del sistema a los 5 minutos (`timeout = 152`,
  medido a partir del reinicio del idle por el screensaver). Bloqueo y
  suspensión usan `omarchy-system-lock` / `omarchy-system-wake`.
- **Lock** (`hyprlock.conf`): campo de contraseña sin animaciones
  (`animations.enabled = false`), fuente `JetBrainsMono Nerd Font Mono`,
  colores importados del tema activo (`~/.config/omarchy/current/theme/hyprlock.conf`).
- **Night light** (`hyprsunset.conf`): perfil por defecto sin tinte
  (`identity = true` a las 07:00); el perfil de temperatura cálida por la
  noche queda comentado, no activo — `hyprsunset` no se autoarranca desde
  `autostart.lua`.

### DofusTabs

`dofustabs.lua` se carga en un bloque `pcall` protegido desde
`hyprland.lua`. Gestiona ventanas y workspaces dedicados a las cuentas de
Dofus; nunca debe tocar `hl.monitor` (ver `monitors/README.md`,
"Inconsistencias detectadas" y `docs/04-problemas-conocidos.md`).

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`. `~/.config/hypr` en una
instalación limpia de Omarchy es un directorio real (no symlink); confirmar
con `readlink ~/.config/hypr` antes de sobrescribir — si devuelve una ruta,
no copiar encima sin revisar primero.

```bash
cp -r ~/.config/hypr ~/.config/hypr.orig
cp -r ~/Repositories/Dots-files/hyprland/.config/hypr/. ~/.config/hypr/
hyprctl reload
```

## Cómo verificar

```bash
hyprctl configerrors        # vacío = sin errores de config
omarchy menu keybindings --print | head    # confirma que los atajos cargaron
```

## Dependencias

- Paquete `hyprland` (vía Omarchy).
- `hyprpicker` (selector de color, `SUPER + A`).
- Plugin `crmne.hyprmoncfg` para el bloque final de monitores (ver `monitors/README.md`).
- Repositorio `JPDevOpti/DofusTabs` para `dofustabs.lua` (ver `manifests/repos.txt`).

## Notas

Ver `docs/04-problemas-conocidos.md` para el conflicto conocido entre
`hyprmoncfgd` y DofusTabs.
