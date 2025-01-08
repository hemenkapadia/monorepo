#!/bin/bash

# Exit on error
set -e

echo "Installing pre-commit hooks..."

# Check if pip is installed
if ! command -v pip &> /dev/null; then
    echo "pip is not installed. Installing pip..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y python3-pip
    elif command -v brew &> /dev/null; then
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
    pre-commit install --install-hooks
    echo "Pre-commit hooks installed successfully!"
else
    echo "Error: .pre-commit-config.yaml not found. Please create one first."
    exit 1
fi
