# Ansible Collection - ansi_colle.wsl

This collections assume user configure/connect to remote Windows host using SSH.
For more information how to setup, Execute/look at `Setup-SSH.ps1` in this directory.

## Windows inventory

1. Execute `bootstrap.ps1` with PowerShell version 5 or above.
2. Configure the following for windows connection (assuming SSH).

```
[windows]
windows_os

[windows:vars]
ansible_user=username
ansible_connection=powershell
ansible_become_method=runas
```
