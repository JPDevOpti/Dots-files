# Paquetes

Listas planas de paquetes y herramientas instaladas en este equipo, por
gestor. Ninguna fija versión: todo se instala siempre en su última versión
disponible (ver la política en el [`README.md`](../README.md) raíz).

## Qué contiene

| Archivo | Gestor | Instalación manual |
|---|---|---|
| `pacman.txt` | pacman (vía Omarchy) | `omarchy pkg add <paquete>` |
| `aur.txt` | AUR (vía Omarchy) | `omarchy pkg aur add <paquete>` |
| `mise.txt` | mise | `mise use -g <herramienta>@latest` |
| `npm-global.txt` | npm (global, node vía mise) | `npm install -g <paquete>@latest` |

## Instalación manual

Un paquete suelto:

```bash
omarchy pkg add jq
omarchy pkg aur add zen-browser-bin
mise use -g claude@latest
npm install -g @colbymchenry/codegraph@latest
```

Toda la lista de un archivo, en una sola línea (comandos verificados con
`omarchy pkg --help`, `omarchy pkg add --help` y `omarchy pkg aur add --help`;
las líneas que empiezan por `#` en `mise.txt` y `npm-global.txt` son
comentarios y se omiten con `rg -v '^#'`):

```bash
omarchy pkg add $(< packages/pacman.txt)
omarchy pkg aur add $(< packages/aur.txt)

for tool in $(rg -v '^#' packages/mise.txt); do mise use -g "$tool@latest"; done
for pkg in $(rg -v '^#' packages/npm-global.txt); do npm install -g "$pkg@latest"; done
```

## Cómo verificar

```bash
omarchy pkg present $(< packages/pacman.txt)   # true si todos están instalados
omarchy pkg present $(< packages/aur.txt)
```

## Dependencias

- `omarchy` (para `omarchy pkg add`/`omarchy pkg aur add`).
- `mise` instalado (paquete `mise` en `pacman.txt`) antes de instalar las
  herramientas de `mise.txt`, y `node` (una de esas herramientas) antes de
  usar `npm install -g` para `npm-global.txt`.

## Notas

`devtools/README.md` documenta por qué `~/.config/mise/config.toml` ya no
se rastrea en este repo: la lista de nombres en `mise.txt` reemplaza al
archivo de configuración generado.
