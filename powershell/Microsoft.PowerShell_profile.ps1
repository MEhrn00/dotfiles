Import-Module PSReadLine
Import-Module -Name Terminal-Icons

Set-PSReadLineOption -EditMode Emacs
Set-PSReadlineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardKillWord

Set-Alias -Name k -Value kubectl.exe

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerline.omp.json" | Invoke-Expression

Import-Module -Name Microsoft.WinGet.CommandNotFound
