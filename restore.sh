#!/usr/bin/env bash

# Script para restaurar dotfiles de Arch Linux (Hyprland / Caelestia)
# Guardado en ~/Dots-files/restore.sh

set -e

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "=== Iniciando Restauración de Dotfiles ==="
echo "Directorio de origen: $BACKUP_DIR"

# Confirmación del usuario
if [ "$1" != "-y" ] && [ "$1" != "--yes" ]; then
    read -p "Este script sobrescribirá configuraciones existentes en tu sistema. ¿Deseas continuar? (s/n): " confirm
    if [[ ! "$confirm" =~ ^[sS]$ ]]; then
        echo "Restauración cancelada."
        exit 0
    fi
fi

# Función auxiliar para restaurar archivos individuales
restore_file() {
    local src="$BACKUP_DIR/$1"
    local dest="$HOME/$2"
    if [ -f "$src" ]; then
        mkdir -p "$(dirname "$dest")"
        cp -f "$src" "$dest"
        echo "✓ Restaurado: $2"
    else
        echo "⚠ No disponible en el respaldo (omitido): $1"
    fi
}

# Función auxiliar para restaurar directorios usando rsync (sin --delete por seguridad)
restore_dir() {
    local src="$BACKUP_DIR/$1"
    local dest="$HOME/$2/"
    if [ -d "$src" ]; then
        mkdir -p "$dest"
        rsync -av "$src/" "$dest"
        echo "✓ Directorio restaurado: $2"
    else
        echo "⚠ Respaldo no contiene el directorio (omitido): $1"
    fi
}

# Función para crear enlaces simbólicos de forma segura
create_symlink() {
    local target="$1"
    local link="$2"
    
    # Crear directorio padre si no existe
    mkdir -p "$(dirname "$link")"
    
    if [ -e "$link" ] && [ ! -L "$link" ]; then
        echo "⚠ El destino $link ya existe y no es un enlace simbólico. Respaldando a ${link}.bak"
        mv "$link" "${link}.bak"
    fi
    ln -sf "$target" "$link"
    echo "✓ Enlace creado: $link -> $target"
}

# 1. Archivos en el HOME (~)
echo "--- Restaurando archivos del HOME ---"
restore_file ".zshrc" ".zshrc"
restore_file ".p10k.zsh" ".p10k.zsh"
restore_file ".tmux.conf" ".tmux.conf"
restore_file ".gitconfig" ".gitconfig"

# 2. Directorios en ~/.config/
echo "--- Restaurando directorios de ~/.config ---"
restore_dir ".config/caelestia" ".config/caelestia"
restore_dir ".config/caelestia-shell" ".config/caelestia-shell"
restore_dir ".config/kitty" ".config/kitty"
restore_dir ".config/fuzzel" ".config/fuzzel"
restore_dir ".config/nwg-displays" ".config/nwg-displays"
restore_dir ".config/gtk-3.0" ".config/gtk-3.0"
restore_dir ".config/gtk-4.0" ".config/gtk-4.0"
restore_dir ".config/qtengine" ".config/qtengine"
restore_dir ".config/zed" ".config/zed"
restore_dir ".config/nvim" ".config/nvim"
restore_dir ".config/Thunar" ".config/Thunar"

# 3. Archivos específicos en ~/.config/
echo "--- Restaurando archivos específicos de ~/.config ---"
restore_file ".config/cava/config" ".config/cava/config"
restore_file ".config/htop/htoprc" ".config/htop/htoprc"
restore_file ".config/nvtop/nvtop.colors" ".config/nvtop/nvtop.colors"
restore_file ".config/macchina/macchina.toml" ".config/macchina/macchina.toml"
restore_file ".config/dolphinrc" ".config/dolphinrc"
restore_file ".config/go/env" ".config/go/env"
restore_file ".config/git/ignore" ".config/git/ignore"
restore_file ".config/opencode/opencode.jsonc" ".config/opencode/opencode.jsonc"
restore_file ".config/QtProject.conf" ".config/QtProject.conf"
restore_file ".config/hyfetch.json" ".config/hyfetch.json"
restore_file ".config/kwinrulesrc" ".config/kwinrulesrc"
restore_file ".config/kdeglobals" ".config/kdeglobals"
restore_file ".config/arkrc" ".config/arkrc"
restore_file ".config/mimeapps.list" ".config/mimeapps.list"
restore_file ".config/user-dirs.dirs" ".config/user-dirs.dirs"
restore_file ".config/user-dirs.locale" ".config/user-dirs.locale"
restore_file ".config/qalculate/qalc.cfg" ".config/qalculate/qalc.cfg"

# 4. Configuraciones de Editores de Código
echo "--- Restaurando configuraciones de Editores ---"
restore_file ".config/Code/User/settings.json" ".config/Code/User/settings.json"
restore_file ".config/Code/User/keybindings.json" ".config/Code/User/keybindings.json"
restore_dir ".config/Code/User/snippets" ".config/Code/User/snippets"

restore_file ".config/Cursor/User/settings.json" ".config/Cursor/User/settings.json"
restore_file ".config/Cursor/User/keybindings.json" ".config/Cursor/User/keybindings.json"
restore_dir ".config/Cursor/User/snippets" ".config/Cursor/User/snippets"

restore_file ".config/lapce-stable/settings.toml" ".config/lapce-stable/settings.toml"
restore_file ".config/lapce-stable/keymaps.toml" ".config/lapce-stable/keymaps.toml"

# 5. Caelestia Desktop Distribution (.local/share/caelestia)
echo "--- Restaurando caelestia local share (distribución completa) ---"
restore_dir ".local/share/caelestia" ".local/share/caelestia"

# 6. Recrear enlaces simbólicos requeridos para Caelestia
echo "--- Configurando enlaces simbólicos de Caelestia ---"
create_symlink "$HOME/.local/share/caelestia/hypr" "$HOME/.config/hypr"
create_symlink "$HOME/.local/share/caelestia/btop" "$HOME/.config/btop"
create_symlink "$HOME/.local/share/caelestia/fastfetch" "$HOME/.config/fastfetch"
create_symlink "$HOME/.local/share/caelestia/fish" "$HOME/.config/fish"
create_symlink "$HOME/.local/share/caelestia/foot" "$HOME/.config/foot"

# 7. Lanzadores de aplicaciones locales (.desktop)
echo "--- Restaurando lanzadores de aplicaciones (.desktop) ---"
restore_dir ".local/share/applications" ".local/share/applications"

# 8. Cargar configuración de dconf (GSettings)
if [ -f "$BACKUP_DIR/dconf_backup.ini" ]; then
    if command -v dconf >/dev/null 2>&1; then
        echo "--- Restaurando base de datos dconf ---"
        dconf load / < "$BACKUP_DIR/dconf_backup.ini"
        echo "✓ Base de datos dconf importada"
    else
        echo "⚠ dconf no está instalado en el sistema. Omitiendo importación."
    fi
else
    echo "⚠ No se encontró dconf_backup.ini en el respaldo."
fi

# 9. Autoinstalación de plugins faltantes (Zsh y Tmux)
echo "--- Verificando gestores de plugins y dependencias ---"

# Oh-My-Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Clonando plugins de Zsh si faltan..."
    
    # zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        echo "✓ zsh-autosuggestions instalado"
    fi
    # zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        echo "✓ zsh-syntax-highlighting instalado"
    fi
    # zsh-history-substring-search
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
        git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
        echo "✓ zsh-history-substring-search instalado"
    fi
    # fzf-tab
    if [ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ]; then
        git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"
        echo "✓ fzf-tab instalado"
    fi
    # powerlevel10k
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
        echo "✓ powerlevel10k instalado"
    fi
else
    echo "⚠ oh-my-zsh no está instalado en este sistema. Omitiendo instalación de plugins de Zsh."
fi

# Tmux Plugin Manager (TPM)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Instalando Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    echo "✓ TPM instalado. Abre tmux y presiona 'Prefix + I' para instalar los plugins."
fi

echo "=== Restauración Completada Exitosamente ==="
