# PowerShell 7 vs PowerShell 5.1 - Guia Completa

**Fecha:** 18 de marzo de 2026
**Aplica a:** Windows 11 Pro

---

## 1. Que son y donde viven

PowerShell tiene dos versiones que coexisten en Windows sin conflicto:

| Caracteristica | PowerShell 5.1 | PowerShell 7 |
|----------------|-----------------|--------------|
| Ejecutable | `powershell.exe` | `pwsh.exe` |
| Ubicacion | `C:\Windows\System32\WindowsPowerShell\v1.0\` | `C:\Program Files\PowerShell\7\` |
| Viene con Windows | Si, componente del sistema | No, instalacion separada |
| Se puede desinstalar | No | Si |
| Runtime | .NET Framework 4.8 | .NET 9 |
| Desarrollo | Modo mantenimiento (solo fixes de seguridad) | Desarrollo activo |
| Open source | No | Si (GitHub: PowerShell/PowerShell) |
| Perfil de usuario | `$HOME\Documents\WindowsPowerShell\` | `$HOME\Documents\PowerShell\` |

**Punto clave:** Son instalaciones independientes. Instalar PS7 no modifica ni reemplaza PS5.1. Cada una tiene su propio perfil, sus propios modulos, y su propio ejecutable.

---

## 2. Como arrancar cada uno

### PowerShell 7

- Escribir `pwsh` en cualquier terminal
- Menu Inicio > buscar "PowerShell 7"
- Windows Terminal > pestana "PowerShell" (si esta configurado como default)

### PowerShell 5.1

- Escribir `powershell` en cualquier terminal
- Menu Inicio > buscar "Windows PowerShell"
- Windows Terminal > pestana "Windows PowerShell"

### Verificar cual estas usando

```powershell
$PSVersionTable.PSVersion
```

Si dice `7.x.x` estas en PS7. Si dice `5.1.x` estas en PS5.1.

### Hacer PS7 el default en Windows Terminal

1. Abrir Windows Terminal
2. Settings (Ctrl+,)
3. Startup > Default profile > seleccionar "PowerShell" (el que dice pwsh, no "Windows PowerShell")
4. Guardar

---

## 3. Por que usamos PS7 por defecto

### 3.1 UTF-8 por defecto

PS7 usa UTF-8 como encoding por defecto. PS5.1 usa codepages del sistema (generalmente Windows-1252 o UTF-16LE con BOM).

Esto es critico para:
- **Claude Code**: requiere UTF-8 para funcionar correctamente
- **Scripts con caracteres especiales**: acentos, enyes, caracteres unicode
- **Interoperabilidad**: Git, Node.js, Python y la mayoria de herramientas modernas esperan UTF-8

### 3.2 Operadores nuevos

```powershell
# Null-coalescing (PS7)
$valor = $null ?? "default"

# Null-coalescing assignment (PS7)
$valor ??= "default"

# Operador ternario (PS7)
$resultado = ($condicion) ? "si" : "no"

# Pipeline chain (PS7)
comando1 && comando2    # comando2 solo si comando1 exitoso
comando1 || comando2    # comando2 solo si comando1 falla
```

En PS5.1 se necesitan if/else completos para lograr lo mismo.

### 3.3 ForEach-Object -Parallel

```powershell
# Procesar items en paralelo (PS7)
1..10 | ForEach-Object -Parallel {
    # Cada iteracion corre en su propio runspace
    Start-Sleep -Seconds 1
    "Procesado $_"
} -ThrottleLimit 5
```

No existe en PS5.1.

### 3.4 Mejor rendimiento general

PS7 sobre .NET 9 tiene mejoras significativas en:
- Tiempo de inicio
- Manejo de memoria
- Velocidad de ejecucion de scripts

### 3.5 Desarrollo activo

PS5.1 solo recibe parches de seguridad. PS7 recibe nuevas funcionalidades, mejoras de rendimiento y correcciones constantes.

---

## 4. Guia de troubleshooting: Cuando probar con PS5.1

Si algo falla en PS7, usa esta tabla para diagnosticar:

| Sintoma | Causa probable | Solucion |
|---------|----------------|----------|
| Un modulo no carga o da error de tipo | El modulo depende de .NET Framework | Probar `Import-Module NombreModulo -UseWindowsPowerShell` en PS7, o ejecutar directamente en PS5.1 |
| `Get-WmiObject` no existe | Eliminado en PS7 | Usar `Get-CimInstance` en PS7, o ejecutar en PS5.1 |
| `Get-EventLog` no existe | Eliminado en PS7 | Usar `Get-WinEvent` en PS7, o ejecutar en PS5.1 |
| Un script viejo falla con errores de sintaxis | Puede usar snap-ins, workflows, o sintaxis deprecada | Probar en PS5.1 primero |
| Encoding raro en archivos generados | PS7 escribe UTF-8 sin BOM; PS5.1 escribe UTF-16LE con BOM | Especificar encoding explicitamente: `-Encoding UTF8` |
| `Test-Connection` falla por parametro | En PS7 el parametro es `-TargetName`, no `-ComputerName` | Cambiar a `-TargetName` en PS7, o usar PS5.1 |
| `Add-PSSnapin` no existe | Snap-ins eliminados en PS7 | Solo funciona en PS5.1 |
| `Write-EventLog` no existe | Eliminado en PS7 | Usar PS5.1, o usar `New-WinEvent` |
| Workflow de PowerShell no corre | Workflows eliminados en PS7 | Solo funciona en PS5.1 |

### Cmdlets que NO existen en PS7

- `Get-WmiObject` -> usar `Get-CimInstance`
- `Get-EventLog` -> usar `Get-WinEvent`
- `Write-EventLog` -> usar PS5.1 o `New-WinEvent`
- `Add-PSSnapin` -> snap-ins no existen en PS7
- Workflows (`workflow {}`) -> solo PS5.1

### Truco: Ejecutar modulos de PS5.1 desde PS7

```powershell
# Carga el modulo en un proceso de PS5.1 y lo expone en PS7
Import-Module NombreModulo -UseWindowsPowerShell
```

Esto crea una sesion remota implicita a PS5.1 y hace proxy de los comandos. util para modulos que solo funcionan en .NET Framework.

---

## 5. Instalar y actualizar PS7 via winget

### Instalar por primera vez

```powershell
winget install --id Microsoft.PowerShell --source winget
```

### Actualizar a la ultima version

```powershell
winget upgrade --id Microsoft.PowerShell
```

### Verificar version instalada

```powershell
pwsh -Command '$PSVersionTable.PSVersion'
```

### Historial de actualizaciones en este equipo

| Fecha | Version anterior | Version nueva | Metodo | Notas |
|-------|-----------------|---------------|--------|-------|
| 2026-03-18 | 7.5.4 (danada/incompleta) | 7.5.5 | winget upgrade | La version 7.5.4 presentaba problemas; winget la actualizo correctamente a 7.5.5 |

---

## 6. Referencia rapida

```
PS7:   pwsh      -> C:\Program Files\PowerShell\7\pwsh.exe
PS5.1: powershell -> C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe

Verificar version:  $PSVersionTable.PSVersion
Perfil PS7:         $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
Perfil PS5.1:       $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```
