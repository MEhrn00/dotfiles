Import-Module PSReadLine
Import-Module -Name Terminal-Icons

Set-PSReadLineOption -EditMode Emacs
Set-PSReadlineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardKillWord

Set-Alias -Name k -Value kubectl.exe

$poshThemePath = Join-Path -Path (Split-Path "$PROFILE" -Parent) -ChildPath powerline-osc99.omp.json
if (Test-Path -Path $poshThemePath) {
    oh-my-posh init pwsh --config "$poshThemePath" | Invoke-Expression
} else {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerline.omp.json" | Invoke-Expression
}

Import-Module -Name Microsoft.WinGet.CommandNotFound
