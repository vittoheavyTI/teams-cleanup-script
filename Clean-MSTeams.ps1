<#
.SYNOPSIS
    Deep Clean Microsoft Teams (Classic & New) - Nuclear Edition
.DESCRIPTION
    Realiza uma limpeza completa, desinstala sobras de MSI, limpa registros profundos,
    instala a versão mais recente via Winget e reinicia o computador.
.AUTHOR
    VittoheavyTI
.LICENSE
    MIT
#>

# 1. Verifica privilégios de Administrador
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERRO: Este script PRECISA ser executado como Administrador!" -ForegroundColor Red
    exit
}

Write-Host "--- Iniciando Limpeza Profunda do Microsoft Teams (MODO NUCLEAR) ---" -ForegroundColor Cyan

# 2. Fecha processos relacionados
Write-Host "[1/7] Encerrando processos..." -ForegroundColor Yellow
$processNames = @("Teams", "ms-teams", "msedgewebview2")
foreach ($name in $processNames) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process -Force
}
Start-Sleep -Seconds 2

# 3. Desinstala o Novo Teams (AppxPackage)
Write-Host "[2/7] Desinstalando Novo Teams (Appx)..." -ForegroundColor Yellow
Get-AppxPackage *MSTeams* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
Get-AppxPackage *MSTeams* | Remove-AppxPackage -ErrorAction SilentlyContinue

# 4. Desinstala o Teams Machine-Wide Installer e sobras de MSI
Write-Host "[3/7] Removendo instaladores e MSIs pendentes..." -ForegroundColor Yellow
$uninstallPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)
foreach ($path in $uninstallPaths) {
    $apps = Get-ItemProperty $path -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "*Teams*" }
    foreach ($app in $apps) {
        if ($app.UninstallString -like "*msiexec*") {
            $guid = ($app.PSChildName)
            Write-Host "Removendo MSI: $($app.DisplayName)..." -ForegroundColor Gray
            Start-Process msiexec.exe -ArgumentList "/x $guid /quiet /norestart" -Wait -NoNewWindow -ErrorAction SilentlyContinue
        } elseif ($app.UninstallString) {
            Write-Host "Executando desinstalação: $($app.DisplayName)..." -ForegroundColor Gray
            Start-Process powershell.exe -ArgumentList "-Command & {$($app.UninstallString)}" -Wait -NoNewWindow -ErrorAction SilentlyContinue
        }
    }
}

# 5. Desinstala o Teams por usuário (Classic)
Write-Host "[4/7] Limpando desinstaladores de usuário..." -ForegroundColor Yellow
$users = Get-ChildItem "C:\Users" -ErrorAction SilentlyContinue
foreach ($user in $users) {
    $updateExe = "$($user.FullName)\AppData\Local\Microsoft\Teams\Update.exe"
    if (Test-Path $updateExe) {
        Start-Process $updateExe -ArgumentList "--uninstall -s" -Wait -NoNewWindow -ErrorAction SilentlyContinue
    }
}

# 6. Remove pastas residuais (Incluso cache e Add-ins)
Write-Host "[5/7] Removendo pastas de arquivos..." -ForegroundColor Yellow
$folders = @(
    "$env:LOCALAPPDATA\Microsoft\Teams",
    "$env:LOCALAPPDATA\Microsoft\TeamsMeetingAddin",
    "$env:LOCALAPPDATA\Microsoft\TeamsPresenceAddin",
    "$env:APPDATA\Microsoft\Teams",
    "$env:PROGRAMDATA\Microsoft\Teams",
    "$env:LOCALAPPDATA\Packages\MSTeams_8wekyb3d8bbwe",
    "$env:LOCALAPPDATA\Microsoft\MSTeams"
)
foreach ($folder in $folders) {
    if (Test-Path $folder) {
        Remove-Item $folder -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Pasta removida: $folder" -ForegroundColor Gray
    }
}

# 7. Limpa o Registro (Limpeza Profunda)
Write-Host "[6/7] Limpando chaves de registro (Nuclear Mode)..." -ForegroundColor Yellow
$regKeys = @(
    "HKCU:\Software\Microsoft\Office\Teams",
    "HKCU:\Software\Microsoft\Teams",
    "HKLM:\SOFTWARE\Microsoft\Teams",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Teams",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\TeamsMachineInstaller",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run\com.squirrel.Teams.Teams",
    "HKCU:\Software\Classes\msteams",
    "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MSTeams_8wekyb3d8bbwe",
    "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\Repository\Packages\MSTeams_8wekyb3d8bbwe*"
)
foreach ($key in $regKeys) {
    if (Test-Path $key) {
        Remove-Item $key -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Registro removido: $key" -ForegroundColor Gray
    }
}

# 8. Instala a versão mais recente do Teams
Write-Host "[7/7] Instalando Microsoft Teams via Winget..." -ForegroundColor Yellow
winget install --id Microsoft.Teams --source winget --silent --accept-package-agreements --accept-source-agreements

Write-Host "`n--- PROCESSO CONCLUÍDO! ---" -ForegroundColor Green
Write-Host "O Teams foi limpo e a versão mais recente foi instalada." -ForegroundColor Cyan
Write-Host "É NECESSÁRIO REINICIAR o computador para finalizar a limpeza." -ForegroundColor Yellow

Write-Host "`n>>> Pressione ENTER para REINICIAR o computador agora (ou feche a janela para reiniciar depois)..." -ForegroundColor Red
Read-Host

Write-Host "Reiniciando..." -ForegroundColor Yellow
Restart-Computer -Force
