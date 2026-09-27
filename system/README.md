# Archivos de sistema

Copias de solo lectura de archivos bajo `/etc`. Requieren `sudo` para
aplicarse, por eso viven aparte de los módulos de `$HOME` y se restauran a
mano, uno por uno.

## Qué contiene

| Archivo | Qué hace | Comando manual |
|---|---|---|
| `etc/modprobe.d/alsa-fix.conf` | Fuerza el modelo `asus-headphone-mic2` para `snd_hda_intel` (jack de auriculares/mic) | `sudo cp system/etc/modprobe.d/alsa-fix.conf /etc/modprobe.d/` |
| `etc/modprobe.d/disable-usb-autosuspend.conf` | Desactiva el autosuspend de USB (`usbcore autosuspend=-1`) | `sudo cp system/etc/modprobe.d/disable-usb-autosuspend.conf /etc/modprobe.d/` |
| `etc/modprobe.d/hid_apple.conf` | `fnmode=2` para teclados con driver `hid_apple` | `sudo cp system/etc/modprobe.d/hid_apple.conf /etc/modprobe.d/` |
| `etc/modprobe.d/nvidia.conf` | Habilita KMS temprano de NVIDIA (`nvidia_drm modeset=1`) | `sudo cp system/etc/modprobe.d/nvidia.conf /etc/modprobe.d/` |
| `etc/modprobe.d/supergfxd.conf` | Generado por `supergfxd`: bloquea `nouveau` y fija `nvidia-drm modeset=1` para el cambio de gráficos híbridos | `sudo cp system/etc/modprobe.d/supergfxd.conf /etc/modprobe.d/` |
| `etc/sysctl.d/99-sysctl.conf` | `net.ipv4.tcp_mtu_probing=1` | `sudo cp system/etc/sysctl.d/99-sysctl.conf /etc/sysctl.d/` |
| `etc/systemd/system/cups-browsed.service.d/10-omarchy.conf` | Drop-in de Omarchy sobre `cups-browsed.service` | `sudo mkdir -p /etc/systemd/system/cups-browsed.service.d && sudo cp system/etc/systemd/system/cups-browsed.service.d/10-omarchy.conf /etc/systemd/system/cups-browsed.service.d/` |
| `etc/systemd/system/docker.service.d/no-block-boot.conf` | Evita que Docker bloquee el arranque | `sudo mkdir -p /etc/systemd/system/docker.service.d && sudo cp system/etc/systemd/system/docker.service.d/no-block-boot.conf /etc/systemd/system/docker.service.d/` |
| `etc/systemd/system/plocate-updatedb.service.d/ac-only.conf` | Restringe la reindexación de `plocate` a cuando hay corriente (AC) | `sudo mkdir -p /etc/systemd/system/plocate-updatedb.service.d && sudo cp system/etc/systemd/system/plocate-updatedb.service.d/ac-only.conf /etc/systemd/system/plocate-updatedb.service.d/` |
| `etc/systemd/system/user@.service.d/10-faster-shutdown.conf`, `faster-shutdown.conf` | Acortan el tiempo de apagado de las sesiones de usuario | `sudo mkdir -p /etc/systemd/system/user@.service.d && sudo cp system/etc/systemd/system/user@.service.d/*.conf /etc/systemd/system/user@.service.d/` |
| `etc/limine-entry-tool.conf` | Configuración de `limine-entry-tool` (genera la entrada de arranque de Limine) | `sudo cp system/etc/limine-entry-tool.conf /etc/limine-entry-tool.conf` |
| `etc/limine-snapper-sync.conf` | Configuración del hook que sincroniza entradas de Limine con snapshots de Snapper | `sudo cp system/etc/limine-snapper-sync.conf /etc/limine-snapper-sync.conf` |
| `kernel-cmdline.txt` | **Solo referencia** — línea de arranque capturada de `/proc/cmdline` en el equipo anterior | No se copia (ver más abajo) |

## Instalación manual

```bash
sudo cp system/etc/modprobe.d/*.conf /etc/modprobe.d/

sudo mkdir -p /etc/systemd/system/cups-browsed.service.d
sudo cp system/etc/systemd/system/cups-browsed.service.d/10-omarchy.conf /etc/systemd/system/cups-browsed.service.d/
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo cp system/etc/systemd/system/docker.service.d/no-block-boot.conf /etc/systemd/system/docker.service.d/
sudo mkdir -p /etc/systemd/system/plocate-updatedb.service.d
sudo cp system/etc/systemd/system/plocate-updatedb.service.d/ac-only.conf /etc/systemd/system/plocate-updatedb.service.d/
sudo mkdir -p /etc/systemd/system/user@.service.d
sudo cp system/etc/systemd/system/user@.service.d/*.conf /etc/systemd/system/user@.service.d/

sudo cp system/etc/limine-entry-tool.conf /etc/limine-entry-tool.conf
sudo cp system/etc/limine-snapper-sync.conf /etc/limine-snapper-sync.conf
sudo cp system/etc/sysctl.d/99-sysctl.conf /etc/sysctl.d/99-sysctl.conf
```

Después de copiar, regenerar lo que cada grupo de archivos afecta:

```bash
sudo mkinitcpio -P           # los modprobe.d de NVIDIA tocan KMS temprano
sudo systemctl daemon-reload # los drop-ins de systemd
sudo sysctl --system         # el archivo de sysctl.d
sudo limine-update           # regenera la entrada de arranque de Limine
```

**`kernel-cmdline.txt` es solo referencia, no se copia literalmente.** Los
valores marcados `[REDACTADO]` (`cryptdevice=PARTUUID=...`,
`resume_offset=...`) son específicos del disco cifrado del equipo anterior;
Limine y el hook de `mkinitcpio` los regeneran automáticamente en la
instalación nueva.

## Cómo verificar

```bash
bat /etc/modprobe.d/nvidia.conf   # coincide con system/etc/modprobe.d/nvidia.conf
systemctl daemon-reload; echo $?  # 0
sysctl net.ipv4.tcp_mtu_probing   # = 1
```

## Dependencias

- `sudo`.
- `mkinitcpio`, `limine-update` (parte de la instalación base de Omarchy con Limine).

## Notas

Estos archivos requieren `sudo` y tocan `/etc`, fuera del alcance de
cualquier módulo bajo `$HOME`; por eso se documentan y aplican aparte.
