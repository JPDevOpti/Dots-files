# Servicios de usuario

Unidades systemd de usuario y variables de entorno de sesión.

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.config/systemd/user/omarchy-spotify.service` | `~/.config/systemd/user/omarchy-spotify.service` | Unidad del plugin `quickshell.spotify` |
| `.config/systemd/user/openclaw-gateway.service` | `~/.config/systemd/user/openclaw-gateway.service` | Servicio de OpenClaw |
| `.config/systemd/user/openclaw-gateway.service.d/claude-cli-path.conf` | misma ruta | Drop-in: ruta del CLI de Claude para OpenClaw |
| `.config/systemd/user/voxtype.service` | `~/.config/systemd/user/voxtype.service` | Servicio de dictado por voz |
| `.config/environment.d/omarchy-firefox-wayland.conf` | `~/.config/environment.d/omarchy-firefox-wayland.conf` | Variables de entorno para Firefox en Wayland |

## Personalizaciones

- No se copian los directorios `*.wants/` (`default.target.wants`,
  `graphical-session.target.wants`, `graphical-session-pre.target.wants`,
  `timers.target.wants`) porque son symlinks que systemd regenera solo al
  habilitar cada unidad — no son configuración editable.
- El drop-in `openclaw-gateway.service.d/claude-cli-path.conf` sí se copia
  porque es una personalización real, no un symlink de systemd.

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`. Copiar las unidades y luego
habilitarlas una por una (ver `manifests/services.txt` para la lista
completa, de sistema y de usuario).

```bash
mkdir -p ~/.config/systemd/user ~/.config/systemd/user/openclaw-gateway.service.d ~/.config/environment.d
cp ~/Repositories/Dots-files/services/.config/systemd/user/omarchy-spotify.service ~/.config/systemd/user/omarchy-spotify.service
cp ~/Repositories/Dots-files/services/.config/systemd/user/openclaw-gateway.service ~/.config/systemd/user/openclaw-gateway.service
cp ~/Repositories/Dots-files/services/.config/systemd/user/openclaw-gateway.service.d/claude-cli-path.conf ~/.config/systemd/user/openclaw-gateway.service.d/claude-cli-path.conf
cp ~/Repositories/Dots-files/services/.config/systemd/user/voxtype.service ~/.config/systemd/user/voxtype.service
cp ~/Repositories/Dots-files/services/.config/environment.d/omarchy-firefox-wayland.conf ~/.config/environment.d/omarchy-firefox-wayland.conf

systemctl --user daemon-reload
systemctl --user enable --now omarchy-spotify.service openclaw-gateway.service voxtype.service
```

## Cómo verificar

```bash
systemctl --user list-unit-files | rg 'openclaw|voxtype|spotify'
```

## Dependencias

- Ver `manifests/services.txt` para la lista completa de servicios (de
  sistema y de usuario) que este equipo habilita fuera del default de
  Omarchy.
- `hyprmoncfgd.service` y `bt-agent.service` también aparecen en
  `manifests/services.txt` pero no tienen unidad de usuario propia en este
  módulo porque las instalan sus respectivos paquetes/plugins.
