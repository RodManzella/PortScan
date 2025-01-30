## A Simple TCP/UDP port scanner script using Powershell


## Usage:
### TCP Scan
##### .\portscan.ps1 -addrs [address_list] -ports [ports_list]

### UDP Scan
##### .\portscan.ps1 -addrs [address_list] -ports [ports_list] -u


## Example:
##### .\portscan.ps1 -addr google.com,youtube.com -ports 53,8080,80,443,9000,3389
##### .\portscan.ps1 -addr 192.168.1.65,192.168.1.128 -ports 53 -u
