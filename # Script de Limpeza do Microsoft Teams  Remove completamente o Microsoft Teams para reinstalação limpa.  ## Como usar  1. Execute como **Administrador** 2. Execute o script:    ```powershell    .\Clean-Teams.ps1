<#
.SYNOPSIS
    Limpeza completa do Microsoft Teams para reinstalação limpa
.DESCRIPTION
    Remove todas as instalações, cache, registro e arquivos de usuário do Teams
.NOTES
    Requer execução como Administrador para remoção completa
#>

#Requires -RunAsAdministrator

Write-Host "=== REMOÇÃO COMPLETA DO MICROSOFT TEAMS ===" -ForegroundColor Cyan

# 1. Mata todos os processos do Teams em todos os usuários
Write-Host "1. Finalizando processos do Teams..." -ForegroundColor Yellow
Get-Process -Name "*Teams*" -ErrorAction SilentlyContinue | Stop-Process -Force

# 2. Remove o Machine-Wide Installer (evita reinstalação automática)
Write-Host "2. Removendo Machine-Wide Installer..." -ForegroundColor Yellow
$machineWide = Get-CimInstance -Class Win32_Product | Where-Object { $_.Name -like "*Teams Machine-Wide Installer*" }
if ($machineWide) {
    $machineWide | Invoke-CimMethod -MethodName Uninstall
}

# 3. Remove pasta do Program Files (instalações antigas)
$programFilesPaths = @(
    "${env:ProgramFiles}\Teams Installer",
    "${env:ProgramFiles(x86)}\Teams Installer"
)
foreach ($path in $programFilesPaths) {
    if (Test-Path $path) { 
        Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 4. Remove para TODOS os usuários (inclui novos e antigos)
Write-Host "3. Removendo dados de todos os usuários..." -ForegroundColor Yellow
$users = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue

foreach ($user in $users) {
    $userPaths = @(
        "$($user.FullName)\AppData\Local\Microsoft\Teams",
        "$($user.FullName)\AppData\Roaming\Microsoft\Teams",
        "$($user.FullName)\AppData\Local\Microsoft\TeamsPresenceAddin",
        "$($user.FullName)\AppData\Local\SquirrelTemp"
    )
    
    foreach ($path in $userPaths) {
        if (Test-Path $path) {
            Write-Host "   Removendo: $path" -ForegroundColor Gray
            Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# 5. Remove cache do WebView2 (Teams moderno)
$webviewPaths = @(
    "$env:LOCALAPPDATA\Microsoft\Edge\WebView2",
    "$env:LOCALAPPDATA\Microsoft\EdgeUpdate"
)
foreach ($path in $webviewPaths) {
    if (Test-Path $path) { 
        Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 6. Remove chaves do Registro (todos os usuários)
Write-Host "4. Limpando Registro..." -ForegroundColor Yellow
$regKeys = @(
    "HKCU:\Software\Microsoft\Office\Teams",
    "HKCU:\Software\Microsoft\Teams",
    "HKLM:\SOFTWARE\Microsoft\Teams",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Teams",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Teams"
)

foreach ($key in $regKeys) {
    if (Test-Path $key) { 
        Remove-Item $key -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 7. Remove tarefas agendadas do Teams
Get-ScheduledTask -TaskName "*Teams*" -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false

Write-Host "=== LIMPEZA CONCLUÍDA! ===" -ForegroundColor Green
Write-Host "Recomendações:" -ForegroundColor Yellow
Write-Host "1. Reinicie o computador"
Write-Host "2. Baixe a versão mais recente do Teams: https://www.microsoft.com/pt-br/microsoft-teams/download-app"
Write-Host "3. Instale o Teams normalmente"
