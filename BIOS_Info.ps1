$OutputFile = "BIOS_Info.txt"

# Получение информации о BIOS
$biosInfo = Get-WmiObject -Class Win32_BIOS
$Manufacturer = "Manufacturer: $($biosInfo.Manufacturer)"
$Version = "Version: $($biosInfo.SMBIOSBIOSVersion)"
$ReleaseDate = "Date: $($biosInfo.ReleaseDate)"

# Получение информации об операционной системе
$osInfo = Get-WmiObject -Class Win32_OperatingSystem
$OSName = "Operating system: $($osInfo.Caption)"
$OSVersion = "Version: $($osInfo.Version)"

# Получение информации о процессоре
$processorInfo = Get-WmiObject -Class Win32_Processor
$ProcessorName = "Processor: $($processorInfo.Name)"
$NumberOfCores = "Number of cores: $($processorInfo.NumberOfCores)"

# Получение информации об объеме памяти
$computerSystem = Get-WmiObject -Class Win32_ComputerSystem
$TotalMemory = "Total memory capacity: $([math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)) GB"

# Проверка статуса пароля BIOS
$BIOSPasswordStatus = $biosInfo.BIOSPasswordStatus
if ($BIOSPasswordStatus -eq "3") {
    $PasswordStatus = "The BIOS password is set."
} else {
    $PasswordStatus = "The BIOS password is not set."
}

# Проверка статуса разрешения загрузки съемных носителей
$BootSourceStatus = [bool](Get-WmiObject -Class Win32_SystemBootConfiguration).BootFromRemovableMedia
if ($bootConfig -and $bootConfig.BootSupported -and $bootConfig.MonitorBootSourceSupported) {
    $BootSourceStatus = "Loading removable media is allowed."
} else {
    $BootSourceStatus = "Loading removable media is not allowed."
}

# Создание массива с информацией
$Output = $Manufacturer, $Version, $ReleaseDate, $OSName, $OSVersion, $ProcessorName, $NumberOfCores, $TotalMemory, $PasswordStatus, $BootStatus,$BootSourceStatus,$AntivirusStatus

# Сохранение информации в файл
$Output | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "The BIOS information is saved in a file: $OutputFile"
