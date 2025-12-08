# Use Ctrl+F for prediction key shortcut
Set-PSReadLineKeyHandler -Chord "Ctrl+f" -Function ForwardWord

oh-my-posh init pwsh --config wholespace | Invoke-Expression
