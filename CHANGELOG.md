# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2025-11-30

### 🚀 Features

- [**breaking**] Remove unused roles.
- Install nerdfont.
- Enable wsl.
- Change to search icon and label.
- Nerd-fonts repo and specify package source.

### 🐛 Bug Fixes

- `ansible-lint` error.

### 🎨 Styling

- Re-arrange role on `site.yml` file.
- Append role name to role var.

## [1.0.0] - 2025-11-29

### 🚀 Features

- Dark mode.
- Install powershell.
- Setup parameter for `bootstrap.ps1`.
- Github action for ansible.
- Github action for creating docs.
- Pre-commit update.
- Install firefox, show hidden files and file extensions.
- Single click to open items in windows explorer.
- Remove SolitaireCollection.
- [**breaking**] Remove microsoft teams.
- `v1.0.0` release and use `CHANGELOG.md` to keep track.

### 🐛 Bug Fixes

- Use `uv pip` instead of `pip`.

### 🚜 Refactor

- Use function for install and configure ssh.
- Use function for network profile setting and enable echo request. (#3)
- Put UTC task into base role.
- [**breaking**] Set inventory and tag with environment variable instead.

### 📚 Documentation

- Change to use `uv` instead of `poetry`.
- Ansible collection dependencies.
- Taskfile.

### 🎨 Styling

- Indentation.

### ◀️ Revert

- Supply `tags` on cli instead of environment variables.
