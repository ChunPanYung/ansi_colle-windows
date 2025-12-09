# Ansible Collection - ansi_colle.wsl

This collections assume user configure/connect to remote Windows host using SSH.
For more information how to setup, Execute/look at `Setup-SSH.ps1` in this directory.

## Quick Start

1. Execute `bootstrap.ps1` with PowerShell version 5 or above.
2. On a different machine(Linux), install
[ansible](https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html)
and [task](https://taskfile.dev/docs/installation).
3. Setup [inventory file](https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html):

    ```ini
    ; hosts.ini
    [windows]
    windows_11_home ansible_host=192.168.x.xxx ansible_user=user_name

    [windows:vars]
    ansible_connection=powershell
    ansible_become_method=runas
    ```

4. Setup SSH agent to avoid retyping passwords

    ```bash
    ssh-agent bash
    ssh-add ~/.ssh/ansible
    ```

5. Run the following command:

    ```bash
    export ANSIBLE_CALLBACK_RESULT_FORMAT=yaml  # yaml output format instead of json
    export ANSIBLE_INVENTORY=hosts.ini  # inventory file path
    export ANSIBLE_VERBOSITY=1  # SEt verbosity, default is 0

    task install:main  #  Install this collection from main branch
    task run:local:all  # Execute ansi_colle.windows.site with all roles
    ```

## Setup Before Running

`bootstrap.ps1` will setup Windows so Ansible can configure Windows machine via `OpenSSH`.

First, ensure Windows can execute PowerShell script:
`Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser`

## Initialize virtual environment

This project use `uv` for Virtual Environment setup.

`uv sync`: Init and sync project's environment according to `pyproject.toml` file.
`source .venv/bin/activate`: Activate bash venv.
