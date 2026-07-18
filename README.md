# 🛠️ Mis Dotfiles - Arch Linux (Hyprland / Caelestia)

Este repositorio contiene las configuraciones personales (dotfiles) para mi entorno de escritorio en Arch Linux, administrado mediante Hyprland y la distribución **Caelestia**.

## 📁 Estructura del Repositorio

El repositorio está organizado reflejando la estructura de directorios del usuario (`$HOME`):

*   `.config/` - Archivos de configuración de aplicaciones (Kitty, Fuzzel, Thunar, cava, zed, nvim, etc.).
*   `.local/share/caelestia/` - La distribución completa de Caelestia, donde residen los scripts del sistema, configuraciones principales de Hyprland y configuraciones de atajos de teclado (`hypr/hyprland/keybinds.conf`).
*   `.local/share/applications/` - Lanzadores `.desktop` locales personalizados.
*   `.zshrc` y `.p10k.zsh` - Configuración de la shell Zsh con Powerlevel10k.
*   `.tmux.conf` - Configuración de Tmux con gestor de plugins (TPM).
*   `.gitconfig` - Configuración global de Git.
*   `dconf_backup.ini` - Volcado del registro GSettings (dconf) para almacenar atajos gráficos globales, configuraciones de ratón/teclado y preferencias del sistema.

---

## 🚀 Cómo Utilizar los Scripts

He incluido scripts automatizados para facilitar la sincronización y la instalación en nuevos equipos.

### 1. Hacer Copia de Seguridad (Backup)

Para actualizar tu copia de seguridad local con las configuraciones actuales del sistema, ejecuta desde la carpeta del repositorio:

```bash
chmod +x backup.sh
./backup.sh
```

El script se encargará de:
*   Copiar los archivos de configuración actualizados.
*   Ignorar carpetas temporales, de caché (`Cache`, `GPUCache`, etc.) y directorios `.git` internos para mantener el repositorio limpio.
*   Hacer un volcado de tu base de datos `dconf` a `dconf_backup.ini`.

Una vez termine, puedes hacer push a tu repositorio remoto:
```bash
git add .
git commit -m "update: copia de seguridad de dotfiles"
git push origin main
```

---

### 2. Restaurar Configuraciones (Restore)

Para aplicar las configuraciones de este repositorio en tu sistema actual (o en un equipo nuevo con Caelestia instalado):

```bash
chmod +x restore.sh
./restore.sh
```

*(O usa `./restore.sh --yes` para no pedir confirmación)*

El script se encargará de:
*   Copiar los dotfiles de vuelta a sus respectivas ubicaciones en `~` y `~/.config/`.
*   Restaurar la carpeta completa `~/.local/share/caelestia/`.
*   Recrear de forma segura los enlaces simbólicos de Caelestia (`~/.config/hypr`, `~/.config/fish`, `~/.config/foot`, `~/.config/fastfetch` y `~/.config/btop`).
*   Restaurar los lanzadores de aplicaciones locales (`.desktop`).
*   Importar las configuraciones gráficas usando `dconf`.
*   Clonar de manera automática los plugins necesarios de **Oh-My-Zsh** (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-history-substring-search`, `fzf-tab` y el tema `powerlevel10k`) y de **Tmux** (`TPM`) si no están instalados.
