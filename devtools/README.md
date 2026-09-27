# Herramientas de desarrollo

Git y mise (gestor de versiones de herramientas).

## Qué contiene

| Archivo | Destino | Propósito |
|---|---|---|
| `.config/git/config` | `~/.config/git/config` | Configuración global de Git |
| `.config/git/allowed_signers` | `~/.config/git/allowed_signers` | Clave pública SSH autorizada para verificar firmas |

La configuración de mise (`~/.config/mise/config.toml`) ya no se rastrea en
este repo: las herramientas que gestiona se listan por nombre en
`packages/mise.txt` y se instalan a mano una por una (ver más abajo), en vez
de copiar el archivo de configuración generado.

## Personalizaciones

- **Firma de commits por SSH**: `commit.gpgsign = true`, `tag.gpgsign = true`,
  `gpg.format = ssh`, `user.signingkey = ~/.ssh/id_ed25519.pub`,
  `gpg.ssh.allowedSignersFile = ~/.config/git/allowed_signers`.
  `allowed_signers` solo contiene material de clave pública (verificado
  antes de copiarlo), pero **la clave privada `~/.ssh/id_ed25519` no está
  en este repo** — sin restaurarla primero, cualquier commit fallará al
  intentar firmarse. Ver `docs/02-instalacion-desde-cero.md`, Fase 1.
- Alias cortos (`co`, `br`, `ci`, `st`), rebase por defecto en `pull`,
  `push.autoSetupRemote = true`, diff con algoritmo `histogram` y
  detección de bloques movidos, `rerere` habilitado.
- Credenciales de GitHub/Gist vía `gh auth git-credential` (no hay tokens
  guardados en el archivo).
- **mise**: gestiona `claude`, `codex`, `opencode`, `pi` y `node`, siempre en
  su última versión — ninguna herramienta gestionada por mise queda
  pinneada a una versión concreta (ver política en `README.md`). La lista de
  nombres vive en `packages/mise.txt`; el archivo de configuración que mise
  genera (`~/.config/mise/config.toml`) no se rastrea en este repo.

## Instalación manual

Restaurar `~/.ssh/id_ed25519` **antes** del primer commit firmado (ver
`docs/01-antes-de-formatear.md` y Fase 1 de
`docs/02-instalacion-desde-cero.md`). Repo clonado en
`~/Repositories/Dots-files`.

```bash
mkdir -p ~/.config/git
cp ~/.config/git/config ~/.config/git/config.orig 2>/dev/null
cp ~/Repositories/Dots-files/devtools/.config/git/config ~/.config/git/config
cp ~/Repositories/Dots-files/devtools/.config/git/allowed_signers ~/.config/git/allowed_signers
```

`mise` en sí llega por `packages/pacman.txt` (ver `packages/README.md`).
Instalar cada herramienta listada en `packages/mise.txt`, una por una,
siempre en su última versión (sintaxis verificada con `mise use --help`):

```bash
mise use -g claude@latest
mise use -g codex@latest
mise use -g node@latest
mise use -g opencode@latest
mise use -g pi@latest
```

## Cómo verificar

```bash
git config --get commit.gpgsign
mise --version
git commit --allow-empty -m "test: verificar firma" && git log --show-signature -1
```

## Dependencias

- `git`, `mise` (`packages/pacman.txt`).
- `~/.ssh/id_ed25519` (par de claves SSH) restaurado desde fuera de este
  repo — nunca se copian claves privadas aquí.
