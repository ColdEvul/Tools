#Requires -RunAsAdministrator
if ("$Env:OS" -ne "Windows_NT") { Write-Host "Your not running on a Windows shell..." -ForegroundColor Red; exit }    

# Set-ExecutionPolicy RemoteSigned -scope CurrentUser

# GLOBALS
$scoop_buckets    = 'extras', 'Arma3Tools https://github.com/ColdEvul/arma3-scoop-bucket.git'

$scoop_pkg        = 'git', 'curl',
                    'aria2', '7zip',
                    'grep', 'ripgrep', 'sed', 'touch', 'jq', 'dos2unix',
                    'zip', '7zip',
                    'neovim', 'scrcpy',
                    'python', 'ruby', 'msys2', 'perl', 'ninja', 'rust',
                    'steamcmd', 'qbittorrent-portable', 'android-sdk', 'rufus',
                    'sharpkeys',
                    'armake', 'hemtt'

$choco_pkg        = 'DotNet4.5.2', 'vcredist140', 'vcredist2015', 'vcredist2017', 'KB2919355', 'KB2919442', 'KB2999226', 'KB3033929', 'KB3035131', 
                    'googlechrome', 'vscode',
                    'microsoft-windows-terminal',
                    'winrar', 'vlc', 'teamviewer',
                    'teamspeak', 'discord', 'slack',
                    'steam',
                    'obs-studio',
                    'linux-reader', 'vcxsrv',
                    'powershell-core', 'winaero-tweaker', "powertoys", "WinHotKey"

$pwsh_modules     = 'PSWindowsUpdate', 'Get-ChildItemColor'



# Script start
Write-Host "Starting up..." -ForegroundColor Magenta

# Installing scoop
Write-Host "Setting up Scoop..." -ForegroundColor Magenta
if (![System.IO.File]::Exists("$env:USERPROFILE\scoop\shims\scoop")) {
    Write-Host "Installing Scoop..." -ForegroundColor Magenta
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh') >$null 2>&1
} else {
    Write-Host "Scoop already exist no need to install. Checking for updates..." -ForegroundColor Yellow
    scoop update scoop >$null 2>&1
}

# Add scoop buckets
Write-Host "Installing Required Scoop Packages..."
$scoop_defult_pkg = 'sudo', 'git', 'aria2', '7zip'
foreach ($pkg in $scoop_defult_pkg) {
    if (![System.IO.Directory]::Exists("$env:USERPROFILE\scoop\apps\$pkg")) {
        Write-Host "Installing $pkg..."
        scoop install $pkg >$null 2>&1
    } else {
        Write-Host "Scoop $pkg already installed skipping..." -ForegroundColor Yellow
    }
}

Write-Host "Adding Scoop buckets..."
foreach ($buckets in $scoop_buckets) {
    scoop bucket add $buckets >$null 2>&1
}

# Install scoop packages
Write-Host "Installing Scoop packages..."
# Packages
foreach ($pkg in $scoop_pkg) {
    if (![System.IO.Directory]::Exists("$env:PROGRAMDATA\scoop\apps\$pkg")) {
        Write-Host "Installing $pkg..."
        scoop install $pkg -g >$null 2>&1
    } else {
        Write-Host "Scoop $pkg already installed skipping..." -ForegroundColor Yellow
    }
}
Write-Host "Installation of scoop packages completed..." -ForegroundColor Green



# Installing Chocolately
Write-Host "Setting up Chocolately..." -ForegroundColor Magenta
if (![System.IO.File]::Exists("C:\ProgramData\chocolatey\choco.exe")) {
    Write-Host "Installing Chocolately..." -ForegroundColor green
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "Changeing and setting some paths for Chocolately..."
    choco feature enable -n allowGlobalConfirmation >$null 2>&1
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\ProgramData\Chocolatey\tools", "Machine")
} else { Write-Host "Chocolately already exist..." -ForegroundColor Yellow }

# Chocolately packages
Write-Host "Installing Chocolately packages..."
$chocoInstalledPackages=choco list --localonly
foreach ($pkg in $choco_pkg) {
    if (!($chocoInstalledPackages -like "*$pkg*")) {
        Write-Host "Installing $pkg..."
        choco install $pkg -y >$null 2>&1
    } else {
        Write-Host "Choco $pkg already installed skipping..." -ForegroundColor Yellow
    }
}
Write-Host "Installation of chocolately packages completed..." -ForegroundColor Green



# Install powershell moduels
Write-Host "Powershell modules..."
Set-PSRepository PSGallery
foreach ($module in $pwsh_modules) {
    Install-Module -Name $module -AllowClobber >$null 2>&1
}
Write-Host "Powershell module installation completed..." -ForegroundColor Green



# Download drives and packages for gaming
Write-Host "Downloading drives and programs for gaming..." -ForegroundColor Magenta
if (![System.IO.File]::Exists("$Env:userprofile\Downloads\TrackIR_5.4.2.exe")) {
    Invoke-WebRequest https://s3.amazonaws.com/naturalpoint/trackir/software/TrackIR_5.4.2.exe -OutFile "$Env:userprofile\Downloads\TrackIR_5.4.2.exe" >$null 2>&1
} else {
        Write-Host "TrackIR already downloaded skipping..." -ForegroundColor Yellow
}
if (![System.IO.File]::Exists("$Env:userprofile\Downloads\Setup.exe")) {
    Invoke-WebRequest https://media.roccat.org/driver/Tyon/ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip -OutFile "$Env:userprofile\Downloads\ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip" >$null 2>&1
    Expand-Archive "$Env:userprofile\Downloads\ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip" -DestinationPath "$Env:userprofile\Downloads\" >$null 2>&1
    Remove-Item "$Env:userprofile\Downloads\ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip" >$null 2>&1
} else {
        Write-Host "ROCCAT Tyon already downloaded skipping..." -ForegroundColor Yellow
}
if (![System.IO.File]::Exists("$Env:userprofile\Downloads\LGS_9.02.65_x64_Logitech.exe")) {
    Invoke-WebRequest https://download01.logi.com/web/ftp/pub/techsupport/gaming/LGS_9.02.65_x64_Logitech.exe -OutFile "$Env:userprofile/Downloads/LGS_9.02.65_x64_Logitech.exe" >$null 2>&1
} else {
        Write-Host "Logitech already downloaded skipping..." -ForegroundColor Yellow
}
Write-Host "Drives packages downloaded and ready..." -ForegroundColor Green


 
Write-Host "Applying windows features..." -ForegroundColor Magenta
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl.exe --set-default-version 2
Write-Host "windows features applied" -ForegroundColor Green


# Setting up home and root enviroment
Write-Host "Setting up home..."
if (![System.IO.Directory]::Exists("$Env:userprofile\.bin")) {
    New-Item -itemtype "directory" -path "$Env:userprofile\.bin"
    (get-item $Env:userprofile\.bin).Attributes += 'Hidden'
    if ( ! $env:path.Contains(";$Env:userprofile\.bin")) { [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$Env:userprofile\.bin", "User") }
    
} else {
    Write-Host "Home already setup skipping..." -ForegroundColor Yellow
}
if (![System.IO.Directory]::Exists("$Env:userprofile\Programs")) {
    New-Item -itemtype "directory" -path "C:\Programs"
    New-Item -itemtype Junction -path "$Env:userprofile" -name "Programs" -value "C:\Programs"

    New-Item -itemtype "directory" -path "C:\Programs\Bin"
    if ( ! $env:path.Contains(";C:\Programs\Bin")) { [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Programs\Bin", "Machine") }

    New-Item -itemtype "directory" -path "C:\Programs\.icon"

    Write-Host "Setting up symbolic links and directories..."
    New-Item -itemtype Junction -path "C:\" -name "Tmp" -value "$Env:temp"

    New-Item -itemtype "directory" -path "C:\Program Files (x86)\Steam\steamapps\common"
    New-Item -itemtype Junction -path "C:\Programs\" -name "SteamApps" -value "C:\Program Files (x86)\Steam\steamapps\common"

    New-Item -itemtype Junction -path "$Env:userprofile" -name ".Templates" -value "$env:appdata\Microsoft\Windows\Templates"
    (get-item $Env:userprofile\.Templates).Attributes += 'Hidden'

} else {
    Write-Host "Root already setup skipping..." -ForegroundColor Yellow
}



# Setup cmd
if (![System.IO.File]::Exists("$Env:userprofile\.batchrc.cmd")) {
    Write-Host "Configurating CMD..." -ForegroundColor Magenta
    C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsBatchRC\add_batchrc.reg" >$null 2>&1

    Copy-Item "$PSScriptRoot\..\MyLibrary\Windows\batchrc\.batchrc.cmd" -Destination "$Env:userprofile\"
    Copy-Item "$PSScriptRoot\..\MyLibrary\Windows\batchrc\.batch_path.cmd" -Destination "$Env:userprofile\"
    Copy-Item "$PSScriptRoot\..\MyLibrary\Windows\batchrc\.batch_aliases.cmd" -Destination "$Env:userprofile\"
    (get-item $Env:userprofile\.batchrc.cmd).Attributes += 'Hidden'
    (get-item $Env:userprofile\.batch_path.cmd).Attributes += 'Hidden'
    (get-item $Env:userprofile\.batch_aliases.cmd).Attributes += 'Hidden'

    Write-Host "Configuration of CMD complete..." -ForegroundColor Green
} else {
    Write-Host "CMD already configured skipping..." -ForegroundColor Yellow
}



# Setup powershell profile
if (![System.IO.File]::Exists("$Env:userprofile\Documents\PowerShell\profile.ps1")) {
    Write-Host "Configurating Powershell..." -ForegroundColor Magenta
    New-Item -itemtype "directory" -path "$Env:userprofile\Documents\PowerShell\"
    (get-item $Env:userprofile\Documents\PowerShell).Attributes += 'Hidden'
    New-Item -itemtype "directory" -path "$Env:userprofile\Documents\WindowsPowerShell\"
    (get-item $Env:userprofile\Documents\WindowsPowerShell).Attributes += 'Hidden'
    
    "if (Test-Path `"$env:userprofile\.pwshrc.ps1`" -PathType leaf) {`n    . `"$env:userprofile\.pwshrc.ps1`"`n}" | Out-File -FilePath "$Env:userprofile\Documents\PowerShell\profile.ps1"

    Write-Host "Restoring powershell profile..."
    Copy-Item "$PSScriptRoot\..\MyLibrary\Windows\Home\.pwshrc.ps1" -Destination "$Env:userprofile"
    Copy-Item "$PSScriptRoot\..\MyLibrary\Windows\Home\.pwsh_path.ps1" -Destination "$Env:userprofile"
    Copy-Item "$PSScriptRoot\..\MyLibrary\Windows\Home\.pwsh_aliases.ps1" -Destination "$Env:userprofile"
    (get-item $Env:userprofile\.pwshrc.ps1).Attributes += 'Hidden'
    (get-item $Env:userprofile\.pwsh_path.ps1).Attributes += 'Hidden'
    (get-item $Env:userprofile\.pwsh_aliases.ps1).Attributes += 'Hidden'

    New-Item -itemtype SymbolicLink -path "$Env:userprofile\Documents\WindowsPowerShell" -name "profile.ps1" -value "$Env:userprofile\Documents\PowerShell\profile.ps1"
    Write-Host "Configuration of PowerShell complete..." -ForegroundColor Green
} else {
    Write-Host "Powershell already configured skipping..." -ForegroundColor Yellow
}



# Creating quick links for terminal
Write-Host "Setting up Programs and Terminal shims..." -ForegroundColor Magenta

[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\ProgramData\Chocolatey\tools", "Machine")

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\choco.exe" -p="C:\ProgramData\Chocolatey\choco.exe" >$null 2>&1
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\choco" -p="C:\ProgramData\Chocolatey\choco.exe" >$null 2>&1

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\chrome.exe" -p="C:\Program Files\Google\Chrome\Application\chrome.exe" >$null 2>&1
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\chrome" -p="C:\Program Files\Google\Chrome\Application\chrome.exe" >$null 2>&1

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\google-chrome.exe" -p="C:\Program Files\Google\Chrome\Application\chrome.exe" >$null 2>&1
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\google-chrome" -p="C:\Program Files\Google\Chrome\Application\chrome.exe" >$null 2>&1

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\steam.exe" -p="C:\Program Files (x86)\Steam\Steam.exe" >$null 2>&1
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\steam" -p="C:\Program Files (x86)\Steam\Steam.exe" >$null 2>&1

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\code.exe" -p="C:\Program Files\Microsoft VS Code\Code.exe" >$null 2>&1
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\code" -p="C:\Program Files\Microsoft VS Code\Code.exe" >$null 2>&1

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\TeamViewer.exe" -p="C:\Program Files (x86)\TeamViewer\TeamViewer.exe" >$null 2>&1
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\TeamViewer" -p="C:\Program Files (x86)\TeamViewer\TeamViewer.exe" >$null 2>&1

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\pwsh.exe" -p="C:\Program Files\PowerShell\7\pwsh.exe" >$null 2>&1
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\pwsh" -p="C:\Program Files\PowerShell\7\pwsh.exe" >$null 2>&1


# Autostart
Write-Host "Setting up autostart..." -ForegroundColor Magenta
$autostart=[Environment]::GetFolderPath('Startup')
New-Item -itemtype Junction -path "C:\Programs" -name "Startup" -value "$autostart"
Copy-Item "$PSScriptRoot\..\MyLibrary\Windows\VcXSrv\config.xlaunch" -Destination "C:\Programs\Startup\"


Write-Host "Adjusting the context menu..." -ForegroundColor Magenta
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\VSCode\Elevation_Add.reg" >$null 2>&1

C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsCustomNewFileRegFile\!cleanUnwantedCreateNewFile.reg" >$null 2>&1
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsCustomNewFileRegFile\addCreateNewCppFile.reg" >$null 2>&1
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsCustomNewFileRegFile\addCreateNewHppFile.reg" >$null 2>&1
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsCustomNewFileRegFile\addCreateNewMdFile.reg" >$null 2>&1
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsCustomNewFileRegFile\addCreateNewPythonFile.reg" >$null 2>&1
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsCustomNewFileRegFile\addCreateNewSqfFile.reg" >$null 2>&1

# Terminals
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsContextMenu\WindowsTerminal_Add.reg" >$null 2>&1
Invoke-WebRequest https://github.com/microsoft/terminal/raw/master/res/terminal.ico -OutFile "C:\Programs\.icon\terminal.ico" >$null 2>&1
Invoke-WebRequest https://iconarchive.com/download/i75927/martz90/circle/ubuntu.ico -OutFile "C:\Programs\.icon\ubuntu.ico" >$null 2>&1

# Change windows time
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsUTCTime\Make Windows Use UTC Time.reg" >$null 2>&1

# Cleanup Context Menus
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsContextMenu\Removers\remove_GIT_BASH_CMD.reg" >$null 2>&1
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsContextMenu\Removers\remove_VLC.reg" >$null 2>&1
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsContextMenu\Removers\remove_VS.reg" >$null 2>&1

# Remove unwanted objects
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsNameSpaceFolders\Remove_3DObjects_Folder.reg" >$null 2>&1

# Restoring save files from programs
Write-Host "Restoring keybindings and other systems..." -ForegroundColor Magenta
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\KeyBinding\RebindCaps2Esc.reg" >$null 2>&1
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\KeyBinding\winHotKeyTerminal.reg" >$null 2>&1


Write-Host "Context menu adjustment completed..." -ForegroundColor green

Write-Host "Script completed." -ForegroundColor green
