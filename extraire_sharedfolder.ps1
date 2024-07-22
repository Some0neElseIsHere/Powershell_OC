Get-WmiObject -Class Win32_Share -computer acme.fr | Out-file -FilePath C:\exportsharedfolder.txt
# Get-SmbShare deuxieme méthode dégueu.