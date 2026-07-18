# Plan de Configuración del Sistema — Omarchy (Arch Linux + Hyprland)

## Estado del sistema
- **Distro base**: Omarchy (DHH) — Arch Linux + Hyprland
- **Shell**: Bash + Starship
- **Terminal**: Ghostty (principal)
- **WM**: Hyprland (gestionado por Omarchy)
- **Status bar**: Waybar
- **Launcher**: Walker
- **Editor**: Neovim (LazyVim) + Zed
- **Multiplexor**: Tmux

---

## Etapa 1 — Terminal y Shell ✅
**Archivos**: `~/.config/ghostty/config`, `~/.config/starship.toml`, `~/.bashrc`

- [x] Ghostty: fuente, tamaño, opacidad, padding
- [x] Starship: prompt con git info, directorio, tiempo de ejecución
- [x] Bash: aliases personales, funciones útiles, variables de entorno

---

## Etapa 2 — Atajos de teclado (Hyprland)
**Archivo**: `~/.config/hypr/bindings.conf`

- [ ] Revisar y limpiar atajos existentes de Omarchy
- [ ] Asignar apps personales (editor, browser, comunicación)
- [ ] Atajos para workspaces y manejo de ventanas
- [ ] Atajos para capturas de pantalla y grabación

---

## Etapa 3 — Aspecto visual
**Archivos**: `~/.config/waybar/`, `~/.config/walker/config.toml`, `~/.config/mako/`

- [ ] Tema de Omarchy: seleccionar o personalizar
- [ ] Waybar: módulos (reloj, batería, red, audio, workspaces)
- [ ] Walker: apariencia del launcher
- [ ] Mako: estilo de notificaciones

---

## Etapa 4 — Editores
**Archivos**: `~/.config/nvim/`, `~/.config/zed/settings.json`

- [ ] Neovim (LazyVim): plugins adicionales, keymaps, opciones visuales
- [ ] Zed: settings, keybindings, tema

---

## Etapa 5 — Git y herramientas de desarrollo
**Archivo**: `~/.config/git/config`

- [ ] Corregir email (typo: `gmeil.com` → `gmail.com`)
- [ ] Aliases adicionales
- [ ] Lazygit: personalización
- [ ] Mise: herramientas globales

---

## Etapa 6 — Apps y miscelánea
- [ ] Obsidian: vault y plugins
- [ ] Chromium: extensiones y configuración
- [ ] Autostart: apps que inician con el sistema
- [ ] SSH: llaves y config por host
