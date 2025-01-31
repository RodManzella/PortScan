
[CmdLetBinding()]
param(
    [Parameter(Mandatory)] [string[]] $addrs,
    [Parameter(Mandatory)] [int[]] $ports,
    [int]$timeout = 1000,
    [string]$data = "$(Get-Date)",
    [switch]$u
)

$asciiArt = @"
                            _           _                _____                
/ /   ____  __  ______ ___  __(_)_________(_)___ ___  ____ / ___/_________ _____ 
/ /   / __ \/ / / / __ `/ / / / / ___/ ___/ / __ `__ \/ __ \\__ \/ ___/ __ `/ __ \
/ /___/ /_/ / /_/ / /_/ / /_/ / (__  |__  ) / / / / / / /_/ /__/ / /__/ /_/ / / / /
/_____/\____/\__,_/\__, /\__,_/_/____/____/_/_/ /_/ /_/\____/____/\___/\__,_/_/ /_/ 
                  /_/                                                            

"@

function PrintAscii($text){
    Write-Output $text
}

function Tcp(){
    PrintAscii($asciiArt)
    foreach ($addr in $addrs) { 

        foreach ($port in $ports) {
            try {
                $tcpClient = New-Object System.Net.Sockets.TcpClient
                $STATUS = $tcpClient.ConnectAsync($addr, $port).Wait(500)
                if($STATUS){
                    Write-Output "{$addr}:$port (OPEN)"
                }else{
                    Write-Output "{$addr}:$port (CLOSED)"
                }
            }
            catch {
                Write-Output "Exceção ocorreu"
            }
            finally {
                $tcpClient.Close() 
            }
        }
    }
}

function Udp {
    foreach ($addr in $addrs) {
        foreach ($port in $ports) {
            $udpObject = $null
            try {
                Write-Output "Making UDP connection to $addr : $port"
                $udpObject = New-Object System.Net.Sockets.UdpClient
                $udpObject.Client.ReceiveTimeout = $timeout
                
                # Convert data to bytes
                $encoder = [System.Text.Encoding]::ASCII
                $byte = $encoder.GetBytes($data)
                
                # Send data
                $bytesSent = $udpObject.Send($byte, $byte.Length, $addr, $port)
                if ($bytesSent -ne $byte.Length) {
                    Write-Output "Failed to send full payload"
                }

                # Setup endpoint
                $remoteEndpoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)
                
                # Attempt to receive response
                $receivedData = $udpObject.Receive([ref]$remoteEndpoint)
                $responseString = $encoder.GetString($receivedData)
                Write-Output "Connection Successful: Received response from $($remoteEndpoint.Address):$($remoteEndpoint.Port)"
                
            } catch [System.Net.Sockets.SocketException] {
                if ($_.Exception.Message -match "did not properly respond after a period of time") {
                    Write-Output "$addr : $port (OPEN|FILTERED) - UDP timeout (possibly open)"
                } elseif ($_.Exception.Message -match "forcibly closed") {
                    Write-Output "$addr : $port (CLOSED)"
                } else {
                    Write-Output "Error: $($_.Exception.Message)"
                }
            } catch {
                Write-Output "General error: $($_.Exception.Message)"
            } finally {
                if ($udpObject -ne $null) {
                    $udpObject.Close()
                }
            }
        }
    }
}


if ($u) {
    Udp
}else{
    Tcp
}


