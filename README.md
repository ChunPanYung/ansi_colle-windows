# Ansible Collection - ansi_colle.wsl

This collections assume user configure/connect to remote Windows host using SSH.
For more information how to setup, Execute/look at `Setup-SSH.ps1` in this directory.

## Quick Start

1. Execute `bootstrap.ps1` with PowerShell version 5 or above.
2. On a different machine, setup [inventory file](https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html):

    ```ini
    ; hosts.ini
    [windows]
    windows_os

    [windows:vars]
    ansible_user=username
    ansible_connection=powershell
    ansible_become_method=runas
    ```

3. Setup SSH agent to avoid retyping passwords

    ```bash
    ssh-agent bash
    ssh-add ~/.ssh/ansible
    ```

4. Run the following command:

    ```bash
    export ANSIBLE_CALLBACK_RESULT_FORMAT=yaml
    export ANSIBLE_INVENTORY=hosts.ini  # inventory file path

    ansible-galaxy collection install \
        git+https://github.com/ChunPanYung/ansi_colle-windows.git

    # Run this to update every time
    ansible-playbook ansi_colle.windows.install

    # Run this after update, it will ask you sudo password
    ansible-playbook ansi_colle.windows.site --connection=local \
        --inventory 127.0.0.1, --ask-become-pass --verbose
    ```

## Setup Before Running

`bootstrap.ps1` will setup Windows so Ansible can configure Windows machine via `OpenSSH`.

First, ensure Windows can execute PowerShell script:
`Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser`

## Initialize virtual environment

This project use `uv` for Virtual Environment setup.

`uv sync`: Init and sync project's environment according to `pyproject.toml` file.
`source .venv/bin/activate`: Activate bash venv.
