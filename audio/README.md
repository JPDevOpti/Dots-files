# Audio

Configuración de WirePlumber (gestor de sesión de PipeWire).

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.config/wireplumber/` | `~/.config/wireplumber/` | Reglas de WirePlumber |

## Personalizaciones

`~/.config/pipewire/` en este equipo solo contiene un directorio
`pipewire.conf.d` sin archivos dentro (0 archivos) — no se copia, no hay
nada que restaurar ahí. Toda la personalización de audio vive en
WirePlumber. Ver `docs/04-problemas-conocidos.md`: la cancelación de eco
por WebRTC AEC se probó y se revirtió porque bloqueaba el micrófono
Bluetooth de los Nothing Ear — no reactivar sin verificar primero que el
micrófono Bluetooth sigue funcionando.

## Instalación manual

Repo clonado en `~/Repositories/Dots-files`.

```bash
cp -r ~/.config/wireplumber ~/.config/wireplumber.orig 2>/dev/null
mkdir -p ~/.config/wireplumber
cp -r ~/Repositories/Dots-files/audio/.config/wireplumber/. ~/.config/wireplumber/
systemctl --user restart wireplumber
```

## Cómo verificar

```bash
systemctl --user is-active wireplumber
wpctl status
```

## Dependencias

- Paquete `wireplumber` (parte de Omarchy/PipeWire).
