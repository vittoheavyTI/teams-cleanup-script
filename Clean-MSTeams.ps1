<#
.SYNOPSIS
    Deep Clean Microsoft Teams (Classic & New)
    .DESCRIPTION
        Este script realiza uma limpeza completa do Microsoft Teams, removendo tanto a vers<#
        .SYNOPSIS
            Deep Clean Microsoft Teams (Classic & New)
            .DESCRIPTION
                Este script realiza uma limpeza completa do Microsoft Teams, removendo tanto a versao Classica 
                    quanto a versao Nova (Work or School), excluindo arquivos locais, chaves de registro e desinstalando 
                        os componentes do sistema.
                        .AUTHOR
                            VittoheavyTI
                            .LICENSE
                                MIT
                                #>

                                # 1. Verifica privilegios de Administrador
                                $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
                                if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                                    Write-Host "ERRO: Este script PRECISA ser executado como Administrador!" -ForegroundColor Red
                                        exit
                                        }

                                        Write-Host "--- Iniciando Limpeza Profunda do Microsoft Teams ---" -ForegroundColor Cyan

                                        # 2. Fecha processos relacionados
                                        Write-Host "[1/6] Encerrando processos..." -ForegroundColor Yellow
                                        $processNames = @("Teams", "ms-teams", "msedgewebview2")
                                        foreach ($name in $processNames) {
                                        
                                            Get-Process $name -ErrorAction SilentlyContinue | Stop-Process -Force
                                            }
                                            Start-Sleep -Seconds 2

                                            # 3. Desinstala o Novo Teams (AppxPackage)
                                            Write-Host "[2/6] Desinstalando Novo Teams (Appx)..." -ForegroundColor Yellow
                                            Get-AppxPackage *MSTeams* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                                            Get-AppxPackage *MSTeams* | Remove-AppxPackage -ErrorAction SilentlyContinue

                                            # 4. Desinstala o Teams Machine-Wide Installer (Classico)
                                            Write-Host "[3/6] Removendo instalador de maquina (Classic)..." -ForegroundColor Yellow
                                            $regPaths = @(
                                                "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
                                                    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
                                                    )
                                                    foreach ($path in $regPaths) {
                                                        $teamsMachineWide = Get-ItemProperty $path -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -eq "Teams Machine-Wide Installer" }
                                                            if ($teamsMachineWide) {
                                                                    $uninstallString = $teamsMachineWide.UninstallString
                                                                            Start-Process msiexec.exe -ArgumentList "$uninstallString /quiet /norestart" -Wait -NoNewWindow
                                                                                }
                                                                                }

                                                                                # 5. Desinstala o Teams por usuario (Classic)
                                                                                Write-Host "[4/6] Limpando desinstaladores de usuario..." -ForegroundColor Yellow
                                                                                $users = Get-ChildItem "C:\Users" -ErrorAction SilentlyContinue
                                                                                foreach ($user in $users) {
                                                                                    $updateExe = "$($user.FullName)\AppData\Local\Microsoft\Teams\Update.exe"
                                                                                        if (Test-Path $updateExe) {
                                                                                                Start-Process $updateExe -ArgumentList "--uninstall -s" -Wait -NoNewWindow -ErrorAction SilentlyContinue
                                                                                                    }
                                                                                                    }
                                                                                                    
                                                                                                    # 6. Remove pastas residuais
                                                                                                    Write-Host "[5/6] Removendo pastas de arquivos..." -ForegroundColor Yellow
                                                                                                    $folders = @(
                                                                                                        "$env:LOCALAPPDATA\Microsoft\Teams",
                                                                                                            "$env:LOCALAPPDATA\Microsoft\TeamsMeetingAddin",
                                                                                                                "$env:LOCALAPPDATA\Microsoft\TeamsPresenceAddin",
                                                                                                                    "$env:APPDATA\Microsoft\Teams",
                                                                                                                        "$env:PROGRAMDATA\Microsoft\Teams",
                                                                                                                            "$env:LOCALAPPDATA\Packages\MSTeams_8wekyb3d8bbwe"
                                                                                                                            )
                                                                                                                            foreach ($folder in $folders) {
                                                                                                                                if (Test-Path $folder) {
                                                                                                                                        Remove-Item $folder -Recurse -Force -ErrorAction SilentlyContinue
                                                                                                                                                Write-Host "Removido: $folder" -ForegroundColor Gray
                                                                                                                                                    }
                                                                                                                                                    }
                                                                                                                                                    
                                                                                                                                                    # 7. Limpa o Registro
                                                                                                                                                    Write-Host "[6/6] Limpando chaves de registro..." -ForegroundColor Yellow
                                                                                                                                                    $regKeys = @(
                                                                                                                                                        "HKCU:\Software\Microsoft\Office\Teams",
                                                                                                                                                            "HKCU:\Software\Microsoft\Teams",
                                                                                                                                                                "HKLM:\SOFTWARE\Microsoft\Teams",
                                                                                                                                                                    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Teams",
                                                                                                                                                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\TeamsMachineInstaller"
                                                                                                                                                                        )
                                                                                                                                                                        foreach ($key in $regKeys) {
                                                                                                                                                                            if (Test-Path $key) {
                                                                                                                                                                                    Remove-Item $key -Recurse -Force -ErrorAction SilentlyContinue
                                                                                                                                                                                            Write-Host "Removida chave: $key" -ForegroundColor Gray
                                                                                                                                                                                                }
                                                                                                                                                                                                }
                                                                                                                                                                                                
                                                                                                                                                                                                Write-Host "`nLimpeza concluida com sucesso!" -ForegroundColor Green
                                                                                                                                                                                                Write-Host "Recomendamos reiniciar o computador antes de reinstalar o Teams." -ForegroundColor Cyan
                                                                                                                                                                                                
