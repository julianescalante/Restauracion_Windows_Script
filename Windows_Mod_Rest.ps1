

# ==============================
# Auto-elevación a Administrador
# ==============================

# Verifica si el script se está ejecutando con privilegios de administrador.
# Muchas operaciones de DISM y SFC requieren permisos elevados para funcionar.
$esAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if (-not $esAdmin) {
    Write-Host "Solicitando permisos de administrador..."
    # Reinicia el script en una nueva ventana de PowerShell con el switch RunAs.
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
        -Verb RunAs
    exit
}

# ==============================
# Configuración de Logs
# ==============================

# Define la ruta de almacenamiento de logs y crea la carpeta si no existe.
$logPath = "C:\Logs_ReparacionWindows"

if (-not (Test-Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath | Out-Null
}

# Usa una marca de tiempo en el nombre del archivo para evitar sobrescribir logs anteriores.
$logFile = "$logPath\ReparacionWindows_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $logFile

# ==============================
# Función reparación automática
# ==============================

# Agrupa los pasos de reparación más comunes en una sola función.
# Esto mejora la organización y la reutilización del código.
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

# Bucle principal que muestra el menú hasta que el usuario decide salir.
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
            # Ejecuta una comprobación de integridad del sistema.
            sfc /scannow
            Pause
        }

        "2" {
            # Repara la imagen del sistema si se encuentra algún daño.
            DISM /Online /Cleanup-Image /RestoreHealth
            Pause
        }

        "3" {
            # Escanea la imagen del sistema en busca de corrupción.
            DISM /Online /Cleanup-Image /ScanHealth
            Pause
        }

        "4" {
            # Limpia componentes obsoletos de Windows para liberar espacio.
            DISM /Online /Cleanup-Image /StartComponentCleanup
            Pause
        }

        "5" {
            # Ejecuta el flujo completo de reparación con DISM y SFC.
            Reparacion-Completa
            Pause
        }

        "0" {
            Write-Host "Saliendo..."
            break
        }

        default {
            # Manejo de entradas inválidas para mejorar la experiencia del usuario.
            Write-Host "Opción no válida." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
}

# Detiene la transcripción de la sesión de PowerShell y cierra el log.
Stop-Transcript
