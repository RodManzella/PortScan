
[CmdLetBinding()]
param(
    [Parameter(Mandatory)] [string[]] $addrs,
    [Parameter(Mandatory)] [int[]] $ports,
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
                
                $udpObject = New-Object System.Net.Sockets.UdpClient(0)
                $udpObject.Client.ReceiveTimeout = 1000  

                
                $payload = [System.Text.Encoding]::ASCII.GetBytes("$(Get-Date)")
                $udpObject.Connect($addr, $port)
                [void]$udpObject.Send($payload, $payload.Length)

                
                $remoteEndpoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)
                $response = $udpObject.Receive([ref]$remoteEndpoint)
                
              
                Write-Output "$addr`:udp/$port [OPEN]"
            } catch [System.Net.Sockets.SocketException] {
                
                if ($_.Exception.ErrorCode -eq 10054) {
                    Write-Output "$addr`:udp/$port [CLOSED]"
                } else {
                    
                    Write-Output "$addr`:udp/$port [OPEN|FILTERED]"
                }
            } catch {
                Write-Error "Error scanning $addr`:udp/$port - $($_.Exception.Message)"
            } finally {
                if ($udpObject) { $udpObject.Dispose() }
            }
        }
    }
}


if ($u) {
    Udp
}else{
    Tcp
}


