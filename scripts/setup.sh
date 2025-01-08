#!/bin/bash

# Uncomment to demug
# set -x

# Exit on error
set -e

echo "Installing pre-commit hooks..."

# Check if pip is installed
if ! command -v pip &>/dev/null; then
    echo "pip is not installed. Installing pip..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y python3-pip
    elif command -v brew &>/dev/null; then
        brew install python3
    else
        echo "Error: Could not install pip. Please install Python and pip manually."
        exit 1
    fi
fi

# Install pre-commit and pre-commit-hooks
pip install pre-commit
pip install shellcheck-py
pip install conventional-pre-commit

# Initialize pre-commit
if [ -f ".pre-commit-config.yaml" ]; then
    pre-commit install
    echo "Pre-commit hooks installed successfully!"
else
    echo "Error: .pre-commit-config.yaml not found. Please create one first."
    exit 1
fi

# Check if $HOME/.local/bin is in PATH and add it if not
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Adding $HOME/.local/bin to PATH..."
    export PATH="$HOME/.local/bin:$PATH"
    # Add to .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        # shellcheck disable=SC2016
        echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.bashrc"
    fi
    # Add to .zshrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
        # shellcheck disable=SC2016
        echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.zshrc"
    fi
fi

# Add binaries needed for terraform pre-commit hooks
# jq
download_url=$(curl -s https://api.github.com/repos/jqlang/jq/releases/latest | grep -o -E -m 1 "https://.+?-linux-amd64")
curl -sL "${download_url}" >jq && chmod u+x jq && mv jq "${HOME}"/.local/bin
unset download_url
# tflint
download_url="$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E -m 1 "https://.+?_linux_amd64.zip")"
curl -sL "${download_url}" >tflint.zip && unzip tflint.zip && rm tflint.zip && mv tflint "${HOME}"/.local/bin
unset download_url
# trivy
download_url="$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep -o -E -i -m 1 "https://.+?/trivy_.+?_Linux-64bit.tar.gz")"
curl -sL "${download_url}" >trivy.tar.gz && tar -xzf trivy.tar.gz trivy && rm trivy.tar.gz && mv trivy "${HOME}"/.local/bin
unset download_url
# # tfupdate
# download_url="$(curl -s https://api.github.com/repos/minamijoyo/tfupdate/releases/latest | grep -o -E -m 1 "https://.+?_linux_amd64.tar.gz")"
# curl -L "${download_url}" >tfupdate.tar.gz && tar -xzf tfupdate.tar.gz tfupdate && rm tfupdate.tar.gz && mv tfupdate "${HOME}"/.local/bin
# unset download_url
# # hcledit
# download_url="$(curl -s https://api.github.com/repos/minamijoyo/hcledit/releases/latest | grep -o -E -m 1 "https://.+?_linux_amd64.tar.gz")"
# curl -L "${download_url}" >hcledit.tar.gz && tar -xzf hcledit.tar.gz hcledit && rm hcledit.tar.gz && mv hcledit "${HOME}"/.local/bin
# # terraform-docs
# download_url="$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep -o -E -m 1 "https://.+?-linux-amd64.tar.gz")"
# curl -L "${download_url}" >terraform-docs.tgz && \
#     tar -xzf terraform-docs.tgz terraform-docs && \
#     rm terraform-docs.tgz && chmod +x terraform-docs && \
#     mv terraform-docs "${HOME}"/.local/bin
# unset download_url
