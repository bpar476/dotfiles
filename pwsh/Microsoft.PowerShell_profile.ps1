Import-Module posh-git

# Aliases
Set-Alias -Name pbcopy -Value clip.exe
Set-Alias -Name pbpaste -Value Get-Clipboard

function Get-GitDiffRemote { & git diff origin/$(git branch --show-current) }
Set-Alias -Name gitdr -Value Get-GitDiffRemote
function Set-GitPushUpstream { & git push --set-upstream origin $(git branch --show-current) }
Set-Alias -Name gpsu -Value Set-GitPushUpstream

