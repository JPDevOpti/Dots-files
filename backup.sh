#!/usr/bin/env bash

# Script para respaldar dotfiles de Arch Linux (Hyprland / Caelestia)
# Guardado en ~/Dots-files/backup.sh

set -e

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "=== Iniciando Respaldo de Dotfiles ==="
echo "Directorio de destino: $BACKUP_DIR"

# Función auxiliar para copiar archivos individuales
backup_file() {
    local src="$1"
    local dest="$BACKUP_DIR/$2"
    if [ -f "$src" ]; then
        mkdir -p "$(dirname "$dest")"
        cp -f "$src" "$dest"
        echo "✓ Copiado: $2"
    else
        echo "⚠ No encontrado (omitido): $src"
    fi
}

# Función auxiliar para copiar directorios usando rsync
backup_dir() {
    local src="$1"
    local dest="$BACKUP_DIR/$2/"
    if [ -d "$src" ]; then
        mkdir -p "$dest"
        rsync -av --delete \
            --exclude=".git" \
            --exclude="node_modules" \
            --exclude="Cache*" \
            --exclude="*cache*" \
            --exclude="GPUCache" \
            --exclude="Local Storage" \
            --exclude="Session Storage" \
            --exclude="databases" \
            "$src/" "$dest"
        echo "✓ Directorio respaldado: $2"
    else
        echo "⚠ Directorio no encontrado (omitido): $src"
    fi
}

# 1. Archivos de configuración en el HOME (~)
echo "--- Respaldando archivos del HOME ---"
backup_file "$HOME/.zshrc" ".zshrc"
backup_file "$HOME/.p10k.zsh" ".p10k.zsh"
backup_file "$HOME/.tmux.conf" ".tmux.conf"
backup_file "$HOME/.gitconfig" ".gitconfig"

# 2. Directorios en ~/.config/
echo "--- Respaldando directorios de ~/.config ---"
backup_dir "$HOME/.config/caelestia" ".config/caelestia"
backup_dir "$HOME/.config/caelestia-shell" ".config/caelestia-shell"
backup_dir "$HOME/.config/kitty" ".config/kitty"
backup_dir "$HOME/.config/fuzzel" ".config/fuzzel"
backup_dir "$HOME/.config/nwg-displays" ".config/nwg-displays"
backup_dir "$HOME/.config/gtk-3.0" ".config/gtk-3.0"
backup_dir "$HOME/.config/gtk-4.0" ".config/gtk-4.0"
backup_dir "$HOME/.config/qtengine" ".config/qtengine"
backup_dir "$HOME/.config/zed" ".config/zed"
backup_dir "$HOME/.config/nvim" ".config/nvim"
backup_dir "$HOME/.config/Thunar" ".config/Thunar"

# 3. Archivos específicos en ~/.config/ (evitando basura de cachés en carpetas de editores)
echo "--- Respaldando archivos específicos de ~/.config ---"
backup_file "$HOME/.config/cava/config" ".config/cava/config"
backup_file "$HOME/.config/htop/htoprc" ".config/htop/htoprc"
backup_file "$HOME/.config/nvtop/nvtop.colors" ".config/nvtop/nvtop.colors"
backup_file "$HOME/.config/macchina/macchina.toml" ".config/macchina/macchina.toml"
backup_file "$HOME/.config/dolphinrc" ".config/dolphinrc"
backup_file "$HOME/.config/go/env" ".config/go/env"
backup_file "$HOME/.config/git/ignore" ".config/git/ignore"
backup_file "$HOME/.config/opencode/opencode.jsonc" ".config/opencode/opencode.jsonc"
backup_file "$HOME/.config/QtProject.conf" ".config/QtProject.conf"
backup_file "$HOME/.config/hyfetch.json" ".config/hyfetch.json"
backup_file "$HOME/.config/kwinrulesrc" ".config/kwinrulesrc"
backup_file "$HOME/.config/kdeglobals" ".config/kdeglobals"
backup_file "$HOME/.config/arkrc" ".config/arkrc"
backup_file "$HOME/.config/mimeapps.list" ".config/mimeapps.list"
backup_file "$HOME/.config/user-dirs.dirs" ".config/user-dirs.dirs"
backup_file "$HOME/.config/user-dirs.locale" ".config/user-dirs.locale"
backup_file "$HOME/.config/qalculate/qalc.cfg" ".config/qalculate/qalc.cfg"

# 4. Configuraciones de Editores de Código
echo "--- Respaldando configuraciones de Editores ---"
# VS Code
backup_file "$HOME/.config/Code/User/settings.json" ".config/Code/User/settings.json"
backup_file "$HOME/.config/Code/User/keybindings.json" ".config/Code/User/keybindings.json"
backup_dir "$HOME/.config/Code/User/snippets" ".config/Code/User/snippets"

# Cursor
backup_file "$HOME/.config/Cursor/User/settings.json" ".config/Cursor/User/settings.json"
backup_file "$HOME/.config/Cursor/User/keybindings.json" ".config/Cursor/User/keybindings.json"
backup_dir "$HOME/.config/Cursor/User/snippets" ".config/Cursor/User/snippets"

# Lapce
backup_file "$HOME/.config/lapce-stable/settings.toml" ".config/lapce-stable/settings.toml"
backup_file "$HOME/.config/lapce-stable/keymaps.toml" ".config/lapce-stable/keymaps.toml"

# 5. Caelestia Desktop Distribution
echo "--- Respaldando caelestia local share (distribución completa) ---"
backup_dir "$HOME/.local/share/caelestia" ".local/share/caelestia"

# 6. Lanzadores de aplicaciones locales (.desktop)
echo "--- Respaldando lanzadores de aplicaciones (.desktop) ---"
if ls "$HOME/.local/share/applications/"*.desktop >/dev/null 2>&1; then
    mkdir -p "$BACKUP_DIR/.local/share/applications"
    cp -f "$HOME/.local/share/applications/"*.desktop "$BACKUP_DIR/.local/share/applications/"
    echo "✓ Copiados lanzadores .desktop"
else
    echo "⚠ No se encontraron lanzadores .desktop"
fi

# 7. Volcado de la base de datos de GSettings (dconf)
echo "--- Respaldando base de datos dconf (GSettings) ---"
if command -v dconf >/dev/null 2>&1; then
    dconf dump / > "$BACKUP_DIR/dconf_backup.ini"
    echo "✓ Volcado de dconf guardado en dconf_backup.ini"
else
    echo "⚠ dconf no está instalado, omitiendo volcado"
fi

echo "=== Respaldo Completado Exitosamente ==="
