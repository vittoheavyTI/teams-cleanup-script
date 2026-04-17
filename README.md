# Clean-MSTeams

Script PowerShell para realizar uma limpeza profunda (Deep Clean) do Microsoft Teams, removendo vestigios tanto da versao Classica quanto da Nova versao (Work or School).

---

## Portugues

### O que este script faz?
Muitas vezes, apenas desinstalar o Teams pelo Painel de Controle nao resolve problemas de cache, erros de login ou falhas na inicializacao. Este script resolve isso:

- Encerra todos os processos relacionados ao Teams.
- - Desinstala o Novo Teams (pacote Appx).
  - - Remove o Teams Machine-Wide Installer (via Registro, sem usar Win32_Product lento).
    - - Limpa pastas de cache em %AppData%, %LocalAppData% e %ProgramData%.
      - - Remove chaves de registro residuais que podem causar conflitos.
       
        - ### Como usar?
       
        - - Baixe o arquivo Clean-MSTeams.ps1.
          - - Clique com o botao direito no arquivo e selecione "Executar com o PowerShell" (Certifique-se de estar como Administrador).
            - - Aguarde a mensagem de conclusao verde.
              - - Reinicie o computador e instale o Teams novamente.
               
                - ---

                ## English

                ### What does this script do?
                Often, simply uninstalling Teams through the Control Panel doesn't fix cache issues, login errors, or startup failures. This script solves that by:

                - Closing all processes related to Teams.
                - - Uninstalling New Teams (Appx package).
                  - - Removing Teams Machine-Wide Installer (via Registry, avoiding slow Win32_Product).
                    - - Cleaning cache folders in %AppData%, %LocalAppData%, and %ProgramData%.
                      - - Removing residual registry keys that might cause conflicts.
                       
                        - ### How to use?
                       
                        - - Download the Clean-MSTeams.ps1 file.
                          - - Right-click the file and select "Run with PowerShell" (Make sure to run as Administrator).
                            - - Wait for the green completion message.
                              - - Restart your computer and install Teams again.
                               
                                - ---

                                ## Aviso / Disclaimer
                                Este script remove todos os dados locais do Teams. Voce nao perdera suas mensagens ou arquivos (pois ficam na nuvem), mas tera que fazer login novamente e reconfigurar preferencias locais.

                                ---

                                **Desenvolvido por [VittoheavyTI](https://github.com/VittoheavyTI)**
                                
