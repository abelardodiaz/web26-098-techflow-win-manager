# CLAUDE.md - TechFlow Win Manager (web26-098)

Repo publico. No escribir aqui rutas de servidores, nombres de clientes ni nada privado.

## Que es

Toolkit modular de soporte IT para Windows 10/11 en PowerShell: backup de perfiles, drivers,
red, seguridad, mantenimiento, paquetes (winget/choco), usuarios y operaciones destructivas
protegidas. 17 opciones de menu sobre 10 modulos. Obra derivada (MIT) de
LUISFGARCIAE/TechFlow_Suite_Pro; ver `NOTICE` y `LICENSE`.

## Estructura

```
Launch-TechFlow.cmd   entrada (resuelve ExecutionPolicy)
Start-TechFlow.ps1    script principal
TechFlow.psd1         manifiesto; carga los submodulos con NestedModules
config/               techflow.config.json, apps-catalog.json
modules/              Core Backup Packages System Security Network Maintenance Users Drivers DangerZone
extras/               herramientas anexas (administracion-win11)
tests/                Pester (Core.Tests.ps1)
legacy/               script monolitico original (solo referencia)
vendor/ logs/         locales, no versionados
```

Guias: `README.md`, `DEV-GUIDE.md` (convenciones y tabla de modulos), `PLAN-ARQUITECTURA.md`.

## Comandos

```powershell
./Launch-TechFlow.cmd
powershell -NoProfile -ExecutionPolicy Bypass -File Start-TechFlow.ps1   # requiere administrador
Invoke-Pester ./tests/
```

## Reglas de codigo (resumen de DEV-GUIDE.md)

- Solo PowerShell 5.1: nada de `?.`, `??` ni ternario.
- Sin emojis en scripts (problemas de codificacion en Windows PowerShell).
- Todo input del usuario pasa por las funciones `Assert-TF*` antes de usarse.
- Operaciones destructivas requieren `Confirm-TFDangerousAction`.
- Nunca `Invoke-Expression` sobre contenido remoto: descargar a temporal, registrar SHA256, confirmar, ejecutar.
- Config y JSON se leen y escriben con `[System.IO.File]` en UTF-8, no con `Out-File`.
- Rutas relativas a `$PSScriptRoot` (portable en USB).
- Nunca guardar contrasenas en texto plano; no versionar `.env`, `logs/` ni `vendor/`.

## Politica de upstream

- NO abrir PRs ni issues en el repositorio original. Se crece por cuenta propia.
- SIEMPRE atribuir la autoria original (README, NOTICE, LICENSE, cualquier difusion).
- SI portar novedades del upstream revisandolo de vez en cuando. Divergieron (upstream monolitico,
  este modular): se porta a `modules/`, no se hace merge.

## PROJECT.yaml

Al cambiar la version actualizar `project.version`; siempre actualizar `updated_at` y
`updated_by: claude-098`. No tocar `project.code`.

## Remotos

`github` y `origin` (GitLab). Pushear la rama actual (`main`) a los dos, uno por uno:
`git push github main && git push origin main`.
