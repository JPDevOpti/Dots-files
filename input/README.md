# Dispositivos de entrada

Ratón Logitech MX Master 3S, distribución de teclado (fcitx5) y
dictado por voz (voxtype).

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.config/solaar/` | `~/.config/solaar/` | Gestor de dispositivos Logitech (MX Master 3S) |
| `.config/fcitx5/` | `~/.config/fcitx5/` | Motor de métodos de entrada / distribuciones de teclado |
| `.config/voxtype/config.toml` | `~/.config/voxtype/config.toml` | Dictado por voz |

## Personalizaciones

- El MX Master 3S se gestiona con `solaar` (visible/oculto según
  `hyprland/.config/hypr/autostart.lua`, que lo arranca oculto:
  `solaar --window=hide`) y con `logiops` (paquete AUR, sin archivo de
  configuración de usuario en este repo — revisar `/etc/logid.cfg` si
  existía una config del sistema para gestos/DPI, fuera del alcance de
  este backup).
- El scroll horizontal del ratón está remapeado a navegación de
  workspaces/pestañas de Dofus en `hyprland/.config/hypr/bindings.lua`.
- `voxtype` expone un archivo de estado para integraciones externas
  (barra, etc.), configurable a `auto`, una ruta personalizada, o
  `disabled`.

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`.

```bash
cp -r ~/.config/solaar ~/.config/solaar.orig 2>/dev/null
mkdir -p ~/.config/solaar
cp -r ~/Repositories/Dots-files/input/.config/solaar/. ~/.config/solaar/

cp -r ~/.config/fcitx5 ~/.config/fcitx5.orig 2>/dev/null
mkdir -p ~/.config/fcitx5
cp -r ~/Repositories/Dots-files/input/.config/fcitx5/. ~/.config/fcitx5/

mkdir -p ~/.config/voxtype
cp ~/.config/voxtype/config.toml ~/.config/voxtype/config.toml.orig 2>/dev/null
cp ~/Repositories/Dots-files/input/.config/voxtype/config.toml ~/.config/voxtype/config.toml
systemctl --user restart voxtype 2>/dev/null || true
```

## Cómo verificar

```bash
solaar --version
fcitx5 -version
```

## Dependencias

- Paquetes `solaar`, `logiops`, `voxtype-bin` (`packages/pacman.txt` y
  `packages/aur.txt`).
- Servicio de usuario `voxtype.service` (ver `manifests/services.txt` y
  `services/README.md`).
