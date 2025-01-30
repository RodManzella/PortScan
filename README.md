
![ascii_image (1)](https://github.com/user-attachments/assets/8e470bbb-4e90-485d-8ad4-183729a28a34)

# A Simple TCP/UDP port scanner script using Powershell


# Usage:
## TCP Scan
#### .\portscan.ps1 -addrs [address_list] -ports [ports_list]

## UDP Scan
#### .\portscan.ps1 -addrs [address_list] -ports [ports_list] -u


# Example:
#### .\portscan.ps1 -addr google.com,youtube.com -ports 53,8080,80,443,9000,3389
#### .\portscan.ps1 -addr 192.168.1.65,192.168.1.128 -ports 53 -u
