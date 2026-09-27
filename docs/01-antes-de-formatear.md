# Antes de formatear

Checklist a ejecutar, en orden, antes de reinstalar el sistema.

## Quick path

1. Refrescar el repo a mano, módulo por módulo (ver abajo)
2. Revisar con `git status` y `git diff`
3. Buscar secretos antes de commitear (comando abajo)
4. `cd ~/Repositories/Dots-files && git add -A && git commit -m "backup: estado antes de formatear" && git push`
5. Verificar el push: `git log origin/main -1` debe coincidir con `git log -1`
6. Exportar todo lo que NO está en git (tabla abajo)
7. Verificación final (al fondo de este documento)

## Refrescar el repo a mano, módulo por módulo

No hay script de backup: por cada módulo, copiar del sistema vivo hacia el
repo con `cp`/`cp -r` (mismo sentido que "Instalación manual", pero al
revés). Ejemplo para los cinco módulos con más cambio habitual:

```bash
cd ~/Repositories/Dots-files
cp -r ~/.config/hypr/. hyprland/.config/hypr/
cp ~/.config/alacritty/alacritty.toml alacritty/.config/alacritty/alacritty.toml
cp -r ~/.config/omarchy/. bar/.config/omarchy/       # cuidado: bar/ solo rastrea un subconjunto, revisar git status después
cp -r ~/.config/omarchy/backgrounds/. wallpapers/.config/omarchy/backgrounds/
cp -r ~/.config/omarchy/themes/. theme/.config/omarchy/themes/
```

Repetir el patrón (`cp` del destino real hacia la ruta del módulo en el
repo) para el resto de módulos, usando la tabla "Qué contiene" de cada
README como guía de qué archivos pertenecen a cada uno.

```bash
git status   # confirma qué archivos nuevos/modificados detecta
git diff     # revisa el contenido de cada cambio antes de commitear
```

## Buscar secretos antes de commitear

```bash
git diff --cached | rg -n 'BEGIN (RSA|OPENSSH|PGP|EC|DSA) PRIVATE KEY|-----BEGIN CERTIFICATE-----|ghp_[A-Za-z0-9]{20,}|gho_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{20,}|xox[baprs]-[A-Za-z0-9-]{10,}'
```
Debe salir sin coincidencias. Cualquier resultado real (no un placeholder de
documentación) se retira del stage antes de commitear.

## Qué NO está en git y dónde vive

| Qué | Ubicación | Acción antes de formatear |
|---|---|---|
| Llaves SSH | `~/.ssh` | Copiar la carpeta completa a un medio externo o gestor de secretos. Nunca a git. |
| Llaves GPG | `~/.gnupg` | `gpg --export-secret-keys --armor > gpg-secret.asc` y guardar fuera del equipo; luego borrar ese archivo temporal. |
| 1Password | — | Confirmar que la cuenta está sincronizada en la nube (Settings → Sync) antes de formatear; no depende de archivos locales. |
| Perfiles de navegador | `~/.config/zen-browser`, `~/.config/chromium`, etc. | Confirmar que Zen Browser / Chromium tienen sync activo, o exportar marcadores/contraseñas manualmente. |
| Base de datos MariaDB | servicio `mariadb.service` | `mysqldump --all-databases -u root -p > mariadb-dump.sql` y guardar fuera del repo (contiene datos, no solo estructura). |
| Base de datos MongoDB | servicio `mongodb.service` | `mongodump --out ~/mongodb-dump/` y guardar fuera del repo. |
| Repositorios con cambios sin subir | `~/Projects`, `~/Work`, `~/Repositories` | Detectar con el comando de abajo y resolver cada uno (commit + push, o descartar conscientemente). |
| Datos de juegos | Dofus (`~/Applications/Dofus.AppImage` y su carpeta de saves), Minecraft (PrismLauncher) | Confirmar que el guardado usa la nube del propio juego, o copiar las carpetas de saves manualmente. |
| `~/Documents`, `~/Downloads`, `~/Pictures` | rutas de usuario | Revisar y copiar lo que no esté ya respaldado en otro lugar (nube, disco externo). |

### Detectar repos con trabajo sin subir

```bash
for d in $(fd -H -t d '^\.git$' ~/Projects ~/Work ~/Repositories -d 5 2>/dev/null); do
  repo=$(dirname "$d")
  cd "$repo"
  dirty=$(git status --porcelain)
  unpushed=$(git log @{u}.. --oneline 2>/dev/null)
  if [ -n "$dirty" ] || [ -n "$unpushed" ]; then
    echo "=== $repo ==="
    [ -n "$dirty" ] && echo "  cambios sin commitear"
    [ -n "$unpushed" ] && echo "  commits sin push: $(echo "$unpushed" | wc -l)"
  fi
  cd - >/dev/null
done
```

## Verificación final

- [ ] Cada módulo que cambió se refrescó a mano y `git diff` se revisó
- [ ] El comando de búsqueda de secretos no reportó coincidencias
- [ ] El commit del backup está pusheado (`git log origin/main -1` == `git log -1`)
- [ ] SSH y GPG están respaldados fuera de este equipo
- [ ] MariaDB y MongoDB tienen dump exportado (si tenían datos que importaban)
- [ ] Ningún repo bajo `~/Projects`, `~/Work`, `~/Repositories` tiene cambios sin subir sin que sea intencional
- [ ] `~/Documents`, `~/Downloads`, `~/Pictures` revisados

## Siguiente paso

Formatear, instalar Omarchy, y seguir [docs/02-instalacion-desde-cero.md](02-instalacion-desde-cero.md).
