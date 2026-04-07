# ============================================
# Script de Reparación del Sistema - Windows
# Autor: José Julián Escalante García
# Fecha: Febrero 19 del 2026
# Descripción: Automatiza procesos SFC y DISM
# ============================================

# ==============================
# Auto-elevación a Administrador
# ==============================

$esAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if (-not $esAdmin) {
    Write-Host "Solicitando permisos de administrador..."
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
        -Verb RunAs
    exit
}

# ==============================
# Configuración de Logs
# ==============================

$logPath = "C:\Logs"

if (-not (Test-Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath | Out-Null
}

$logFile = "$logPath\ReparacionWindows_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $logFile

# ==============================
# Función reparación automática
# ==============================

function Reparacion-Completa {

    Write-Host "Ejecutando DISM RestoreHealth..." -ForegroundColor Cyan
    DISM /Online /Cleanup-Image /RestoreHealth

    Write-Host "Ejecutando SFC..." -ForegroundColor Cyan
    sfc /scannow

    Write-Host "Proceso completado." -ForegroundColor Green
}

# ==============================
# Menú principal
# ==============================

while ($true) {

    Clear-Host
    Write-Host "==================================" -ForegroundColor Yellow
    Write-Host "   MENÚ DE REPARACIÓN WINDOWS"
    Write-Host "==================================" -ForegroundColor Yellow
    Write-Host "1 - Ejecutar SFC"
    Write-Host "2 - DISM RestoreHealth"
    Write-Host "3 - DISM ScanHealth"
    Write-Host "4 - DISM StartComponentCleanup"
    Write-Host "5 - Reparación completa automática"
    Write-Host "0 - Salir"
    Write-Host ""

    $seleccion = Read-Host "Elegir opción"

    switch ($seleccion) {

        "1" {
            sfc /scannow
            Pause
        }

        "2" {
            DISM /Online /Cleanup-Image /RestoreHealth
            Pause
        }

        "3" {
            DISM /Online /Cleanup-Image /ScanHealth
            Pause
        }

        "4" {
            DISM /Online /Cleanup-Image /StartComponentCleanup
            Pause
        }

        "5" {
            Reparacion-Completa
            Pause
        }

        "0" {
            Write-Host "Saliendo..."
            break
        }

        default {
            Write-Host "Opción no válida." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
}

Stop-Transcript
