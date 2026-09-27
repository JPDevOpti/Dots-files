# Monitores

Perfiles guardados de `hyprmoncfg` y configuración de `nwg-displays`. Los
archivos que Hyprland realmente carga (`monitors.lua`,
`hyprmoncfg-monitors.lua`, `scripts/monitors-home.sh`) viven físicamente en
el módulo `hyprland/` porque Hyprland los busca en `~/.config/hypr`; este
documento los referencia y explica cómo encajan entre sí.

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.config/hyprmoncfg/profiles/uno.conf`, `uno.json`, `uno.lua` | `~/.config/hyprmoncfg/profiles/` | Perfil de monitores guardado por el plugin `crmne.hyprmoncfg` |
| `.config/nwg-displays/config` | `~/.config/nwg-displays/config` | Configuración de la GUI `nwg-displays` |
| (referencia) `hyprland/.config/hypr/monitors.lua` | `~/.config/hypr/monitors.lua` | Configuración manual/heredada, se carga temprano |
| (referencia) `hyprland/.config/hypr/hyprmoncfg-monitors.lua` | `~/.config/hypr/hyprmoncfg-monitors.lua` | Generado por `hyprmoncfgd`, se carga al final |
| (referencia) `hyprland/.config/hypr/scripts/monitors-home.sh` | `~/.config/hypr/scripts/monitors-home.sh` | Layout de tres monitores en casa (atajo `SUPER + D`) |

## Personalizaciones

### Layout de casa (tres monitores), tal como lo define `scripts/monitors-home.sh`

El script desactiva primero las salidas externas y luego las reactiva sin
espejo, en este orden:

| Salida | Modo | Posición | Rol |
|---|---|---|---|
| `DP-1` o `DP-3` (Lenovo externo, según el puerto — NVIDIA vs. amdgpu) | `1920x1080@60.00` | `0x0` | arriba a la izquierda |
| `HDMI-A-1` | `1920x1080@60.00` | `1920x0` | arriba a la derecha |
| `eDP-2` (panel del portátil) | `1920x1200@144.00` | `960x1080` | abajo al centro, principal |

Después fija los workspaces (las reglas de workspace solo aplican a
workspaces nuevos, no a los que ya existían tras el hotplug): workspace
`1` → `eDP-2`, `2` → el Lenovo, `3` → `HDMI-A-1`. Termina con
`omarchy-restart-shell`.

### Layout solo portátil (`monitors.lua`)

Sin monitores externos: `eDP-2` en `1920x1200@144.0`, posición `960x1080`,
escala `1.0`; `HDMI-A-1` en `1920x1080@60.0`, posición `2880x1200`
(generado por `nwg-displays` el 23-09-2026).

### Qué archivo manda

Orden de carga en `hyprland.lua`: `monitors.lua` se carga temprano junto
con `input`/`bindings`/`looknfeel`/`autostart`; `hyprmoncfg-monitors.lua`
se carga al final con un `dofile` condicional, así que siempre gana.

- **`monitors.lua`**: configuración manual/heredada; cualquier salida que
  `hyprmoncfg-monitors.lua` también declare queda sobrescrita.
- **`hyprmoncfg-monitors.lua`**: generado por el daemon `hyprmoncfgd` a
  partir del perfil activo — no editar a mano.
- **`~/.config/hyprmoncfg/profiles/`**: los perfiles guardados
  (`uno.conf`/`.json`/`.lua`) que `hyprmoncfgd` usa para regenerar
  `hyprmoncfg-monitors.lua`. Es la única fuente editable/restaurable del
  layout gestionado por el daemon.

## Inconsistencias detectadas

Dos hechos verificados en los archivos actuales, sin cambiar nada:

- **(a)** `monitors.lua` define la salida `eDP-2` dos veces con posiciones
  distintas: una vez en el bloque "hyprmoncfg wake settings"
  (`position = "2889x1140"`) y otra en el bloque generado por
  `nwg-displays` (`position = "960x1080"`). La segunda declaración es la
  vigente al cargar ese archivo, hasta que `hyprmoncfg-monitors.lua` la
  sobrescribe de nuevo.
- **(b)** Un comentario en `scripts/monitors-home.sh` (línea 28) dice que
  `mirror = ""` es necesario porque, si no, la salida hereda "el espejo de
  la regla catch-all en `monitors.lua`". Esa regla catch-all (una
  declaración `hl.monitor` con salida comodín y `mirror`) no existe en el
  `monitors.lua` actual — el archivo solo tiene las dos declaraciones
  explícitas de (a). El comentario probablemente describe un estado
  anterior del archivo. El `mirror = ""` explícito en el script se
  mantiene como salvaguarda aunque la causa original ya no esté presente.

## Instalación manual

Este módulo depende de que `hyprland/` ya esté instalado (ver
`hyprland/README.md`) antes de copiar los perfiles de monitores. Repo
clonado en `~/Repositories/Dots-files`.

```bash
cp -r ~/.config/hyprmoncfg ~/.config/hyprmoncfg.orig 2>/dev/null
mkdir -p ~/.config/hyprmoncfg/profiles
cp ~/Repositories/Dots-files/monitors/.config/hyprmoncfg/profiles/uno.conf ~/Repositories/Dots-files/monitors/.config/hyprmoncfg/profiles/uno.json ~/Repositories/Dots-files/monitors/.config/hyprmoncfg/profiles/uno.lua ~/.config/hyprmoncfg/profiles/

mkdir -p ~/.config/nwg-displays
cp ~/.config/nwg-displays/config ~/.config/nwg-displays/config.orig 2>/dev/null
cp ~/Repositories/Dots-files/monitors/.config/nwg-displays/config ~/.config/nwg-displays/config

hyprctl reload
```

El perfil de `~/.config/hyprmoncfg/profiles/` no se aplica solo — hay que
volver a seleccionarlo desde la interfaz de `hyprmoncfg` (widget
`crmne.hyprmoncfg` en la barra) para que regenere `hyprmoncfg-monitors.lua`.

## Cómo verificar

```bash
hyprctl monitors            # confirma salidas, modos y posiciones activos
```

## Dependencias

- Plugin `crmne.hyprmoncfg` (ver `manifests/omarchy-plugins.txt`).
- `nwg-displays` (paquete pacman).
- `jq` (usado por `scripts/monitors-home.sh` para detectar el puerto del Lenovo).

## Notas

Ver "Inconsistencias detectadas" arriba y
`docs/04-problemas-conocidos.md` para el conflicto entre `hyprmoncfgd` y
DofusTabs, y el problema conocido de espejado que rompe la barra y el
fondo.
