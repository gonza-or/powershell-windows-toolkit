# PowerShell Windows Toolkit

Script de PowerShell para consultar información básica de Windows.

Muestra equipo, versión de Windows, CPU, memoria, discos, red, IP, procesos, servicios y eventos. También permite probar ping y TCP. No cambia configuraciones.

## Requisitos

- Windows 10 u 11
- Windows PowerShell 5.1 o PowerShell 7

## Uso

```powershell
.\toolkit.ps1 -Action System
.\toolkit.ps1 -Action Windows
.\toolkit.ps1 -Action CPU
.\toolkit.ps1 -Action Memory
.\toolkit.ps1 -Action Disks
.\toolkit.ps1 -Action Network
.\toolkit.ps1 -Action IP
.\toolkit.ps1 -Action Processes -Count 10
.\toolkit.ps1 -Action Services
.\toolkit.ps1 -Action Events -Count 10
.\toolkit.ps1 -Action Ping -TargetHost 127.0.0.1
.\toolkit.ps1 -Action TCP -TargetHost localhost -Port 80
```

Sin `-Action` consulta el equipo. `Events` revisa errores y advertencias del registro `System`.

El script se revisó en Linux pero necesita Windows para ejecutarse. Las conexiones TCP fallidas terminan con código 1.
