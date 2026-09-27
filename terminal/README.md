# Terminal (Foot y tmux)

Terminal alternativa (Foot) y el multiplexor tmux. Alacritty es la terminal
principal del día a día (ver `alacritty/README.md`).

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.config/foot/foot.ini` | `~/.config/foot/foot.ini` | Configuración de Foot |
| `.config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | Configuración de tmux |

## Personalizaciones

### Foot

- Fuente `JetBrainsMono Nerd Font Mono`, tamaño `9`; padding `14x14`.
- Colores importados del tema activo:
  `include=~/.local/state/omarchy/current/theme/foot.ini`.
- Scrollback: `10000` líneas, multiplicador `7.0`.
- Cursor en bloque, sin parpadeo.
- `Control+Insert` copia, `Shift+Insert` pega.
- Ningún atajo de este repo lanza Foot por defecto (ver
  `hyprland/README.md`); Alacritty es la terminal del día a día.

### tmux

- Prefijo `Ctrl+Space` (con `Ctrl+b` como alternativa, `prefix2`).
- `q` recarga la configuración.
- Modo vi para copiar (`v` inicia selección, `y` copia y cierra el modo).
- `Alt+Enter` divide horizontalmente, `Alt+Shift+Enter` divide
  verticalmente, `Alt+Esc` mata el pane (sin necesidad del prefijo).
- Renombrado automático de ventanas según el directorio actual.
- Barra de estado minimalista, colores en azul/negro, sin fondo.
- Reenvío de portapapeles OSC 52 habilitado, para que `yank` en Neovim
  remoto llegue al portapapeles local.
- La sesión `Work` se crea o adjunta con `SUPER + SHIFT + Q` (ver
  `hyprland/README.md`).

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`.

```bash
cp ~/.config/foot/foot.ini ~/.config/foot/foot.ini.orig 2>/dev/null
mkdir -p ~/.config/foot
cp ~/Repositories/Dots-files/terminal/.config/foot/foot.ini ~/.config/foot/foot.ini

cp ~/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf.orig 2>/dev/null
mkdir -p ~/.config/tmux
cp ~/Repositories/Dots-files/terminal/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
```
Recargar tmux si hay una sesión activa: `tmux source-file ~/.config/tmux/tmux.conf`.

## Cómo verificar

```bash
foot --version
tmux -V
```

## Dependencias

- Paquetes `foot`, `tmux` (`packages/pacman.txt`).
- Tema activo de Omarchy para los colores de Foot (ver `theme/README.md`).
