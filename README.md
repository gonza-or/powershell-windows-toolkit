# PowerShell Windows Toolkit

Herramienta de consulta para diagnóstico básico de Windows, mediante PowerShell, CIM y cmdlets del sistema. No instala servicios ni modifica configuraciones.

## Requisitos e instalación

Windows 10/11 con Windows PowerShell 5.1 o PowerShell 7 y módulos de Windows `NetAdapter`, `NetTCPIP`, `CimCmdlets` y `Microsoft.PowerShell.Diagnostics` disponibles. Abrir PowerShell en esta carpeta después de descargar el repositorio.

Si Windows bloquea el script descargado, primero leerlo y comprobar su procedencia. Se puede desbloquear sólo este archivo con `Unblock-File .\toolkit.ps1`. Las políticas organizacionales pueden impedir ejecutarlo; no se propone desactivarlas ni usar `Bypass`. Las consultas habituales no requieren administrador; los permisos de eventos dependen del equipo.

## Uso y ejemplos

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

Sin argumentos consulta el equipo. `Events` muestra errores y advertencias del registro System; si no encuentra eventos coincidentes, informa el error que devuelve Windows. `Disks` incluye discos lógicos locales. La conexión TCP requiere que exista un servicio escuchando; el ejemplo de puerto 80 puede fallar si no hay servidor web. Los errores de consulta y las conexiones TCP fallidas devuelven salida 1. `Test-NetConnection` puede demorar según los tiempos de espera de Windows.

## Qué demuestra

Parámetros tipados, validación de entrada, objetos y pipelines, consultas CIM, memoria y discos, adaptadores e IP, procesos, servicios y eventos. Permite distinguir una falla de conectividad de un servicio que no escucha.

## Validación

El entorno de construcción es Linux: no se afirma que las consultas hayan sido ejecutadas en Windows. Ver [validación pendiente en Windows](../../docs/verification.md) antes de presentar resultados de ese sistema.
