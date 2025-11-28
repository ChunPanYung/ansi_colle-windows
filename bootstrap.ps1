# Enable printing CLI as it runs
Set-PSDebug -Trace 1

$IsAdmin = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Error "This script needs to be executed with Administrator privilege!"
    exit 1
}

if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Error "This script requires PowerShell to be major version 5 or above."
    exit 1
}

function Install-SSH {

    Get-WindowsCapability -Name OpenSSH.Server* -Online |
        Add-WindowsCapability -Online

    # Install the OpenSSH Server
    Get-WindowsCapability -Name OpenSSH.Client* -Online |
        Add-WindowsCapability -Online

    # Start the sshd service now
    Start-Service sshd
    # Start service automatically
    Set-Service -Name sshd -StartupType 'Automatic'

    # By default, the ssh-agent service is disabled. Configure it to start automatically.
    # Run the following command as an administrator.
    Get-Service ssh-agent | Set-Service -StartupType 'Automatic'
    # Start the service.
    Start-Service ssh-agent

}

function Set-SSH {
    # Create .ssh directory for user account
    New-Item -Force -ItemType "directory" -Path "$nev:USERPROFILE\.ssh"
    # Create authorized_keys file for user account
    New-Item -Force -ItemType "file" -Path "$env:USERPROFILE\.ssh\authorized_keys"

    # Enable key based authorization on ssh
    [string]$GlobalSSH = "$env:ProgramData\ssh\sshd_config"
    (Get-Content $GlobalSSH).replace('#PubkeyAuthentication yes', 'PubkeyAuthentication yes') |
        Set-Content $GlobalSSH

    # Setup authorized_keys file for Administrators for Windows
    [string]$GlobalAuthorizedKeys = "$env:ProgramData\ssh\administrators_authorized_keys"
    if (-not (Test-Path -PathType leaf -Path $GlobalAuthorizedKeys)) {
        New-Item -ItemType "file" -Path $GlobalAuthorizedKeys
    }
    # Grand permission to $GlobalAuthorizedKeys file
    icacls.exe $GlobalAuthorizedKeys /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"

    # Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
    if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
        Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
        $firewallParams = @{
                Name = 'OpenSSH-Server-In-TCP'
                DisplayName = 'OpenSSH Server (sshd)'
                Action = 'Allow'
                Direction = 'Inbound'
                Enabled = 'True'  # enum type
                Profile = 'Any'
                Protocol = 'TCP'
                LocalPort = 22
            }
        New-NetFirewallRule @firewallParams
    } else {
        Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
    }
}

Install-SSH
Set-SSH

# Enable ICMP echo requests -- allows ping command to reach this OS.
Enable-NetFirewallRule -displayName "File and Printer Sharing (Echo Request - ICMPv4-In)"
Enable-NetFirewallRule -displayName "File and Printer Sharing (Echo Request - ICMPv6-In)"

# Set current Network Profile to Private so that SSH and ICMP rules work properly
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory "Private"

# Set the default shell to be PowerShell
$NewItemPropertyParams = @{
    Path         = "HKLM:\SOFTWARE\OpenSSH"
    Name         = "DefaultShell"
    Value        = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    PropertyType = "String"
    Force        = $true
}
New-ItemProperty @NewItemPropertyParams

Write-Output "SSH Bootstrap done!"
[string]$Link = "https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement#deploying-the-public-key"
Write-Output "For deploying public keys, please look at: $Link"
