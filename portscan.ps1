
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

                }else{

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

function Udp(){
    foreach ($addr in $addrs) { 
        foreach ($port in $ports) {
            $udpClient = New-Object System.Net.Sockets.UdpClient(11000)
            try {
                $string = "testing"
                $byteArray = [System.Text.Encoding]::ASCII.GetBytes($string)
                $udpClient.Connect($addr, $port)
            
                $udpClient.Send($byteArray, $byteArray.Length)
                
                # Recebe a resposta do host
                $remoteIpEndPoint = New-Object System.Net.IPEndPoint [System.Net.IPAddress]::Any, 0
                $receiveBytes = $udpClient.Receive([ref]$remoteIpEndPoint)
                $returnData = [System.Text.Encoding]::ASCII.GetString($receiveBytes)

                # Exibe a mensagem recebida e o endereço de origem
                Write-Output "Received message: $returnData"
                Write-Output "From IP: $($remoteIpEndPoint.Address) on Port: $($remoteIpEndPoint.Port)"
            }
            catch {
                Write-Error "An error occurred: $_"
            }
            finally {
                $udpClient.Close()
            }
        }
    }
}

if ($u) {
    Udp
}else{
    Tcp
}


