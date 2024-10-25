param ([string]$ip)
$whois = New-Object System.Net.Sockets.TcpClient
$whois.Connect("whois.arin.net", 43)
$stream = $whois.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$writer.WriteLine("n $ip")
$writer.Flush()
$reader = New-Object System.IO.StreamReader($stream)
$response = "IP: $ip" + $reader.ReadToEnd()
$whois.Close()
$response
