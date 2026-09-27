# Tema

Tema activo, branding, pantalla de bloqueo, GTK, fuentes, y los temas
añadidos sobre la instalación de Omarchy por defecto.

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.config/omarchy/themes/wallhaven-9okxwk/` | `~/.config/omarchy/themes/wallhaven-9okxwk/` | Tema de usuario, sin remoto git |
| `.config/omarchy/themes/wallhaven-mlozx9/` | `~/.config/omarchy/themes/wallhaven-mlozx9/` | Tema de usuario, sin remoto git |
| `.config/omarchy/themes/wallhaven-xekz3v/` | `~/.config/omarchy/themes/wallhaven-xekz3v/` | Tema de usuario, sin remoto git |
| `.config/omarchy/branding/` | `~/.config/omarchy/branding/` | Branding personalizado de Omarchy |
| `.config/omarchy/lock-designs/` | `~/.config/omarchy/lock-designs/` | Diseños de pantalla de bloqueo |
| `.config/gtk-3.0/` | `~/.config/gtk-3.0/` | Bookmarks, CSS y ajustes de GTK 3 |
| `.config/fontconfig/fonts.conf` | `~/.config/fontconfig/fonts.conf` | Configuración de fuentes del sistema |
| `dconf.ini` | (se importa con `dconf load /`) | Preferencias GNOME/GTK (color-scheme, cursor, icon-theme) |

## Personalizaciones

### Tema activo

**Saga** (`omarchy theme current`).

### Cómo se propagan los colores del tema

Verificado leyendo los archivos reales, no asumido:

- **Hyprland**: el tema publica `~/.local/state/omarchy/current/theme/hyprland.lua`
  con `active_border_color = "#b2fff3"` e `inactive_border_color = "rgba(595959aa)"`.
  Ese archivo se carga como parte de los defaults de Omarchy; la
  personalización de `hyprland/.config/hypr/looknfeel.lua` se carga
  **después** y gana con sus propios colores neutros (blanco/gris), así
  que el borde final que se ve **no** es el del tema — ver
  `hyprland/README.md`.
- **Barra**: el tema publica `~/.local/state/omarchy/current/theme/shell.toml`
  con la paleta de la barra (`[bar] background = "#05080A"`, etc.). El
  `shell.toml` de usuario en `bar/.config/omarchy/shell.toml` es un
  archivo de 22 bytes, un override mínimo sobre esa base.
- **Alacritty**: `alacritty/.config/alacritty/alacritty.toml` importa
  directamente `~/.local/state/omarchy/current/theme/alacritty.toml`,
  generado por Omarchy a partir de `colors.toml` del tema (ver
  `alacritty/README.md`).
- **GTK**: `theme/.config/gtk-3.0/gtk.css` **no** importa los colores del
  tema de Omarchy (se verificó: no hay ninguna directiva `@import` hacia
  `current/theme/` en ese archivo). El aspecto de GTK lo controlan las
  claves de `dconf` (`gtk-theme = 'Adwaita-dark'`,
  `icon-theme = 'Yaru-purple'`, `color-scheme = 'prefer-dark'`),
  independientes del tema de colores de Omarchy.
- **Lock screen**: `hyprland/.config/hypr/hyprlock.conf` importa
  `~/.config/omarchy/current/theme/hyprlock.conf` (variables `$color`,
  `$inner_color`, etc.).

### Paleta del tema activo (Saga)

Leída de `~/.config/omarchy/themes/saga/colors.toml`:

| Rol | Color |
|---|---|
| foreground | `#fff6ff` |
| background | `#05080a` |
| accent / cursor | `#b2fff3` |
| selection foreground | `#05080a` |
| selection background | `#ffc2df` |
| color0 (negro) | `#05080a` |
| color1 (rojo) | `#ff9fbc` |
| color2 (verde) | `#baf7b5` |
| color3 (amarillo) | `#fff6c3` |
| color4 (azul) | `#b2fff3` |
| color5 (magenta) | `#dfbaff` |
| color6 (cian) | `#ffc79b` |
| color7 (blanco) | `#f3ceff` |
| color8-15 (brillantes) | `#4b4c4d`, `#ffaecb`, `#baf7b5`, `#fff6c3`, `#b2fff3`, `#dfbaff`, `#ffc79b`, `#ffe1e1` |

### Temas añadidos con remoto git (reinstalables por URL)

| Tema | URL |
|---|---|
| `city-783` | `https://github.com/OldJobobo/omarchy-city-783-theme` |
| `greek-noir` | `https://github.com/HANCORE-linux/omarchy-greek-noir-theme.git` |
| `oligarchy` | `https://github.com/EF-Code/omarchy-oligarchy-theme.git` |
| `saga` | `https://github.com/HANCORE-linux/omarchy-saga-theme.git` |

Comando de instalación verificado (`omarchy theme --help`):
`omarchy theme install <git-repo-url>`.

### Temas de usuario guardados en este repo (sin remoto git)

`wallhaven-9okxwk`, `wallhaven-mlozx9`, `wallhaven-xekz3v` — generados a
mano, sin origen reinstalable; se copian literalmente
(`.config/omarchy/themes/<nombre>/`, ~15M en total).

`aether` es un directorio vacío y real en el equipo de origen (0 archivos,
no symlink); no hay nada que copiar ni un origen determinable.

Ver `manifests/omarchy-theme.txt` para la lista completa de temas de stock
vs. añadidos.

### Fuentes

`theme/.config/fontconfig/fonts.conf` — configuración de fuentes del
sistema. La terminal usa `JetBrainsMono Nerd Font Mono` (ver
`alacritty/README.md`); la pantalla de bloqueo también usa
`JetBrainsMono Nerd Font Mono` (`hyprlock.conf`, `font_family`).

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`. Instalar primero los temas con
remoto git; luego copiar los temas de usuario sin remoto (`wallhaven-*`) y el
resto del módulo.

```bash
omarchy theme install https://github.com/HANCORE-linux/omarchy-saga-theme.git
omarchy theme install https://github.com/HANCORE-linux/omarchy-greek-noir-theme.git
omarchy theme install https://github.com/EF-Code/omarchy-oligarchy-theme.git
omarchy theme install https://github.com/OldJobobo/omarchy-city-783-theme

cp -r ~/.config/omarchy/themes ~/.config/omarchy/themes.orig 2>/dev/null
cp -r ~/Repositories/Dots-files/theme/.config/omarchy/themes/. ~/.config/omarchy/themes/
cp -r ~/Repositories/Dots-files/theme/.config/omarchy/branding/. ~/.config/omarchy/branding/
cp -r ~/Repositories/Dots-files/theme/.config/omarchy/lock-designs/. ~/.config/omarchy/lock-designs/

cp -r ~/.config/gtk-3.0 ~/.config/gtk-3.0.orig 2>/dev/null
cp -r ~/Repositories/Dots-files/theme/.config/gtk-3.0/. ~/.config/gtk-3.0/
cp ~/.config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf.orig 2>/dev/null
mkdir -p ~/.config/fontconfig
cp ~/Repositories/Dots-files/theme/.config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf

dconf dump / > ~/dconf-antes-de-restaurar.ini
dconf load / < ~/Repositories/Dots-files/theme/dconf.ini

omarchy theme set Saga
```

## Cómo verificar

```bash
omarchy theme current   # debe responder "Saga"
omarchy theme list      # confirma que los temas añadidos aparecen
```

## Dependencias

- `git` (para `omarchy theme install`).
- Ninguna otra dependencia externa a Omarchy.
