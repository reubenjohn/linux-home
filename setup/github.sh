#!/bin/bash

source "$HOME/.home/setup/utils.sh"
source "$HOME/.home/rc/envrc"

SSH_AGENT_RC="$HOME/.home/.env/ssh0-agent.rc"
GITHUB_SSH_RC="$HOME/.home/.env/ssh1-github.rc"


update_and_install_gh() {
    echo "🔄 Updating system and installing GitHub CLI..."
    sudo apt update && sudo apt install -y gh jq || return 1
}

authenticate_with_gh() {
    echo "🔐 Authenticating with GitHub CLI..."
    gh auth login --hostname github.com --git-protocol ssh || return 1
}

generate_ssh_key() {
    local key_path="$1"
    if [ ! -f "$key_path" ]; then
        local email
        default_email=$(git config --global user.email)
        read -p "Enter your GitHub email [$default_email]: " email
        email=${email:-$default_email}
        echo "🔑 Generating a new SSH key..."
        ssh-keygen -t ed25519 -C "$email" -f "$key_path" -q -N "" && return 0
    else
        echo "🔑 SSH key already exists at $key_path. Skipping key generation."
    fi
    return 1
}

add_ssh_key_to_github() {
    local key_path="$1"
    echo "🔗 Adding SSH key to your GitHub account..."
    gh ssh-key add "$key_path.pub" --title "WSL Key ($(date +'%Y-%m-%d'))"
}

configure_ssh() {
    local key_path="$1"
    echo "⚙️ Configuring SSH and starting SSH agent..."
    SSH_CONFIG="$HOME/.ssh/config"
    local github_config="
Host github.com
    HostName github.com
    User git
    IdentityFile $key_path
    AddKeysToAgent yes
"
    echo "Appending to '$SSH_CONFIG':"
    echo "$github_config"

    if ! grep -q "Host github.com" "$SSH_CONFIG" 2>/dev/null; then
        echo "⚙️ Adding the following GitHub configuration to $SSH_CONFIG:"
        echo "$github_config"
        echo "$github_config" >> "$SSH_CONFIG"
    else
        echo "⚙️ GitHub configuration for 'Host github.com' already exists in $SSH_CONFIG. Skipping."
        return 1
    fi
}

start_agent_with_key() {
    local key_path="$1"
    eval "$(ssh-agent -s)"
    ssh-add "$key_path"
}

automate_ssh_agent_startup() {
    local key_path="$1"
    echo "🔄 Automating SSH agent startup..."
    _warn_overwrite "$SSH_AGENT_RC" || return 1
    echo -e "\neval \"\$(ssh-agent -s)\" \n" > "$SSH_AGENT_RC"
    _warn_overwrite "$GITHUB_SSH_RC" || return 1
    echo -e "ssh-add $key_path" > "$GITHUB_SSH_RC"
    envrc-generate
    envrc-source
}

test_ssh_connection() {
    echo "🔗 Testing SSH connection to GitHub..."
    ssh -T git@github.com
}

setup_github() {
    echo "🚀 Starting GitHub setup..."

    local KEY_PATH="$HOME/.ssh/id_ed25519_github"
    _optional_command "Install gh & jq" update_and_install_gh
    _optional_command "Authenticate with gh" authenticate_with_gh
    _optional_command "Generate SSH key" generate_ssh_key "$KEY_PATH"
    _optional_command "Add SSH Key to GitHub" add_ssh_key_to_github "$KEY_PATH"
    _optional_command "Configure SSH" configure_ssh "$KEY_PATH"
    _optional_command "Start Agent with key" start_agent_with_key "$KEY_PATH"
    _optional_command "Automate SSH Agent startup" automate_ssh_agent_startup "$KEY_PATH"
    _optional_command "Test SSH connection" test_ssh_connection
    echo "🎉 GitHub SSH setup completed successfully!"
}
