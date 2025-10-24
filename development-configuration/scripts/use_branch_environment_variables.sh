#!/bin/bash

# Script to load environment variables based on JIRA prefix from branch name
# Uses direnv to load environment variables with the extracted prefix
# Warns if the file doesn't exist but doesn't error

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

# Function to load environment variables using direnv
load_env_vars() {
    local prefix="$1"
    local env_file
    env_file=".envrc.$(echo "$prefix" | tr '[:upper:]' '[:lower:]')" # Convert to lowercase

    if [[ -f "$env_file" ]]; then
        echo "Loading environment variables from $env_file"

        # Check if direnv is installed
        if ! command -v direnv &> /dev/null; then
            echo "Warning: direnv is not installed. Sourcing file directly."
            # shellcheck source=/dev/null
            source "$env_file"
        else
            # Use direnv to load the environment variables
            echo "use dotenv $env_file" > .envrc.tmp
            direnv allow .envrc.tmp
            # shellcheck source=/dev/null
            source <(direnv export bash .envrc.tmp)
            rm -f .envrc.tmp
        fi

        echo "Environment variables loaded successfully for prefix: $prefix"
    else
        echo "Warning: Environment file $env_file not found for JIRA prefix '$prefix'"
        echo "Skipping environment variable loading..."
    fi
}

# Main execution
main() {
    # Get current branch name
    local current_branch
    if git rev-parse --is-inside-work-tree &> /dev/null; then
        current_branch=$(git branch --show-current)
    else
        echo "Warning: Not in a git repository. Cannot determine branch name."
        exit 0
    fi

    if [[ -z "$current_branch" ]]; then
        echo "Warning: Could not determine current branch name."
        exit 0
    fi

    echo "Current branch: $current_branch"

    # Extract JIRA prefix
    local jira_prefix
    jira_prefix=$(extract_jira_prefix "$current_branch")

    if [[ -z "$jira_prefix" ]]; then
        echo "Warning: No JIRA prefix found in branch name '$current_branch'"
        echo "No environment variables will be loaded."
        exit 0
    fi

    echo "Extracted JIRA prefix: $jira_prefix"

    # Load environment variables
    load_env_vars "$jira_prefix"
}

# Run main function if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
