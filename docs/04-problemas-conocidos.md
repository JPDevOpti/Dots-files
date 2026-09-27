# Problemas conocidos

Solo hechos verificados en este equipo o ya establecidos como decisiones
tomadas conscientemente. No es una lista de bugs abiertos de Omarchy.

## 1. `hyprmoncfgd` conflictúa con DofusTabs y el manejo de monitores

El daemon del plugin `crmne.hyprmoncfg` (`hyprmoncfgd.service`, usuario)
genera `hyprland/.config/hypr/hyprmoncfg-monitors.lua` y `hyprland.lua` lo
carga al final para que nada anterior lo pise. DofusTabs
(`hyprland/.config/hypr/dofustabs.lua`) **nunca** debe tocar `hl.monitor` —
hacerlo reintroduce el conflicto que causó comportamiento errático de
monitores y ventanas al usarlo junto con este daemon. Ver también
`monitors/README.md`.

## 2. El espejado de pantalla rompe la barra y el fondo (layout de casa)

En el layout de tres monitores en casa, poner un monitor en modo espejo
(`mirror`) rompe la barra de Omarchy y el fondo de pantalla. Usar siempre
`~/.config/hypr/scripts/monitors-home.sh` (atajo `SUPER + D`) en vez de
espejar manualmente con `hyprctl` o `nwg-displays`.

## 3. Cancelación de eco de PipeWire, revertida

Se probó cancelación de eco/ruido por WebRTC AEC en PipeWire para el
micrófono, pero bloqueaba el micrófono Bluetooth de los Nothing Ear. Se
revirtió (ver historial de commits: "revert: eliminar echo-cancel"). No
reactivar esa configuración sin verificar primero que el micrófono
Bluetooth sigue funcionando.

## 4. Zen Browser excluido de la transparencia global de ventanas

Las reglas de transparencia de ventana a nivel global no se aplican a Zen
Browser — se excluyó explícitamente porque afectaba la legibilidad del
navegador.

## 5. El widget de monitor de hardware está fijado a la GPU NVIDIA

`meviusisback.hw-monitor` (widget de la barra) tiene `showGpu: true` fijado
a la GPU NVIDIA de forma explícita, no a la iGPU AMD — en un equipo con
gráficos híbridos, sin fijarlo el widget podría mostrar la GPU equivocada
según cuál esté activa en un momento dado.

## Pendiente de decisión

- **Kernel vanilla `linux` junto a `linux-omarchy`**: no se ha decidido si
  mantener ambos kernels instalados en la próxima instalación o quedarse
  solo con `linux-omarchy`.
- **Origen de instalación de `engram`**: el binario en `~/.local/bin/engram`
  es un ELF estático sin metadatos de paquete; no se pudo determinar con
  evidencia de este equipo si se instaló por script, descarga manual o
  builder propio. Ver `manifests/standalone-tools.md`.
