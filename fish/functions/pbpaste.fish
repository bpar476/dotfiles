function pbpaste
    powershell.exe Get-Clipboard | sed 's/\r$//' | sed -z '$ s/\n$//'
end
