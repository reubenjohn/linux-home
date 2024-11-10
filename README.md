# linux-home

Version controlled configurations for Reuben's Ubuntu home directory.

## Overview

This repository contains various configuration files and scripts to set up and manage Reuben's Ubuntu environment. The primary configuration file is `.zshrc`, which is used to configure the Zsh shell with custom settings, aliases, and plugins.

## Files

- `.zshrc`: Main configuration file for Zsh.
- `README.md`: This file, providing an overview of the repository.

## .zshrc Highlights

- **Oh My Zsh**: Configured with the `itchy` theme and several plugins including `git`, `poetry`, `rust`, and `podman`.
- **Aliases**: Custom aliases for common commands, including clipboard integration and JetBrains applications setup.
- **Environment Variables**: Configuration for `JAVA_HOME`, `SPARK_HOME`, and `NVM_DIR`.
- **NVM**: Node Version Manager setup for managing Node.js versions.
- **SSH Agent**: Automatic start and addition of SSH keys.
- **GPG**: Configuration for GPG TTY.

## Usage

1. Clone the repository to your home directory:
    ```sh
    git clone https://github.com/yourusername/linux-home.git ~/
    ```

2. Run the install script to set up the `.zshrc` file:
    ```sh
    sh ~/linux-home/install.sh
    ```

3. Reload your Zsh configuration:
    ```sh
    source ~/.zshrc
    ```

## Contributing

Feel free to submit issues or pull requests if you have suggestions or improvements.

## License

This project is licensed under the MIT License.
