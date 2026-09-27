# Editores

Neovim, Zed y VS Code.

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.config/nvim/` | `~/.config/nvim/` | Config de Neovim (basada en LazyVim) |
| `.config/zed/` | `~/.config/zed/` | Config de Zed |
| `.config/Code/User/settings.json` | `~/.config/Code/User/settings.json` | Ajustes de VS Code |
| `.config/Code/User/keybindings.json` | `~/.config/Code/User/keybindings.json` | Atajos de VS Code |
| `.config/Code/User/snippets/` | `~/.config/Code/User/snippets/` | Snippets de VS Code |

## Personalizaciones

- **Neovim**: distribución LazyVim (`lazyvim.json`, `lua/config/`,
  `lua/plugins/`). Personalizaciones propias en `lua/plugins/`:
  `all-themes.lua`, `disable-news-alert.lua`, `omarchy-theme-hotreload.lua`
  (recarga el tema de Neovim cuando cambia el tema de Omarchy),
  `snacks-animated-scrolling-off.lua`. `lazy-lock.json` **no** se rastrea
  en este repo (ver política de versiones en `README.md`): al restaurar,
  cada plugin se resuelve en su versión más reciente compatible.
- **VS Code**: solo se rastrean `settings.json`, `keybindings.json` y
  `snippets/` — no la carpeta completa de extensiones ni su caché.
- **Zed**: `settings.json` en `.config/zed/`; `SUPER + R` lo lanza como
  editor por defecto (ver `hyprland/README.md`).

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`.

```bash
cp -r ~/.config/nvim ~/.config/nvim.orig 2>/dev/null
mkdir -p ~/.config/nvim
cp -r ~/Repositories/Dots-files/editors/.config/nvim/. ~/.config/nvim/

cp -r ~/.config/zed ~/.config/zed.orig 2>/dev/null
mkdir -p ~/.config/zed
cp -r ~/Repositories/Dots-files/editors/.config/zed/. ~/.config/zed/

mkdir -p ~/.config/Code/User
cp ~/.config/Code/User/settings.json ~/.config/Code/User/settings.json.orig 2>/dev/null
cp ~/.config/Code/User/keybindings.json ~/.config/Code/User/keybindings.json.orig 2>/dev/null
cp ~/Repositories/Dots-files/editors/.config/Code/User/settings.json ~/.config/Code/User/settings.json
cp ~/Repositories/Dots-files/editors/.config/Code/User/keybindings.json ~/.config/Code/User/keybindings.json
```
Abrir Neovim una vez para que `lazy.nvim` resuelva e instale los plugins.

## Cómo verificar

```bash
nvim --version
zed --version
code --version
```

## Dependencias

- Paquetes `neovim`, `zed` (ver `manifests/standalone-tools.md` para
  cómo se instaló `zed`), `visual-studio-code-bin` (`packages/aur.txt`).
- Conectividad a internet para que `lazy.nvim` descargue los plugins.
