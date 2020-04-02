$domain = "enter domain name here"
$password = "enter domain password here" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\enter domain admin name here" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
$localuser = $env:UserName
$dns = "10.10.1.5"
$adapter = Get-NetAdapter | ? {$_.Status -eq "up"}

ECHO changing adapter DNS
$adapter | Set-DnsClientServerAddress -ServerAddresses $dns

#if you want to change the local admin password, remove the hashtags below
#ECHO changing password
#net user $localuser enter-password-here

ECHO removing from domain
remove-Computer -Credential $credential -force

ECHO adding to domain
Add-Computer -DomainName $domain -Credential $credential
