$OutputFile = "BIOS_Info.txt"


# Получение информации о BIOS
Write-Host "Search for BIOS information..." -ForegroundColor Cyan
$biosInfo = Get-WmiObject -Class Win32_BIOS
$Manufacturer = "Manufacturer: $($biosInfo.Manufacturer)"
$Version = "Version: $($biosInfo.SMBIOSBIOSVersion)"
$ReleaseDate = "Date: $([System.Management.ManagementDateTimeConverter]::ToDateTime($biosInfo.ReleaseDate))"

# Проверка статуса пароля BIOS
Write-Host "Checking the BIOS password status..." -ForegroundColor Cyan
$BIOSPasswordStatus = $biosInfo.BIOSPasswordStatus
if ($BIOSPasswordStatus -eq "3") {
    $PasswordStatus = "The BIOS password is set."
} else {
    $PasswordStatus = "The BIOS password is not set."
}

# Проверка статуса разрешения загрузки съемных носителей
Write-Host "Checking the status of the permission to download removable media..." -ForegroundColor Cyan
$BootSourceStatus = [bool](Get-WmiObject -Class Win32_SystemBootConfiguration).BootFromRemovableMedia
if ($bootConfig -and $bootConfig.BootSupported -and $bootConfig.MonitorBootSourceSupported) {
    $BootSourceStatus = "Loading removable media is allowed."
} else {
    $BootSourceStatus = "Loading removable media is not allowed."
}

# Получение информации об операционной системе
Write-Host "Getting information about the operating system..." -ForegroundColor Cyan
$osInfo = Get-WmiObject -Class Win32_OperatingSystem
$OSName = "Operating system: $($osInfo.Caption)"
$OSVersion = "Version: $($osInfo.Version)"

# Получение информации о процессоре
Write-Host "Getting information about the processor..." -ForegroundColor Cyan
$processorInfo = Get-WmiObject -Class Win32_Processor
$ProcessorName = "Processor: $($processorInfo.Name)"
$NumberOfCores = "Number of cores: $($processorInfo.NumberOfCores)"

# Получение информации об объеме памяти
Write-Host "Getting information about the amount of memory..." -ForegroundColor Cyan
$computerSystem = Get-WmiObject -Class Win32_ComputerSystem
$TotalMemory = "Total memory capacity: $([math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)) GB"

# Получение информации о видеокарте
Write-Host "Getting information about the video card..." -ForegroundColor Cyan
$graphicsInfo = Get-WmiObject -Class Win32_VideoController
if ($graphicsInfo) {
    $GraphicsCard = "Video card: $($graphicsInfo.Description)"
} else {
    $GraphicsCard = "Built-in graphics"
}

# Создание массива с информацией
$Output = $Manufacturer, $Version, $ReleaseDate, $OSName, $OSVersion, $ProcessorName, $NumberOfCores, $TotalMemory, $PasswordStatus,$BootSourceStatus, $GraphicsCard

# Сохранение информации в файл
Write-Host "Saving information to a file..." -ForegroundColor Cyan
$Output | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "The BIOS information is saved in a file: $OutputFile" 

