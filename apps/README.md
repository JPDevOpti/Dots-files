# Aplicaciones y utilidades

Lanzadores de aplicaciones, scripts personales pequeños, y configuración de
utilidades varias que no encajan en un módulo dedicado.

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.local/share/applications/*.desktop` | `~/.local/share/applications/` | Lanzadores personalizados (DofusTabs, Ankama, Claude Code URL handler, OpenClaw, web apps de Omarchy) |
| `.local/bin/gga` | `~/.local/bin/gga` | Gentleman Guardian Angel — revisión de código con IA agnóstica de proveedor |
| `.local/bin/hermes` | `~/.local/bin/hermes` | Script personal |
| `.local/bin/muse` | `~/.local/bin/muse` | Script personal |
| `.config/Thunar/` | `~/.config/Thunar/` | Atajos y acciones personalizadas del gestor de archivos |
| `.config/qalculate/` | `~/.config/qalculate/` | Configuración de la calculadora |
| `.config/mimeapps.list` | `~/.config/mimeapps.list` | Asociaciones de aplicaciones por tipo de archivo |
| `.config/user-dirs.dirs` | `~/.config/user-dirs.dirs` | Rutas de carpetas de usuario (Descargas, Documentos, etc.) |
| `.config/autostart/` | `~/.config/autostart/` | Aplicaciones de autoarranque XDG |
| `.config/imv/config` | `~/.config/imv/config` | Configuración del visor de imágenes |
| `.config/btop/` | `~/.config/btop/` | Configuración del monitor de sistema |
| `.config/lazygit/config.yml` | `~/.config/lazygit/config.yml` | Configuración de lazygit |

## Personalizaciones

- Solo se rastrean los lanzadores hechos a mano o personales (DofusTabs,
  Ankama, Claude Code, OpenClaw, y las web apps de Omarchy: Docker, Fizzy,
  Zoom, Discord, Figma, X, GitHub, Google Contacts, YouTube, Google Photos,
  ChatGPT, WhatsApp, Google Maps, HEY, Google Messages) — no los lanzadores
  que instala cada paquete del sistema.
- Los tres scripts de `.local/bin/` son scripts de texto Bash verificados
  sin secretos (`file` confirma texto, no binario).
- `.config/btop/themes/current.theme` es un symlink gestionado por Omarchy
  hacia el tema activo — no se copia, se regenera solo.

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`.

```bash
mkdir -p ~/.local/share/applications
cp -r ~/Repositories/Dots-files/apps/.local/share/applications/. ~/.local/share/applications/

mkdir -p ~/.local/bin
cp ~/Repositories/Dots-files/apps/.local/bin/gga ~/Repositories/Dots-files/apps/.local/bin/hermes ~/Repositories/Dots-files/apps/.local/bin/muse ~/.local/bin/
chmod +x ~/.local/bin/gga ~/.local/bin/hermes ~/.local/bin/muse

cp -r ~/.config/Thunar ~/.config/Thunar.orig 2>/dev/null
mkdir -p ~/.config/Thunar
cp -r ~/Repositories/Dots-files/apps/.config/Thunar/. ~/.config/Thunar/

mkdir -p ~/.config/qalculate ~/.config/autostart ~/.config/imv ~/.config/btop ~/.config/lazygit
cp -r ~/Repositories/Dots-files/apps/.config/qalculate/. ~/.config/qalculate/
cp -r ~/Repositories/Dots-files/apps/.config/autostart/. ~/.config/autostart/
cp ~/Repositories/Dots-files/apps/.config/imv/config ~/.config/imv/config
cp ~/Repositories/Dots-files/apps/.config/btop/btop.conf ~/.config/btop/btop.conf
cp ~/Repositories/Dots-files/apps/.config/lazygit/config.yml ~/.config/lazygit/config.yml
cp ~/Repositories/Dots-files/apps/.config/mimeapps.list ~/.config/mimeapps.list
cp ~/Repositories/Dots-files/apps/.config/user-dirs.dirs ~/.config/user-dirs.dirs
```

## Cómo verificar

```bash
gga --help 2>&1 | head -1
update-desktop-database ~/.local/share/applications 2>&1 || true
```

## Dependencias

- Paquetes `thunar`, `thunar-archive-plugin`, `thunar-volman`,
  `libqalculate`, `imv`, `btop`, `lazygit` (`packages/pacman.txt`).
