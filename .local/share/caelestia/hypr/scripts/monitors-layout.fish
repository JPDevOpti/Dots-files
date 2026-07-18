#!/usr/bin/env fish
# Applies the canonical 3-monitor layout:
#   [ HKC 27E3Q 2560x1440 (izq) ][ Samsung 1920x1080 (der) ]
#                                 [ eDP-1 1920x1200@144 ]  (debajo de la derecha)
# Se direcciona por `desc:` porque los nombres de puerto cambian entre arranques
# (DP-2/DP-7). Las tres pantallas tienen desc/serial distintos, asi que no colisionan.

hyprctl --batch "\
keyword monitor desc:HKC OVERSEAS LIMITED 27E3Q 0000000000001,2560x1440@59.95,0x0,1.0 ; \
keyword monitor desc:Samsung Electric Company S22F350 H4ZN200586,1920x1080@60.16,2560x0,1.0 ; \
keyword monitor desc:China Star Optoelectronics Technology Co. Ltd MNG007QX2-1,1920x1200@144.0,2560x1080,1.0"

notify-send -a "Hyprland" "Monitors" "Layout aplicado: HKC 2K (izq) | Samsung (der)  /  laptop debajo der."
