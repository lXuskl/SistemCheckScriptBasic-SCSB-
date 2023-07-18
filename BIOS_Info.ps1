$OutputFile = "System_Info.txt"
$Emptystring = " "

# Получение информации о BIOS
Write-Host "Search for BIOS information..." -ForegroundColor Cyan
$biosInfo = Get-WmiObject -Class Win32_BIOS
$BIOS = "BIOS:"
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

# Получение информации о виртуализации
Write-Host "Getting information about virtualization..." -ForegroundColor Cyan
$VirtualizationEnabled = ""
if ($biosInfo.VirtualizationFirmwareEnabled) {
    $VirtualizationEnabled = "Virtualization Firmware Enabled: $($biosInfo.VirtualizationFirmwareEnabled)"
} else {
    $VirtualizationEnabled = "Virtualization Information Not Available"
}

# Получение информации о статусе батареи CMOS
Write-Host "Getting information about the CMOS battery status..." -ForegroundColor Cyan
$CMOSBatteryStatus = "CMOS Battery Status: $($biosInfo.Status)"


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
if ($videoCard.VideoModeDescription -like "*onboard*") {
        $Type = "Type: Integrated"
    } else {
        $Type = "Type: Discrete"
    }

# Получение информации о физических дисках
Write-Host "Getting information about physical disks..." -ForegroundColor Cyan
$NameDisks = "Disks:"
$disks = Get-WmiObject -Class Win32_DiskDrive
$diskInfo = foreach ($disk in $disks) {
    $Manufacturer2 = $disk.Manufacturer
    $Model = $disk.Model
    $Capacity = [math]::Round($disk.Size / 1GB, 2)

    [PSCustomObject]@{
        Manufacturer = $Manufacturer2
        Model = $Model
        Capacity = $Capacity
    }
}

# Получение информации о материнской плате
$NameMotherBoard = "NameMotherBoard:"
Write-Host "Getting information about the motherboard..." -ForegroundColor Cyan
$motherboard = Get-WmiObject -Class Win32_BaseBoard
$Manufacturer3 = "Manufacturer: $($motherboard.Manufacturer)"
$Product3 = "Product: $($motherboard.Product)"
$Version3 = "Version: $($motherboard.Version)"
$SerialNumber = "Serial Number: $($motherboard.SerialNumber)"


# Создание массива с информацией
$Output = $BIOS, $Manufacturer, $Version, $ReleaseDate, $PasswordStatus, $BootSourceStatus,$CMOSBatteryStatus,$VirtualizationEnabled,$Emptystring, $OSName, ,$OSVersion,$Emptystring, $ProcessorName, $NumberOfCores, $TotalMemory,$Emptystring, $GraphicsCard,$Type, $Emptystring, $NameDisks, $diskInfo, $Emptystring,$NameMotherBoard, $Manufacturer3,$Product3,$Version3,$SerialNumber

# Сохранение информации в файл
Write-Host "Saving information to a file..." -ForegroundColor Cyan
$Output | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "The BIOS information is saved in a file: $OutputFile" 
