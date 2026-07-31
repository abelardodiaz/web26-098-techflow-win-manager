# Reglas de Documentación - Proyecto 896

## 1. Archivos Obligatorios

| Archivo | Ubicación | Propósito |
|---------|-----------|-----------|
| README.md | raíz | Problema, solución, uso |
| CHANGELOG.md | raíz | Historial de cambios |

## 2. Commits

**Formato:**
```
tipo: descripción breve

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Tipos:**
| Tipo | Uso |
|------|-----|
| feat | Nuevo script o funcionalidad |
| fix | Corrección de bug |
| docs | Solo documentación |

## 3. Scripts PowerShell

**Convenciones:**
- Nombres: kebab-case o snake_case (configurar_updates.ps1)
- Comentarios al inicio explicando propósito
- Verificar privilegios de admin si necesario
- Output claro al usuario

**Estructura script:**
```powershell
# =============================================================================
# Nombre: script_name.ps1
# Descripción: Qué hace este script
# Requiere: Admin (si aplica)
# =============================================================================

# Verificar admin si necesario
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Requiere privilegios de Administrador"
    exit 1
}

# Código aquí
```

## 4. Versionado

- MAJOR: Cambios significativos
- MINOR: Nuevos scripts/funcionalidades
- PATCH: Fixes menores

## 5. Logs de Diagnóstico

Guardar logs relevantes en archivos separados para referencia futura.
Formato: `logs-DESCRIPCION.txt` o `diagnostico-FECHA.txt`
