#!/usr/bin/env fish
# Applies the work 3-monitor layout:
#   [ E24-40 1920x1080 (arriba) ][ LEN-A560-B 1920x1080 (arriba-der) ]
#   [ eDP-1 1920x1200@144 ]                                  (debajo del E24-40)
# Se direcciona por `desc:` porque los nombres de puerto cambian entre arranques
# (DP-2/DP-7/HDMI-A-1). Las tres pantallas tienen desc/serial distintos, asi que no colisionan.

hyprctl --batch "\
keyword monitor desc:Lenovo Group Limited E24-40 V30FYW0M,1920x1080@60.00,0x0,1.0 ; \
keyword monitor desc:Lenovo Group Limited LEN-A560-B LM238WF2-SSM1,1920x1080@60.16,1920x0,1.0 ; \
keyword monitor desc:China Star Optoelectronics Technology Co. Ltd MNG007QX2-1,1920x1200@144.0,0x1080,1.0"

notify-send -a "Hyprland" "Monitors" "Layout trabajo aplicado: E24-40 (arriba) | LEN-A560-B (arriba-der)  /  laptop debajo izq."
