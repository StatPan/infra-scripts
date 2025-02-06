```markdown
# STATPAN Stack Setup

This repository provides a one-stop script (`ubuntu-init.sh`) to install and configure the **STATPAN Stack** on an Ubuntu system. The name **STATPAN** here refers to a set of essential technologies for modern development:

- **S** – System Tools (e.g., build-essential, curl, etc.)  
- **T** – TypeScript (installed via Node.js & `create-tsready`)  
- **A** – Additional Languages & Tools (like Go, Rust, etc.)  
- **T** – Tooling for Node.js (NVM, npm)  
- **P** – Python (managed via pyenv)  
- **A** – Advanced Databases (PostgreSQL)  
- **N** – Node.js (LTS)

By running this script, you will have a fully functional environment with the following components:

- **Node.js (LTS)** and NVM  
- **Python** (latest version via pyenv)  
- **TypeScript** (including `create-tsready`)  
- **Go (Golang)**  
- **Rust**  
- **PostgreSQL**  
- Plus various **system utilities** (git, curl, vim, build-essential, etc.)

---

## Features

1. **System Update & Essentials**  
   - Updates system packages (`apt update && apt upgrade`)  
   - Installs crucial build tools, libraries, and utilities

2. **User Creation & sudo Configuration**  
   - Creates a new user (default: `ubuntu`) and grants `sudo` privileges  
   - Honors environment variables to override the default username

3. **Programming Languages & Tools**  
   - **Node.js (NVM)**: Installs the latest LTS version of Node.js  
   - **Python (pyenv)**: Installs the latest Python 3.x  
   - **TypeScript**: Globally installs `create-tsready` for TypeScript scaffolding  
   - **Go (Golang)**: Downloads and installs the latest stable release  
   - **Rust**: Installs the stable toolchain via `rustup`  

4. **Databases**  
   - **PostgreSQL**: Installs and configures PostgreSQL, creates a database and user if desired (using environment variables)

5. **System Tools**  
   - Installs `git, curl, wget, vim, htop, tree, jq, screen, zip, unzip, openssh-server, nginx, locales` and more.  
   - Configures locales for English (UTF-8) and Korean (UTF-8).

---

## Usage

1. **Clone or Download** this repository and locate the `ubuntu-init.sh` script.  
2. (Optional) **Create a `.env` file** in the same directory to override default environment variables:
   ```bash
   # .env example
   USERNAME="myuser"         # Default is "ubuntu"

   DB_USER="postgres_user"
   DB_PASSWORD="securepassword"
   DB_NAME="postgres_db"
   PGADMIN_USER="postgres"
   PGADMIN_PASSWORD="adminpassword"
   PGHOST="localhost"
   PGPORT="5432"
   ```
3. **Make the script executable**:
   ```bash
   chmod +x ubuntu-init.sh
   ```
4. **Run the script**:
   ```bash
   # If you have environment variables in .env, just:
   ./ubuntu-init.sh
   # or
   sudo -E ./ubuntu-init.sh
   ```
   The `-E` option preserves your user environment (including variables from `.env` if you `source .env` first or if the script does it internally).

5. **Verify**  
   - After completion, you can verify each component:
     ```bash
     node -v
     python --version
     rustc --version
     go version
     psql --version
     ```

---

## Environment Variables

The script supports various environment variables to customize the setup without editing the script directly. You can place them in a `.env` file or export them in your shell before running `ubuntu-init.sh`.

| Variable           | Default Value      | Description                                                          |
|--------------------|--------------------|----------------------------------------------------------------------|
| `USERNAME`         | `ubuntu`           | The system username to be created.                                   |
| `DB_USER`          | `postgres_user`    | PostgreSQL user that will be created.                                |
| `DB_PASSWORD`      | `securepassword`   | Password for `DB_USER`.                                              |
| `DB_NAME`          | `postgres_db`      | PostgreSQL database name to create.                                  |
| `PGADMIN_USER`     | `postgres`         | Admin username for PostgreSQL (default superuser).                   |
| `PGADMIN_PASSWORD` | `adminpassword`    | Password for `PGADMIN_USER`.                                         |
| `PGHOST`           | `localhost`        | Host for PostgreSQL connections.                                     |
| `PGPORT`           | `5432`             | Port for PostgreSQL connections.                                     |

You can set these in your `.env` like so:
```bash
DB_USER="myappuser"
DB_PASSWORD="mypassword"
```

---

## Language Install Examples

Below are some manual commands in case you need them outside the script:

```bash
# Node.js (LTS)
nvm install --lts
```

```bash
# Python via pyenv
pyenv install 3.10.14
pyenv global 3.10.14
```

```bash
# Rust (stable)
rustup install stable
```

```bash
# Go (latest)
wget https://go.dev/dl/goX.X.X.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf goX.X.X.linux-amd64.tar.gz
```

---

## PostgreSQL Configuration

- Installs PostgreSQL from the official Postgres apt repository.
- Creates a database and user as specified by environment variables (`DB_USER`, `DB_PASSWORD`, `DB_NAME`, etc.).
- Modifies the `pg_hba.conf` to allow external connections (`0.0.0.0/0`) with `md5` authentication.
- Restarts PostgreSQL to apply changes.

### Verification

```bash
service postgresql status
psql -U <DB_USER> -d <DB_NAME> -h <PGHOST> -p <PGPORT>
```

---

## Contributing

1. Fork this repository.
2. Create a new branch for your feature or fix.
3. Commit and push your changes.
4. Create a Pull Request describing your changes.

---

## License

This project is licensed under the [MIT License](LICENSE). Feel free to modify and distribute as you see fit.

---

**Enjoy your new STATPAN Stack environment!** For any issues or questions, please open an issue in this repository.
```
