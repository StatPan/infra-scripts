# Development Environment Setup

[en](README.md) | [ko](README_ko.md)

This script sets up a development environment on an Ubuntu system. It installs necessary programming languages, tools, and databases for a comprehensive development setup.

## Features

- Updates and upgrades the system
- Installs essential tools: git, curl, wget, vim, build-essential, software-properties-common
- Sets up OpenSSH server
- Installs the latest Node.js LTS
- Installs Rust programming language
- Installs Zsh and Oh My Zsh
- Installs screen for terminal multiplexer
- Installs zip and unzip utilities
- Installs useful tools: htop, tree, jq
- Configures locale for English (UTF-8) and Korean (UTF-8)
- Installs Miniconda for managing Python environments
- Installs PostgreSQL database
- Installs Redis database

## Usage

1. Save the script as `setup_dev_env.sh`.
2. Navigate to the directory containing the script.
3. Make the script executable:
    ```sh
    chmod +x setup_dev_env.sh
    ```
4. Run the script:
    ```sh
    ./setup_dev_env.sh
    ```

## Locale Configuration

This script configures the locale to support both English and Korean languages in the terminal. It sets the `LANG` to `en_US.UTF-8` and `LC_CTYPE` to `ko_KR.UTF-8`.

## Miniconda

Miniconda is installed for managing Python environments. The script ensures that Conda is initialized and added to the `PATH` for both bash and zsh shells.

## PostgreSQL

PostgreSQL, a powerful, open-source object-relational database system, is installed and ready for use.

## Redis

Redis, an in-memory data structure store, is installed for high-performance operations.

---

For the Korean version of this README, click [here](README_ko.md).
