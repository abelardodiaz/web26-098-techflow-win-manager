# Script para configurar Windows Update y horas activas
# Debe ejecutarse como Administrador

Write-Host "Configurando Windows Update y horas activas..." -ForegroundColor Green

# 1. Configurar horas activas (7 AM a 5 AM - 22 horas protegidas)
Write-Host "`n1. Configurando horas activas: 7 AM a 5 AM" -ForegroundColor Cyan
Write-Host "   Ventana de actualizacion permitida: 5 AM a 7 AM" -ForegroundColor Yellow
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "ActiveHoursStart" -Value 7 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "ActiveHoursEnd" -Value 5 -Type DWord
    Write-Host "   Horas activas configuradas correctamente" -ForegroundColor Green
} catch {
    Write-Host "   Error al configurar horas activas: $_" -ForegroundColor Red
}

# 2. Configurar Windows Update para notificar antes de descargar/instalar
Write-Host "`n2. Configurando Windows Update para notificar antes de instalar" -ForegroundColor Cyan

# Crear la ruta si no existe
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
if (-not (Test-Path $regPath)) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "AU" -Force | Out-Null
    Write-Host "   Ruta de registro creada" -ForegroundColor Yellow
}

try {
    # AUOptions = 2: Notificar antes de descargar y notificar antes de instalar
    # AUOptions = 3: Descargar automaticamente pero notificar antes de instalar
    # Usaremos 3 para mejor experiencia
    Set-ItemProperty -Path $regPath -Name "AUOptions" -Value 3 -Type DWord
    Set-ItemProperty -Path $regPath -Name "NoAutoUpdate" -Value 0 -Type DWord
    Write-Host "   Windows Update configurado para notificar antes de instalar" -ForegroundColor Green
} catch {
    Write-Host "   Error al configurar Windows Update: $_" -ForegroundColor Red
}

# 3. Deshabilitar reinicio automatico
Write-Host "`n3. Deshabilitando reinicio automatico" -ForegroundColor Cyan
try {
    Set-ItemProperty -Path $regPath -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -Type DWord
    Set-ItemProperty -Path $regPath -Name "AUPowerManagement" -Value 0 -Type DWord
    Write-Host "   Reinicio automatico deshabilitado" -ForegroundColor Green
} catch {
    Write-Host "   Error al deshabilitar reinicio automatico: $_" -ForegroundColor Red
}

Write-Host "`n=== Configuracion completada ===" -ForegroundColor Green
Write-Host "`nResumen de cambios:" -ForegroundColor Yellow
Write-Host "- Horas activas: 7:00 AM a 5:00 AM (22 horas protegidas)"
Write-Host "- Ventana de mantenimiento: 5:00 AM a 7:00 AM"
Write-Host "- Windows Update: Descarga automatica, pero notifica antes de instalar"
Write-Host "- No reiniciara automaticamente si hay usuarios conectados"
Write-Host "`nEs posible que necesites reiniciar para que algunos cambios tengan efecto." -ForegroundColor Cyan
