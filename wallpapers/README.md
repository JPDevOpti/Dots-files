# Fondos de pantalla

Fondos personalizados del usuario, separados de los fondos que trae cada
tema (esos viven dentro de `theme/`, en la propia carpeta de cada tema).

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.config/omarchy/backgrounds/arc-blueberry/` | `~/.config/omarchy/backgrounds/arc-blueberry/` | Set de fondos personalizado |
| `.config/omarchy/backgrounds/catppuccin/` | `~/.config/omarchy/backgrounds/catppuccin/` | Set de fondos personalizado |
| `.config/omarchy/backgrounds/tokyo-night/` | `~/.config/omarchy/backgrounds/tokyo-night/` | Set de fondos personalizado |

## Personalizaciones

Tres sets de fondos guardados por el usuario en
`~/.config/omarchy/backgrounds/` (2.0M en total), fuera de los fondos que
cada tema trae en su propia carpeta (`~/.config/omarchy/themes/<tema>/backgrounds/`).

## Cómo se selecciona y cambia el fondo activo

Comandos reales, confirmados con `omarchy commands`:

```bash
omarchy theme bg current      # muestra el fondo activo
omarchy theme bg next         # pasa al siguiente fondo del tema activo
omarchy theme bg set <ruta>   # fija un fondo concreto
omarchy theme bg-switcher     # abre el selector visual de fondos
omarchy theme bg install      # abre la carpeta de fondos de usuario del tema activo
omarchy theme bg cache        # regenera las miniaturas del selector
```

## Relación entre fondos de tema y fondos de usuario

Cada tema (`~/.config/omarchy/themes/<tema>/backgrounds/`) trae su propio
set de fondos "de fábrica". Los fondos de este módulo
(`~/.config/omarchy/backgrounds/`) son sets adicionales, independientes del
tema activo, que aparecen junto a los del tema en el selector
(`omarchy theme bg-switcher`).

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`.

```bash
cp -r ~/.config/omarchy/backgrounds ~/.config/omarchy/backgrounds.orig 2>/dev/null
mkdir -p ~/.config/omarchy/backgrounds
cp -r ~/Repositories/Dots-files/wallpapers/.config/omarchy/backgrounds/. ~/.config/omarchy/backgrounds/
omarchy theme bg-switcher   # para elegir uno tras restaurar
```

## Cómo verificar

```bash
omarchy theme bg current
```

## Dependencias

- Ninguna aparte del propio Omarchy (`omarchy theme bg*`).
