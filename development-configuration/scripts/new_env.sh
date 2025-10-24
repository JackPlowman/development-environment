#!/bin/bash

# Script to create a new .envrc file with JIRA suffix based on current branch name
# Alias: new_env

set -euo pipefail

# Function to extract JIRA prefix from branch name
extract_jira_prefix() {
    local branch_name="$1"

    # Match common JIRA patterns: ABC-123, PROJ-456, etc.
    # Extract the full JIRA ticket ID (project key + number)
    if [[ $branch_name =~ ^([A-Z]+-[0-9]+) ]]; then
        echo "${BASH_REMATCH[1]}"
    elif [[ $branch_name =~ ([A-Z]+-[0-9]+)[_-] ]]; then
        # Handle cases like ABC-123-description or feature/ABC-123-description
        echo "${BASH_REMATCH[1]}"
    else
        # No JIRA prefix found
        echo ""
    fi
}

# Function to create .envrc file with template
create_envrc_file() {
    local prefix="$1"
    local env_file
    env_file=".envrc.$(echo "$prefix" | tr '[:upper:]' '[:lower:]')" # Convert to lowercase

    if [[ -f "$env_file" ]]; then
        echo "Warning: $env_file already exists!"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Cancelled. File not created."
            exit 0
        fi
    fi

    # Create the .envrc file with a basic template
    cat > "$env_file" << EOF
# Environment variables for JIRA project: $prefix
# Generated on $(date '+%Y-%m-%d %H:%M:%S')
EOF

    echo "Created $env_file with template content"
    echo "Edit the file to add your specific environment variables"

    echo "To use this environment file, run:"
    echo "direnv allow $env_file"
    echo "Or use: env"
}

# Main execution
main() {
    # Get current branch name
    local current_branch
    if git rev-parse --is-inside-work-tree &> /dev/null; then
        current_branch=$(git branch --show-current)
    else
        echo "Error: Not in a git repository. Cannot determine branch name."
        exit 1
    fi

    if [[ -z "$current_branch" ]]; then
        echo "Error: Could not determine current branch name."
        exit 1
    fi

    echo "Current branch: $current_branch"

    # Extract JIRA prefix
    local jira_prefix
    jira_prefix=$(extract_jira_prefix "$current_branch")

    if [[ -z "$jira_prefix" ]]; then
        echo "Error: No JIRA prefix found in branch name '$current_branch'"
        echo "Expected format: PROJECT-123 or feature/PROJECT-123-description"
        echo "Please ensure your branch name contains a JIRA ticket reference."
        exit 1
    fi

    echo "Extracted JIRA prefix: $jira_prefix"

    # Create environment file
    create_envrc_file "$jira_prefix"
}

# Show help if requested
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    cat << EOF
Usage: $0 [OPTIONS]

Create a new .envrc file with JIRA suffix based on current branch name.

This script extracts the JIRA project key from your current branch name
and creates a corresponding .envrc file (e.g., .envrc.abc for branch ABC-123).

OPTIONS:
    -h, --help    Show this help message

EXAMPLES:
    # If current branch is "feature/ABC-123-new-feature"
    # Creates: .envrc.abc

    # If current branch is "PROJ-456"
    # Creates: .envrc.proj

The created file will contain a template with example environment variables
that you can customize for your specific project needs.

REQUIREMENTS:
    - Must be run in a git repository
    - Branch name must contain a JIRA ticket reference (e.g., ABC-123)

EOF
    exit 0
fi

# Run main function
main "$@"
