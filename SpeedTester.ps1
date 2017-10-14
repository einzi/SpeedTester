
Function downloadSpeed($strUploadUrl)
    {
        $topServerUrlSpilt = $strUploadUrl -split 'upload'
        $url = $topServerUrlSpilt[0] + 'random2000x2000.jpg'
        $col = new-object System.Collections.Specialized.NameValueCollection 
        $wc = new-object system.net.WebClient 
        $wc.QueryString = $col 
        $downloadElaspedTime = (measure-command {$webpage1 = $wc.DownloadData($url)}).totalmilliseconds
        $string = [System.Text.Encoding]::ASCII.GetString($webpage1)
        $downSize = ($webpage1.length + $webpage2.length) / 1MB
        $downloadSize = [Math]::Round($downSize, 2)
        $downloadTimeSec = $downloadElaspedTime * 0.001
        $downSpeed = ($downloadSize / $downloadTimeSec) * 8
        $downloadSpeed = [Math]::Round($downSpeed, 2)

        #write-host "$($webpage2.length) $($downloadSize) @ $($downloadTimeSec) sek"
        return $downloadSpeed
    }

<#
Using this method to make the submission to speedtest. Its the only way i could figure out how to interact with the page since there is no API.
More information for later here: https://support.microsoft.com/en-us/kb/290591

$objXmlHttp = New-Object -ComObject MSXML2.ServerXMLHTTP
$objXmlHttp.Open("GET", "http://www.speedtest.net/speedtest-config.php", $False)
$objXmlHttp.Send()

Retrieving the content of the response.
[xml]$content = $objXmlHttp.responseText#>

#Sækja serverlista
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
[xml]$ServerList = Get-Content "D:\Documents\einzi\Docs\GitHub\SpeedTester\serverlist.xml"
$cons = $ServerList.settings.servers.server 

#Gera timestamp og object
$sResults = [string]$(get-date -f MM-dd-yyyy_HH_mm) + ";"



#Loopa í gegnum servera í serverlist.xml 
foreach($val in $cons) 
{ 
    #$ServerInformation += @([pscustomobject]@{Distance = $d; Country = $val.country; Sponsor = $val.sponsor; Url = $val.url })
    $DLResult = downloadSpeed($val.url)
    $sResults = $sResults + $DLResult + ";"
    Write-Host "$($val.name)($($val.sponsor)): $($DLResult) Mbps"
}

$sResults | Add-Content "D:\Documents\einzi\Docs\GitHub\SpeedTester\log.txt"
$sResults = ""