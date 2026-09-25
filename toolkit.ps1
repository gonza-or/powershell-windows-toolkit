[CmdletBinding()]
param(
    [ValidateSet('System', 'Windows', 'CPU', 'Memory', 'Disks', 'Network', 'IP', 'Processes', 'Services', 'Events', 'Ping', 'TCP')]
    [string]$Action = 'System',
    [string]$TargetHost,
    [ValidateRange(1, 65535)]
    [int]$Port = 443,
    [ValidateRange(1, 100)]
    [int]$Count = 20
)

$ErrorActionPreference = 'Stop'

if ($env:OS -ne 'Windows_NT') {
    Write-Error 'Sólo funciona en Windows.'
    exit 1
}

try {
    switch ($Action) {
        'System' {
            Get-CimInstance Win32_ComputerSystem |
                Select-Object Name, Manufacturer, Model, NumberOfLogicalProcessors,
                    @{Name='RAM_GiB'; Expression={[math]::Round($_.TotalPhysicalMemory / 1GB, 2)}}
        }
        'Windows' {
            Get-CimInstance Win32_OperatingSystem |
                Select-Object Caption, Version, BuildNumber, OSArchitecture, LastBootUpTime
        }
        'CPU' {
            Get-CimInstance Win32_Processor |
                Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, LoadPercentage
        }
        'Memory' {
            Get-CimInstance Win32_OperatingSystem |
                Select-Object @{Name='Total_GiB'; Expression={[math]::Round($_.TotalVisibleMemorySize / 1MB, 2)}},
                    @{Name='Free_GiB'; Expression={[math]::Round($_.FreePhysicalMemory / 1MB, 2)}}
        }
        'Disks' {
            Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' |
                Select-Object DeviceID, FileSystem,
                    @{Name='Size_GiB'; Expression={[math]::Round($_.Size / 1GB, 2)}},
                    @{Name='Free_GiB'; Expression={[math]::Round($_.FreeSpace / 1GB, 2)}}
        }
        'Network' { Get-NetAdapter | Select-Object Name, InterfaceDescription, Status, LinkSpeed }
        'IP' { Get-NetIPConfiguration }
        'Processes' {
            Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First $Count Id, ProcessName,
                @{Name='RAM_MiB'; Expression={[math]::Round($_.WorkingSet64 / 1MB, 1)}}
        }
        'Services' { Get-Service | Sort-Object Status, Name | Select-Object Status, Name, DisplayName }
        'Events' {
            Get-WinEvent -FilterHashtable @{LogName='System'; Level=2,3} -MaxEvents $Count |
                Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message
        }
        { $_ -in 'Ping', 'TCP' } {
            if ([string]::IsNullOrWhiteSpace($TargetHost) -or $TargetHost -notmatch '^[a-zA-Z0-9:][a-zA-Z0-9._:%-]*$') {
                throw 'Indicá un hostname o IP válido.'
            }
            if ($Action -eq 'Ping') {
                Test-Connection -ComputerName $TargetHost -Count 4
            } else {
                $result = Test-NetConnection -ComputerName $TargetHost -Port $Port -WarningAction SilentlyContinue
                $result | Select-Object ComputerName, RemoteAddress, RemotePort, TcpTestSucceeded
                if (-not $result.TcpTestSucceeded) { exit 1 }
            }
        }
    }
} catch {
    Write-Error "Error: $($_.Exception.Message)" -ErrorAction Continue
    exit 1
}
