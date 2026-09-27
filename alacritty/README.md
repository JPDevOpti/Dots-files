# Alacritty

Terminal principal del día a día (ver `terminal/README.md` para Foot y tmux).

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.config/alacritty/alacritty.toml` | `~/.config/alacritty/alacritty.toml` | Configuración completa de Alacritty |

## Personalizaciones

- **Fuente**: `JetBrainsMono Nerd Font Mono` (normal, bold, italic), tamaño `9`.
- **Padding**: `14px` horizontal y vertical (`window.padding.x/y = 14`).
- **Opacidad**: `window.opacity = 1.0` (siempre opaca; la transparencia de
  ventana la controla la regla global de Hyprland en `hyprland/README.md`,
  no la propia terminal).
- **Decoraciones**: `window.decorations = "None"` (sin barra de título).
- **Cursor**: forma `Beam`, parpadeo activado (`blinking = "On"`).
- **Colores**: importados del tema activo de Omarchy —
  `general.import = ["~/.local/state/omarchy/current/theme/alacritty.toml"]`.
  No hay paleta fija en este archivo; cambia sola al cambiar de tema con
  `omarchy theme set` (ver `theme/README.md`).
- **Atajos de teclado** (`keyboard.bindings`):
  - `Ctrl+Shift+C` / `Ctrl+Shift+V`: copiar/pegar.
  - `Shift+Insert` / `Ctrl+Insert`: pegar/copiar (estilo X11 clásico).
  - `Shift+Return` envía CSI-u (`\x1b[13;2u`) para que las TUI lo
    distingan de `Return` sin confundirlo con `Alt+Return`.
  - `Alt+Shift+Return` envía CSI-u (`\x1b[13;4u`) para que tmux distinga
    `M-S-Enter` (la codificación legacy lo confunde con `Alt+Return`).
- **OSC 52**: `terminal.osc52 = "CopyPaste"` (copiar/pegar remoto vía
  secuencia de escape, útil sobre SSH).

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`.

```bash
cp ~/.config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml.orig 2>/dev/null
mkdir -p ~/.config/alacritty
cp ~/Repositories/Dots-files/alacritty/.config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
omarchy restart terminal
```

## Cómo verificar

```bash
alacritty --version
```
Abrir una terminal nueva y confirmar fuente, padding y atajos.

## Dependencias

- Paquete `alacritty` (`packages/pacman.txt`).
- Fuente `JetBrainsMono Nerd Font Mono` (paquete de fuentes Nerd Font de Omarchy).
- Tema activo de Omarchy para los colores (ver `theme/README.md`).
