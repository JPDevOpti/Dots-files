# Shell

Bash y el prompt Starship.

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.bashrc` | `~/.bashrc` | Configuración interactiva de Bash |
| `.bash_profile` | `~/.bash_profile` | Se carga en shells de login |
| `.config/starship.toml` | `~/.config/starship.toml` | Prompt Starship |

## Personalizaciones

- `.bashrc` respeta `/etc/omarchy.conf` (escrito por `omarchy-dev-link`) si
  existe, y cae al valor por defecto del paquete si no — para no arrastrar
  un valor heredado y obsoleto.
- Starship: `add_newline = true`, `command_timeout = 500`. Formato de una
  línea: directorio, rama e info de git, duración del comando y el
  carácter de prompt en la línea siguiente. Carácter de éxito en cian
  negrita, de error en rojo negrita, de modo vi en verde negrita.
  Truncamiento de ruta a 3 niveles con `…/`.

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`.

```bash
cp ~/.bashrc ~/.bashrc.orig 2>/dev/null
cp ~/.bash_profile ~/.bash_profile.orig 2>/dev/null
cp ~/.config/starship.toml ~/.config/starship.toml.orig 2>/dev/null

cp ~/Repositories/Dots-files/shell/.bashrc ~/.bashrc
cp ~/Repositories/Dots-files/shell/.bash_profile ~/.bash_profile
mkdir -p ~/.config
cp ~/Repositories/Dots-files/shell/.config/starship.toml ~/.config/starship.toml

source ~/.bashrc
```

## Cómo verificar

```bash
starship --version
bash -n ~/.bashrc
```

## Dependencias

- Paquete `starship` (parte de Omarchy).
