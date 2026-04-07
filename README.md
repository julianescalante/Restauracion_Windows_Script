# Restauracion_Windows_Script

Script de reparación y escaneo de archivos corruptos en dispositivos Windows

## Descripción

Este script de PowerShell automatiza procesos comunes de reparación del sistema Windows utilizando herramientas integradas como SFC (System File Checker) y DISM (Deployment Image Servicing and Management). Proporciona una interfaz de menú interactiva para ejecutar diferentes comandos de reparación de manera sencilla.

## Características

- **Auto-elevación**: El script se ejecuta automáticamente con permisos de administrador si no se tienen.
- **Interfaz de menú**: Menú interactivo con opciones numeradas para facilitar el uso.
- **Logging automático**: Registra todas las operaciones en archivos de log con timestamp en `C:\Logs`.
- **Reparación completa automática**: Opción que combina DISM RestoreHealth y SFC en secuencia.

## Requisitos

- **Sistema operativo**: Windows 10/11
- **Permisos**: Debe ejecutarse como administrador
- **PowerShell**: Versión 5.1 o superior

## Uso

1. Descarga el archivo `Windows_Mod_Rest.ps1`
2. Ejecuta el script con PowerShell (se auto-elevará a administrador si es necesario)
3. Selecciona la opción deseada del menú

### Opciones del menú

- **1 - Ejecutar SFC**: Ejecuta `sfc /scannow` para escanear y reparar archivos del sistema corruptos
- **2 - DISM RestoreHealth**: Ejecuta `DISM /Online /Cleanup-Image /RestoreHealth` para reparar la imagen del sistema
- **3 - DISM ScanHealth**: Ejecuta `DISM /Online /Cleanup-Image /ScanHealth` para verificar el estado de la imagen
- **4 - DISM StartComponentCleanup**: Ejecuta `DISM /Online /Cleanup-Image /StartComponentCleanup` para limpiar componentes
- **5 - Reparación completa automática**: Ejecuta primero DISM RestoreHealth y luego SFC
- **0 - Salir**: Cierra el script

## Logging

Los logs se guardan automáticamente en `C:\Logs\` con nombres como `ReparacionWindows_YYYYMMDD_HHMMSS.log`. Incluyen toda la salida de los comandos ejecutados.

## Autor

José Julián Escalante García

## Fecha

Febrero 19 del 2026
