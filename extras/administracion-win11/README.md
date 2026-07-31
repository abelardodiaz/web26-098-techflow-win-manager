# Extras — Administracion de Windows 11

Scripts y notas de administracion de Windows 11 que **no forman parte del menu de TechFlow**.
Viven aqui porque son del mismo dominio y no tenia sentido mantener un proyecto aparte para
ellos.

## Procedencia

Esto era el proyecto **web26-896 "Administracion Windows 11"** (v0.2.0), un repo propio con
scripts de PowerShell para la maquina de trabajo. Se fusiono aqui el **2026-07-30** durante la
homologacion de la flota en 996: era demasiado pequeno para justificar proyecto propio y su
dominio es exactamente el de TechFlow.

El proyecto 896 quedo retirado. Su historial esta en `CHANGELOG-896.md`.

## Contenido

| Archivo | Que es |
|---|---|
| `configurar_windows_update.ps1` | Control de Windows Update (pausa, diferimiento, politicas) |
| `docs/powershell-7-vs-5.md` | Diferencias practicas entre PowerShell 5.1 y 7, y cual usar segun el caso |
| `docs/REGLAS-DOCUMENTACION.md` | Convenciones de documentacion que seguia 896 |
| `logs-diagnostico.txt` | Caso real: diagnostico de un reinicio inesperado (13-ene-2026). Resulto ser TrustedInstaller aplicando una actualizacion planeada. Se conserva como ejemplo de como leer el visor de eventos para este tipo de incidente |
| `CHANGELOG-896.md` | Historial del proyecto original |

## Reglas al tocar estos scripts

- **Sin emojis.** Se corren en PowerShell de Windows y dan problemas de codificacion. Aplica a
  todo el repo, pero aqui se repite porque es donde nacio la regla.
- **Modifican el sistema operativo real.** No los ejecutes sin leerlos primero.
- `configurar_windows_update.ps1` toca politicas de actualizacion: entiende que hace antes de
  correrlo en una maquina que no sea de pruebas.

## Relacion con el toolkit principal

TechFlow tiene su propio modulo `Maintenance/` dentro de `modules/`. Si alguna de estas piezas
madura o se usa seguido, el siguiente paso natural es promoverla a un submodulo formal del menu
en vez de dejarla en `extras/`.
