# Clean-MSTeams

Script PowerShell para realizar uma limpeza profunda (Deep Clean) do Microsoft Teams, removendo vestigios tanto da versao **Classica** quanto da **Nova versao (Work or School)**.

---

## Portugues

### Execucao Rapida (PowerShell)
Voce pode rodar o script diretamente sem precisar baixar o arquivo:
1.  Abra o **PowerShell como Administrador**.
2.  2.  Copie e cole o comando abaixo:
    3.  ```powershell
        irm https://raw.githubusercontent.com/vittoheavyTI/teams-cleanup-script/main/Clean-MSTeams.ps1 | iex
        ```

        ### O que este script faz?
        Muitas vezes, apenas desinstalar o Teams pelo Painel de Controle nao resolve problemas de cache, erros de login ou falhas na inicializacao. Este script resolve isso:
        1.  **Encerra todos os processos** relacionados ao Teams.
        2.  2.  **Desinstala o Novo Teams** (pacote Appx).
            3.  3.  **Remove o Teams Machine-Wide Installer** (via Registro, sem usar Win32_Product lento).
                4.  4.  **Limpa pastas de cache** em %AppData%, %LocalAppData% e %ProgramData%.
                    5.  5.  **Remove chaves de registro** residuais que podem causar conflitos.
                      
                        6.  ### Como usar?
                        7.  1.  Baixe o arquivo Clean-MSTeams.ps1.
                            2.  2.  Clique com o botao direito no arquivo e selecione "Executar com o PowerShell" (Certifique-se de estar como Administrador).
                                3.  3.  Aguarde a mensagem de conclusao verde.
                                    4.  4.  Reinicie o computador e instale o Teams novamente.
                                      
                                        5.  ---
                                      
                                        6.  ## English
                                      
                                        7.  ### What does this script do?
                                        8.  Often, simply uninstalling Teams through the Control Panel doesn't fix cache issues, login errors, or startup failures. This script solves that by:
                                        9.  1.  **Closing all processes** related to Teams.
                                            2.  2.  **Uninstalling New Teams** (Appx package).
                                                3.  3.  **Removing Teams Machine-Wide Installer** (via Registry, avoiding slow Win32_Product).
                                                    4.  4.  **Cleaning cache folders** in %AppData%, %LocalAppData%, and %ProgramData%.
                                                        5.  5.  **Removing residual registry keys** that might cause conflicts.
                                                          
                                                            6.  ### How to use?
                                                            7.  1.  Download the Clean-MSTeams.ps1 file.
                                                                2.  2.  Right-click the file and select "Run with PowerShell" (Make sure to run as Administrator).
                                                                    3.  3.  Wait for the green completion message.
                                                                        4.  4.  Restart your computer and install Teams again.
                                                                          
                                                                            5.  ---
                                                                          
                                                                            6.  ## Aviso / Disclaimer
                                                                            7.  Este script remove todos os dados locais do Teams. Voce nao perdera suas mensagens ou arquivos (pois ficam na nuvem), mas tera que fazer login novamente e reconfigurar preferencias locais.
                                                                          
                                                                            8.  ---
                                                                          
                                                                            9.  **Desenvolvido por [VittoheavyTI](https://github.com/VittoheavyTI)**
                                                                            10.  
