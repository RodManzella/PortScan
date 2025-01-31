
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
            $UdpObject = New-Object system.Net.Sockets.Udpclient
            # Define connect parameters
            $UdpObject.Connect($addr, $port)    
        
            # Convert current time string to byte array
            $ASCIIEncoding = New-Object System.Text.ASCIIEncoding
            $Bytes = $ASCIIEncoding.GetBytes("$(Get-Date -UFormat "%Y-%m-%d %T")")
            # Send data to server
            [void]$UdpObject.Send($Bytes, $Bytes.length)    
        
            # Cleanup
            $UdpObject.Close()
        }
    }
}


if ($u) {
    Udp
}else{
    Tcp
}


